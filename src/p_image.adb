package body p_image is


    procedure afficher(pixel: T_pixel) is
    begin
      put('(');
      put(pixel.rouge,0);
      put(',');
      put(pixel.vert,0);
      put(',');
      put(pixel.bleue,0);
      put(')');
    end afficher;

    procedure afficher(image: T_image) is
    begin
      for x in image'Range(1) loop
        for y in image'Range(2) loop
          afficher(image(x,y));
        end loop;
        new_line;
      end loop;
    end afficher;

  function init(x:Natural; y:Natural; default:T_Pixel := white_pixel) return T_image is
    image : T_image(0..x,0..y) := (others =>(others=>default));
  begin
    return image;
  end init;

  function getPixel(image: T_image; x:Natural; y: Natural) return T_pixel is
  begin
    return image(x,y);
  end getPixel;

  procedure setPixel(image: in out T_image; x: in Natural; y: in Natural; pixel: in T_pixel) is
  begin
    image(x,y) := pixel;
  end setPixel;

end p_image;
