with  Ada.Text_IO, Ada.Sequential_IO;
use Ada.Text_IO;
with GLib;             use GLib;

procedure Sc_1 is

   type T_Octet is new Guchar;
   --type T_Octet is mod 2 ** 8;
   --type T_Octet is mod 256;
   --type T_Octet is range 0 .. 255;
   --type T_Octet is new INTEGER range 0 .. 255;
   --type T_Octet is new INTEGER;

   package P_Octet_IO is new Ada.Sequential_IO(T_Octet);

   Mon_Fichier : P_Octet_IO.File_Type;
   Mon_Octet : T_Octet;

   procedure Lire is
   begin
      P_Octet_IO.Open(Mon_Fichier, P_Octet_IO.In_File, "gling.ppm");
      while not P_Octet_IO.End_Of_File(Mon_Fichier) loop
         P_Octet_IO.Read(Mon_Fichier, Mon_Octet);
         Put_Line(T_Octet'Image(Mon_Octet));
      end loop;
      P_Octet_IO.Close(Mon_Fichier);
   end Lire;

begin

   Put_Line("Nb octets : " & INTEGER'image(T_Octet'Size));

   Lire;
   --Lire;

end Sc_1;
