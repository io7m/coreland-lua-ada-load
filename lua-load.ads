with ada.strings.unbounded;

generic
  type udata is private;

package lua.load is
  package su renames ada.strings.unbounded;

  -- types
  subtype u_string is su.unbounded_string;

  type load_t is record
    ls: lua.state_ptr_t;
    name_depth: natural := 0;
    name_code: u_string;
    name_file: u_string;
    err_string: u_string;
  end record;

  type load_ptr_t is access all load_t;

  -- api functions
  procedure set_lua (ctx: load_ptr_t; ls: lua.state_ptr_t);
  procedure set_file (ctx: load_ptr_t; file: string);

  function key_type (ctx: load_ptr_t) return lua.type_t;
  function key_type_is (ctx: load_ptr_t; t: lua.type_t) return boolean;
  function value_type (ctx: load_ptr_t) return lua.type_t;
  function value_type_is (ctx: load_ptr_t; t: lua.type_t) return boolean;
  function key (ctx: load_ptr_t) return long_float;
  function key (ctx: load_ptr_t) return u_string;

  function named_local (ctx: load_ptr_t; name: string) return u_string;
  function named_local (ctx: load_ptr_t; name: string) return long_float;
  function named_local_cond (ctx: load_ptr_t; name: string; default: string) return u_string;
  function named_local_cond (ctx: load_ptr_t; name: string; default: long_float) return long_float;

  function local (ctx: load_ptr_t) return long_float;
  function local (ctx: load_ptr_t) return u_string;
  function local_cond (ctx: load_ptr_t; default: long_float) return long_float;
  function local_cond (ctx: load_ptr_t; default: string) return u_string;

  procedure table_start (ctx: load_ptr_t; name: string);
  procedure table_iterate (ctx: load_ptr_t;
    proc: not null access procedure (ctx: load_ptr_t; data: in out udata);
    data: in out udata);
  procedure table_end (ctx: load_ptr_t);

  -- exceptions
  load_error: exception;

end lua.load;
