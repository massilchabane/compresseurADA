package body p_pixel.YCbCr is

  function init(Y: Float; Cb: Float; Cr: Float) return T_Pixel_YCbCr is
    pixel : T_Pixel_YCbCr;
  begin
    pixel.Y := Y;
    pixel.Cb := Cb;
    pixel.Cr := Cr;
    return pixel;
  end init;

  function getY(pixel : T_Pixel_YCbCr) return Float is
  begin
    return pixel.Y;
  end getY;

  function getCb(pixel : T_Pixel_YCbCr) return Float is
  begin
    return pixel.Cb;
  end getCb;

  function getCr(pixel : T_Pixel_YCbCr) return Float is
  begin
    return pixel.Cr;
  end getCr;

  procedure setY(pixel : out T_Pixel_YCbCr; Y : Float) is
  begin
    pixel.Y := Y;
  end setY;

  procedure setCb(pixel : out T_Pixel_YCbCr; Cb : Float) is
  begin
    pixel.cb := Cb;
  end setCb;

  procedure setCr(pixel : out T_Pixel_YCbCr; Cr : Float) is
  begin
    pixel.Cr := Cr;
  end setCr;

  procedure afficher(pixel: T_Pixel_YCbCr) is
  begin
    put("(");
    put(Float'image(pixel.Y));
    --put(",");
    --put(Float'image(pixel.Cb));
    --put(",");
    --put(Float'image(pixel.Cr));
    put(")");
  end afficher;

end P_pixel.YCbCr;
