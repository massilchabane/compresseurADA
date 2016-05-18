with P_Pixel;
use P_Pixel;

package p_image is
  type A_Image is private;

  function get(image: A_Image; x: Natural; y: Natural) return A_Pixel;
  function get(image: A_Image; x: Natural; y: Natural; width: Natural; height: Natural) return A_Image;

  function getWidth(image: A_Image) return natural;
  function getHeight(image: A_Image) return natural;

  function getCategory(image: A_Image) return T_Magic_Token;

  function getMax(image: A_Image) return Natural;


  procedure set(image: in A_Image; x: in Natural; y: in Natural; pixel: in A_Pixel);

  function init(width: Natural; height: Natural; category: T_Magic_Token; max: Natural := 1) return A_Image;
  procedure destroy(image: in out A_Image; destroy_completly : Boolean := TRUE);

  private
  type A_String is access string;
  type T_Image_Array is array (natural range <>, natural range <>) of A_Pixel;
  type A_Image_Array is access T_Image_Array;

  type T_Image is record
    pixels : A_Image_Array;
    category : T_Magic_Token;
    max : Integer;
    name : A_String;
    compressed : Boolean;
  end record;
  type A_Image is access T_Image;
end p_image;
