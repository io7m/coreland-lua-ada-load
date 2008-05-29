with ada.strings;
with ada.strings.fixed;

package body lua.load is
  package s renames ada.strings;
  package sf renames ada.strings.fixed;

  -- add a name component
  procedure add_name_component (ctx: load_ptr_t; name: string) is
  begin
    if su.length (ctx.name_code) /= 0 then
      su.append (ctx.name_code, ".");
    end if;
    su.append (ctx.name_code, name);
    ctx.name_depth := ctx.name_depth + 1;
  end add_name_component;

  -- remove a name component
  procedure remove_name_component (ctx: load_ptr_t) is
    len: constant natural := su.length (ctx.name_code);
    dot: natural := su.index (ctx.name_code, ".", len, s.backward);
  begin
    if dot /= 0 then dot := dot - 1; end if;
    su.head (ctx.name_code, dot);
    ctx.name_depth := ctx.name_depth - 1;
  end remove_name_component;

  type target_t is (target_key, target_value);

  function target_name (t: target_t) return string is
  begin
    case t is
      when target_key => return "key";
      when target_value => return "value";
    end case;
  end target_name;

  -- type error
  procedure type_error (ctx: load_ptr_t; target: target_t; expected: lua.type_t) is
  begin
    ctx.err_string := su.to_unbounded_string ("");
    if su.length (ctx.name_code) /= 0 then
      su.append (ctx.err_string, su.to_string (ctx.name_code) & ": ");
    end if;
    su.append (ctx.err_string, target_name (target) & ": not a " & lua.type_name (expected));
    raise load_error;
  end;

  --
  -- Public API
  --

  -- set lua context
  procedure set_lua (ctx: load_ptr_t; ls: lua.state_ptr_t) is
  begin
    ctx.ls := ls;
  end set_lua;

  -- set filename
  procedure set_file (ctx: load_ptr_t; file: string) is
  begin
    ctx.name_file := su.to_unbounded_string (file);
  end set_file;

  -- get key type
  function key_type (ctx: load_ptr_t) return lua.type_t is
  begin
    return lua.type_of (ctx.ls, -2);
  end key_type;

  -- check if key is of type t
  function key_type_is (ctx: load_ptr_t; t: lua.type_t) return boolean is
  begin
    return key_type (ctx) = t;
  end key_type_is;

  -- get value type
  function value_type (ctx: load_ptr_t) return lua.type_t is
  begin
    return lua.type_of (ctx.ls, -1);
  end value_type;

  -- check if value is of type t
  function value_type_is (ctx: load_ptr_t; t: lua.type_t) return boolean is
  begin
    return value_type (ctx) = t;
  end value_type_is;

  -- get key on stack as number
  function key (ctx: load_ptr_t) return long_float is
  begin
    if key_type_is (ctx, lua.t_number) = false then
      type_error (ctx, target => target_key, expected => lua.t_number);
    end if;
    return long_float (lua.to_number (ctx.ls, -2));
  end key;

  -- get key on stack as string
  function key (ctx: load_ptr_t) return u_string is
  begin
    if key_type_is (ctx, lua.t_string) = false then
      type_error (ctx, target => target_key, expected => lua.t_string);
    end if;
    return su.to_unbounded_string (lua.to_string (ctx.ls, -2));
  end key;

  -- get number on stack, error on invalid type.
  function local (ctx: load_ptr_t) return long_float is
  begin
    if value_type_is (ctx, lua.t_number) = false then
      lua.pop (ctx.ls, 1);
      type_error (ctx, target => target_value, expected => lua.t_number);
    end if;
    return long_float (lua.to_number (ctx.ls, -1));
  end local;

  -- get number on stack, return default on nil, error on invalid type.
  function local_cond (ctx: load_ptr_t; default: long_float)
    return long_float is
  begin
    if value_type_is (ctx, lua.t_nil) then
      lua.pop (ctx.ls, 1);
      return default;
    end if;
    return local (ctx);
  end local_cond;

  -- get string on stack, error on invalid type.
  function local (ctx: load_ptr_t) return u_string is
  begin
    if value_type_is (ctx, lua.t_string) = false then
      lua.pop (ctx.ls, 1);
      type_error (ctx, target => target_value, expected => lua.t_string);
    end if;
    return su.to_unbounded_string (lua.to_string (ctx.ls, -1));
  end local;

  -- get string on stack, return default on nil, error on invalid type.
  function local_cond (ctx: load_ptr_t; default: string)
    return u_string is
  begin
    if value_type_is (ctx, lua.t_nil) then
      lua.pop (ctx.ls, 1);
      return su.to_unbounded_string (default);
    end if;
    return local (ctx);
  end local_cond;

  -- get named numeric field, error on invalid type.
  function named_local (ctx: load_ptr_t; name: string)
    return long_float is
  begin
    lua.get_field (ctx.ls, -1, name);
    if value_type_is (ctx, lua.t_number) = false then
      lua.pop (ctx.ls, 1);
      type_error (ctx, target => target_value, expected => lua.t_number);
    end if;
    declare
      num: constant long_float := long_float (lua.to_number (ctx.ls, -1));
    begin
      lua.pop (ctx.ls, 1);
      return num;
    end;
  end named_local;

  -- get named numeric field if defined, return default on nil, error on other type
  function named_local_cond (ctx: load_ptr_t; name: string;
    default: long_float) return long_float is
  begin
    lua.get_field (ctx.ls, -1, name);

    if value_type_is (ctx, lua.t_nil) then
      lua.pop (ctx.ls, 1);
      return default;
    end if;

    if value_type_is (ctx, lua.t_number) = false then
      lua.pop (ctx.ls, 1);
      type_error (ctx, target => target_value, expected => lua.t_number);
    end if;

    declare
      num: constant long_float := long_float (lua.to_number (ctx.ls, -1));
    begin
      lua.pop (ctx.ls, 1);
      return num;
    end;
  end named_local_cond;

  -- get named string field, error on other type.
  function named_local (ctx: load_ptr_t; name: string)
    return u_string is
  begin
    lua.get_field (ctx.ls, -1, name);

    if value_type_is (ctx, lua.t_string) = false then
      lua.pop (ctx.ls, 1);
      type_error (ctx, target => target_value, expected => lua.t_string);
    end if;

    declare
      str: constant string := lua.to_string (ctx.ls, -1);
      us: constant u_string := su.to_unbounded_string (str);
    begin
      lua.pop (ctx.ls, 1);
      return us;
    end;
  end named_local;

  -- get string if defined, error on other type
  function named_local_cond (ctx: load_ptr_t; name: string;
    default: string) return u_string is
  begin
    lua.get_field (ctx.ls, -1, name);

    if value_type_is (ctx, lua.t_nil) then
      lua.pop (ctx.ls, 1);
      return su.to_unbounded_string (default);
    end if;

    if value_type_is (ctx, lua.t_string) = false then
      lua.pop (ctx.ls, 1);
      type_error (ctx, target => target_value, expected => lua.t_string);
    end if;

    declare
      str: constant string := lua.to_string (ctx.ls, -1);
      us: constant u_string := su.to_unbounded_string (str);
    begin
      lua.pop (ctx.ls, 1);
      return us;
    end;
  end named_local_cond;

  -- push table 'name' onto stack
  procedure table_start (ctx: load_ptr_t; name: string) is
  begin
    lua.get_field (ctx.ls, -1, name);
    if value_type_is (ctx, lua.t_table) = false then
      type_error (ctx, target => target_value, expected => lua.t_table);
    end if;
    add_name_component (ctx, name);
  end table_start;

  -- remove table from stack
  procedure table_end (ctx: load_ptr_t) is
  begin
    if value_type_is (ctx, lua.t_table) = false then
      type_error (ctx, target => target_value, expected => lua.t_table);
    end if;
    remove_name_component (ctx);
    lua.pop (ctx.ls, 1);
  end table_end;

  -- iterate over table, calling proc for each value
  procedure table_iterate (ctx: load_ptr_t;
    proc: not null access procedure (ctx: load_ptr_t; data: in out udata);
    data: in out udata) is
    findex: long_float;
    index: integer;
    added: boolean;
  begin
    if value_type_is (ctx, lua.t_table) = false then
      type_error (ctx, target => target_value, expected => lua.t_table);
    end if;
 
    -- iterate over table keys
    lua.push_nil (ctx.ls);
    while (lua.next (ctx.ls, -2) /= 0) loop
      added := false;

      -- build string name based on key type and value
      case key_type (ctx) is
        when lua.t_number =>
          findex := key (ctx);
          index := integer (findex);
          declare
            str: constant string :=
              "[" & sf.trim (integer'image (index), s.left) & "]";
          begin
            add_name_component (ctx, str);
            added := true;
          end;
        when lua.t_string =>
          add_name_component (ctx, su.to_string (key (ctx)));
          added := true;
        when others =>
          null;
      end case;

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
