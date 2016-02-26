with P_image, p_compression;
use P_image, p_compression;

procedure sc_compression is
  image : T_image := init(9,9);
begin
  image := compression(image, 2);
end sc_compression;
