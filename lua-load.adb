with ada.strings;
with ada.strings.fixed;

package body lua.load is
  package s renames ada.strings;
  package sf renames ada.strings.fixed;

  -- add a name component
  procedure add_name_component
    (context : load_access_t;
     name    : string) is
  begin
    if su.length (context.name_code) /= 0 then
      su.append (context.name_code, ".");
    end if;
    su.append (context.name_code, name);
    context.name_depth := context.name_depth + 1;
  end add_name_component;

  -- remove a name component
  procedure remove_name_component (context : load_access_t) is
    len : constant natural := su.length (context.name_code);
    dot : natural          := su.index (context.name_code, ".", len, s.backward);
  begin
    if dot /= 0 then dot := dot - 1; end if;
    su.head (context.name_code, dot);
    context.name_depth := context.name_depth - 1;
  end remove_name_component;

  type target_t is (target_key, target_value);

  function target_name (target: target_t) return string is
  begin
    case target is
      when target_key => return "key";
      when target_value => return "value";
    end case;
  end target_name;

  -- type error
  procedure type_error
    (context  : load_access_t;
     target   : target_t;
     expected : lua.type_t) is
  begin
    context.err_string := su.to_unbounded_string ("");
    if su.length (context.name_code) /= 0 then
      su.append (context.err_string, su.to_string (context.name_code) & ": ");
    end if;
    su.append (context.err_string, target_name (target) & ": not a " & lua.type_name (expected));
    raise load_error;
  end;

  --
  -- Public API
  --

  -- set lua context
  procedure set_lua
    (context   : load_access_t;
     lua_state : lua.state_t) is
  begin
    context.lua_state := lua_state;
  end set_lua;

  -- set filename
  procedure set_file
    (context : load_access_t;
     file    : string) is
  begin
    context.name_file := su.to_unbounded_string (file);
  end set_file;

  -- get key type
  function key_type (context: load_access_t) return lua.type_t is
  begin
    return lua.type_of (context.lua_state, -2);
  end key_type;

  -- check if key is of type key_type
  function key_type_is
    (context : load_access_t;
     k_type  : lua.type_t) return boolean is
  begin
    return key_type (context) = k_type;
  end key_type_is;

  -- get value type
  function value_type (context: load_access_t) return lua.type_t is
  begin
    return lua.type_of (context.lua_state, -1);
  end value_type;

  -- check if value is of type value_type
  function value_type_is
    (context : load_access_t;
     v_type  : lua.type_t) return boolean is
  begin
    return value_type (context) = v_type;
  end value_type_is;

  -- get key on stack as number
  function key (context: load_access_t) return long_float is
  begin
    if key_type_is (context, lua.t_number) = false then
      type_error (context, target => target_key, expected => lua.t_number);
    end if;
    return long_float (lua.to_number (context.lua_state, -2));
  end key;

  -- get key on stack as string
  function key (context: load_access_t) return u_string is
  begin
    if key_type_is (context, lua.t_string) = false then
      type_error (context, target => target_key, expected => lua.t_string);
    end if;
    return su.to_unbounded_string (lua.to_string (context.lua_state, -2));
  end key;

  -- get number on stack, error on invalid type.
  function local (context: load_access_t) return long_float is
  begin
    if value_type_is (context, lua.t_number) = false then
      lua.pop (context.lua_state, 1);
      type_error (context, target => target_value, expected => lua.t_number);
    end if;
    return long_float (lua.to_number (context.lua_state, -1));
  end local;

  -- get number on stack, return default on nil, error on invalid type.
  function local_cond
    (context : load_access_t;
     default : long_float) return long_float is
  begin
    if value_type_is (context, lua.t_nil) then
      lua.pop (context.lua_state, 1);
      return default;
    end if;
    return local (context);
  end local_cond;

  -- get string on stack, error on invalid type.
  function local (context: load_access_t) return u_string is
  begin
    if value_type_is (context, lua.t_string) = false then
      lua.pop (context.lua_state, 1);
      type_error (context, target => target_value, expected => lua.t_string);
    end if;
    return su.to_unbounded_string (lua.to_string (context.lua_state, -1));
  end local;

  -- get string on stack, return default on nil, error on invalid type.
  function local_cond
    (context : load_access_t;
     default : string) return u_string is
  begin
    if value_type_is (context, lua.t_nil) then
      lua.pop (context.lua_state, 1);
      return su.to_unbounded_string (default);
    end if;
    return local (context);
  end local_cond;

  -- get named numeric field, error on invalid type.
  function named_local
    (context : load_access_t;
     name    : string) return long_float is
  begin
    lua.get_field (context.lua_state, -1, name);
    if value_type_is (context, lua.t_number) = false then
      lua.pop (context.lua_state, 1);
      type_error (context, target => target_value, expected => lua.t_number);
    end if;
    declare
      num: constant long_float := long_float (lua.to_number (context.lua_state, -1));
    begin
      lua.pop (context.lua_state, 1);
      return num;
    end;
  end named_local;

  -- get named numeric field if defined, return default on nil, error on other type
  function named_local_cond
    (context : load_access_t;
     name    : string;
     default : long_float) return long_float is
  begin
    lua.get_field (context.lua_state, -1, name);

    if value_type_is (context, lua.t_nil) then
      lua.pop (context.lua_state, 1);
      return default;
    end if;

    if value_type_is (context, lua.t_number) = false then
      lua.pop (context.lua_state, 1);
      type_error (context, target => target_value, expected => lua.t_number);
    end if;

    declare
      num: constant long_float := long_float (lua.to_number (context.lua_state, -1));
    begin
      lua.pop (context.lua_state, 1);
      return num;
    end;
  end named_local_cond;

  -- get named string field, error on other type.
  function named_local
    (context : load_access_t;
     name    : string) return u_string is
  begin
    lua.get_field (context.lua_state, -1, name);

    if value_type_is (context, lua.t_string) = false then
      lua.pop (context.lua_state, 1);
      type_error (context, target => target_value, expected => lua.t_string);
    end if;

    declare
      str: constant string := lua.to_string (context.lua_state, -1);
      us: constant u_string := su.to_unbounded_string (str);
    begin
      lua.pop (context.lua_state, 1);
      return us;
    end;
  end named_local;

  -- get string if defined, error on other type
  function named_local_cond
    (context : load_access_t;
     name    : string;
     default : string) return u_string is
  begin
    lua.get_field (context.lua_state, -1, name);

    if value_type_is (context, lua.t_nil) then
      lua.pop (context.lua_state, 1);
      return su.to_unbounded_string (default);
    end if;

    if value_type_is (context, lua.t_string) = false then
      lua.pop (context.lua_state, 1);
      type_error (context, target => target_value, expected => lua.t_string);
    end if;

    declare
      str: constant string := lua.to_string (context.lua_state, -1);
      us: constant u_string := su.to_unbounded_string (str);
    begin
      lua.pop (context.lua_state, 1);
      return us;
    end;
  end named_local_cond;

  -- push table 'name' onto stack
  procedure table_start
    (context : load_access_t;
     name    : string) is
  begin
    lua.get_field (context.lua_state, -1, name);
    if value_type_is (context, lua.t_table) = false then
      type_error (context, target => target_value, expected => lua.t_table);
    end if;
    add_name_component (context, name);
  end table_start;

  -- remove table from stack
  procedure table_end (context: load_access_t) is
  begin
    if value_type_is (context, lua.t_table) = false then
      type_error (context, target => target_value, expected => lua.t_table);
    end if;
    remove_name_component (context);
    lua.pop (context.lua_state, 1);
  end table_end;

  -- iterate over table, calling proc for each value
  procedure table_iterate
    (context : load_access_t;
     proc    : not null access procedure (context: load_access_t; data: in out udata);
     data    : in out udata)
  is
    findex : long_float;
    index  : integer;
    added  : boolean;
  begin
    if value_type_is (context, lua.t_table) = false then
      type_error (context, target => target_value, expected => lua.t_table);
    end if;
 
    -- iterate over table keys
    lua.push_nil (context.lua_state);
    while (lua.next (context.lua_state, -2) /= 0) loop
      added := false;

      -- build string name based on key type and value
      case key_type (context) is
        when lua.t_number =>
          findex := key (context);
          index := integer (findex);
          declare
            str : constant string :=
              "[" & sf.trim (integer'image (index), s.left) & "]";
          begin
            add_name_component (context, str);
            added := true;
          end;
        when lua.t_string =>
          add_name_component (context, su.to_string (key (context)));
          added := true;
        when others =>
          null;
      end case;

      -- call proc ()
      begin
        proc (context, data);
      exception
        when load_error =>
          if added then remove_name_component (context); end if;
          raise;
      end;

      if added then remove_name_component (context); end if;
      lua.pop (context.lua_state, 1);
    end loop;
  end table_iterate;

  -- return error string

  function error_string (context : load_access_t) return string is
  begin
    return su.to_string (context.err_string);
  end error_string;

  function name_code (context : load_access_t) return string is
  begin
    return su.to_string (context.name_code);
  end name_code;

end lua.load;
