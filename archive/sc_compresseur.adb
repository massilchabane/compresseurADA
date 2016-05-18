with P_Image, P_Pixel, P_Image.File, P_Image.Compression, Ada.Text_IO, Ada.Integer_Text_IO;
use P_Image, P_Pixel, P_Image.File, P_Image.Compression, Ada.Text_IO, Ada.Integer_Text_IO;

procedure sc_compresseur is
  --image_P1 : A_Image := open("gling.pbm");
  --image_C1 : A_Image;
  image_P2 : A_Image := open("gling.pgm");
  image_C2 : A_Image;
  image_D2 : A_Image;
  --image_P3 : A_Image := open("gling.ppm");

  procedure afficher(pixel: A_Pixel; Category: T_Magic_Token) is
  begin
    put(get(pixel), 0);
    if Category = P3 then
      put(' ');
      put(get(pixel,Green), 0);
      put(' ');
      put(get(pixel, Blue), 0);
    end if;
  end afficher;

  procedure afficher(image :A_Image) is
  begin
    put_line(T_Magic_Token'Image(getCategory(image)));
    put(getWidth(image), 0); put(' '); put(getHeight(image), 0); new_line;

    if (getCategory(image)/=P1) then
      put(getMax(Image), 1);new_line;
    end if;

    for y in 0..getHeight(image)-1 loop
      for x in 0..getWidth(image)-1 loop
        afficher(get(image,x,y), getCategory(image));
        if x /= getWidth(image)-1 then
          put(' ');
        end if;
      end loop;
      new_line;
    end loop;
  end afficher;

begin
  afficher(image_P2);
  image_C2 := compress(image_P2);
  afficher(image_C2);
  image_D2 := decompress(image_C2);
  afficher(image_D2);
  destroy(image_P2);
  destroy(image_C2);
end sc_compresseur;
