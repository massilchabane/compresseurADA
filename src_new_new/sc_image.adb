with Ada.Text_IO, P_Image_Float;
use Ada.Text_IO, P_Image_Float, P_Image_Float.P_Image_Init, P_Image_Float.P_Image_Init.P_Pixel_Init, P_Image_Float.P_Compression;

procedure sc_image is
image : A_Image := init(4, 4, 3);

procedure afficher(e : in out float) is
begin
  put(Float'Image(e));
  put(",");
end afficher;

procedure clear is
begin
  new_line;
end clear;

procedure afficher(pixel: in A_Pixel) is
begin
  put("(");
  act(pixel,  afficher'access, null, null);
  put(")");
end afficher;

procedure afficher(image: in A_Image) is
begin
  put("[");
  clear;
  act(image,  afficher'access, clear'access);
  put("]");
  clear;
end afficher;

begin
  setPixel(image, 0, 0, init((0.0,0.0,0.0)));
  setPixel(image, 0, 1, init((0.0,0.0,0.0)));
  setPixel(image, 0, 2, init((0.0,0.0,0.0)));
  setPixel(image, 0, 3, init((0.0,0.0,0.0)));
  setPixel(image, 1, 0, init((0.0,0.0,0.0)));
  setPixel(image, 1, 1, init((0.0,0.0,0.0)));
  setPixel(image, 1, 2, init((0.0,0.0,0.0)));
  setPixel(image, 1, 3, init((0.0,0.0,0.0)));
  setPixel(image, 2, 0, init((0.0,0.0,0.0)));
  setPixel(image, 2, 1, init((0.0,0.0,0.0)));
  setPixel(image, 2, 2, init((0.0,0.0,0.0)));
  setPixel(image, 2, 3, init((0.0,0.0,0.0)));
  setPixel(image, 3, 0, init((0.0,0.0,0.0)));
  setPixel(image, 3, 1, init((0.0,0.0,0.0)));
  setPixel(image, 3, 2, init((0.0,0.0,0.0)));
  setPixel(image, 3, 3, init((0.0,0.0,0.0)));

  afficher(image);
  new_line;
  image := compression(image);
  afficher(image);
  new_line;

  image := decompression(image);
  afficher(image);
  new_line;
end sc_image;
