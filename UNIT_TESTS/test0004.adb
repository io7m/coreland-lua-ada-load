with ada.strings.unbounded;
with ada.text_io;
with test;

procedure test0004 is
  package io renames ada.text_io;
  package su renames ada.strings.unbounded;
begin
  test.init ("test0004.lua");

  begin
    declare
      x: constant su.unbounded_string :=
        test.load.named_local (test.loader_ptr, "x");
    begin
      io.put_line ("x: " & su.to_string (x));
    end;
  exception
    when test.load.load_error =>
      io.put_line (test.su.to_string (test.loader.err_string));
  end;

exception
  when test.load.load_error =>
    io.put_line ("fail: " & test.su.to_string (test.loader.err_string));
    raise test.load.load_error;
end test0004;
