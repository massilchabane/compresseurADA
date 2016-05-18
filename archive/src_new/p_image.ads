with Ada.Text_IO;
use Ada.Text_IO;

generic
  type T_Pixel_Range is (<>);
  type T_Pixel_Value is private;
  type T_Pixel is array (T_Pixel_Range) of T_Pixel_Value;

package P_Image is
  type T_Image (<>) is private;
  procedure afficher(image : T_Image);
  private
  type T_image is array (T_Pixel_Range range <>, natural range <>, natural range <>) of T_Pixel_Value;
end P_Image;
