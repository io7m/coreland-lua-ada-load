with lua.lib;

package body test is

  procedure init (file : string) is
  begin
    lua_context := lua.open;
    if lua_context = lua.state_error then
      lua_err_string := su.to_unbounded_string ("could not open lua");
      raise program_error;
    end if;

    lua.lib.open_base (lua_context);

    lua_err := lua.load_file (lua_context, file);
    if lua_err /= lua.lua_error_none then
      lua_err_string := su.to_unbounded_string (lua.to_string (lua_context, -1));
      raise program_error;
    end if;

    lua_err := lua.pcall (lua_context, 0, 1, 0);
    if lua_err /= lua.lua_error_none then
      lua_err_string := su.to_unbounded_string (lua.to_string (lua_context, -1));
      raise program_error;
    end if;

    lua.load.set_lua (loader_access, lua_context);
    lua.load.set_file (loader_access, "test.lua");
  end init;

end test;
