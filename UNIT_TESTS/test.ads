with ada.strings.unbounded;
with lua;
with lua.load;

pragma elaborate_all (lua.load);

package test is
  package su renames ada.strings.unbounded;
  package load is new lua.load (integer);

  lua_err: lua.error_t;
  lua_ctx: lua.state_ptr_t;
  lua_err_string: su.unbounded_string;

  loader: aliased load.load_t;
  loader_ptr: constant load.load_ptr_t := loader'access;

  use type lua.state_ptr_t;
  use type lua.error_t;

  procedure init (file: string);
end test;
