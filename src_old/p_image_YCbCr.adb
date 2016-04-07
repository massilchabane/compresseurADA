package body P_Image_YCbCr is

  function init(largeur:Natural; hauteur:Natural) return T_Image is
    image : T_Image(0..largeur-1,0..hauteur-1);
  begin
    return image;
  end init;

  function getBloc(image: T_Image; x: Natural; y: Natural; largeur: Natural; hauteur: natural) return T_Image is
    img: T_image := init(largeur, hauteur);
  begin
    for i in x..x+largeur-1 loop
      for j in y..y+hauteur-1 loop
        img(i-x, j-y) := image(i,j);
      end loop;
    end loop;
    return img;
  end getBloc;


  function getPixel(image: T_Image; x:Natural; y: Natural) return T_Pixel is
  begin
    return image(x,y);
  end getPixel;

  procedure setPixel(image: in out T_Image; x: in Natural; y: in Natural; pixel: in T_Pixel) is
  begin
    image(x,y) := pixel;
  end setPixel;

  function getHauteur(image: T_Image) return natural is
  begin
    return image'length(2);
  end getHauteur;
  function getLargeur(image: T_Image) return natural is
  begin
    return image'length(1);
  end getLargeur;

  procedure afficher(pixel: T_pixel) is
  begin
    put('(');
    put(pixel.Y,0);
    put(',');
    put(pixel.Cb,0);
    put(',');
    put(pixel.Cr,0);
    put(')');
  end afficher;

  procedure afficher(image: T_image) is
  begin
    for x in image'Range(1) loop
      for y in image'Range(2) loop
        afficher(image(x,y));
      end loop;
      new_line;
    end loop;
  end afficher;


end P_Image_YCbCr;
