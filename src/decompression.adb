with P_Image, P_Pixel, P_Image.File, P_Image.Compression, Ada.Text_IO, Ada.Integer_Text_IO;
use P_Image, P_Pixel, P_Image.File, P_Image.Compression, Ada.Text_IO, Ada.Integer_Text_IO;
with Ada.Command_Line;
procedure decompression is
  package CLI renames Ada.Command_Line;
  image : A_Image;
  compressed_image : A_Image;
begin
if CLI.Argument_Count = 0 then
  put_line("Filename missing");
  return;
elsif CLI.Argument_Count = 1 then
  compressed_image := open(CLI.Argument(1));
  image := decompress(compressed_image);
  write(image);
  destroy(image);
  destroy(compressed_image);
  put_line("Image decompressed");
else
  put_line("Too many arguments");
end if;
end decompression;
