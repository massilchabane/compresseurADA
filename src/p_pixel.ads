package P_Pixel is
  type A_Pixel is private;
  type T_Magic_Token is (P1, P2, P3);
  type T_Pixel_Array is array (natural range <>) of Natural;

  Red, Y : Constant Integer := 0;
  Green, Cb : Constant Integer := 1;
  Blue, Cr : Constant Integer := 2;

  function get(pixel: A_Pixel; Canal : Natural := 0) return Integer;
  procedure set(pixel: in A_Pixel; Canal : in Natural := 0; value: in Integer);

  function init(category: T_Magic_Token; max: Natural := 1) return A_pixel;
  procedure destroy(pixel: in out A_Pixel);

  private
  type A_Pixel_Array is access T_Pixel_Array;

  type T_Pixel is record
    values : A_Pixel_Array;
    category : T_Magic_Token;
    Max : Integer;
  end record;

  type A_Pixel is access T_Pixel;
end P_Pixel;
