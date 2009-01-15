with ada.strings.unbounded;

package lua.load is
  package su renames ada.strings.unbounded;

  -- types
  subtype ustring_t is su.unbounded_string;

  type state_t is limited private;
  type state_access_t is access all state_t;

  -- api functions

  procedure set_lua
    (state     : in state_access_t;
     lua_state : in lua.state_t);

  procedure set_file
    (state : in state_access_t;
     file  : in string);

  -- type retrieval

  function key_type (state : in state_access_t) return lua.type_t;
  pragma inline (key_type);

  function key_type_is
    (state  : in state_access_t;
     k_type : in lua.type_t) return boolean;
  pragma inline (key_type_is);

  function value_type (state : in state_access_t) return lua.type_t;
  pragma inline (value_type);

  function value_type_is
    (state  : in state_access_t;
     v_type : in lua.type_t) return boolean;
  pragma inline (value_type_is);

  function key (state: in state_access_t) return long_float;
  function key (state: in state_access_t) return long_integer;
  function key (state: in state_access_t) return ustring_t;

  -- named local retrieval

  function named_local
    (state : in state_access_t;
     name  : in string) return ustring_t;

  function named_local
    (state : in state_access_t;
     name  : in string) return long_float;

  function named_local
    (state : in state_access_t;
     name  : in string) return long_integer;

  function named_local_cond
    (state   : in state_access_t;
     name    : in string;
     default : in string := "") return ustring_t;

  function named_local_cond
    (state   : in state_access_t;
     name    : in string;
     default : in long_float := 0.0) return long_float;

  function named_local_cond
    (state   : in state_access_t;
     name    : in string;
     default : in long_integer := 0) return long_integer;

  function local (state : in state_access_t) return long_float;

  function local (state : in state_access_t) return long_integer;

  function local (state : in state_access_t) return ustring_t;

  function local_cond
    (state   : in state_access_t;
     default : in long_float := 0.0) return long_float;

  function local_cond
    (state   : in state_access_t;
     default : in long_integer := 0) return long_integer;

  function local_cond
    (state   : in state_access_t;
     default : in string := "") return ustring_t;

  -- table handling

  procedure table_start
    (state : in state_access_t;
     name  : in string);

  procedure table_iterate
    (state : in state_access_t;
     proc  : not null access procedure
      (state : in state_access_t));

  procedure table_end (state: in state_access_t);

  -- error strings

  function error_string (state : in state_access_t) return string;
  pragma inline (error_string);

  function name_code (state : in state_access_t) return string;
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
