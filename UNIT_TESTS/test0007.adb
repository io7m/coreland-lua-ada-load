with Ada.Text_IO;
with Test;

procedure test0007 is
  package IO renames Ada.Text_IO;
begin
  Test.Init ("test0007.lua");

  declare
    procedure Process (Context : Test.Load.State_Access_t) is
      x : constant Long_Float := Test.Load.Named_Local (Context, "x");
      y : constant Long_Float := Test.Load.Named_Local (Context, "y");
      z : constant Long_Float := Test.Load.Named_Local (Context, "z");
    begin
      IO.Put_Line ("--");
      IO.Put_Line
        (Test.Load.Name_Code (Test.Loader_Access) & ".x: " & Integer'Image (Integer (x)));
      IO.Put_Line
        (Test.Load.Name_Code (Test.Loader_Access) & ".y: " & Integer'Image (Integer (y)));
      IO.Put_Line
        (Test.Load.Name_Code (Test.Loader_Access) & ".z: " & Integer'Image (Integer (z)));
    end Process;
  begin
    Test.Load.Table_Iterate (Test.Loader_Access, Process'Access);
  end;

exception
  when Test.Load.Load_Error =>
    IO.Put_Line ("fail: " & Test.Load.Error_String (Test.Loader_Access));
    raise Test.Load.Load_Error;
end test0007;
