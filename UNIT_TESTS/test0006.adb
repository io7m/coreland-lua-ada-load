with Ada.Text_IO;
with Test;

procedure test0006 is
  package IO renames Ada.Text_IO;
begin
  Test.Init ("test0006.lua");

  begin
    Test.Load.Table_Start (Test.Loader_Access, "y");
  exception
    when Test.Load.Load_Error =>
      IO.Put_Line (Test.Load.Error_String (Test.Loader_Access));
  end;

exception
  when Test.Load.Load_Error =>
    IO.Put_Line ("fail: " & Test.Load.Error_String (Test.Loader_Access));
    raise Test.Load.Load_Error;
end test0006;
