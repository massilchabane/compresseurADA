with p_image, P_Image_YCbCr, Ada.Text_IO, Ada.Numerics,Ada.Numerics.Elementary_Functions;
use p_image, Ada.Text_IO;
package p_compression is

function compression(image: T_Image; debug : Natural := 0) return T_image;

private

type A_Image is access P_Image_YCbCr.T_Image;
type T_Bloc is array (natural range <>) of A_Image;

function conversion_rgb_ycbcr(pixel: T_pixel) return P_Image_YCbCr.T_Pixel;
function conversion_rgb_ycbcr(image: T_Image) return P_Image_YCbCr.T_Image;

function decoupage_en_bloc(image: P_Image_YCbCr.T_Image) return T_Bloc;
function getNombreBloc(hauteur: Natural; largeur: Natural) return natural;

function c(x:Natural) return float;
procedure dct(bloc: in out T_Bloc);
procedure dct(image: in out P_Image_YCbCr.T_Image);
procedure dct(image: in out P_Image_YCbCr.T_Image; pixel: in out P_Image_YCbCr.T_Pixel; i : natural; j : natural);
function dct_Cb(image: in out P_Image_YCbCr.T_Image; pixel: in out P_Image_YCbCr.T_Pixel; i : natural; j : natural) return float;
function dct_Cr(image: in out P_Image_YCbCr.T_Image; pixel: in out P_Image_YCbCr.T_Pixel; i : natural; j : natural) return float;
function dct_Y(image: in out P_Image_YCbCr.T_Image; pixel: in out P_Image_YCbCr.T_Pixel; i : natural; j : natural) return float;

end p_compression;
