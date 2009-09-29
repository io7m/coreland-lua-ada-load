with Ada.Text_IO;
with Test;

procedure test0010 is
  package IO renames Ada.Text_IO;
begin
  Test.Init ("test0010.lua");

  declare
    procedure Process (Context : Test.Load.State_Access_t) is
    begin
      IO.Put_Line (Long_Integer'Image (Test.Load.Indexed_Local (Context, 1)));
      IO.Put_Line (Long_Integer'Image (Test.Load.Indexed_Local (Context, 2)));
      IO.Put_Line (Long_Integer'Image (Test.Load.Indexed_Local (Context, 3)));
      IO.Put_Line (Long_Integer'Image (Test.Load.Indexed_Local (Context, 4)));
      IO.Put_Line (Long_Integer'Image (Test.Load.Indexed_Local (Context, 5)));
      IO.Put_Line (Long_Integer'Image (Test.Load.Indexed_Local (Context, 6)));
      IO.Put_Line (Long_Integer'Image (Test.Load.Indexed_Local (Context, 7)));
      IO.Put_Line (Long_Integer'Image (Test.Load.Indexed_Local (Context, 8)));
      IO.Put_Line (Long_Integer'Image (Test.Load.Indexed_Local (Context, 9)));
    end Process;
  begin
    Test.Load.Table_Iterate (Test.Loader_Access, Process'Access);
  end;

exception
  when Test.Load.Load_Error =>
    IO.Put_Line ("fail: " & Test.Load.Error_String (Test.Loader_Access));
    raise Test.Load.Load_Error;
end test0010;
