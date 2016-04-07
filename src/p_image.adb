package body P_Image is

  function getHeight(image : A_Image) return Natural is
  begin
    return image.all'length(2);
  end getHeight;

  function getWidth(image : A_Image) return Natural is
  begin
    return image.all'length(1);
  end getWidth;

  function getPixel(image: T_image; x:Natural; y: Natural) return T_pixel is
    pixel : T_Pixel := image(x,y);
  begin
    return pixel;
  end getPixel;


  function getPixel(image: A_image; x:Natural; y: Natural) return T_pixel is
  begin
    return getPixel(image.all, x, y);
  end getPixel;


  function getPartOfImage(image: A_image; x:Natural; y: Natural; width: Natural; height: Natural) return A_Image is
    part : A_Image := new T_image(0..width-1, 0..height-1);
  begin
    for i in 0..width-1 loop
      for j in 0..height-1 loop
        part.all(i,j) := getPixel(image, x+i, y+j);
      end loop;
    end loop;
    return part;
  end getPartOfImage;


  function init(width: Natural; height: natural) return A_Image is
    image: A_image := new T_Image(0..width-1, 0..height-1);
  begin
    return image;
  end init;

  function init(width: Natural; height: Natural; pixel: T_pixel) return A_Image is
    image: A_image := init(width, height);
  begin
    for x in image'range(1) loop
      for y in image'range(2) loop
        image.all(x, y) := pixel;
      end loop;
    end loop;
    return image;
  end init;

  procedure afficher(image : in T_Image) is
  begin
    for x in image'range(1) loop
      for y in image'range(2) loop
        afficher(image(x,y));
      end loop;
      new_line;
    end loop;
  end afficher;

  procedure afficher(image : in A_Image) is
  begin
    afficher(image.all);
  end afficher;

  procedure setPixel(image: in out T_image; x: in Natural; y: in Natural; pixel : in T_Pixel) is
  begin
    image(x, y) := pixel;
  end setPixel;

  procedure setPixel(image: in A_image; x: in Natural; y: in Natural; pixel: in T_Pixel) is
  begin
    setPixel(image.all, x, y, pixel);
  end setPixel;

end P_Image;
