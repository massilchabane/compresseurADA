package body p_compression is

  --function compression(image : T_Image) return T_Image is
  --begin
    --afficher(image);
    --return image;
  --end compression;

  procedure compression(image : A_Image) is
    blocks : p_blocks_YCbCr.A_Blocks;
    work_image : p_image_YCbCr.A_Image;
  begin
    afficher(image);

    new_line;
    put("Conversion : ");
    work_image := convert_to_YCbCr(image);
    put("OK");
    new_Line;
    p_image_YCbCr.afficher(work_image);

    new_line;
    put("Amount of Blocks : ");
    put(p_blocks_YCbCr.getAmountOfBlocks(work_image), 0);
    new_line;

    put_line("Blocks : ");
    blocks := p_blocks_YCbCr.cutInBlocks(work_image);
    p_blocks_YCbCr.afficher(blocks);
    new_line;

    put("Dct : ");
    dct(blocks);
    put("OK");
    new_line;
    p_blocks_YCbCr.afficher(blocks);
    new_line;

    put("Dct inverse : ");
    dct(blocks, false);
    put("OK");
    new_line;
    p_blocks_YCbCr.afficher(blocks);
    new_line;

  end compression;

  procedure afficher(pxl: T_255) is
  begin
    put(Integer(pxl), 0);
  end afficher;

  function toFloat(p: T_255) return float is
  begin
    return 0.0;
  end toFloat;



  function convert_to_YCbCr(pixel: T_Pixel_RGB) return T_Pixel_YCbCr is
    pixel_YCbCr : T_pixel_YCbCr;
  begin
    setY(pixel_YCbCr, 0.299 * float(getRed(pixel)) + 0.587 * float(getGreen(pixel)) + 0.114 * float(getBlue(pixel)));
    setCb(pixel_YCbCr, -0.1687 * float(getRed(pixel)) - 0.3313 * float(getGreen(pixel)) - 0.5 * float(getBlue(pixel)) + 128.0);
    setCr(pixel_YCbCr, 0.5 * float(getRed(pixel)) - 0.4187 * float(getGreen(pixel)) - 0.0813 * float(getBlue(pixel)) + 128.0);
    return pixel_YCbCr;
  end convert_to_YCbCr;

  function convert_to_YCbCr(image: A_Image) return p_image_YCbCr.A_Image is
    converted_image : p_image_YCbCr.A_Image := p_image_YCbCr.init(getWidth(image),getHeight(image));
  begin
    for x in 0..getWidth(image)-1 loop
      for y in 0..getHeight(image)-1 loop
        p_image_YCbCr.setPixel(converted_image, x, y, convert_to_YCbCr(getPixel(image, x, y)));
      end loop;
    end loop;
    return converted_image;
  end convert_to_YCbCr;


  function convert_to_rgb(pixel: T_Pixel_YCbCr) return T_Pixel_RGB is
    pixel_rgb : T_Pixel_RGB;
  begin
    setRed(pixel_rgb,T_255(getY(pixel) + 1.402*(getCr(pixel) - 128.0)));
    setGreen(pixel_rgb,T_255(getY(pixel) - 0.34414*(getCb(pixel) - 128.0) - 0.71414*(getCr(pixel) - 128.0)));
    setBlue(pixel_rgb,T_255(getY(pixel) + 1.772*(getCb(pixel) - 128.0)));
    return pixel_rgb;
  end convert_to_rgb;

  procedure dct(blocks : in p_blocks_YCbCr.A_Blocks; mode : Boolean := true) is
  begin
    for x in 0..p_blocks_YCbCr.getWidth(blocks)-1 loop
      for y in 0..p_blocks_YCbCr.getHeight(blocks)-1 loop
        p_blocks_YCbCr.setImage(blocks, x, y, dct(p_blocks_YCbCr.getImage(blocks, x, y), mode));
      end loop;
    end loop;
  end dct;

  function dct(image : P_Image_YCbCr.A_Image; mode : Boolean) return P_Image_YCbCr.A_Image is
    converted_image : P_Image_YCbCr.A_Image := P_Image_YCbCr.init(P_Image_YCbCr.getWidth(image), P_Image_YCbCr.getHeight(image));
  begin
    for x in 0..P_Image_YCbCr.getWidth(image)-1 loop
      for y in 0..P_Image_YCbCr.getHeight(image)-1 loop
        dct(image, converted_image, x, y, mode);
      end loop;
    end loop;
    return converted_image;
  end dct;

  procedure dct(image_source: in P_Image_YCbCr.A_Image; converted_image: in P_Image_YCbCr.A_Image; i : in natural; j : in natural; mode : Boolean) is
  begin
    p_image_YCbCr.setPixel(converted_image, i, j, P_YCbCr.init(
      dct_Y(image_source, i, j, mode),
      dct_Cb(image_source, i, j, mode),
      dct_Cr(image_source, i, j, mode)
    ));
  end dct;

  function c(x:Natural) return float is
  begin
    if x = 0 then
      return 1.0/Ada.Numerics.Elementary_Functions.Sqrt(Float(2));
    else
      return 1.0;
    end if;
  end c;

  function dct_cos(a : Natural; b: Natural; N: Natural) return float is
  begin
    return Ada.Numerics.Elementary_Functions.cos(((2.0 * float(a) + 1.0) * float(b) * Ada.Numerics.Pi) / (2.0  * float(N)));
  end dct_cos;

  function dct_Y(image: P_Image_YCbCr.A_Image; i : natural; j : natural; mode : Boolean) return float is
  begin
    if mode then
      return dct_Calc(image, i, j, P_YCbCr.getY'access);
    else
      return dct_Calc_inverse(image, i, j, P_YCbCr.getY'access);
    end if;
  end dct_Y;

  function dct_Cb(image: P_Image_YCbCr.A_Image; i : natural; j : natural; mode : Boolean) return float is
  begin
    if mode then
      return dct_Calc(image, i, j, P_YCbCr.getCb'access);
    else
      return dct_Calc_inverse(image, i, j, P_YCbCr.getCb'access);
    end if;
  end dct_Cb;

  function dct_Cr(image: P_Image_YCbCr.A_Image; i : natural; j : natural; mode : Boolean) return float is
  begin
    if mode then
      return dct_Calc(image, i, j, P_YCbCr.getCr'access);
    else
      return dct_Calc_inverse(image, i, j, P_YCbCr.getCr'access);
    end if;
  end dct_Cr;

  function dct_Calc(image: P_Image_YCbCr.A_Image; i : natural; j : natural; get : Proc_Access_T) return float is
    value : float := 0.0;
    s1 : float := 0.0;
    s2 : float := 0.0;
    tmp : float := 0.0;
    N : Natural := P_Image_YCbCr.getWidth(image);
  begin
    for x in 0..N-1 loop
      for y in 0..N-1 loop
        tmp := get(P_Image_YCbCr.getPixel(image, x, y)) * dct_cos(x, i, N) * dct_cos(y,j, N);
        s1 := s1 + tmp;
      end loop;
      s2 := s2 + s1;
      s1 := 0.0;
    end loop;
    value := (2.0 / float(Taille_Bloc))*c(i)*c(j)*s2;
    return value;
  end dct_Calc;

  function dct_Calc_inverse(image: P_Image_YCbCr.A_Image; x : natural; y : natural; get : Proc_Access_T) return float is
    value : float := 0.0;
    s1 : float := 0.0;
    s2 : float := 0.0;
    tmp : float := 0.0;
    N : Natural := P_Image_YCbCr.getWidth(image);
  begin
    for i in 0..N-1 loop
      for j in 0..N-1 loop
        tmp := c(i)*c(j)*get(P_Image_YCbCr.getPixel(image, i, j)) * dct_cos(x, i, N) * dct_cos(y,j, N);
        s1 := s1 + tmp;
      end loop;
      s2 := s2 + s1;
      s1 := 0.0;
    end loop;
    value := (2.0 / float(Taille_Bloc))*s2;
    return value;
  end dct_Calc_inverse;

  function matrice_de_quantification return p_image_YCbCr.A_Image is
    matrice : p_image_YCbCr.A_Image := p_image_YCbCr.init(Taille_Bloc, Taille_Bloc);
    value : float := 0.0;
  begin
    for x in 0.. Taille_Bloc -1 loop
      for y in 0 .. Taille_Bloc - 1 loop
        value := 10.0 + float(x) + float(y);
        p_image_YCbCr.setPixel(matrice, x, y, P_YCbCr.init(value, value, value));
      end loop;
    end loop;
    return matrice;
  end matrice_de_quantification;


  procedure quantification(blocks : in p_blocks_YCbCr.A_Blocks; mode : Boolean := True) is
  begin
    for x in 0..p_blocks_YCbCr.getWidth(blocks)-1 loop
      for y in 0..p_blocks_YCbCr.getHeight(blocks)-1 loop
        quantification(p_blocks_YCbCr.getImage(blocks, x, y), mode);
      end loop;
    end loop;
  end quantification;

  procedure quantification(image : in P_Image_YCbCr.A_Image; mode : in Boolean) is
  begin
    for x in 0..P_Image_YCbCr.getWidth(image)-1 loop
      for y in 0..P_Image_YCbCr.getHeight(image)-1 loop
        quantification(image, x, y, mode);
      end loop;
    end loop;
  end quantification;

  procedure quantification(image : in P_Image_YCbCr.A_Image; x : natural; y : natural; mode : in Boolean) is
  begin
    quantification_y(image, x, y, mode);
    quantification_cb(image, x, y, mode);
    quantification_cr(image, x, y, mode);
  end quantification;

  -- @todo transform into function that returns float

  procedure quantification_y(image : in P_Image_YCbCr.A_Image; x : natural; y : natural; mode : in Boolean) is
  begin
    null;
  end quantification_y;

  procedure quantification_cb(image : in P_Image_YCbCr.A_Image; x : natural; y : natural; mode : in Boolean) is
  begin
    null;
  end quantification_cb;

  procedure quantification_cr(image : in P_Image_YCbCr.A_Image; x : natural; y : natural; mode : in Boolean)  is
  begin
    null;
  end quantification_cr;

  function quantification(image : P_Image_YCbCr.A_Image; x : natural; y : natural; get : Proc_Access_T; mode : Boolean) return float is
    matrice_quantification : p_image_YCbCr.A_Image := matrice_de_quantification;
    P : float := get(P_Image_YCbCr.getPixel(image, x, y));
    q : float := get(P_Image_YCbCr.getPixel(matrice_quantification, x, y));
  begin
    return (p + float(integer(q/2.0))) / q;
  end quantification;



end p_compression;
