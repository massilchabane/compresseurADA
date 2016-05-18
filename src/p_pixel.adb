package body P_Pixel is

   ---------
   -- get --
   ---------

   function get (pixel: A_Pixel; Canal : Natural := 0) return Integer is
   begin
     return pixel.all.values.all(Canal);
   end get;

   ---------
   -- set --
   ---------

   procedure set (pixel: in A_Pixel; Canal : in Natural := 0; value: in Integer) is
   begin
     pixel.all.values.all(Canal) := Value;
   end set;

   ----------
   -- init --
   ----------

   function init
     (category: T_Magic_Token;
      max: Natural := 1)
      return A_pixel
   is
     pixel : A_Pixel := new T_pixel;
   begin
     pixel.all.category := category;
     if category = P1 then
       pixel.all.max := 1;
       pixel.all.values := new T_Pixel_Array(0..0);
     elsif category = P2 then
       pixel.all.max := max;
       pixel.all.values := new T_Pixel_Array(0..0);
     elsif category = P3 then
       pixel.all.max := max;
       pixel.all.values := new T_Pixel_Array(Red..Blue);
    end if;
    return pixel;
   end init;

   -------------
   -- destroy --
   -------------

   procedure destroy (pixel: in out A_Pixel) is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "destroy unimplemented");
      raise Program_Error with "Unimplemented procedure destroy";
   end destroy;

end P_Pixel;
