with Ada.Strings.Unbounded;
with Ada.Text_IO;
with Test;

procedure test0004 is
  package IO renames Ada.Text_IO;
  package UB_Strings renames Ada.Strings.Unbounded;
begin
  Test.Init ("test0004.lua");

  begin
    declare
      x : constant UB_Strings.Unbounded_String :=
        Test.Load.Named_Local (Test.Loader_Access, "x");
    begin
      IO.Put_Line ("x: " & UB_Strings.To_String (x));
    end;
  exception
    when Test.Load.Load_Error =>
      IO.Put_Line (Test.Load.Error_String (Test.Loader_Access));
  end;

exception
  when Test.Load.Load_Error =>
    IO.Put_Line ("fail: " & Test.Load.Error_String (Test.Loader_Access));
    raise Test.Load.Load_Error;
end test0004;
