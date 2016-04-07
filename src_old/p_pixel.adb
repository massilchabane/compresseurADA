package body P_Pixel is

  function init(Red: T_255; Green: T_255; Blue: T_255) return T_Pixel is
    pixel : T_pixel := (Red,Green,Blue);
  begin
    return pixel;
  end init;

  function getRed(pixel : T_pixel) return T_255 is
  begin
    return pixel.Red;
  end getRed;

  procedure setRed(pixel : in out T_pixel; Red: in T_255) is
  begin
    pixel.Red := Red;
  end setRed;

  function getGreen(pixel : T_pixel) return T_255 is
  begin
    return pixel.Green;
  end getGreen;

  procedure setGreen(pixel : in out T_pixel; Green: in T_255) is
  begin
    pixel.Green := Green;
  end setGreen;

  function getBlue(pixel : T_pixel) return T_255 is
  begin
    return pixel.blue;
  end getBlue;

  procedure setBlue(pixel : in out T_pixel; Blue: in T_255) is
  begin
    pixel.Blue := Blue;
  end setBlue;

  function black_pixel return T_Pixel is
  begin
    return init(0,0,0);
  end black_pixel;

  function white_pixel return T_Pixel is
  begin
    return init(255,255,255);
  end white_pixel;

  function red_pixel return T_Pixel is
  begin
    return init(255,0,0);
  end red_pixel;

  function green_pixel return T_Pixel is
  begin
    return init(0,255,0);
  end green_pixel;

  function blue_pixel return T_Pixel is
  begin
    return init(0,0,255);
  end blue_pixel;

  procedure afficher(pixel: T_pixel) is
  begin
    null;
  end afficher;

end P_Pixel;
