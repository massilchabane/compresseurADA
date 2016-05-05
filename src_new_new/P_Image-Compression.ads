generic
  type element is private;

package P_Image.Compression is
  type T_Blocks (<>) is private;
  type A_Blocks is access T_Blocks;
  function compression(image: A_Image) return A_Image;
  function decompression(image: A_Image) return A_Image;
  private
  Taille_Bloc : constant Natural := 2;
  type T_Blocks is array (natural range <>, natural range <>) of A_Image;
  function decoupage_en_bloc(image: A_Image) return A_Blocks;
end P_Image.Compression;
