with ada.text_io;
with lua;
with test;

procedure test0008 is
  package io renames ada.text_io;
begin
  test.init ("test0008.lua");

  declare
    procedure proc
      (context : test.load.load_access_t;
       data    : in out integer) is
    begin
      io.put_line ("--");
      io.put_line (lua.type_name (test.load.key_type (context)));
    end proc;
    x : integer := 0;
  begin
    test.load.table_iterate (test.loader_access, proc'access, x);
  end;

exception
  when test.load.load_error =>
    io.put_line ("fail: " & test.load.error_string (test.loader_access));
    raise test.load.load_error;
end test0008;
