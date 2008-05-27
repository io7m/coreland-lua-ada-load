with ada.strings.unbounded;
with lua;
with lua.load;

pragma elaborate_all (lua.load);

package test is
  package su renames ada.strings.unbounded;
  package load is new lua.load (integer);

  lua_err: lua.error_type;
  lua_ctx: lua.state;
  lua_err_string: su.unbounded_string;

  loader: aliased load.load_t;
  loader_ptr: constant load.load_ptr := loader'access;

  use type lua.state;
  use type lua.error_type;

  procedure init (file: string);
end test;
