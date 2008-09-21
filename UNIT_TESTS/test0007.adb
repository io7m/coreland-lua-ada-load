with ada.text_io;
with test;

procedure test0007 is
  package io renames ada.text_io;
begin
  test.init ("test0007.lua");

  declare
    procedure proc
      (context : test.load.load_access_t;
       data    : in out integer)
    is
      x : constant long_float := test.load.named_local (context, "x");
      y : constant long_float := test.load.named_local (context, "y");
      z : constant long_float := test.load.named_local (context, "z");
    begin
      io.put_line ("--");
      io.put_line
        (test.load.name_code (test.loader_access) & ".x: " & integer'image (integer (x)));
      io.put_line
        (test.load.name_code (test.loader_access) & ".y: " & integer'image (integer (y)));
      io.put_line
        (test.load.name_code (test.loader_access) & ".z: " & integer'image (integer (z)));
    end proc;
    x : integer := 0;
  begin
    test.load.table_iterate (test.loader_access, proc'access, x);
  end;

exception
  when test.load.load_error =>
    io.put_line ("fail: " & test.load.error_string (test.loader_access));
    raise test.load.load_error;
end test0007;
