package body P_Bloc is

  function getNombreBloc(image: T_Image) return natural is
  begin
    return ( getHeight(image) * getWidth(image) ) / 8;
  end getNombreBloc;

  --function decoupageEnBloc(image: T_Image) return A_Blocs is
    --width : natural := getWidth(image)/8-1;
    --height : natural := getHeight(image)/8-1;
    --blocs : A_Blocs := new T_Blocs(0..width, 0..height);
    --counter : Natural := 0;
    --image_bloc : T_Image;
  --begin
    --function getPixel(image: T_image; x:Natural; y: Natural; width: Natural; height: Natural) return T_Image;
    --image_bloc := getPixel(image, 0, 0, Taille_Bloc, Taille_Bloc);
    --blocs(0, 0) := image_bloc'access;

    --return blocs;
  --end decoupageEnBloc;


end p_Bloc;
