with ada.text_io;
with test;

procedure test0005 is
  package io renames ada.text_io;
begin
  test.init ("test0005.lua");

  test.load.table_start (test.loader_ptr, "x");
  declare
    x: constant long_float :=
      test.load.named_local_number (test.loader_ptr, "y");
  begin
    io.put_line ("x.y: " & integer'image (integer (x)));
  end;
  test.load.table_end (test.loader_ptr);

exception
  when test.load.load_error =>
    io.put_line ("fail: " & test.su.to_string (test.loader.err_string));
    raise test.load.load_error;
end test0005;
