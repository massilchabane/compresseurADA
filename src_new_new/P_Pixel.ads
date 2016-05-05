generic
  type element is private;
  with function to_float(e: element) return float;
  with function to_element(e: float) return element;

package P_Pixel is
  type T_Pixel_Array is array (natural range <>) of element;
  type T_Pixel is private;
  type A_Pixel is access T_Pixel;
  Red, Y : Constant Integer := 1 ;
  Green, Cb : Constant Integer := 2 ;
  Blue, Cr : Constant Integer := 3 ;

  not_rgb : Exception;
  not_YCbCr : Exception;

  function init(elements : T_Pixel_Array) return A_Pixel;


  function get(pixel : A_Pixel; Canal: natural) return element;
  procedure set(pixel : A_Pixel; Canal: natural; e: element);

  procedure convert_to_YCbCr(pixel: in A_Pixel);
  procedure convert_to_RGB(pixel: in A_Pixel);

  function getNbCanaux(pixel : A_Pixel) return Natural;

  procedure act(pixel: A_Pixel; what_to_do_on_Canal: access procedure (e: in out element); what_to_do_between_canal : access procedure; what_to_do_in_the_end : access procedure);
  Canal_Invalide : Exception;
  private

  type A_Pixel_Array is access T_Pixel_Array;
  type T_Pixel is record
    Canaux : A_Pixel_Array;
  end record;

end P_pixel;
