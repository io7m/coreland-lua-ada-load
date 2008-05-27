with ada.strings;
with ada.strings.fixed;

package body lua.load is
  package s renames ada.strings;
  package sf renames ada.strings.fixed;

  -- add a name component
  procedure add_name_component (ctx: load_ptr; name: string) is
  begin
    if su.length (ctx.name_code) /= 0 then
      su.append (ctx.name_code, ".");
    end if;
    su.append (ctx.name_code, name);
    ctx.name_depth := ctx.name_depth + 1;
  end add_name_component;

  -- remove a name component
  procedure remove_name_component (ctx: load_ptr) is
    len: constant natural := su.length (ctx.name_code);
    dot: natural := su.index (ctx.name_code, ".", len, s.backward);
  begin
    if dot /= 0 then dot := dot - 1; end if;
    su.head (ctx.name_code, dot);
    ctx.name_depth := ctx.name_depth - 1;
  end remove_name_component;

  -- return dot if current name is nonzero length
  function dot (ctx: load_ptr) return string is
  begin
    if (su.length (ctx.name_code) /= 0) then return "."; else return ""; end if;
  end dot;

  --
  -- Public API
  --

  -- set lua context
  procedure set_lua (ctx: load_ptr; ls: lua.state) is
  begin
    ctx.ls := ls;
  end set_lua;

  -- set filename
  procedure set_file (ctx: load_ptr; file: string) is
  begin
    ctx.name_file := su.to_unbounded_string (file);
  end set_file;

  -- get number on stack, error on invalid type.
  function local_number (ctx: load_ptr) return long_float is
  begin
    if lua.type_of (ctx.ls, -1) /= lua.t_number then
      lua.pop (ctx.ls, 1);
      ctx.err_string := su.to_unbounded_string
        (su.to_string (ctx.name_code) & ": not a number");
      raise load_error;
    end if;
    return long_float (lua.to_number (ctx.ls, -1));
  end local_number;

  -- get number on stack, return default on nil, error on invalid type.
  function local_number_cond (ctx: load_ptr; default: long_float)
    return long_float is
  begin
    if lua.type_of (ctx.ls, -1) = lua.t_nil then
      lua.pop (ctx.ls, 1);
      return default;
    end if;
    return local_number (ctx);
  end local_number_cond;

  -- get string on stack, error on invalid type.
  function local_string (ctx: load_ptr) return u_string is
  begin
    if lua.type_of (ctx.ls, -1) /= lua.t_string then
      lua.pop (ctx.ls, 1);
      ctx.err_string := su.to_unbounded_string
        (su.to_string (ctx.name_code) & ": not a string");
      raise load_error;
    end if;
    return su.to_unbounded_string (lua.to_string (ctx.ls, -1));
  end local_string;

  -- get string on stack, return default on nil, error on invalid type.
  function local_string_cond (ctx: load_ptr; default: string)
    return u_string is
  begin
    if lua.type_of (ctx.ls, -1) = lua.t_nil then
      lua.pop (ctx.ls, 1);
      return su.to_unbounded_string (default);
    end if;
    return local_string (ctx);
  end local_string_cond;

  -- get named numeric field, error on invalid type.
  function named_local_number (ctx: load_ptr; name: string)
    return long_float is
  begin
    lua.get_field (ctx.ls, -1, name);
    if lua.type_of (ctx.ls, -1) /= lua.t_number then
      lua.pop (ctx.ls, 1);
      ctx.err_string := su.to_unbounded_string
        (su.to_string (ctx.name_code) & dot (ctx) & name & ": not a number");
      raise load_error;
    end if;
    declare
      num: constant long_float := long_float (lua.to_number (ctx.ls, -1));
    begin
      lua.pop (ctx.ls, 1);
      return num;
    end;
  end named_local_number;

  -- get named numeric field if defined, return default on nil, error on other type
  function named_local_number_cond (ctx: load_ptr; name: string;
    default: long_float) return long_float is
  begin
    lua.get_field (ctx.ls, -1, name);
    if lua.type_of (ctx.ls, -1) = lua.t_number then
      declare
        num: constant long_float := long_float (lua.to_number (ctx.ls, -1));
      begin
        lua.pop (ctx.ls, 1);
        return num;
      end;
    end if;
    if lua.type_of (ctx.ls, -1) = lua.t_nil then
      lua.pop (ctx.ls, 1);
      return default;
    end if;
    lua.pop (ctx.ls, 1);
    ctx.err_string := su.to_unbounded_string
      (su.to_string (ctx.name_code) & dot (ctx) & name & ": not a number");
    raise load_error;
  end named_local_number_cond;

  -- get named string field, error on other type.
  function named_local_string (ctx: load_ptr; name: string)
    return u_string is
  begin
    lua.get_field (ctx.ls, -1, name);
    if lua.type_of (ctx.ls, -1) /= lua.t_string then
      lua.pop (ctx.ls, 1);
      ctx.err_string := su.to_unbounded_string
        (su.to_string (ctx.name_code) & dot (ctx) & name & ": not a string");
      raise load_error;
    end if;
    declare
      str: constant string := lua.to_string (ctx.ls, -1);
       us: constant u_string := su.to_unbounded_string (str);
    begin
      lua.pop (ctx.ls, 1);
      return us;
    end;
  end named_local_string;

  -- get string if defined, error on other type
  function named_local_string_cond (ctx: load_ptr; name: string;
    default: string) return u_string is
  begin
    lua.get_field (ctx.ls, -1, name);
    if lua.type_of (ctx.ls, -1) = lua.t_string then
      declare
        str: constant string := lua.to_string (ctx.ls, -1);
         us: constant u_string := su.to_unbounded_string (str);
      begin
        lua.pop (ctx.ls, 1);
        return us;
      end;
    end if;
    if lua.type_of (ctx.ls, -1) = lua.t_nil then
      lua.pop (ctx.ls, 1);
      return su.to_unbounded_string (default);
    end if;
    lua.pop (ctx.ls, 1);
    ctx.err_string := su.to_unbounded_string
      (su.to_string (ctx.name_code) & dot (ctx) & name & ": not a string");
    raise load_error;
  end named_local_string_cond;

  -- push table 'name' onto stack
  procedure table_start (ctx: load_ptr; name: string) is
  begin
    lua.get_field (ctx.ls, -1, name);
    if lua.type_of (ctx.ls, -1) /= lua.t_table then
      ctx.err_string := su.to_unbounded_string
        (su.to_string (ctx.name_code) & dot (ctx) & name & ": not a table");
      raise load_error;
    end if;
    add_name_component (ctx, name);
  end table_start;

  -- remove table from stack
  procedure table_end (ctx: load_ptr) is
  begin
    if lua.type_of (ctx.ls, -1) /= lua.t_table then
      ctx.err_string := su.to_unbounded_string
        (su.to_string (ctx.name_code) & ": not a table");
      raise load_error;
    end if;
    remove_name_component (ctx);
    lua.pop (ctx.ls, 1);
  end table_end;

  -- iterate over table, calling proc for each value
  procedure table_iterate (ctx: load_ptr;
    proc: not null access procedure (ctx: load_ptr; data: in out udata);
    data: in out udata) is
    index: integer;
    added: boolean;
  begin
    if lua.type_of (ctx.ls, -1) /= lua.t_table then
      ctx.err_string := su.to_unbounded_string
        (su.to_string (ctx.name_code) & ": not a table");
      raise load_error;
    end if;
 
    -- iterate over table keys
    lua.push_nil (ctx.ls);
    while (lua.next (ctx.ls, -2) /= 0) loop
      added := false;

      -- integer key?
      if (lua.type_of (ctx.ls, -2) = lua.t_number) then
        index := integer (lua.to_number (ctx.ls, -2));
        declare
          str: constant string := "[" & sf.trim (integer'image (index), s.left) & "]";
        begin
          add_name_component (ctx, str);
        end;
        added := true;
      end if;

      -- string key?
      if (lua.type_of (ctx.ls, -2) = lua.t_string) then
        add_name_component (ctx, lua.to_string (ctx.ls, -2));
        added := true;
      end if;

      -- call proc ()
      begin
        proc (ctx, data);
      exception
        when load_error =>
          if added then remove_name_component (ctx); end if;
          raise;
      end;

      if added then remove_name_component (ctx); end if;
      lua.pop (ctx.ls, 1);
    end loop;
  end table_iterate;

end lua.load;
