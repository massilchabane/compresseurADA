with Ada.Text_IO, Ada.Float_Text_IO;
use Ada.Text_IO, Ada.Float_Text_IO;

package P_Image_YCbCr is

  type T_Pixel is record
    Y: FLoat;
    Cb: Float;
    Cr: Float;
  end record;

type T_Image is array (natural range <>, natural range <>) of T_Pixel;

function init(largeur:Natural; hauteur:Natural) return T_Image;

function getPixel(image: T_Image; x:Natural; y: Natural) return T_Pixel;
function getBloc(image: T_Image; x: Natural; y: Natural; largeur: Natural; hauteur: natural) return T_Image;

procedure setPixel(image: in out T_Image; x: in Natural; y: in Natural; pixel: in T_Pixel);


function getHauteur(image: T_Image) return natural;
function getLargeur(image: T_Image) return natural;

procedure afficher(pixel: T_Pixel);
procedure afficher(image: T_Image);

end P_Image_YCbCr;
