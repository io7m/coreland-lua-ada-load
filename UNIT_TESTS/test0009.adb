with Ada.Text_IO;
with Lua;
with Test;

procedure test0009 is
  package IO renames Ada.Text_IO;
begin
  Test.Init ("test0009.lua");

  declare
    procedure Process (Context : Test.Load.State_Access_t) is
    begin
      IO.Put_Line ("--");
      IO.Put_Line (Lua.Type_Name (Test.Load.Key_Type (Context)));
      IO.Put_Line (Test.UB_Strings.To_String (Test.Load.Key (Context)));
    end Process;
  begin
    Test.Load.Table_Iterate (Test.Loader_Access, Process'Access);
  end;

exception
  when Test.Load.Load_Error =>
    IO.Put_Line ("fail: " & Test.Load.Error_String (Test.Loader_Access));
    raise Test.Load.Load_Error;
end test0009;
