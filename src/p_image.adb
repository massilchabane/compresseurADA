package body p_image is

   ---------
   -- get --
   ---------

   function get (image: A_Image; x: Natural; y: Natural) return A_Pixel is
   begin
     return image.all.pixels.all(x, y);
   end get;

   ---------
   -- get --
   ---------

   function get
     (image: A_Image;
      x: Natural;
      y: Natural;
      width: Natural;
      height: Natural)
      return A_Image
   is
     new_image : A_Image := init(width, height, P1, 0);
   begin
     return new_image;
   end get;

   ---------
   -- set --
   ---------

   procedure set
     (image: in A_Image;
      x: in Natural;
      y: in Natural;
      pixel: in A_Pixel)
   is
   begin
     image.all.pixels.all(x, y) := pixel;
   end set;

   ----------
   -- init --
   ----------

   function init
     (width: Natural;
      height: Natural;
      category: T_Magic_Token;
      max : Natural := 1)
      return A_Image
   is
     image : A_Image := new T_Image;
   begin
     image.all.category := category;
     if category = P1 then
       image.all.max := 1;
     elsif category = P2 then
       image.all.max := max;
     else
       image.all.max := max;
    end if;
    image.all.pixels := new T_Image_Array(0..width-1, 0..height-1);
    return image;
   end init;

   -------------
   -- destroy --
   -------------

   procedure destroy
     (image: in out A_Image;
      destroy_completly : Boolean := TRUE)
   is
   begin
     null;
   end destroy;


   function getWidth(image: A_Image) return natural is
   begin
     return image.all.pixels'length(1);
   end getWidth;

   function getHeight(image: A_Image) return natural is
   begin
     return image.all.pixels'length(2);
   end getHeight;

   function getCategory(image: A_Image) return T_Magic_Token is
   begin
     return image.all.category;
   end getCategory;

   function getMax(image: A_Image) return Natural is
   begin
     return image.all.max;
   end getMax;


end p_image;
