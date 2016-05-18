with Ada.Text_IO;
use Ada.Text_IO;

generic
  type T_Pixel is private;
  with procedure afficher(pixel: T_Pixel);

package P_Image is
  type T_Image (<>) is private;
  type A_image is access T_image;
  Falsche_Format : Exception;

  function getHeight(image : A_Image) return Natural;
  function getWidth(image : A_Image) return Natural;
  function getPartOfImage(image: A_Image; x: Natural; y: Natural; width: Natural; height: Natural) return A_Image;

  function getPixel(image: T_image; x:Natural; y: Natural) return T_pixel;
  function getPixel(image: A_image; x:Natural; y: Natural) return T_pixel;

  procedure setPixel(image: in out T_image; x: in Natural; y: in Natural; pixel: in T_Pixel);
  procedure setPixel(image: in A_image; x: in Natural; y: in Natural; pixel: in T_Pixel);

  function init(width: Natural; height: natural) return A_Image;
  function init(width: Natural; height: Natural; pixel: T_pixel) return A_Image;

  procedure afficher(image : in T_Image);
  procedure afficher(image : in A_Image);

  private
  type T_image is array (natural range <>, natural range <>) of T_Pixel;
end P_Image;
