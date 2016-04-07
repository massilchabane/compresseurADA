with Ada.Text_IO, Ada.Integer_Text_IO;
use Ada.Text_IO, Ada.Integer_Text_IO;

package P_Pixel.YCbCr is
  type T_pixel_YCbCr is private;
  function init(Y: Float; Cb: Float; Cr: Float) return T_pixel_YCbCr;
  function convert_to_YCbCr(pixel: T_pixel) return T_pixel_YCbCr;
  function convert_to_rgb(pixel: T_pixel_YCbCr) return T_pixel;


  private

  type T_pixel_YCbCr is record
    Y: FLoat;
    Cb: Float;
    Cr: Float;
  end record;

end P_Pixel.YCbCr;
