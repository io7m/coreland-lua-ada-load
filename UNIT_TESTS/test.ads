with Ada.Strings.Unbounded;
with Lua;
with Lua.Load;

package Test is

  package UB_Strings renames Ada.Strings.Unbounded;
  package Load       renames Lua.Load;

  Lua_Err        : Lua.Error_t;
  Lua_Context    : Lua.State_t;
  Lua_Err_String : UB_Strings.Unbounded_String;

  Loader        : aliased Lua.Load.State_t;
  Loader_Access : constant Lua.Load.State_Access_t := Loader'Access;

  use type Lua.State_t;
  use type Lua.Error_t;

  procedure Init (File : in String);

end Test;
