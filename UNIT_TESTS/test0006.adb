with ada.text_io;
with test;

procedure test0006 is
  package io renames ada.text_io;
begin
  test.init ("test0006.lua");

  begin
    test.load.table_start (test.loader_ptr, "y");
  exception
    when test.load.load_error =>
      io.put_line (test.su.to_string (test.loader.err_string));
  end;

exception
  when test.load.load_error =>
    io.put_line ("fail: " & test.su.to_string (test.loader.err_string));
    raise test.load.load_error;
end test0006;
