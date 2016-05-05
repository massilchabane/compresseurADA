with Ada.Text_IO, P_Pixel;
use Ada.Text_IO;

procedure sc_pixel is

  function to_float(f: float) return float is
  begin
    return f;
  end to_float;

  package P_Pixel_Init is new P_Pixel(float, to_float, to_float);
  use P_Pixel_Init;

  procedure afficher(e : in out float) is
  begin
    put(Float'Image(e));
    put(",");
  end afficher;

  procedure afficher(pixel: in A_Pixel) is
  begin
    put("(");
    act(pixel,  afficher'access, null, null);
    put(")");
  end afficher;

  pixel : A_Pixel := init((10.0, 10.0, 10.0));
begin

  afficher(pixel);
  new_line;
  convert_to_YCbCr(pixel);
  afficher(pixel);
  new_line;
  convert_to_RGB(pixel);
  afficher(pixel);
  new_line;
end sc_pixel;
