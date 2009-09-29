with Lua.Lib;

package body Test is

  procedure Init (File : String) is
  begin
    Lua_Context := Lua.Open;
    if Lua_Context = Lua.State_Error then
      Lua_Err_String := UB_Strings.To_Unbounded_String ("could not open Lua");
      raise Program_Error;
    end if;

    Lua.Lib.Open_Base (Lua_Context);

    Lua_Err := Lua.Load_File (Lua_Context, File);
    if Lua_Err /= Lua.Lua_Error_None then
      Lua_Err_String := UB_Strings.To_Unbounded_String (Lua.To_String (Lua_Context, -1));
      raise Program_Error;
    end if;

    Lua_Err := Lua.PCall (Lua_Context, 0, 1, 0);
    if Lua_Err /= Lua.Lua_Error_None then
      Lua_Err_String := UB_Strings.To_Unbounded_String (Lua.To_String (Lua_Context, -1));
      raise Program_Error;
    end if;

    Lua.Load.Set_Lua (Loader_Access, Lua_Context);
    Lua.Load.Set_File (Loader_Access, "test.lua");
  end Init;

end Test;
