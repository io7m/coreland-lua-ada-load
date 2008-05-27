with lua.lib;

package body test is

  procedure init (file: string) is
  begin
    lua_ctx := lua.open;
    if lua_ctx = lua.state_error then
      lua_err_string := su.to_unbounded_string ("could not open lua");
      raise program_error;
    end if;

    lua.lib.open_base (lua_ctx);

    lua_err := lua.load_file (lua_ctx, file);
    if lua_err /= lua.lua_error_none then
      lua_err_string := su.to_unbounded_string (lua.to_string (lua_ctx, -1));
      raise program_error;
    end if;

    lua_err := lua.pcall (lua_ctx, 0, 1, 0);
    if lua_err /= lua.lua_error_none then
      lua_err_string := su.to_unbounded_string (lua.to_string (lua_ctx, -1));
      raise program_error;
    end if;

    load.set_lua (loader_ptr, lua_ctx);
    load.set_file (loader_ptr, "test.lua");
  end init;

end test;
