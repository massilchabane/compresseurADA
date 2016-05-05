package body P_Image is

  function getHeight(image : A_Image) return Natural is
  begin
    return image.all.pixels.all'length(2);
  end getHeight;

  function getWidth(image : A_Image) return Natural is
  begin
    return image.all.pixels.all'length(1);
  end getWidth;

  function getPixel(image: A_image; x:Natural; y: Natural) return A_pixel is
  begin
    return image.all.pixels.all(x,y);
  end getPixel;

  procedure setPixel(image: in A_image; x: in Natural; y: in Natural; pixel: in A_Pixel) is
  begin
    if getNbCanaux(pixel) /= image.all.Nb_canaux then
      raise Canal_Invalide;
    end if;
    image.all.pixels.all(x,y) := pixel;
  end setPixel;

  function init(width: Natural; height: Natural; Nb_canaux: Natural) return A_Image is
    image: A_image := new T_Image;
  begin
    image.all.pixels := new T_Image_Array(0..width-1, 0..height-1);
    image.all.Nb_canaux := Nb_canaux;
    return image;
  end init;

  function init(width: Natural; height: Natural; pixel: A_pixel) return A_Image is
    image: A_image := init(width, height, getNbCanaux(pixel));
  begin
    for x in image.all.pixels.all'range(1) loop
      for y in image.all.pixels.all'range(2) loop
        image.all.pixels.all(x, y) := pixel;
      end loop;
    end loop;
    return image;
  end init;

  procedure act(image: A_Image; what_to_do_on_pixel: access procedure (pixel: in A_Pixel); what_to_do_on_line: access procedure) is
  begin
    for x in image.all.pixels.all'range(1) loop
      for y in image.all.pixels.all'range(2) loop
        what_to_do_on_pixel(image.all.pixels.all(x, y));
      end loop;
      if what_to_do_on_line /= null then
        what_to_do_on_line.all;
      end if;
    end loop;
  end act;

  procedure convert_to_YCbCr(image: A_Image) is
  begin
    P_Image.act(image, P_Pixel_Init.convert_to_YCbCr'access, null);
  end convert_to_YCbCr;

  procedure convert_to_RGB(image: A_Image) is
  begin
    P_Image.act(image, P_Pixel_Init.convert_to_RGB'access, null);
  end convert_to_RGB;

end P_Image;