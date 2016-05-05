generic
  type element is private;

package P_Image.File is
  procedure open_file(Filename : String);
  Bad_File : Exception;

  function open(Filename : String) return A_Image;

  private
  procedure read_line(Line : String; image : in out A_Image; canaux: in out Natural; Line_Count : in out Natural);

end P_Image.File;
