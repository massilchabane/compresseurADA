with P_Image, p_Pixel.RGB, P_Pixel.YCbCr, p_blocks, Ada.Text_IO, Ada.Integer_Text_IO, Ada.Numerics,Ada.Numerics.Elementary_Functions;
use Ada.Text_IO, Ada.Integer_Text_IO;

package p_compression is
  Taille_Bloc : constant Natural := 2;
  type T_255 is new integer range 0..255;

  procedure afficher(pxl: T_255);
  function toFloat(p: T_255) return float;



  package P_RGB is new P_Pixel.rgb(T_255, afficher);
  use P_RGB;
  package P_YCbCr is new P_Pixel.YCbCr(T_255, toFloat);
  use P_YCbCr;
  package p_image_rgb is new P_image(T_Pixel_RGB, P_RGB.afficher);
  use p_image_rgb;
  package p_image_YCbCr is new P_image(T_Pixel_YCbCr, P_YCbCr.afficher);
  package p_blocks_rgb is new P_blocks(A_image, getHeight, getWidth, getPartOfImage, afficher, Taille_Bloc);
  use p_blocks_rgb;
  package p_blocks_YCbCr is new P_blocks(p_image_YCbCr.A_image, p_image_YCbCr.getHeight, p_image_YCbCr.getWidth, p_image_YCbCr.getPartOfImage, p_image_YCbCr.afficher, Taille_Bloc);

  procedure compression(image : A_Image);

  private
  function convert_to_rgb(pixel: T_Pixel_YCbCr) return T_Pixel_RGB;
  function convert_to_YCbCr(pixel: T_Pixel_RGB) return T_Pixel_YCbCr;
  function convert_to_YCbCr(image: A_Image) return p_image_YCbCr.A_Image;

  procedure dct(blocks : in p_blocks_YCbCr.A_Blocks; mode : Boolean := True);
  function dct(image : P_Image_YCbCr.A_Image; mode : Boolean) return P_Image_YCbCr.A_Image;
  procedure dct(image_source: in P_Image_YCbCr.A_Image; converted_image: in   P_Image_YCbCr.A_Image; i : in natural; j : in natural; mode : Boolean);

  function dct_Y(image: P_Image_YCbCr.A_Image; i : natural; j : natural; mode : Boolean) return float;
  function dct_Cb(image: P_Image_YCbCr.A_Image; i : natural; j : natural; mode : Boolean) return float;
  function dct_Cr(image: P_Image_YCbCr.A_Image; i : natural; j : natural; mode : Boolean) return float;

  type Proc_Access_T is access function (pixel : P_YCbCr.T_Pixel_YCbCr) return float;
  function dct_Calc(image: P_Image_YCbCr.A_Image; i : natural; j : natural; get : Proc_Access_T) return float;
  function dct_Calc_inverse(image: P_Image_YCbCr.A_Image; x : natural; y : natural; get : Proc_Access_T) return float;

  function matrice_de_quantification return p_image_YCbCr.A_Image;
  procedure quantification(blocks : in p_blocks_YCbCr.A_Blocks; mode : Boolean := True);
  procedure quantification(image : in P_Image_YCbCr.A_Image; mode : in Boolean);
  procedure quantification(image : in P_Image_YCbCr.A_Image; x : natural; y : natural; mode : in Boolean);
  procedure quantification_y(image : in P_Image_YCbCr.A_Image; x : natural; y : natural; mode : in Boolean);
  procedure quantification_cb(image : in P_Image_YCbCr.A_Image; x : natural; y : natural; mode : in Boolean);
  procedure quantification_cr(image : in P_Image_YCbCr.A_Image; x : natural; y : natural; mode : in Boolean);
  function quantification(image : P_Image_YCbCr.A_Image; x : natural; y : natural; get : Proc_Access_T; mode : Boolean) return float;

end p_compression;
