with ada.text_io;
with lua;
with test;

procedure test0008 is
  package io renames ada.text_io;
begin
  test.init ("test0008.lua");

  declare
    procedure proc (context : test.load.state_access_t) is
    begin
      io.put_line ("--");
      io.put_line (lua.type_name (test.load.key_type (context)));
    end proc;
  begin
    test.load.table_iterate (test.loader_access, proc'access);
  end;

exception
  when test.load.load_error =>
    io.put_line ("fail: " & test.load.error_string (test.loader_access));
    raise test.load.load_error;
end test0008;
