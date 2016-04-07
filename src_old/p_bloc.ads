generic
 type T_Image(<>) is private;
 type A_Image is private;
 type T_pixel is private;
 with function getHeight(image: T_Image) return Natural;
 with function getWidth(image: T_Image) return Natural;
 with function getPixel(image: T_Image; x: Natural; y: Natural; width: Natural; height: Natural) return A_Image;

package P_bloc is
  Taille_Bloc : constant Natural := 8;

  type T_Blocs is array (natural range <>, natural range <>) of A_Image;
  type A_Blocs is access T_Blocs;

  function getNombreBloc(image: T_Image) return natural;
  --function decoupageEnBloc(image: T_Image) return A_Blocs;
  private
end P_Bloc;
