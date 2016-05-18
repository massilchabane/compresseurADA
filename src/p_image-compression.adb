package body P_Image.Compression is

   -----------------
   -- compression --
   -----------------

   function copy(image: A_Image; pixel : A_Pixel) return A_Pixel is
     pixel_copy : A_Pixel := init(image.all.category, image.all.max);
   begin
     if image.all.category = P3 then
       set(pixel_copy, Red,get(pixel, Red));
       set(pixel_copy, Green,get(pixel, Green));
       set(pixel_copy, Blue,get(pixel, Blue));
     else
       set(pixel_copy, 0,get(pixel, 0));
     end if;
     return pixel_copy;
   end copy;

   function copy(image : A_Image; width : Natural; height : Natural) return A_Image is
     image_copy : A_Image := init(width, height, image.all.category, image.all.max);
     void_pixel : A_Pixel := init(image.all.category, image.all.max);
   begin

     for x in 0..getWidth(image_copy)-1 loop
       for y in 0..getHeight(image_copy)-1 loop
         if x < getWidth(image)  and y < getHeight(image) then
           set(image_copy, x, y, copy(image, get(image, x, y)));
         else
           set(image_copy, x, y, void_pixel);
         end if;
       end loop;
     end loop;

     return image_copy;
   end copy;

   function copy(image : A_Image) return A_Image is
   begin
     return copy(image, getWidth(image), getHeight(image));
   end copy;


   function cut_in_blocks(image : A_Image) return T_Blocks is
     blocks : T_Blocks(0..(getWidth(image)/Taille_Bloc)-1, 0..(getHeight(image)/Taille_Bloc)-1);
   begin
     for i in blocks'range(1) loop
       for j in blocks'range(2) loop
         blocks(i,j) := init(Taille_Bloc, Taille_Bloc, image.all.category, image.all.max);
         for x in 0..Taille_Bloc-1 loop
           for y in 0..Taille_Bloc-1 loop
             set(blocks(i,j), x, y, get(image,x+Taille_Bloc*i,y+Taille_Bloc*j));
           end loop;
         end loop;
       end loop;
     end loop;
     return blocks;
   end cut_in_blocks;

   function cut_blocks(blocks : T_Blocks) return T_Blocks is
     blocks_cut : T_Blocks(blocks'range(1), blocks'range(2));
   begin
     for i in blocks'range(1) loop
       for j in blocks'range(2) loop
         blocks_cut(i,j) := init(Taille_Bloc/2, Taille_Bloc/2, blocks(i,j).all.category, blocks(i,j).all.max);
         for x in 0..Taille_Bloc/2-1 loop
           for y in 0..Taille_Bloc/2-1 loop
             set(blocks_cut(i,j), x, y, get(blocks(i,j),x,y));
           end loop;
         end loop;
       end loop;
     end loop;
     return blocks_cut;
   end cut_blocks;

   function merge_blocks(blocks : T_Blocks) return A_Image is
     image : A_Image := init(getWidth(blocks(0,0))*blocks'length(1), getHeight(blocks(0,0))*blocks'length(2), blocks(0,0).all.category, blocks(0,0).all.max);
     index_x : Integer := 0;
     index_y : Integer := 0;
   begin
     for i in blocks'range(1) loop
       for j in blocks'range(2) loop
          for x in 0..getWidth(blocks(i,j))-1 loop
            for y in 0..getHeight(blocks(i,j))-1 loop
              index_x := x+(i*(getWidth(blocks(0,0))));
              index_y := y+(j*(getHeight(blocks(0,0))));
              set(image, index_x, index_y, get(blocks(i,j), x, y));
            end loop;
          end loop;
       end loop;
     end loop;

     return image;
   end merge_blocks;


   procedure destroy(blocks : T_Blocks) is
   begin
     for i in blocks'range(1) loop
       for j in blocks'range(2) loop
         --destroy(blocks(i,j));
         null;
       end loop;
     end loop;
     --@todo free itself
   end destroy;

     function c(x:Integer) return float is
     begin
       if x = 0 then
         return 1.0/Sqrt(Float(2));
       else
         return 1.0;
       end if;
     end c;

     function cos_dct(a: Integer; b:Integer) return float is
     begin
       return cos(((2.0*float(a)+1.0)*float(b)*Ada.Numerics.Pi)/(2.0/float(Taille_Bloc)));
     end cos_dct;

     procedure dct(pixel: A_Pixel; image: A_Image; i: Natural; j: Natural; canal: Natural) is
       e : Integer;
       sum : float := 0.0;
     begin
       for x in 0..Taille_Bloc-1 loop
         for y in 0..Taille_Bloc-1 loop
           sum := float(get(get(image, x, y), canal)) * cos_dct(x,i) * cos_dct(y, j) + sum;
         end loop;
       end loop;
       e := Integer(2.0/float(Taille_Bloc) * c(i) * c(j) * sum);
       set(pixel, canal, e);
     end dct;

     procedure dct(pixel: A_Pixel; image: A_Image; x: Natural; y:Natural) is
     begin
       dct(pixel, image, x, y, 0);
     end dct;

     procedure dct(image: A_Image) is
       image_copy : A_Image := copy(image);
     begin
       for x in 0..getWidth(image)-1 loop
         for y in 0..getHeight(image)-1 loop
           dct(get(image, x, y), image_copy, x, y);
         end loop;
       end loop;
       destroy(image_copy);
     end dct;

     procedure dct(blocks: T_Blocks) is
     begin
       for i in blocks'range(1) loop
         for j in blocks'range(2) loop
           dct(blocks(i, j));
         end loop;
       end loop;
     end dct;

   function compress(image : in out A_Image) return A_Image is
     image_copy : A_Image := copy(image);
     blocks : T_Blocks(0..(getWidth(image)/Taille_Bloc)-1, 0..(getHeight(image)/Taille_Bloc)-1) := cut_in_blocks(image_copy);
     blocks_cut : T_Blocks(blocks'range(1), blocks'range(2)) := cut_blocks(blocks);
     compressed_image : A_Image := merge_blocks(blocks_cut);
     safely_compressed_image: A_Image;
   begin
     dct(blocks);
     safely_compressed_image := copy(compressed_image);
     --destroy(blocks, false);
     --destroy(blocks_cut, false);
     destroy(compressed_image, false);
     destroy(image_copy, true);
     compressed_image.name := image.name;
     compressed_image.compressed := true;
     return compressed_image;
   end compress;

   -------------------
   -- decompression --
   -------------------

   procedure dct_inverse(pixel: A_Pixel; image: A_Image; i: Natural; j: Natural; canal: Natural) is
     e : Integer;
     sum : float := 0.0;
   begin
     for x in 0..Taille_Bloc-1 loop
       for y in 0..Taille_Bloc-1 loop
         sum :=  c(i) * c(j) * float(get(get(image, i, j), canal)) * cos_dct(x,i) * cos_dct(y, j) + sum;
       end loop;
     end loop;
     e := Integer(2.0/float(Taille_Bloc) * sum);
     set(pixel, canal, e);
   end dct_inverse;

   procedure dct_inverse(pixel: A_Pixel; image: A_Image; x: Natural; y:Natural) is
   begin
     dct_inverse(pixel, image, x, y, 0);
   end dct_inverse;

   procedure dct_inverse(image: A_Image) is
     image_copy : A_Image := copy(image);
   begin
     for x in 0..getWidth(image)-1 loop
       for y in 0..getHeight(image)-1 loop
         dct_inverse(get(image, x, y), image_copy, x, y);
       end loop;
     end loop;
     destroy(image_copy);
   end dct_inverse;

   procedure dct_inverse(blocks: T_Blocks) is
   begin
     for i in blocks'range(1) loop
       for j in blocks'range(2) loop
         dct_inverse(blocks(i, j));
       end loop;
     end loop;
   end dct_inverse;


   function decompress(image : in out A_Image) return A_Image is
     image_copy : A_Image := copy(image, Taille_Bloc, Taille_Bloc);
     blocks : T_Blocks(0..(getWidth(image_copy)/Taille_Bloc)-1, 0..(getHeight(image_copy)/Taille_Bloc)-1) := cut_in_blocks(image_copy);
     decompressed_image : A_Image := merge_blocks(blocks);
     safely_decompressed_image: A_Image;
   begin
     dct_inverse(blocks);
     safely_decompressed_image := copy(decompressed_image);
     safely_decompressed_image.name := image.name;
     return safely_decompressed_image;
   end decompress;

end P_Image.Compression;
