package p_pixel is
  type T_Pixel is private;
  type A_pixel is access T_Pixel;

private
  type T_Pixel is tagged
   record
   null;
  end record;

end P_pixel;
