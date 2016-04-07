with p_pixel, p_compression;
use p_pixel, p_compression;

procedure sc_compression is
  image : p_image_rgb.T_image := p_image_rgb.init(8,8, black_pixel);
begin
  image := compression(image, 2);
end sc_compression;
