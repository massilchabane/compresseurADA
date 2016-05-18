with p_pixel,Ada.Text_IO;
use p_pixel, Ada.Text_IO;

generic
  type element is private;
  with procedure afficher(pxl: element);

package p_pixel.rgb is
  type T_Pixel_RGB is private;
  type A_Pixel_RGB is access T_Pixel_RGB;

  function init(red: element; green: element; blue: element) return T_Pixel_RGB;

  function getRed(pixel : T_Pixel_RGB) return element;
  function getGreen(pixel : T_Pixel_RGB) return element;
  function getBlue(pixel : T_Pixel_RGB) return element;

  procedure setRed(pixel : out T_Pixel_RGB; red : element);
  procedure setGreen(pixel : out T_Pixel_RGB; Green : element);
  procedure setBlue(pixel : out T_Pixel_RGB; Blue : element);

  procedure afficher(pixel: T_Pixel_RGB);

  private
  type T_Pixel_RGB is new T_Pixel with
    record
    red : element;
    green : element;
    blue : element;
  end record;

end P_pixel.rgb;
