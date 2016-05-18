with p_pixel, Ada.Text_IO;
use p_pixel, Ada.Text_IO;

generic
  type element is private;
  with function toFloat(e: element) return Float;

package p_pixel.YCbCr is
  type T_Pixel_YCbCr is private;
  type A_Pixel_YCbCr is access T_Pixel_YCbCr;

  function init(Y: Float; Cb: Float; Cr: Float) return T_Pixel_YCbCr;

  function getY(pixel : T_Pixel_YCbCr) return Float;
  function getCb(pixel : T_Pixel_YCbCr) return Float;
  function getCr(pixel : T_Pixel_YCbCr) return Float;

  procedure setY(pixel : out T_Pixel_YCbCr; Y : Float);
  procedure setCb(pixel : out T_Pixel_YCbCr; Cb : Float);
  procedure setCr(pixel : out T_Pixel_YCbCr; Cr : Float);

  procedure afficher(pixel: T_Pixel_YCbCr);

  private
  type T_Pixel_YCbCr is new T_Pixel with
    record
    Y : Float;
    Cb : Float;
    Cr : Float;
  end record;

end P_pixel.YCbCr;
