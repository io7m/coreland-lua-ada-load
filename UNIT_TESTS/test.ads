with ada.strings.unbounded;
with lua;
with lua.load;

package test is
  package su renames ada.strings.unbounded;
  package load renames lua.load;

  lua_err        : lua.error_t;
  lua_context    : lua.state_t;
  lua_err_string : su.unbounded_string;

  loader        : aliased lua.load.state_t;
  loader_access : constant lua.load.state_access_t := loader'access;

  use type lua.state_t;
  use type lua.error_t;

  procedure init (file : string);
end test;
