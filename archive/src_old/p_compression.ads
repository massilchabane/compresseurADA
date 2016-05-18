with p_image, p_pixel, p_pixel.YcbCr, p_bloc, Ada.Text_IO, Ada.Numerics,Ada.Numerics.Elementary_Functions;
use p_pixel, p_pixel.YcbCr, Ada.Text_IO;
package p_compression is
  Taille_Bloc : constant Natural := 8;



  package p_image_rgb is new P_image(T_pixel);
  package p_image_YcbCr is new P_image(T_pixel_YCbCr);
  package p_bloc_YCbCr is new P_bloc(p_image_YcbCr.T_Image, T_pixel_YCbCr, p_image_YcbCr.getHauteur, p_image_YcbCr.getLargeur, p_image_YcbCr.getPixel);
  use p_bloc_YCbCr;

  type A_Image is access P_Image_YCbCr.T_Image;
  type T_Bloc is array (natural range <>) of A_Image;


  function compression(image: p_image_rgb.T_Image; debug : Natural := 0) return p_image_rgb.T_image;
  --function decompression(image: p_image_rgb.T_Image; debug : Natural := 0) return p_image_rgb.T_image;

  private
  function conversion_rgb_ycbcr(image: p_image_rgb.T_Image) return P_Image_YCbCr.T_Image;

end p_compression;
