package body P_Pixel is

  function get(pixel : A_Pixel; Canal: natural) return element is
  begin
    return pixel.all.Canaux.all(Canal);
    Exception
    when constraint_error => raise Canal_Invalide;
  end get;

  procedure set(pixel : A_Pixel; Canal: natural; e: element) is
  begin
    pixel.all.Canaux.all(Canal) := e;
    Exception
    when constraint_error => raise Canal_Invalide;
  end set;

  function getNbCanaux(pixel : A_Pixel) return Natural is
  begin
    return pixel.all.Canaux.all'length;
  end getNbCanaux;

  procedure act(pixel: A_Pixel; what_to_do_on_Canal: access procedure (e: in out element); what_to_do_between_canal : access procedure; what_to_do_in_the_end : access procedure) is
  begin
    for i in pixel.all.Canaux.all'range loop
      what_to_do_on_Canal.all(pixel.all.Canaux.all(i));
    end loop;
  end act;


  function init(elements : T_Pixel_Array) return A_Pixel is
    pixel : A_Pixel := new T_Pixel;
    iterateur : Natural := 1;
  begin
    pixel.all.Canaux := new T_Pixel_Array(1..elements'length);
    for i in elements'range loop
      pixel.all.Canaux.all(iterateur) := elements(i);
      iterateur := iterateur + 1;
    end loop;
    return pixel;
  end init;

  function init(pixel: A_Pixel) return A_Pixel is
  begin
    return init(pixel.all.Canaux.all);
  end init;

  procedure convert_to_YCbCr(pixel: in A_Pixel) is
    ancien_pixel : A_Pixel := init(pixel.Canaux.all);
  begin
    if getNbCanaux(pixel) /= 3 then
      raise not_rgb;
    end if;
    set(pixel, Y, to_element(0.257 * to_float(get(ancien_pixel, Red)) + 0.504 * to_float(get(ancien_pixel, Green)) + 0.098 * to_float(get(ancien_pixel, Blue)) + 16.0));
    set(pixel, Cb, to_element(-0.148 * to_float(get(ancien_pixel, Red)) - 0.291 * to_float(get(ancien_pixel, Green)) + 0.439 * to_float(get(ancien_pixel, Blue)) + 128.0));
    set(pixel, Cr, to_element(0.439 * to_float(get(ancien_pixel, Red)) -  0.368 * to_float(get(ancien_pixel, Green)) - 0.071 * to_float(get(ancien_pixel, Blue)) + 128.0));
  end convert_to_YCbCr;

  procedure convert_to_RGB(pixel: in A_Pixel) is
    ancien_pixel : A_Pixel := init(pixel.Canaux.all);
  begin
    if getNbCanaux(pixel) /= 3 then
      raise not_YCbCr;
    end if;
    set(pixel, Red, to_element(1.164*(to_float(get(ancien_pixel, Y)) - 16.0) + 1.596*(to_float(get(ancien_pixel, Cr)) - 128.0)));
    set(pixel, Green, to_element(1.164*(to_float(get(ancien_pixel, Y)) - 16.0) - 0.813*(to_float(get(ancien_pixel, Cr)) - 128.0)  - 0.392*(to_float(get(ancien_pixel, Cb)) - 128.0) ));
    set(pixel, Blue, to_element(1.164*(to_float(get(ancien_pixel, Y)) - 16.0) + 2.017*(to_float(get(ancien_pixel, Cb)) - 128.0)));
  end convert_to_RGB;


end P_pixel;
