with ada.strings.unbounded;

generic
  type udata is private;

package lua.load is
  package su renames ada.strings.unbounded;

  -- types

  subtype u_string is su.unbounded_string;

  type load_t is limited private;
  type load_access_t is access all load_t;

  -- api functions

  procedure set_lua
    (context   : load_access_t;
     lua_state : lua.state_t);

  procedure set_file
    (context : load_access_t;
     file    : string);

  -- type retrieval

  function key_type (context : load_access_t) return lua.type_t;
  pragma inline (key_type);

  function key_type_is
    (context : load_access_t;
     k_type  : lua.type_t) return boolean;
  pragma inline (key_type_is);

  function value_type (context : load_access_t) return lua.type_t;
  pragma inline (value_type);

  function value_type_is
    (context : load_access_t;
     v_type  : lua.type_t) return boolean;
  pragma inline (value_type_is);

  function key (context: load_access_t) return long_float;
  function key (context: load_access_t) return u_string;

  -- named local retrieval

  function named_local
    (context : load_access_t;
     name    : string) return u_string;

  function named_local
    (context : load_access_t;
     name    : string) return long_float;

  function named_local_cond
    (context : load_access_t;
     name    : string;
     default : string) return u_string;

  function named_local_cond
    (context : load_access_t;
     name    : string;
     default : long_float) return long_float;

  function local (context: load_access_t) return long_float;

  function local (context: load_access_t) return u_string;

  function local_cond
    (context : load_access_t;
     default : long_float) return long_float;

  function local_cond
    (context : load_access_t;
     default : string) return u_string;

  -- table handling

  procedure table_start
    (context : load_access_t;
     name    : string);

  procedure table_iterate
    (context : load_access_t;
     proc    : not null access procedure
      (context : load_access_t;
       data    : in out udata);
     data    : in out udata);

  procedure table_end (context: load_access_t);

  -- error strings

  function error_string (context : load_access_t) return string;
  pragma inline (error_string);

  function name_code (context : load_access_t) return string;
  pragma inline (name_code);

  -- exceptions
  load_error: exception;

private

  type load_t is record
    lua_state  : lua.state_t;
    name_depth : natural := 0;
    name_code  : u_string;
    name_file  : u_string;
    err_string : u_string;
  end record;

end lua.load;
