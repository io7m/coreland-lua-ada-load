with ada.text_io;
with test;

procedure test0006 is
  package io renames ada.text_io;
begin
  test.init ("test0006.lua");

  begin
    test.load.table_start (test.loader_access, "y");
  exception
    when test.load.load_error =>
      io.put_line (test.load.error_string (test.loader_access));
  end;

exception
  when test.load.load_error =>
    io.put_line ("fail: " & test.load.error_string (test.loader_access));
    raise test.load.load_error;
end test0006;
