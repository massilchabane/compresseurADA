generic
  type element is private;

package P_Image.File is
  Bad_File : Exception;

  function open(Filename : String) return A_Image;
  procedure write(image : A_Image);

  private
  procedure read_line(Line : String; image : in out A_Image; canaux: in out Natural; Line_Count : in out Natural; File_Name : String);

end P_Image.File;
