with ada.text_io;
with lua;
with test;

procedure test0008 is
  package io renames ada.text_io;
begin
  test.init ("test0008.lua");

  declare
    procedure proc (ctx: test.load.load_ptr_t; data: in out integer) is
    begin
      io.put_line ("--");
      io.put_line (lua.type_name (test.load.key_type (ctx)));
    end proc;
    x: integer := 0;
  begin
    test.load.table_iterate (test.loader_ptr, proc'access, x);
  end;

exception
  when test.load.load_error =>
    io.put_line ("fail: " & test.su.to_string (test.loader.err_string));
    raise test.load.load_error;
end test0008;
