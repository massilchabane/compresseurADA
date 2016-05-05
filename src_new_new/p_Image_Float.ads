with Ada.Text_IO, P_Image, P_Pixel, P_Image.Compression;
use Ada.Text_IO;

package P_Image_Float is
  function to_float(f: float) return float;

  package P_Image_Init is new P_Image(Float, to_float, to_float);
  use P_Image_Init;

  package P_Compression is new P_Image_Init.Compression(Float);
  use P_Compression;
end P_Image_Float;
