package body p_compression is

function compression(image: T_Image; debug : Natural := 0) return T_image is
  imageCompressee: T_image := init(getHauteur(image), getLargeur(image));

  image_YCbCr : P_Image_YCbCr.T_Image(0..getLargeur(image)-1, 0..getHauteur(image)-1);
  bloc : T_bloc(0..getNombreBloc(getHauteur(image), getLargeur(image))-1);
begin
  if debug > 0 then
    new_line;
    put_line("Compression de l'image en cours : ");
  end if;
  -- Etape 1 : Conversion RGV -> YCbCr
  if debug > 0 then
    put("Conversion RGB vers Y'CbCr : ");
  end if;
  image_YCbCr := conversion_rgb_ycbcr(image);
  if debug > 0 then
    put("Ok");
    new_line;
  end if;

  if debug > 1 then
    P_Image_YCbCr.afficher(image_YCbCr);
  end if;


  -- Etape 2 : Sous echantillonage -> Facultatif

  if debug > 0 then
    put("Sous Echantillonage : ");
  end if;
  if debug > 0 then
    put("Faculatif");
    new_line;
  end if;
  if debug > 1 then
    null;
  end if;

  -- Etape 3 : Découpage en blocs
  if debug > 0 then
    put("Découpage en blocs : ");
  end if;
  Bloc := decoupage_en_bloc(image_YCbCr);
  if debug > 0 then
    put("Ok");
    new_line;
  end if;
  if debug > 1 then
    for i in bloc'range loop
      put("Bloc ");
      put(Integer'Image(i));
      put(" : ");
      new_line;
      P_Image_YCbCr.afficher(bloc(i).all);
    end loop;
  end if;

  -- Etape 4 : Transformée DCT




  if debug > 0 then
    new_line;
  end if;
  return image;
end compression;

function decoupage_en_bloc(image: P_Image_YCbCr.T_Image) return T_Bloc is
  bloc : T_bloc(0..getNombreBloc(P_Image_YCbCr.getHauteur(image), P_Image_YCbCr.getLargeur(image))-1);
  i : natural := 0;
begin
  for y in image'first(2)..image'last(2)/Taille_Bloc loop
    for x in image'first(1)..image'last(1)/Taille_Bloc loop
      if y = image'last(2)/Taille_Bloc and x = image'last(1)/Taille_Bloc then
        bloc(i) := new P_Image_YCbCr.T_image(0..image'last(1)-x*Taille_Bloc,0..image'last(2)-y*Taille_Bloc);
        bloc(i).all := P_Image_YCbCr.getBloc(image, x*Taille_Bloc, y*Taille_Bloc, image'last(1)-x*Taille_Bloc+1, image'last(2)-y*Taille_Bloc+1);
      elsif y = image'last(2)/Taille_Bloc then
        bloc(i) := new P_Image_YCbCr.T_image(0..Taille_Bloc-1,0..image'last(2)-y*Taille_Bloc);
        bloc(i).all := P_Image_YCbCr.getBloc(image, x*Taille_Bloc, y*Taille_Bloc, Taille_Bloc, image'last(2)-y*Taille_Bloc+1);
      elsif x = image'last(1)/Taille_Bloc then
        bloc(i) := new P_Image_YCbCr.T_image(0..image'last(1)-x*Taille_Bloc,0..Taille_Bloc-1);
        bloc(i).all := P_Image_YCbCr.getBloc(image, x*Taille_Bloc, y*Taille_Bloc, image'last(1)-x*Taille_Bloc+1, Taille_Bloc);
      else
        bloc(i) := new P_Image_YCbCr.T_image(0..Taille_Bloc-1,0..Taille_Bloc-1);
        bloc(i).all := P_Image_YCbCr.getBloc(image, x*Taille_Bloc, y*Taille_Bloc, Taille_Bloc, Taille_Bloc);
      end if;
      i := i + 1;
    end loop;
  end loop;
  return bloc;
end decoupage_en_bloc;


function conversion_rgb_ycbcr(pixel: T_pixel) return P_Image_YCbCr.T_Pixel is
  pixel_YCbCr : P_Image_YCbCr.T_Pixel;
begin
  pixel_YCbCr.Y := 0.299 * float(pixel.rouge) + 0.587 * float(pixel.vert) + 0.114 * float(pixel.bleue);
  pixel_YCbCr.Cb := -0.1687 * float(pixel.rouge) - 0.3313 * float(pixel.vert) - 0.5 * float(pixel.bleue) + 128.0;
  pixel_YCbCr.Cr := 0.5 * float(pixel.rouge) - 0.4187 * float(pixel.vert) - 0.0813 * float(pixel.bleue) + 128.0;
  return pixel_YCbCr;
end conversion_rgb_ycbcr;

function conversion_YCbCr_rgb(pixel: P_Image_YCbCr.T_Pixel) return T_pixel is
  pixel_rgb : T_pixel;
begin
  pixel_rgb.rouge := natural(pixel.Y + 1.402*(pixel.Cr - 128.0));
  pixel_rgb.vert := natural(pixel.Y - 0.34414*(pixel.Cb - 128.0) - 0.71414*(pixel.Cr - 128.0));
  pixel_rgb.bleue := natural(pixel.Y + 1.772*(pixel.Cb - 128.0));
  return pixel_rgb;
end conversion_YCbCr_rgb;

function conversion_rgb_ycbcr(image: T_Image) return P_Image_YCbCr.T_Image is
  image_YCbCr : P_Image_YCbCr.T_Image:= P_Image_YCbCr.init(getLargeur(image), getHauteur(image));
begin
  for x in image'range(1) loop
    for y in image'range(2)loop
      P_Image_YCbCr.setPixel(image_YCbCr,x, y, conversion_rgb_ycbcr(getPixel(image,x,y)));
    end loop;
  end loop;
  return image_YCbCr;
end conversion_rgb_ycbcr;

function getNombreBloc(hauteur: Natural; largeur: Natural) return natural is
  nombreDeBloc :natural := 0;
begin
  nombreDeBloc := largeur/Taille_Bloc + hauteur/Taille_Bloc;

  if largeur mod Taille_Bloc /= 0 then
    nombreDeBloc := nombreDeBloc + 1;
  end if;

  if hauteur mod Taille_Bloc /= 0 then
    nombreDeBloc := nombreDeBloc + 1;
  end if;

  if largeur mod Taille_Bloc /= 0 and hauteur mod Taille_Bloc /= 0 then
    nombreDeBloc := nombreDeBloc + 1;
  end if;

  return nombreDeBloc;
end getNombreBloc;


function c(x:Natural) return float is
begin
  if x = 0 then
    return 1.0/Ada.Numerics.Elementary_Functions.Sqrt(Float(2));
  else
    return 1.0;
  end if;
end c;


end p_compression;
