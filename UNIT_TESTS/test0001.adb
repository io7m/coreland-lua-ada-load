with Ada.Text_IO;
with Test;

procedure test0001 is
  package IO renames Ada.Text_IO;
begin
  Test.Init ("test0001.lua");

  declare
    x : constant Long_Float := Test.Load.Named_Local (Test.Loader_Access, "x");
  begin
    IO.Put_Line ("x: " & Integer'Image (Integer (x)));
  end;

exception
  when Test.Load.Load_Error =>
    IO.Put_Line ("fail: " & Test.Load.Error_String (Test.Loader_Access));
    raise Test.Load.Load_Error;
end test0001;
