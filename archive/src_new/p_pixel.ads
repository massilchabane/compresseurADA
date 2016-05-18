with Ada.Text_IO;
use Ada.Text_IO;

generic
  type Element is private;

package P_Image is
  type T_Pixel (<>) is private;
  procedure afficher(image : T_Image);
  procedure getPixel(x, y);


  private
  type T_Pixel is array (T_Pixel_Range) of Element;
end P_Image;
