with Ada.Text_IO, Ada.Integer_Text_IO;
use Ada.Text_IO, Ada.Integer_Text_IO;

package P_Pixel is
  type T_pixel is private;
  subtype T_255 is Natural range 0..255;

  function init(Red: T_255; Green: T_255; Blue: T_255) return T_Pixel;

  function getRed(pixel : T_pixel) return T_255;
  procedure setRed(pixel : in out T_pixel; Red: in T_255);
  function getGreen(pixel : T_pixel) return T_255;
  procedure setGreen(pixel : in out T_pixel; Green: in T_255);
  function getBlue(pixel : T_pixel) return T_255;
  procedure setBlue(pixel : in out T_pixel; Blue: in T_255);

  function black_pixel return T_Pixel;
  function white_pixel return T_Pixel;
  function red_pixel return T_Pixel;
  function green_pixel return T_Pixel;
  function blue_pixel return T_Pixel;

  procedure afficher(pixel: T_pixel);

  private
  type T_pixel is record
    Red: T_255;
    Green: T_255;
    Blue: T_255;
  end record;
end P_Pixel;
