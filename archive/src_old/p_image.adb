package body P_Image is

  function init(largeur:Natural; hauteur:Natural; default:T_Pixel) return T_image is
    image : T_image(0..largeur-1,0..hauteur-1) := (others=>(others=>default));
  begin
    if largeur mod 8 = 0 and hauteur mod 8 = 0 then
      return image;
    end if;
    raise Falsche_Format;
  end init;

  function getPixel(image: T_image; x:Natural; y: Natural) return T_pixel is
  begin
    return image(x,y);
  end getPixel;

  function getPixel(image: T_image; x:Natural; y: Natural; width: Natural; height: Natural) return T_Image is
    bloc : T_image(0..width-1, 0..height-1);
  begin
    for i in 0..width-1 loop
      for j in 0..height-1 loop
        bloc(i,j) := getPixel(image, x+i, y+j);
      end loop;
    end loop;
    return bloc;
  end getPixel;

  function getTranche(image: T_image; x:Natural; y: Natural; width: Natural; height: Natural) return A_Image is
    bloc : A_Image := new T_image(0..width-1, 0..height-1);
  begin
    for i in 0..width-1 loop
      for j in 0..height-1 loop
        bloc.all(i,j) := getPixel(image, x+i, y+j);
      end loop;
    end loop;
    return bloc;
  end getTranche;



  procedure setPixel(image: in out T_image; x: in Natural; y: in Natural; pixel: in T_pixel) is
  begin
    image(x,y) := pixel;
  end setPixel;

  function getHauteur(image: T_image) return natural is
  begin
    return image'length(2);
  end getHauteur;

  function getLargeur(image: T_image) return natural is
  begin
    return image'length(1);
  end getLargeur;

  procedure act(image : in out T_Image; action : in Proc_Access_T) is
  begin
    for x in image'Range(1) loop
      for y in image'Range(2) loop
        action.all(image(x,y));
      end loop;
    end loop;
  end act;



end P_Image;
