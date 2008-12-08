with ada.strings.unbounded;

package lua.load is
  package su renames ada.strings.unbounded;

  -- types
  subtype ustring_t is su.unbounded_string;

  type state_t is limited private;
  type state_access_t is access all state_t;

  -- api functions

  procedure set_lua
    (state     : state_access_t;
     lua_state : lua.state_t);

  procedure set_file
    (state : state_access_t;
     file  : string);

  -- type retrieval

  function key_type (state : state_access_t) return lua.type_t;
  pragma inline (key_type);

  function key_type_is
    (state  : state_access_t;
     k_type : lua.type_t) return boolean;
  pragma inline (key_type_is);

  function value_type (state : state_access_t) return lua.type_t;
  pragma inline (value_type);

  function value_type_is
    (state  : state_access_t;
     v_type : lua.type_t) return boolean;
  pragma inline (value_type_is);

  function key (state: state_access_t) return long_float;
  function key (state: state_access_t) return long_integer;
  function key (state: state_access_t) return ustring_t;

  -- named local retrieval

  function named_local
    (state : state_access_t;
     name  : string) return ustring_t;

  function named_local
    (state : state_access_t;
     name  : string) return long_float;

  function named_local
    (state : state_access_t;
     name  : string) return long_integer;

  function named_local_cond
    (state   : state_access_t;
     name    : string;
     default : string := "") return ustring_t;

  function named_local_cond
    (state   : state_access_t;
     name    : string;
     default : long_float := 0.0) return long_float;

  function named_local_cond
    (state   : state_access_t;
     name    : string;
     default : long_integer := 0) return long_integer;

  function local (state : state_access_t) return long_float;

  function local (state : state_access_t) return long_integer;

  function local (state : state_access_t) return ustring_t;

  function local_cond
    (state   : state_access_t;
     default : long_float := 0.0) return long_float;

  function local_cond
    (state   : state_access_t;
     default : long_integer := 0) return long_integer;

  function local_cond
    (state   : state_access_t;
     default : string := "") return ustring_t;

  -- table handling

  procedure table_start
    (state : state_access_t;
     name  : string);

  procedure table_iterate
    (state : state_access_t;
     proc  : not null access procedure (state : state_access_t));

  procedure table_end (state: state_access_t);

  -- error strings

  function error_string (state : state_access_t) return string;
  pragma inline (error_string);

  function name_code (state : state_access_t) return string;
  pragma inline (name_code);

  -- exceptions
  load_error: exception;

private

  type state_t is record
    lua_state  : lua.state_t;
    name_depth : natural := 0;
    name_code  : ustring_t;
    name_file  : ustring_t;
    err_string : ustring_t;
  end record;

end lua.load;
