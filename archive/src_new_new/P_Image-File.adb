package body P_Image.File is

  procedure write_type(image: A_Image; file: File_type) is
  begin
    Put_Line(file, "P1");
  end write_type;

  procedure write_dimension(image: A_Image; file: File_type) is
  begin
    Put_Line(file, Natural'Image(getWidth(image))(Natural'Image(getWidth(image))'first+1..Natural'Image(getWidth(image))'last) & Natural'Image(getHeight(image)));
  end write_dimension;

  procedure write_canal(e: P_Image.element; file: File_type) is
  begin
    Ada.Float_Text_IO.put(file, to_float(e), 0, 0, 0);
    put(file, ' ');
  end write_canal;

  procedure write_pixel(pixel: A_Pixel; file: File_type) is
  begin
    for canal in 1..getNbCanaux(pixel) loop
      write_canal(get(pixel, canal), file);
    end loop;
  end write_pixel;

  procedure write_line(image: A_Image; y : Natural; file: File_type) is
  begin
    for x in 0..getWidth(image)-1 loop
      write_pixel(getPixel(image,x,y), file);
    end loop;
  end write_line;

  procedure write_image(image: A_Image; file: File_type) is
  begin
    for y in 0..getHeight(image)-1 loop
      write_line(image, y, file);
      if y /= getHeight(image)-1 then
        new_line(file);
      end if;
    end loop;
  end write_image;

  procedure write(image : A_Image) is
    file : File_type ;
  begin
    put("***************");
    put_line(image.all.Name.all);
    put("***************");
   --create(file,Name => image.all.Name.all);
   --write_type(image, file);
   --write_dimension(image, file);
   --write_image(image, file);
   --close(file) ;
  end write;


  function open(Filename : String) return A_Image is
    image : A_Image;
    File       : Ada.Text_IO.File_Type;
    Line_Count : Natural := 0;
    canaux : Natural := 0;
  begin
    Ada.Text_IO.Open (File,Ada.Text_IO.In_File,Filename);
    while not Ada.Text_IO.End_Of_File (File) loop
      declare
         Line : String := Ada.Text_IO.Get_Line (File);
      begin
        read_line(Line, image, canaux, Line_Count, Filename);
      end;
    end loop;
    Ada.Text_IO.Close (File);
    return image;
    exception
    When Bad_File =>     put("Bad File");Ada.Text_IO.Close (File);return Null;
  end open;


  procedure read_magic_line(Line : String; canaux: out Natural) is
  begin
    if Line'length /= 2 then
      raise Bad_File;
    end if;
    if Line(Line'First) /= 'P' then
      raise Bad_File;
    end if;
    case Line(Line'First+1) is
      when '1' => canaux := 1;
      when '2' => canaux := 1;
      when '3' => canaux := 3;
      when others =>
      put("1");
        raise Bad_File;
    end case;
  end read_magic_line;

  procedure read_dimension_line(Line : String; image : out A_Image; canaux: in Natural; File_Name : String) is
    previous_space : Integer := Line'First-1;
    x : Natural := 0;
    y : Natural := 0;
  begin
    for i in Line'Range loop
      if Line(i) = ' ' then
        x := Natural'Value(Line(previous_space+1..i-1));
        previous_space := i;
      end if;
    end loop;
    y := Natural'Value(Line(previous_space+1..Line'Last));

    if x /= 0 and y /= 0 then
      image := init(x, y, canaux, File_Name);
      return;
    end if;
    put("2");

    raise Bad_File;
  end read_dimension_line;

  procedure read_pixel_line(Line: String; image : in out A_Image; y : Natural) is
    x : Natural := 0;
    previous_space : Integer := Line'First-1;
    pixel_components : T_Pixel_Array(1..image.all.Nb_canaux);
    canal : Natural := 1;
  begin
    if y >= getHeight(image) then
      put("3");
      raise Bad_File;
    end if;

    for i in Line'Range loop
      if Line(i) = ' ' then
        pixel_components(canal) := to_element(Float'Value(Line(previous_space+1..i-1)));
        previous_space := i;
        canal := canal + 1;
        if canal > image.all.Nb_canaux then
          canal := 1;
          setPixel(image, x, y, init(pixel_components));
          x:= x+1;
        end if;
      end if;
    end loop;

    pixel_components(canal) := to_element(Float'Value(Line(previous_space+1..Line'Last)));
    canal := canal + 1;
    if canal > image.all.Nb_canaux then
      canal := 1;
      setPixel(image, x, y, init(pixel_components));
      x:= x+1;
    end if;

    if x /= getWidth(image) then
      put("4");
      raise Bad_File;
    end if;

    Exception
    when constraint_error =>       put("5");raise Bad_File;

  end read_pixel_line;


  procedure read_line(Line : String; image : in out A_Image; canaux: in out Natural; Line_Count : in out Natural; File_Name : String) is
  begin
    if Line(Line'First) = '#' then
      return;
    end if;
    Line_Count := Line_Count + 1;
    if Line_Count = 1 then
      read_magic_line(Line, canaux);
    elsif Line_Count = 2 then
      read_dimension_line(Line, image, canaux, File_Name);
    else
      read_pixel_line(Line, image, Line_Count - 3);
    end if;
  end read_line;



end P_Image.File;
