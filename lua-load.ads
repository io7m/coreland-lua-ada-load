with ada.strings.unbounded;

generic
  type udata is private;

package lua.load is
  package su renames ada.strings.unbounded;

  -- types
  subtype u_string is su.unbounded_string;

  type load_t is record
    ls: lua.state;
    name_depth: natural := 0;
    name_code: u_string;
    name_file: u_string;
    err_string: u_string;
  end record;

  type load_ptr is access all load_t;

  -- api functions
  procedure set_lua (ctx: load_ptr; ls: lua.state);
  procedure set_file (ctx: load_ptr; file: string);

  function named_local_string (ctx: load_ptr; name: string) return u_string;
  function named_local_string_cond (ctx: load_ptr; name: string; default: string) return u_string;
  function named_local_number (ctx: load_ptr; name: string) return long_float;
  function named_local_number_cond (ctx: load_ptr; name: string; default: long_float) return long_float;

  function local_number (ctx: load_ptr) return long_float;
  function local_number_cond (ctx: load_ptr; default: long_float) return long_float;
  function local_string (ctx: load_ptr) return u_string;
  function local_string_cond (ctx: load_ptr; default: string) return u_string;

  procedure table_start (ctx: load_ptr; name: string);
  procedure table_iterate (ctx: load_ptr;
    proc: not null access procedure (ctx: load_ptr; data: in out udata);
    data: in out udata);
  procedure table_end (ctx: load_ptr);

  -- exceptions
  load_error: exception;

end lua.load;
