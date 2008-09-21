with ada.text_io;
with test;

procedure test0002 is
  package io renames ada.text_io;
begin
  test.init ("test0002.lua");

  begin
    declare
      x : constant long_float := test.load.named_local (test.loader_access, "x");
    begin
      io.put_line ("x: " & long_float'image (x));
    end;
  exception
    when test.load.load_error =>
      io.put_line (test.load.error_string (test.loader_access));
  end;

exception
  when test.load.load_error =>
    io.put_line ("fail: " & test.load.error_string (test.loader_access));
    raise test.load.load_error;
end test0002;
