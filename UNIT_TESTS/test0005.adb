with Ada.Text_IO;
with Test;

procedure test0005 is
  package IO renames Ada.Text_IO;
begin
  Test.Init ("test0005.lua");

  Test.Load.Table_Start (Test.Loader_Access, "x");
  declare
    x : constant Long_Float := Test.Load.Named_Local (Test.Loader_Access, "y");
  begin
    IO.Put_Line ("x.y: " & Integer'Image (Integer (x)));
  end;
  Test.Load.Table_End (Test.Loader_Access);

exception
  when Test.Load.Load_Error =>
    IO.Put_Line ("fail: " & Test.Load.Error_String (Test.Loader_Access));
    raise Test.Load.Load_Error;
end test0005;
