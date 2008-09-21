with ada.strings.unbounded;
with ada.text_io;
with test;

procedure test0003 is
  package io renames ada.text_io;
  package su renames ada.strings.unbounded;
begin
  test.init ("test0003.lua");

  declare
    x : constant su.unbounded_string :=
      test.load.named_local (test.loader_access, "x");
  begin
    io.put_line ("x: " & su.to_string (x));
  end;

exception
  when test.load.load_error =>
    io.put_line ("fail: " & test.load.error_string (test.loader_access));
    raise test.load.load_error;
end test0003;
