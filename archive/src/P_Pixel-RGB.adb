package body p_pixel.rgb is

  function init(red: element; green: element; blue: element) return T_Pixel_RGB is
    pixel : T_Pixel_RGB;
  begin
    pixel.red := red;
    pixel.green := green;
    pixel.blue := blue;
    return pixel;
  end init;

  function getRed(pixel : T_Pixel_RGB) return element is
  begin
    return pixel.red;
  end getRed;

  function getGreen(pixel : T_Pixel_RGB) return element is
  begin
    return pixel.green;
  end getGreen;

  function getBlue(pixel : T_Pixel_RGB) return element is
  begin
    return pixel.blue;
  end getBlue;

  procedure setRed(pixel : out T_Pixel_RGB; red : element) is
  begin
    pixel.red := red;
  end setRed;

  procedure setGreen(pixel : out T_Pixel_RGB; Green : element) is
  begin
    pixel.green := Green;
  end setGreen;

  procedure setBlue(pixel : out T_Pixel_RGB; Blue : element) is
  begin
    pixel.blue := blue;
  end setBlue;

  procedure afficher(pixel: T_Pixel_RGB) is
  begin
    put("(");
    afficher(pixel.red);
    put(",");
    afficher(pixel.green);
    put(",");
    afficher(pixel.blue);
    put(")");
  end afficher;

end P_pixel.rgb;
