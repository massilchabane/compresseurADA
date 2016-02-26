with Ada.Text_IO, Ada.Integer_Text_IO;
use Ada.Text_IO, Ada.Integer_Text_IO;

package P_Image is

subtype T_255 is Integer range 0..255;

type T_pixel is record
  rouge: T_255;
  vert: T_255;
  bleue: T_255;
end record;

black_pixel : constant T_pixel := (0,0,0);
white_pixel : constant T_pixel := (255, 255, 255);


type T_image is array (natural range <>, natural range <>) of T_pixel;

function init(largeur:Natural; hauteur:Natural; default:T_Pixel := white_pixel) return T_image;

function getPixel(image: T_image; x:Natural; y: Natural) return T_pixel;

procedure setPixel(image: in out T_image; x: in Natural; y: in Natural; pixel: in T_pixel);


function getHauteur(image: T_image) return natural;
function getLargeur(image: T_image) return natural;

procedure afficher(image: T_image);
procedure afficher(pixel: T_pixel);
end P_Image;
