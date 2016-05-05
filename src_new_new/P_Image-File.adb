package body P_Image.File is

  procedure open_file(Filename : String) is
     File       : Ada.Text_IO.File_Type;
     Line_Count : Natural := 0;
  begin
     Ada.Text_IO.Open (File => File,
                       Mode => Ada.Text_IO.In_File,
                       Name => Filename);
     while not Ada.Text_IO.End_Of_File (File) loop
        declare
           Line : String := Ada.Text_IO.Get_Line (File);
        begin
           Line_Count := Line_Count + 1;
           Ada.Text_IO.Put_Line (Natural'Image (Line_Count) & ": " & Line);
        end;
     end loop;
     Ada.Text_IO.Close (File);
  end open_file;

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
        read_line(Line, image, canaux, Line_Count);
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
        raise Bad_File;
    end case;
  end read_magic_line;

  procedure read_dimension_line(Line : String; image : out A_Image; canaux: in Natural) is
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
      image := init(x, y, canaux);
      return;
    end if;

    raise Bad_File;
  end read_dimension_line;

  procedure read_pixel_line(Line: String; image : in out A_Image; y : Natural) is
    x : Natural := 0;
    previous_space : Integer := Line'First-1;
    pixel_components : T_Pixel_Array(1..image.all.Nb_canaux);
    canal : Natural := 1;
  begin
    if y >= getHeight(image) then
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

  end read_pixel_line;


  procedure read_line(Line : String; image : in out A_Image; canaux: in out Natural; Line_Count : in out Natural) is
  begin
    if Line(Line'First) = '#' then
      return;
    end if;
    Line_Count := Line_Count + 1;
    if Line_Count = 1 then
      read_magic_line(Line, canaux);
    elsif Line_Count = 2 then
      read_dimension_line(Line, image, canaux);
    else
      read_pixel_line(Line, image, Line_Count - 3);
    end if;
  end read_line;



end P_Image.File;
