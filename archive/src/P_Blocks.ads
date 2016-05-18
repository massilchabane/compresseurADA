with Ada.Text_IO;
use Ada.Text_IO;

generic
  type A_Image is private;
  with function getHeight(image: A_Image) return Natural;
  with function getWidth(image: A_Image) return Natural;
  with function getPartOfAnImage(image: A_Image; x: Natural; y: Natural; width: Natural; height: Natural) return A_Image;
  with procedure afficher(image: A_Image);
  Taille_Bloc : in Natural := 8;

package P_Blocks is
  type T_Blocks (<>) is private;
  type A_Blocks is access T_Blocks;

  function getAmountOfBlocks(image: A_Image) return natural;
  function cutInBlocks(image: A_Image) return A_Blocks;

  procedure afficher(blocks : in T_Blocks);
  procedure afficher(blocks : in A_Blocks);

  function getHeight(blocks : T_Blocks) return Natural;
  function getHeight(blocks : A_Blocks) return Natural;

  function getWidth(blocks : T_Blocks) return Natural;
  function getWidth(blocks : A_Blocks) return Natural;

  function getImage(blocks : T_Blocks; x : Natural; y  : Natural) return A_Image;
  function getImage(blocks : A_Blocks; x : Natural; y : Natural) return A_Image;

  procedure setImage(blocks : in out T_Blocks; x : Natural; y  : Natural; image: A_Image);
  procedure setImage(blocks : A_Blocks; x : Natural; y  : Natural; image: A_Image);

  private
  type T_Blocks is array (natural range <>, natural range <>) of A_Image;
end P_Blocks;
