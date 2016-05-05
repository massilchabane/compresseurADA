with Ada.Text_IO, P_Pixel;
use Ada.Text_IO;

generic
  type element is private;
  with function to_float(e: element) return float;
  with function to_element(e: float) return element;

Package P_Image is

  package P_Pixel_Init is new P_Pixel(element, to_float, to_element);
  use P_Pixel_Init;

  type T_Image is private;
  type A_image is access T_image;
  Falsche_Format : Exception;

  function getHeight(image : A_Image) return Natural;
  function getWidth(image : A_Image) return Natural;

  function getPixel(image: A_image; x:Natural; y: Natural) return A_pixel;

  procedure setPixel(image: in A_image; x: in Natural; y: in Natural; pixel: in A_Pixel);

  function init(width: Natural; height: Natural; Nb_canaux: Natural) return A_Image;
  function init(width: Natural; height: Natural; pixel: A_pixel) return A_Image;

  procedure act(image: A_Image; what_to_do_on_pixel: access procedure (pixel: in A_Pixel); what_to_do_on_line: access procedure);

  private
  type T_Image_Array is array (natural range <>, natural range <>) of A_Pixel;
  type A_Image_Array is access T_Image_Array;

  type T_image is record
    pixels : A_Image_Array;
    Nb_canaux: Natural;
  end record;

  procedure convert_to_YCbCr(image: A_Image);
  procedure convert_to_RGB(image: A_Image);

end P_Image;