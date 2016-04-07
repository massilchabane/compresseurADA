package body P_Pixel.YCbCr is

  function init(Y: Float; Cb: Float; Cr: Float) return T_pixel_YCbCr is
    pixel : T_pixel_YCbCr := (Y, Cb, Cr);
  begin
    return pixel;
  end init;

  function convert_to_YCbCr(pixel: T_pixel) return T_pixel_YCbCr is
    pixel_YCbCr : T_pixel_YCbCr := (0.0, 0.0, 0.0);
  begin
    pixel_YCbCr.Y := 0.299 * float(getRed(pixel)) + 0.587 * float(getGreen(pixel)) + 0.114 * float(getBlue(pixel));
    pixel_YCbCr.Cb := -0.1687 * float(getRed(pixel)) - 0.3313 * float(getGreen(pixel)) - 0.5 * float(getBlue(pixel)) + 128.0;
    pixel_YCbCr.Cr := 0.5 * float(getRed(pixel)) - 0.4187 * float(getGreen(pixel)) - 0.0813 * float(getBlue(pixel)) + 128.0;
    return pixel_YCbCr;
  end convert_to_YCbCr;

  function convert_to_rgb(pixel: T_pixel_YCbCr) return T_pixel is
    pixel_rgb : T_pixel;
  begin
    setRed(pixel_rgb,natural(pixel.Y + 1.402*(pixel.Cr - 128.0)));
    setGreen(pixel_rgb,natural(pixel.Y - 0.34414*(pixel.Cb - 128.0) - 0.71414*(pixel.Cr - 128.0)));
    setBlue(pixel_rgb,natural(pixel.Y + 1.772*(pixel.Cb - 128.0)));
    return pixel_rgb;
  end convert_to_rgb;


end P_Pixel.YCbCr;
