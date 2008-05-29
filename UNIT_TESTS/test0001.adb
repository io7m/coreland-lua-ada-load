with ada.text_io;
with test;

procedure test0001 is
  package io renames ada.text_io;
begin
  test.init ("test0001.lua");

  declare
    x: constant long_float := test.load.named_local (test.loader_ptr, "x");
  begin
    io.put_line ("x: " & integer'image (integer (x)));
  end;

exception
  when test.load.load_error =>
    io.put_line ("fail: " & test.su.to_string (test.loader.err_string));
    raise test.load.load_error;
end test0001;
