package body P_Blocks is


  function getAmountOfBlocks(image: A_Image) return natural is
  begin
    return ( getHeight(image) * getWidth(image) ) / Taille_Bloc**2;
  end getAmountOfBlocks;

  function cutInBlocks(image: A_Image) return A_Blocks is
    width : natural := getWidth(image)/Taille_Bloc;
    height : natural := getHeight(image)/Taille_Bloc;
    blocks : A_Blocks := new T_Blocks(0..width-1, 0..height-1);
  begin
    for x in 0 .. width-1 loop
      for y in 0 .. height-1 loop
        blocks(x, y) := getPartOfAnImage(image, x*Taille_Bloc, y*Taille_Bloc, Taille_Bloc, Taille_Bloc);
      end loop;
    end loop;
    return blocks;
  end cutInBlocks;


  function getHeight(blocks : T_Blocks) return Natural is
  begin
    return blocks'length(2);
  end getHeight;

  function getHeight(blocks : A_Blocks) return Natural is
  begin
    return getHeight(blocks.all);
  end getHeight;

  function getWidth(blocks : T_Blocks) return Natural is
  begin
    return blocks'length(1);
  end getWidth;

  function getWidth(blocks : A_Blocks) return Natural is
  begin
    return getWidth(blocks.all);
  end getWidth;


  function getImage(blocks : T_Blocks; x : Natural; y : Natural) return A_Image is
  begin
    return blocks(x,y);
  end getImage;

  function getImage(blocks : A_Blocks; x : Natural; y : Natural) return A_Image is
  begin
    return getImage(blocks.all, x, y);
  end getImage;


  procedure setImage(blocks : in out T_Blocks; x : Natural; y  : Natural; image: A_Image) is
  begin
    --@todo add free
    blocks(x, y) := image;
  end setImage;

  procedure setImage(blocks : A_Blocks; x : Natural; y  : Natural; image: A_Image) is
  begin
    setImage(blocks.all, x, y, image);
  end setImage;

  procedure afficher(blocks : in T_Blocks) is
  begin
    for x in blocks'range(1) loop
      for y in blocks'range(2) loop
        afficher(blocks(x,y));
        new_line;
        new_line;
        return;
      end loop;
    end loop;
  end afficher;

  procedure afficher(blocks : in A_Blocks) is
  begin
    afficher(blocks.all);
  end afficher;


end P_Blocks;
