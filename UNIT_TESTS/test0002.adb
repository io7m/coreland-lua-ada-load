with ada.text_io;
with test;

procedure test0002 is
  package io renames ada.text_io;
begin
  test.init ("test0002.lua");

  begin
    declare
      x: constant long_float := test.load.named_local_number (test.loader_ptr, "x");
    begin
      io.put_line ("x: " & long_float'image (x));
    end;
  exception
    when test.load.load_error =>
      io.put_line (test.su.to_string (test.loader.err_string));
  end;

exception
  when test.load.load_error =>
    io.put_line ("fail: " & test.su.to_string (test.loader.err_string));
    raise test.load.load_error;
end test0002;
