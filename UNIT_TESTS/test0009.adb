with ada.text_io;
with lua;
with test;

procedure test0009 is
  package io renames ada.text_io;
begin
  test.init ("test0009.lua");

  declare
    procedure proc
      (context : test.load.load_access_t;
       data    : in out integer) is
    begin
      io.put_line ("--");
      io.put_line (lua.type_name (test.load.key_type (context)));
      io.put_line (test.su.to_string (test.load.key (context)));
    end proc;
    x : integer := 0;
  begin
    test.load.table_iterate (test.loader_access, proc'access, x);
  end;

exception
  when test.load.load_error =>
    io.put_line ("fail: " & test.load.error_string (test.loader_access));
    raise test.load.load_error;
end test0009;
