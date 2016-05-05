package body P_Image.Compression is

  function compression(image: A_Image) return A_Image is
    blocs : A_Blocks := decoupage_en_bloc(image);
  begin
    convert_to_YCbCr(image);
    return image;
  end compression;

  function decompression(image: A_Image) return A_image is
  begin
    convert_to_RGB(image);
    return image;
  end decompression;

  procedure decoupage(image: in A_Image; x: in Natural; y: in Natural; blocs : in A_Blocks) is
  begin
    if y > getHeight(image) then
      return;
    end if;
    if x > getWidth(image) then
      decoupage(image, 0, y+Taille_Bloc, blocs);
    end if;
    decoupage(image, y, x+Taille_Bloc, blocs);
  end decoupage;

  function decoupage_en_bloc(image: A_Image) return A_Blocks is
    width : natural := getWidth(image)/Taille_Bloc;
    height : natural := getHeight(image)/Taille_Bloc;
    blocs : A_Blocks := new T_Blocks(0..width-1, 0..height-1);
    begin
    decoupage(image, 0, 0, blocs);
    return blocs;
  end decoupage_en_bloc;

end P_Image.Compression;
