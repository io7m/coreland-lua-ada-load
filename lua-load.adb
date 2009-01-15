with ada.strings;
with ada.strings.fixed;

package body lua.load is
  package s renames ada.strings;
  package sf renames ada.strings.fixed;

  -- add a name component
  procedure add_name_component
    (state : in state_access_t;
     name  : in string) is
  begin
    if su.length (state.name_code) /= 0 then
      su.append (state.name_code, ".");
    end if;
    su.append (state.name_code, name);
    state.name_depth := state.name_depth + 1;
  end add_name_component;

  -- remove a name component
  procedure remove_name_component (state : in state_access_t) is
    len : constant natural := su.length (state.name_code);
    dot : natural          := su.index (state.name_code, ".", len, s.backward);
  begin
    if dot /= 0 then dot := dot - 1; end if;
    su.head (state.name_code, dot);
    state.name_depth := state.name_depth - 1;
  end remove_name_component;

  type target_t is (target_key, target_value);

  function target_name (target : in target_t) return string is
  begin
    case target is
      when target_key => return "key";
      when target_value => return "value";
    end case;
  end target_name;

  -- type error
  procedure type_error
    (state    : in state_access_t;
     target   : in target_t;
     expected : in lua.type_t;
     name     : in string := "") is
  begin
    state.err_string := su.to_unbounded_string ("");
    if su.length (state.name_code) /= 0 then
      su.append (state.err_string, su.to_string (state.name_code) & ": ");
    end if;
    if name /= "" then
      su.append (state.err_string, name & ": ");
    end if;
    su.append (state.err_string,
      target_name (target) & ": not a " & lua.type_name (expected));
    raise load_error with su.to_string (state.err_string);
  end;

  --
  -- Public API
  --

  -- set lua state
  procedure set_lua
    (state     : in state_access_t;
     lua_state : in lua.state_t) is
  begin
    state.lua_state := lua_state;
  end set_lua;

  -- set filename
  procedure set_file
    (state   : in state_access_t;
     file    : in string) is
  begin
    state.name_file := su.to_unbounded_string (file);
  end set_file;

  -- get key type
  function key_type (state : in state_access_t) return lua.type_t is
  begin
    return lua.type_of (state.lua_state, -2);
  end key_type;

  -- check if key is of type key_type
  function key_type_is
    (state  : in state_access_t;
     k_type : in lua.type_t) return boolean is
  begin
    return key_type (state) = k_type;
  end key_type_is;

  -- get value type
  function value_type (state : in state_access_t) return lua.type_t is
  begin
    return lua.type_of (state.lua_state, -1);
  end value_type;

  -- check if value is of type value_type
  function value_type_is
    (state  : in state_access_t;
     v_type : in lua.type_t) return boolean is
  begin
    return value_type (state) = v_type;
  end value_type_is;

  -- get key on stack as number
  function key (state : in state_access_t) return long_float is
  begin
    if key_type_is (state, lua.t_number) = false then
      type_error
        (state    => state,
         target   => target_key,
         expected => lua.t_number);
    end if;
    return long_float (lua.to_number (state.lua_state, -2));
  end key;

  function key (state : in state_access_t) return long_integer is
    temp_float : constant long_float := key (state);
  begin
    return long_integer (temp_float);
  end key;

  -- get key on stack as string
  function key (state : in state_access_t) return ustring_t is
  begin
    if key_type_is (state, lua.t_string) = false then
      type_error
        (state    => state,
         target   => target_key,
         expected => lua.t_string);
    end if;
    return su.to_unbounded_string (lua.to_string (state.lua_state, -2));
  end key;

  -- get number on stack, error on invalid type.
  function local (state : in state_access_t) return long_float is
  begin
    if value_type_is (state, lua.t_number) = false then
      lua.pop (state.lua_state, 1);
      type_error
        (state    => state,
         target   => target_value,
         expected => lua.t_number);
    end if;
    return long_float (lua.to_number (state.lua_state, -1));
  end local;

  function local (state : in state_access_t) return long_integer is
  begin
    if value_type_is (state, lua.t_number) = false then
      lua.pop (state.lua_state, 1);
      type_error
        (state    => state,
         target   => target_value,
         expected => lua.t_number);
    end if;
    return long_integer (lua.to_number (state.lua_state, -1));
  end local;

  -- get number on stack, return default on nil, error on invalid type.
  function local_cond
    (state   : in state_access_t;
     default : in long_float := 0.0) return long_float is
  begin
    if value_type_is (state, lua.t_nil) then
      lua.pop (state.lua_state, 1);
      return default;
    end if;
    return local (state);
  end local_cond;

  function local_cond
    (state   : in state_access_t;
     default : in long_integer := 0) return long_integer is
  begin
    return long_integer (local_cond
      (state   => state,
       default => long_float (default)));
  end local_cond;

  -- get string on stack, error on invalid type.
  function local (state : in state_access_t) return ustring_t is
  begin
    if value_type_is (state, lua.t_string) = false then
      lua.pop (state.lua_state, 1);
      type_error
        (state    => state,
         target   => target_value,
         expected => lua.t_string);
    end if;
    return su.to_unbounded_string (lua.to_string (state.lua_state, -1));
  end local;

  -- get string on stack, return default on nil, error on invalid type.
  function local_cond
    (state   : in state_access_t;
     default : in string := "") return ustring_t is
  begin
    if value_type_is (state, lua.t_nil) then
      lua.pop (state.lua_state, 1);
      return su.to_unbounded_string (default);
    end if;
    return local (state);
  end local_cond;

  -- get named numeric field, error on invalid type.
  function named_local
    (state : in state_access_t;
     name  : in string) return long_float is
  begin
    lua.get_field (state.lua_state, -1, name);
    if value_type_is (state, lua.t_number) = false then
      lua.pop (state.lua_state, 1);
      type_error
        (state    => state,
         target   => target_value,
         name     => name,
         expected => lua.t_number);
    end if;
    declare
      num : constant long_float :=
        long_float (lua.to_number (state.lua_state, -1));
    begin
      lua.pop (state.lua_state, 1);
      return num;
    end;
  end named_local;

  function named_local
    (state   : in state_access_t;
     name    : in string) return long_integer
  is
    temp_float : constant long_float := (named_local
      (state => state,
       name  => name));
  begin
    return long_integer (temp_float);
  end named_local;

  -- get named numeric field if defined, return default on nil, error on other type
  function named_local_cond
    (state   : in state_access_t;
     name    : in string;
     default : in long_float := 0.0) return long_float is
  begin
    lua.get_field (state.lua_state, -1, name);

    if value_type_is (state, lua.t_nil) then
      lua.pop (state.lua_state, 1);
      return default;
    end if;

    if value_type_is (state, lua.t_number) = false then
      lua.pop (state.lua_state, 1);
      type_error
        (state    => state,
         target   => target_value,
         name     => name,
         expected => lua.t_number);
    end if;

    declare
      num : constant long_float :=
        long_float (lua.to_number (state.lua_state, -1));
    begin
      lua.pop (state.lua_state, 1);
      return num;
    end;
  end named_local_cond;

  function named_local_cond
    (state   : in state_access_t;
     name    : in string;
     default : in long_integer := 0) return long_integer is
  begin
    return long_integer (named_local_cond
      (state   => state,
       name    => name,
       default => long_float (default)));
  end named_local_cond;

  -- get named string field, error on other type.
  function named_local
    (state : in state_access_t;
     name  : in string) return ustring_t is
  begin
    lua.get_field (state.lua_state, -1, name);

    if value_type_is (state, lua.t_string) = false then
      lua.pop (state.lua_state, 1);
      type_error
        (state    => state,
         target   => target_value,
         name     => name,
         expected => lua.t_string);
    end if;

    declare
      str : constant string := lua.to_string (state.lua_state, -1);
      us  : constant ustring_t := su.to_unbounded_string (str);
    begin
      lua.pop (state.lua_state, 1);
      return us;
    end;
  end named_local;

  -- get string if defined, error on other type
  function named_local_cond
    (state   : in state_access_t;
     name    : in string;
     default : in string := "") return ustring_t is
  begin
    lua.get_field (state.lua_state, -1, name);

    if value_type_is (state, lua.t_nil) then
      lua.pop (state.lua_state, 1);
      return su.to_unbounded_string (default);
    end if;

    if value_type_is (state, lua.t_string) = false then
      lua.pop (state.lua_state, 1);
      type_error
        (state    => state,
         target   => target_value,
         name     => name,
         expected => lua.t_string);
    end if;

    declare
      str : constant string := lua.to_string (state.lua_state, -1);
      us  : constant ustring_t := su.to_unbounded_string (str);
    begin
      lua.pop (state.lua_state, 1);
      return us;
    end;
  end named_local_cond;

  -- push table 'name' onto stack
  procedure table_start
    (state : in state_access_t;
     name  : in string) is
  begin
    lua.get_field (state.lua_state, -1, name);
    if value_type_is (state, lua.t_table) = false then
      type_error
        (state    => state,
         target   => target_value,
         name     => name,
         expected => lua.t_table);
    end if;
    add_name_component (state, name);
  end table_start;

  -- remove table from stack
  procedure table_end (state : in state_access_t) is
  begin
    if value_type_is (state, lua.t_table) = false then
      type_error
        (state    => state,
         target   => target_value,
         expected => lua.t_table);
    end if;
    remove_name_component (state);
    lua.pop (state.lua_state, 1);
  end table_end;

  -- iterate over table, calling proc for each value
  procedure table_iterate
    (state : in state_access_t;
     proc  : not null access procedure
       (state : in state_access_t))
  is
    findex : long_float;
    index  : integer;
    added  : boolean;
  begin
    if value_type_is (state, lua.t_table) = false then
      type_error
        (state    => state,
         target   => target_value,
         expected => lua.t_table);
    end if;
 
    -- iterate over table keys
    lua.push_nil (state.lua_state);
    while (lua.next (state.lua_state, -2) /= 0) loop
      added := false;

      -- build string name based on key type and value
      case key_type (state) is
        when lua.t_number =>
          findex := key (state);
          index := integer (findex);
          declare
            str : constant string :=
              "[" & sf.trim (integer'image (index), s.left) & "]";
          begin
            add_name_component (state, str);
            added := true;
          end;
        when lua.t_string =>
          add_name_component (state, su.to_string (key (state)));
          added := true;
        when others =>
          null;
      end case;

      -- call proc ()
      begin
        proc (state);
      exception
        when load_error =>
          if added then remove_name_component (state); end if;
          raise;
      end;

      if added then remove_name_component (state); end if;
      lua.pop (state.lua_state, 1);
    end loop;
  end table_iterate;

  -- return error string

  function error_string (state : in state_access_t) return string is
  begin
    return su.to_string (state.err_string);
  end error_string;

  function name_code (state : in state_access_t) return string is
  begin
    return su.to_string (state.name_code);
  end name_code;

end lua.load;
