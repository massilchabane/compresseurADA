package body p_compression is

  function compression(image: p_image_rgb.T_Image; debug : Natural := 0) return p_image_rgb.T_image is

  image_YCbCr : P_Image_YCbCr.T_Image := P_Image_YCbCr.init(P_Image_rgb.getLargeur(image),
                                                              P_Image_rgb.getHauteur(image),
                                                              init(0.0,0.0,0.0));
  blocs : A_Blocs;

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
      null;
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
      new_line;
    end if;
    if debug > 0 then
      put("   Calcul du nombre de blocs : ");
      put(Natural'image(getNombreBloc(image_YCbCr)));
      new_line;
    end if;
    if debug > 0 then
      put("   Découpage :");
    end if;
    --Bloc := decoupage_en_bloc(image_YCbCr);
    if debug > 0 then
      put("Ok");
      new_line;
    end if;


    return image;
  end compression;


  function conversion_rgb_ycbcr(image: P_Image_rgb.T_Image) return P_Image_YCbCr.T_Image is
    image_YCbCr : P_Image_YCbCr.T_Image := P_Image_YCbCr.init(P_Image_rgb.getLargeur(image),
                                                              P_Image_rgb.getHauteur(image),
                                                              init(0.0,0.0,0.0));
  begin
    for x in image'range(1) loop
      for y in image'range(2) loop
        P_Image_YCbCr.setPixel(image_YCbCr, x, y, convert_to_YCbCr(P_Image_rgb.getPixel(image, x,y)));
      end loop;
    end loop;
    return image_YCbCr;
  end conversion_rgb_ycbcr;


end p_compression;
