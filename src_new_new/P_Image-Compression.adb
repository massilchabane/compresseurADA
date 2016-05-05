package body P_Image.Compression is

  function compression(image: A_Image) return A_Image is
    image_copie : A_Image := init(image);
    blocs : A_Blocks := decoupage_en_bloc(image_copie);
  begin
    convert_to_YCbCr(image_copie);
    dct(blocs);
    return image_copie;
  end compression;

  function decompression(image: A_Image) return A_image is
  begin
    convert_to_RGB(image);
    return image;
  end decompression;

  procedure decoupage(image: in A_Image; x: in Natural; y: in Natural; blocs : in A_Blocks) is
  begin
    if y >= getHeight(image) then
      return;
    end if;
    if x >= getWidth(image) then
      decoupage(image, 0, y+Taille_Bloc, blocs);
      return;
    end if;
    blocs.all(x/Taille_Bloc, y/Taille_Bloc) := init(Taille_Bloc, Taille_Bloc, 3);
    for i in x..x+Taille_Bloc-1 loop
      for j in y..y+Taille_Bloc-1 loop
        setPixel(blocs.all(x/Taille_Bloc, y/Taille_Bloc),i-x, j-y, getPixel(image, x, y));
      end loop;
    end loop;
    decoupage(image, x+Taille_Bloc, y, blocs);
  end decoupage;

  function decoupage_en_bloc(image: A_Image) return A_Blocks is
    width : natural := getWidth(image)/Taille_Bloc;
    height : natural := getHeight(image)/Taille_Bloc;
    blocs : A_Blocks := new T_Blocks(0..width-1, 0..height-1);
    begin
    decoupage(image, 0, 0, blocs);
    return blocs;
  end decoupage_en_bloc;

  function c(x:Natural) return float is
  begin
    if x = 0 then
      return 1.0/Sqrt(Float(2));
    else
      return 1.0;
    end if;
  end c;

  function cos_dct(a: Natural; b:Natural) return float is
  begin
    return cos(((2.0*float(a)+1.0)*float(b)*Ada.Numerics.Pi)/(2.0/float(Taille_Bloc)));
  end cos_dct;

  procedure dct(pixel: A_Pixel; image: A_Image; i: Natural; j: Natural; canal: Natural) is
    e : P_Image.element := to_element(0.0);
    sum : float := 0.0;
  begin
    for x in 0..Taille_Bloc-1 loop
      for y in 0..Taille_Bloc-1 loop
        sum := to_float(get(getPixel(image, x, y), canal)) * cos_dct(x,i) * cos_dct(y, j);
        e := to_element (to_float(e) + sum);
      end loop;
    end loop;
    e := to_element(2.0/float(Taille_Bloc) * c(i) * c(j) * to_float(e));
    set(pixel, canal, e);
  end dct;


  procedure dct(pixel: A_Pixel; image: A_Image; x: Natural; y:Natural) is
  begin
    for canal in 1 .. getNbCanaux(pixel) loop
      dct(pixel, image, x, y, canal);
    end loop;
  end dct;

  procedure dct(image: A_Image) is
    image_copie : A_image := init(image);
  begin
    for x in 0..getWidth(image)-1 loop
      for y in 0..getHeight(image)-1 loop
        dct(getPixel(image, x, y), image_copie, x, y);
      end loop;
    end loop;
    destroy(image_copie);
  end dct;

  procedure dct(blocks: A_Blocks) is
  begin
    for i in blocks.all'range(1) loop
      for j in blocks.all'range(2) loop
        dct(blocks.all(i, j));
      end loop;
    end loop;
  end dct;

end P_Image.Compression;
