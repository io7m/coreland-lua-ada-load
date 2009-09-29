with Ada.Text_IO;
with Test;

procedure test0002 is
  package IO renames Ada.Text_IO;
begin
  Test.Init ("test0002.lua");

  begin
    declare
      x : constant Long_Float := Test.Load.Named_Local (Test.Loader_Access, "x");
    begin
      IO.Put_Line ("x: " & Long_Float'Image (x));
    end;
  exception
    when Test.Load.Load_Error =>
      IO.Put_Line (Test.Load.Error_String (Test.Loader_Access));
  end;

exception
  when Test.Load.Load_Error =>
    IO.Put_Line ("fail: " & Test.Load.Error_String (Test.Loader_Access));
    raise Test.Load.Load_Error;
end test0002;
