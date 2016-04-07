with Ada.Text_IO; use Ada.Text_IO;
with ada.Numerics.Discrete_Random;

with Gtk.Alignment;
with Gtk.Box;
with Gtk.Menu_Bar;
with Gtk.Menu;
with Gtk.Menu_item;
with Gtk.Drawing_Area;
with Gtk.Container;
with Gtk.Widget;
with Gtk.Window;
with Gtk.Main;

with Cairo;
with Cairo.Surface;
with Cairo.Image_Surface;
with Gdk.Cairo;
with Gdk.Pixbuf;
With Gdk.Event;
with Gdk.Window;
with Gdk.Rectangle;
with Gdk.Color;
with Gdk.Main;

with GLib; use GLib;


package body P_Console is

   package P_Alea is new Ada.Numerics.Discrete_Random(Gint);

   Mon_Generateur          : P_Alea.Generator;

   Ma_Fenetre              : Gtk.Window.Gtk_Window;
   Ma_Boite_Aspect         : Gtk.Box.Gtk_Vbox;
   Mon_Alignement_Vertical : Gtk.Alignment.Gtk_Alignment;
   Ma_Zone                 : Gtk.Drawing_Area.Gtk_Drawing_Area;
   Mon_Dessin              : Cairo.Cairo_Surface := Cairo.Null_Surface;
   Mon_Dessin_2            : Cairo.Cairo_Surface;
   Ma_Barre_Menu           : Gtk.Menu_Bar.Gtk_Menu_Bar;
   Mon_Item_Fichier        : Gtk.Menu_Item.Gtk_Menu_Item;
   Mon_Menu_Fichier        : Gtk.Menu.Gtk_Menu;
   Mon_Item_Quitter        : Gtk.Menu_Item.Gtk_Menu_Item;
   Mon_Item_Dessiner       : Gtk.Menu_Item.Gtk_Menu_Item;
   Mon_Menu_Dessiner       : Gtk.Menu.Gtk_Menu;
   Mon_Item_Segment        : Gtk.Menu_Item.Gtk_Menu_Item;
   Mon_Item_Point          : Gtk.Menu_Item.Gtk_Menu_Item;
   Mon_Item_Boite          : Gtk.Menu_Item.Gtk_Menu_Item;


   -- cette procedure permet de quitter le programme principal.
   function Sortie (Self  : access Gtk.Widget.Gtk_Widget_Record'Class;
                    Event : Gdk.Event.Gdk_Event) return Boolean is
   begin
      Gtk.Main.Main_Quit;
      return TRUE;
   end Sortie;

   -- Cette procedure permet de quitter un menu
   procedure Menu_Quitter (Self : access Gtk.Menu_Item.Gtk_Menu_Item_Record'Class) is
   begin
      Gtk.Main.Main_Quit;
   end Menu_Quitter;

   -- Cette procedure permet d'ouvrir un outil de séléction de fichier.
   procedure Menu_Fichier is
   begin
      Gtk.Menu.Gtk_New(Mon_Menu_Fichier);
      Gtk.Menu_Item.Gtk_New_With_Mnemonic(Mon_Item_Quitter, "_Quitter");
      Gtk.Menu_Item.On_Activate(Mon_Item_Quitter, Menu_Quitter'access, FALSE);
      Gtk.Menu.add(Mon_Menu_Fichier, Mon_Item_Quitter);
      Gtk.Menu_Item.Gtk_New_With_Mnemonic(Mon_Item_Fichier, "_Fichier");
      Gtk.Menu_Item.Set_Submenu(Mon_Item_Fichier, Mon_Menu_Fichier);
   end Menu_Fichier;

   -- cette procedure permet de recupérer la couleur cliquée sous format texte dans la console.
   function  Clic (Self  : access Gtk.Widget.Gtk_Widget_Record'Class; Event : Gdk.Event.Gdk_Event_Button) return Boolean is
      Rouge, Vert, Bleu : Guchar;
      Mon_Pixel : Gdk.Pixbuf.Rgb_Buffer_Access;
      Mon_Pixbuf : Gdk.Pixbuf.Gdk_Pixbuf;
   begin
      Mon_Pixbuf :=  Gdk.Pixbuf.Get_From_Surface (Mon_Dessin, Gint(Event.X), Gint(Event.Y), 1, 1);
      Mon_Pixel := Gdk.Pixbuf.Get_Pixels(Mon_Pixbuf);

      Rouge := Mon_Pixel.all(0).Red;
      Vert := Mon_Pixel.all(0).Green;
      Bleu := Mon_Pixel.all(0).Blue;
      Put_Line("Clic : (" & Guchar'image(Rouge) & ","
               & Guchar'image(Vert) & ","
               & Guchar'image(Bleu) & ")");
      return FALSE;
   end Clic;

   --Cette procedure permet de dessiner un segment de couleur bleu avec une taille et une position aléatoire.
   procedure Menu_Segment (Self : access Gtk.Menu_Item.Gtk_Menu_Item_Record'Class) is
      Mon_Rect : Gdk.Rectangle.Gdk_Rectangle;
      Ma_Couleur : Gdk.Color.Gdk_Color;
      Mon_Context : Cairo.Cairo_Context := Cairo.Null_Context;
      X, Y, X2, Y2 : Gint;
   begin
      X := P_Alea.Random(Mon_Generateur) mod Gdk.Window.Get_Width(Ma_Zone.Get_Window);
      Y := P_Alea.Random(Mon_Generateur) mod Gdk.Window.Get_Height(Ma_Zone.Get_Window);
      X2 := P_Alea.Random(Mon_Generateur) mod Gdk.Window.Get_Width(Ma_Zone.Get_Window);
      Y2 := P_Alea.Random(Mon_Generateur) mod Gdk.Window.Get_Height(Ma_Zone.Get_Window);
      Gdk.Color.Set_Rgb(Ma_Couleur, 0, Guint16'last, 0);
      Mon_Context := Cairo.Create(Mon_Dessin);
      Gdk.Cairo.Set_Source_Color(Mon_Context, Ma_Couleur);
      Cairo.Set_Line_Width(Mon_Context, 1.0);
      Cairo.Move_To(Mon_Context, GDouble(X), GDouble(Y));
      Cairo.Line_To(Mon_Context, GDouble(X2), GDouble(Y2));
      Cairo.Stroke(Mon_Context);
      Cairo.Destroy(Mon_Context);
      Mon_Rect.X := Gint'Min(X, X2);
      Mon_Rect.Y := Gint'Min(Y, Y2);
      Mon_Rect.Width := Gint'Max(X, X2) - Mon_Rect.X;
      Mon_Rect.Height := Gint'Max(Y, Y2) - Mon_Rect.Y;
      Gdk.Window.Invalidate_Rect(Ma_Zone.Get_Window, Mon_Rect, FALSE);
   end Menu_Segment;

   -- Cette procedure permet de dessiner un rectangle pris en parametre avec une couleur prise en parametre
   procedure Dessiner_Boite (Mon_Rect : Gdk.Rectangle.Gdk_Rectangle;
                             Ma_Couleur : Gdk.Color.Gdk_Color) is
      Mon_Context : Cairo.Cairo_Context := Cairo.Null_Context;
   begin
      Mon_Context := Cairo.Create(Mon_Dessin);
      Gdk.Cairo.Set_Source_Color(Mon_Context, Ma_Couleur);
      Cairo.Rectangle(Mon_Context, GDouble(Mon_Rect.X), GDouble(Mon_Rect.Y),
                      GDouble(Mon_Rect.Width), GDouble(Mon_Rect.Height));
      Cairo.Fill(Mon_Context);
      Cairo.Destroy(Mon_Context);
      Gdk.Window.Invalidate_Rect(Ma_Zone.Get_Window, Mon_Rect, FALSE);
   end Dessiner_Boite;

   -- Cette procedure permet de dessiner un point de couleur bleue
   procedure Menu_Point (Self : access Gtk.Menu_Item.Gtk_Menu_Item_Record'Class) is
      Mon_Rect : Gdk.Rectangle.Gdk_Rectangle;
      Ma_Couleur : Gdk.Color.Gdk_Color;
   begin
      Mon_Rect.X := P_Alea.Random(Mon_Generateur) mod Gdk.Window.Get_Width(Ma_Zone.Get_Window);
      Mon_Rect.Y:= P_Alea.Random(Mon_Generateur) mod Gdk.Window.Get_Height(Ma_Zone.Get_Window);
      Mon_Rect.Width := 1;
      Mon_Rect.Height := 1;
      Gdk.Color.Set_Rgb(Ma_Couleur, 0, 0, Guint16'last);
      Dessiner_Boite(Mon_Rect, Ma_Couleur);
   end Menu_Point;

   -- Cette procedure permet de dessiner un rectangle 10*10 de couleur
   procedure Menu_Boite (Self : access Gtk.Menu_Item.Gtk_Menu_Item_Record'Class) is
      Mon_Rect : Gdk.Rectangle.Gdk_Rectangle;
      Ma_Couleur : Gdk.Color.Gdk_Color;
   begin
      Mon_Rect.X := P_Alea.Random(Mon_Generateur) mod Gdk.Window.Get_Width(Ma_Zone.Get_Window);
      Mon_Rect.Y := P_Alea.Random(Mon_Generateur) mod Gdk.Window.Get_Height(Ma_Zone.Get_Window);
      Mon_Rect.Width := 10;
      Mon_Rect.Height := 10;
      Gdk.Color.Set_Rgb(Ma_Couleur, Guint16'last, 0, 0);
      Dessiner_Boite(Mon_Rect, Ma_Couleur);
   end Menu_Boite;


   -- Cette fonction permet de tracer les dessins en memoire.
   function Trace (Self : access Gtk.Widget.Gtk_Widget_Record'Class; Cr : Cairo.Cairo_Context) return Boolean is
   begin
      Cairo.Set_Source_Surface(Cr, Mon_Dessin, 0.0, 0.0);
      Cairo.Rectangle(Cr, 0.0, 0.0, GDouble(Gdk.Window.Get_Width(Ma_Zone.Get_Window)), GDouble(Gdk.Window.Get_Height(Ma_Zone.Get_Window)));
      Cairo.Paint(Cr);
      Cairo.Stroke(Cr);
      return TRUE;
   end Trace;


   -- Cette fonction permet de configurer la surface dessinable : Cairo
   function Configuration (Self  : access Gtk.Widget.Gtk_Widget_Record'Class;
                           Event : Gdk.Event.Gdk_Event_Configure) return Boolean is
      Mon_Cairo_Context : Cairo.Cairo_Context := Cairo.Null_Context;
   begin
      if Cairo."="(Mon_Dessin, Cairo.Null_Surface) then
         Mon_Dessin := Cairo.Image_Surface.Create(Cairo.Image_Surface.Cairo_Format_ARGB32,
                                                  Event.Width,
                                                  Event.Height);
         Mon_Cairo_Context := Cairo.Create(Mon_Dessin);
         Cairo.Set_Source_Rgb(Mon_Cairo_Context, 1.0, 1.0, 1.0);
         Cairo.Paint(Mon_Cairo_Context);
         Cairo.destroy(Mon_Cairo_Context);
      elsif Event.Width > Cairo.Image_Surface.Get_Width(Mon_Dessin) or
        Event.Height > Cairo.Image_Surface.Get_Height(Mon_Dessin) then
         Mon_Dessin_2 := Cairo.Image_Surface.Create(Cairo.Image_Surface.Cairo_Format_ARGB32,
                                                    Gint'Max(Event.Width, Cairo.Image_Surface.Get_Width(Mon_Dessin)),
                                                    Gint'Max(Event.Height, Cairo.Image_Surface.Get_Height(Mon_Dessin)));
         Mon_Cairo_Context := Cairo.Create(Mon_Dessin_2);
         Cairo.Set_Source_Rgb(Mon_Cairo_Context, 1.0, 1.0, 1.0);
         Cairo.Paint(Mon_Cairo_Context);
         Cairo.Set_Source_Surface(Mon_Cairo_Context, Mon_Dessin, 0.0, 0.0);
         Cairo.Stroke(Mon_Cairo_Context);
         Cairo.Surface.Destroy(Mon_Dessin);
         Mon_Dessin := Mon_Dessin_2;
      end if;
      return FALSE;
   end Configuration;

   --Cette procedure initialise le menu Dessiner utilisé dans la barre de menu.

   procedure Menu_Dessiner is
   begin
      Gtk.Menu.Gtk_New(Mon_Menu_Dessiner);
      Gtk.Menu_Item.Gtk_New_With_Mnemonic(Mon_Item_Segment, "_Segment");
      Gtk.Menu_Item.On_Activate(Mon_Item_Segment, Menu_Segment'access, FALSE);
      Gtk.Menu_Item.Gtk_New_With_Mnemonic(Mon_Item_Point, "_Point");
      Gtk.Menu_Item.On_Activate(Mon_Item_Point, Menu_Point'access, FALSE);
      Gtk.Menu_Item.Gtk_New_With_Mnemonic(Mon_Item_Boite, "_Boite");
      Gtk.Menu_Item.On_Activate(Mon_Item_Boite, Menu_Boite'access, FALSE);
      Gtk.Menu.add(Mon_Menu_Dessiner, Mon_Item_Segment);
      Gtk.Menu.add(Mon_Menu_Dessiner, Mon_Item_Point);
      Gtk.Menu.add(Mon_Menu_Dessiner, Mon_Item_Boite);
      Gtk.Menu_Item.Gtk_New_With_Mnemonic(Mon_Item_Dessiner, "_Dessiner");
      Gtk.Menu_Item.Set_Submenu(Mon_Item_Dessiner, Mon_Menu_Dessiner);
   end Menu_Dessiner;

   --Cette procedure initialise la barre de menu

   procedure Menus is
   begin
      Menu_Fichier;
      Menu_Dessiner;
      Gtk.Menu_Bar.Gtk_New(Ma_Barre_Menu);
      Gtk.Menu_Bar.add(Ma_Barre_Menu, Mon_Item_Fichier);
      Gtk.Menu_Bar.add(Ma_Barre_Menu, Mon_Item_Dessiner);
   end Menus;

   --Cette procedure permet d'initialiser la Fenêtre graphique ainsi que ses composants et les rend visible.

   procedure Init is
   begin
      P_Alea.Reset(Mon_Generateur);
      Gtk.Main.Init;

      Gtk.Window.Gtk_New(Ma_Fenetre);
      Gtk.Window.Set_Title(Ma_Fenetre, "Rendu - 0.7");
      Gtk.Window.Set_Default_Size(Ma_Fenetre, 600, 800);

      Gtk.Box.Gtk_New_VBox(Ma_Boite_Aspect, homogeneous => False, spacing => 3);

      Gtk.Alignment.Gtk_New(Mon_alignement_Vertical, 0.0, 0.0, 0.0, 0.0);

      Menus;

      Gtk.Box.Pack_Start(Ma_Boite_Aspect, Mon_alignement_Vertical, FALSE, FALSE, 0);
      Gtk.Box.Pack_Start(Ma_Boite_Aspect, Ma_Barre_Menu, FALSE, FALSE, 0);

      Gtk.Drawing_Area.Gtk_New(Ma_Zone);
      Gtk.Box.pack_end(Ma_Boite_Aspect, Ma_Zone, True, True, 0);
      Ma_Fenetre.Add(Ma_Boite_Aspect);
      Gtk.Widget.Set_Events(Gtk.Widget.Gtk_Widget(Ma_Zone), gdk.Event.BUTTON_PRESS_MASK);
      Gtk.Widget.On_Button_Press_Event(Gtk.Widget.Gtk_Widget(Ma_Zone), Clic'access);
      Gtk.Widget.On_Configure_Event(Gtk.Widget.Gtk_Widget(Ma_Zone), Configuration'access);
      Gtk.Widget.On_Delete_Event(Gtk.Widget.Gtk_Widget(Ma_Fenetre), Sortie'access);
      Gtk.Widget.Show_All(Gtk.Widget.Gtk_Widget(Ma_Fenetre));
      Gtk.Widget.On_Draw(Gtk.Widget.Gtk_Widget(Ma_Zone), Trace'access);

      Gtk.Main.Main;
   end Init;

end P_Console;
