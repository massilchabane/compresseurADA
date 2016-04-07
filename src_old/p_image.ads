generic
 type T_pixel is private;

package P_Image is
  type T_image is array (natural range <>, natural range <>) of T_pixel;
  type A_image is access T_image;

  type Proc_Access_T is access procedure (pixel : in out T_pixel);

  Falsche_Format : Exception;

  function init(largeur:Natural; hauteur:Natural; default:T_Pixel) return T_image;

  function getPixel(image: T_image; x:Natural; y: Natural) return T_pixel;
  function getPixel(image: T_image; x:Natural; y: Natural; width: Natural; height: Natural) return T_Image;

  function getTranche(image: T_image; x:Natural; y: Natural; width: Natural; height: Natural) return A_Image;


  procedure setPixel(image: in out T_image; x: in Natural; y: in Natural; pixel: in T_pixel);

  function getHauteur(image: T_image) return natural;
  function getLargeur(image: T_image) return natural;

  procedure act(image : in out T_Image; action : in Proc_Access_T);

  private
end P_Image;
