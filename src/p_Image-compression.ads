with P_Pixel;
use P_Pixel;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Numerics,Ada.Numerics.Elementary_Functions;
use Ada.Numerics,Ada.Numerics.Elementary_Functions;

package P_Image.Compression is
  function compress(image : in out A_Image) return A_Image;
  function decompress(image : in out A_Image) return A_Image;
  private
  Taille_Bloc : constant Natural := 8;
  Type T_Blocks is array(natural range <>, natural range <>) of A_Image;
end P_Image.Compression;
