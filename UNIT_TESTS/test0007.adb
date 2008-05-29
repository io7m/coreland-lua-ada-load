with ada.text_io;
with test;

procedure test0007 is
  package io renames ada.text_io;
begin
  test.init ("test0007.lua");

  declare
    procedure proc (ctx: test.load.load_ptr_t; data: in out integer) is
      x: constant long_float := test.load.named_local (ctx, "x");
      y: constant long_float := test.load.named_local (ctx, "y");
      z: constant long_float := test.load.named_local (ctx, "z");
    begin
      io.put_line ("--");
      io.put_line
        (test.su.to_string (ctx.name_code) & ".x: " & integer'image (integer (x)));
      io.put_line
        (test.su.to_string (ctx.name_code) & ".y: " & integer'image (integer (y)));
      io.put_line
        (test.su.to_string (ctx.name_code) & ".z: " & integer'image (integer (z)));
    end proc;
    x: integer := 0;
  begin
    test.load.table_iterate (test.loader_ptr, proc'access, x);
  end;

exception
  when test.load.load_error =>
    io.put_line ("fail: " & test.su.to_string (test.loader.err_string));
    raise test.load.load_error;
end test0007;
