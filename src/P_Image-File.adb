package body P_Image.File is

   ----------
   -- open --
   ----------

   function copy(str : String) return A_String is
     line : A_String := new String(str'range);
   begin
     for i in str'range loop
       line(i) := str(i);
     end loop;
     return line;
   end copy;

   function parse(line: string; char: character) return T_Strings is
     strings : T_Strings(line'first..line'length);
     size : natural := 0;
     last_token : natural := line'first-1;
   begin
     for i in line'range loop
       if line(i) = char then
         strings(line'first+size) := copy(line(last_token+1..i-1));
         last_token := i;
         size := size + 1;
       end if;
     end loop;

     if last_token /= line'last then
       strings(line'first+size) := copy(line(last_token+1..line'last));
       size := size + 1;
     end if;

     return strings(line'first..line'first + size - 1);
   end parse;


   procedure getLine_P1(image: in A_Image; line : in String; y : natural) is
     values : T_Strings := parse(line, ' ');
   begin
     for x in values'range loop
       set(image, x-values'first, y, init(image.category, image.max));
       set(get(image, x-values'first, y), 0, Natural'value(values(x).all));
     end loop;
   end getLine_P1;

   procedure getLine_P3(image: in A_Image; line : in String; y : natural) is
     R : Natural;
     G : Natural;
     B : Natural;
     counter : Natural := 0;
     pixel_index : Natural := 0;
     values : T_Strings := parse(line, ' ');
   begin
     for x in values'range loop
       counter := counter + 1;
       if (counter = 1) then
         R := Natural'value(values(x).all);
       elsif (counter = 2) then
         G := Natural'value(values(x).all);
       else
         B := Natural'value(values(x).all);
         set(image, pixel_index, y, init(image.category, image.max));
         set(get(image, pixel_index, y), Red, R);
         set(get(image, pixel_index, y), Green, G);
         set(get(image, pixel_index, y), Blue, B);
         pixel_index := pixel_index + 1;
         counter := 0;
       end if;
     end loop;
   end getLine_P3;


   procedure getLine(image: in A_Image; line : in String; y : natural) is
   begin
     if image.category = P3 then
       getLine_P3(image, line, y);
     else
       getLine_P1(image, line, y);
     end if;
   end getLine;

   procedure getMax(image: in A_Image; line : in String) is
   begin
     image.all.max := Natural'Value(line);
   end getMax;

   procedure get_dimensions(image : in A_Image; line : in String) is
     dimensions : T_Strings := parse(line, ' ');
   begin
     if dimensions'length = 2 then
       image.all.pixels := new T_Image_Array(0..Natural'Value(dimensions(dimensions'first).all)-1, 0..Natural'Value(dimensions(dimensions'last).all)-1);
       return;
     end if;
   end get_dimensions;

   procedure read_line(image: in A_Image; line: in String; Line_Count : in Natural) is
   begin
     case Line_Count is
       when 0 => image.all.category := T_Magic_Token'Value(line);
       when 1 => get_dimensions(image, line);
       when 2 => if image.all.category /= P1 then getMax(image, line); else getLine(image, line, 0); end if;
       when others => if image.all.category /= P1 then getLine(image, line, Line_Count-3); else getLine(image, line, Line_Count-2); end if;
     end case;
   end read_line;

   function open (Filename : String) return A_Image is
     image : A_Image := new T_Image;
     File       : Ada.Text_IO.File_Type;
     Line_Count : Natural := 0;
     canaux : Natural := 0;
     name : String := parse(Filename, '.')(1).all;
     extension : String := parse(Filename, '.')(2).all;
   begin
     Ada.Text_IO.Open (File,Ada.Text_IO.In_File,Filename);

     while not Ada.Text_IO.End_Of_File (File) loop
       declare
          Line : String := Ada.Text_IO.Get_Line (File);
       begin
         if Line(Line'First) /= '#' then
           read_line(image, Line, Line_Count);
           Line_Count := Line_Count + 1;
         end if;
       end;
     end loop;

     Ada.Text_IO.Close (File);
     image.name := new string(name'range);
     image.name.all := name;

     if extension = "gpj" then
       image.compressed := true;
     else
       image.compressed := false;
     end if;

     return image;
   end open;

   -----------
   -- write --
   -----------


   procedure write(pixel: A_Pixel; Category: T_Magic_Token; File : File_Type) is
   begin
     put(file, get(pixel), 0);
     if Category = P3 then
       put(file, ' ');
       put(file, get(pixel,Green), 0);
       put(file, ' ');
       put(file, get(pixel, Blue), 0);
     end if;
   end write;

   procedure write(image : A_Image; File : File_Type) is
   begin
     put_line(file, T_Magic_Token'Image(getCategory(image)));
     put(file, getWidth(image), 0); put(file, ' '); put(file, getHeight(image), 0); new_line(file);

     if (getCategory(image)/=P1) then
       put(file, getMax(Image), 1);new_line(file);
     end if;

     for y in 0..getHeight(image)-1 loop
       for x in 0..getWidth(image)-1 loop
         write(get(image,x,y), getCategory(image), File);
         if x /= getWidth(image)-1 then
           put(file, ' ');
         end if;
       end loop;
       new_line(file);
     end loop;
   end write;

   procedure write (image : A_Image; FileName : String := "") is
     file : File_type ;
     extension : String(1..3);
   begin
     if image.compressed then
       extension := "gpj";
     else
       case getCategory(image) is
         when P1 => extension := "pbm";
         when P2 => extension := "pgm";
         when P3 => extension := "ppm";
       end case;
     end if;
     if (FileName'Length = 0) then
       create(file, Name => image.name.all & "." & extension);
     else
       create(file, Name => FileName & extension);
     end if;

     write(image, file);
     close(file);
   end write;

end P_Image.File;
