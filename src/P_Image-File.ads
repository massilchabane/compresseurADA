with Ada.Text_IO, Ada.Integer_Text_IO; use Ada.Text_IO, Ada.Integer_Text_IO;
package P_Image.File is
  Bad_File : Exception;

  function open(Filename : String) return A_Image;
  procedure write (image : A_Image; FileName : String := "");

  private

  type T_Strings is array(Natural range <>) of A_String;

end P_Image.File;
