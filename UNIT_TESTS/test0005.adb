with ada.text_io;
with test;

procedure test0005 is
  package io renames ada.text_io;
begin
  test.init ("test0005.lua");

  test.load.table_start (test.loader_access, "x");
  declare
    x : constant long_float := test.load.named_local (test.loader_access, "y");
  begin
    io.put_line ("x.y: " & integer'image (integer (x)));
  end;
  test.load.table_end (test.loader_access);

exception
  when test.load.load_error =>
    io.put_line ("fail: " & test.load.error_string (test.loader_access));
    raise test.load.load_error;
end test0005;
