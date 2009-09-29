with Ada.Strings;
with Ada.Strings.Fixed;

package body Lua.Load is
  package Strings reNames Ada.Strings;
  package Fixed_Strings reNames Ada.Strings.Fixed;

  --
  -- Return float, removing from stack.
  --

  function Float_From_Stack (State : in State_Access_t) return Long_Float is
    Number : constant Long_Float :=
      Long_Float (Lua.To_Number (State.all.Lua_State, -1));
  begin
    Lua.Pop (State.all.Lua_State, 1);
    return Number;
  end Float_From_Stack;

  --
  -- Return string, removing from stack.
  --

  function String_From_Stack (State : in State_Access_t) return UString_t is
    US : constant UString_t := Lua.To_Unbounded_String (State.all.Lua_State, -1);
  begin
    Lua.Pop (State.all.Lua_State, 1);
    return US;
  end String_From_Stack;

  --
  -- Add a Name component.
  --

  procedure Add_Name_Component
    (State : in State_Access_t;
     Name  : in String) is
  begin
    if UB_Strings.Length (State.all.Name_Code) /= 0 then
      UB_Strings.Append (State.all.Name_Code, ".");
    end if;
    UB_Strings.Append (State.all.Name_Code, Name);
    State.all.Name_Depth := State.all.Name_Depth + 1;
  end Add_Name_Component;

  --
  -- Remove a Name component.
  --

  procedure Remove_Name_Component (State : in State_Access_t) is
    Length : constant Natural := UB_Strings.Length (State.all.Name_Code);
    Dot    :          Natural := UB_Strings.Index (State.all.Name_Code, ".", Length, Strings.Backward);
  begin
    if Dot /= 0 then
      Dot := Dot - 1;
    end if;

    UB_Strings.Head (State.all.Name_Code, Dot);
    State.all.Name_Depth := State.all.Name_Depth - 1;
  end Remove_Name_Component;

  type Target_t is
    (Target_Key,
     Target_Value);

  function Target_Name (Target : in Target_t) return String is
  begin
    case Target is
      when Target_Key   => return "Key";
      when Target_Value => return "value";
    end case;
  end Target_Name;

  --
  -- Raise type error exception.
  --

  procedure Type_Error
    (State    : in State_Access_t;
     Target   : in Target_t;
     Expected : in Lua.Type_t;
     Name     : in String := "") is
  begin
    State.all.Err_String := UB_Strings.To_Unbounded_String ("");
    if UB_Strings.Length (State.all.Name_Code) /= 0 then
      UB_Strings.Append (State.all.Err_String, UB_Strings.To_String (State.all.Name_Code) & ": ");
    end if;
    if Name /= "" then
      UB_Strings.Append (State.all.Err_String, Name & ": ");
    end if;
    UB_Strings.Append (State.all.Err_String,
      Target_Name (Target) & ": not a " & Lua.Type_Name (Expected));
    raise Load_Error with UB_Strings.To_String (State.all.Err_String);
  end Type_Error;

  --
  -- Public API.
  --

  --
  -- Set Lua interpreter state.
  --

  procedure Set_Lua
    (State     : in State_Access_t;
     Lua_State : in Lua.State_t) is
  begin
    State.all.Lua_State := Lua_State;
  end Set_Lua;

  --
  -- Set file name.
  --

  procedure Set_File
    (State   : in State_Access_t;
     File    : in String) is
  begin
    State.all.Name_File := UB_Strings.To_Unbounded_String (File);
  end Set_File;

  --
  -- Get key type.
  --

  function Key_Type (State : in State_Access_t) return Lua.Type_t is
  begin
    return Lua.Type_Of (State.all.Lua_State, -2);
  end Key_Type;

  --
  -- Check if Key is of type Key_Type.
  --

  function Key_Type_Is
    (State      : in State_Access_t;
     Type_Value : in Lua.Type_t) return Boolean is
  begin
    return Key_Type (State) = Type_Value;
  end Key_Type_Is;

  --
  -- Get value type.
  --

  function Value_Type (State : in State_Access_t) return Lua.Type_t is
  begin
    return Lua.Type_Of (State.all.Lua_State, -1);
  end Value_Type;

  --
  -- Check if value is of type Value_Type.
  --

  function Value_Type_Is
    (State      : in State_Access_t;
     Type_Value : in Lua.Type_t) return Boolean is
  begin
    return Value_Type (State) = Type_Value;
  end Value_Type_Is;

  --
  -- Get key on stack as number.
  --

  function Key (State : in State_Access_t) return Long_Float is
  begin
    if Key_Type_Is (State, Lua.T_Number) = False then
      Type_Error
        (State    => State,
         Target   => Target_Key,
         Expected => Lua.T_Number);
    end if;
    return Long_Float (Lua.To_Number (State.all.Lua_State, -2));
  end Key;

  function Key (State : in State_Access_t) return Long_Integer is
    Temp_Float : constant Long_Float := Key (State);
  begin
    return Long_Integer (Temp_Float);
  end Key;

  --
  -- Get key on stack as string.
  --

  function Key (State : in State_Access_t) return UString_t is
  begin
    if Key_Type_Is (State, Lua.T_String) = False then
      Type_Error
        (State    => State,
         Target   => Target_Key,
         Expected => Lua.T_String);
    end if;
    return Lua.To_Unbounded_String (State.all.Lua_State, -2);
  end Key;

  --
  -- Get number on stack, error on invalid type.
  --

  function Local (State : in State_Access_t) return Long_Float is
  begin
    if Value_Type_Is (State, Lua.T_Number) = False then
      Lua.Pop (State.all.Lua_State, 1);
      Type_Error
        (State    => State,
         Target   => Target_Value,
         Expected => Lua.T_Number);
    end if;
    return Long_Float (Lua.To_Number (State.all.Lua_State, -1));
  end Local;

  function Local (State : in State_Access_t) return Long_Integer is
  begin
    if Value_Type_Is (State, Lua.T_Number) = False then
      Lua.Pop (State.all.Lua_State, 1);
      Type_Error
        (State    => State,
         Target   => Target_Value,
         Expected => Lua.T_Number);
    end if;
    return Long_Integer (Lua.To_Number (State.all.Lua_State, -1));
  end Local;

  --
  -- Get number on stack, return Default on nil, raise error on invalid type.
  --

  function Local_Conditional
    (State   : in State_Access_t;
     Default : in Long_Float := 0.0) return Long_Float is
  begin
    if Value_Type_Is (State, Lua.T_Nil) then
      Lua.Pop (State.all.Lua_State, 1);
      return Default;
    end if;
    return Local (State);
  end Local_Conditional;

  function Local_Conditional
    (State   : in State_Access_t;
     Default : in Long_Integer := 0) return Long_Integer is
  begin
    return Long_Integer (Local_Conditional
      (State   => State,
       Default => Long_Float (Default)));
  end Local_Conditional;

  --
  -- Get string on stack, error on invalid type.
  --

  function Local (State : in State_Access_t) return UString_t is
  begin
    if Value_Type_Is (State, Lua.T_String) = False then
      Lua.Pop (State.all.Lua_State, 1);
      Type_Error
        (State    => State,
         Target   => Target_Value,
         Expected => Lua.T_String);
    end if;
    return Lua.To_Unbounded_String (State.all.Lua_State, -1);
  end Local;

  --
  -- Get string on stack, return Default on nil, raise error on invalid type.
  --

  function Local_Conditional
    (State   : in State_Access_t;
     Default : in String := "") return UString_t is
  begin
    if Value_Type_Is (State, Lua.T_Nil) then
      Lua.Pop (State.all.Lua_State, 1);
      return UB_Strings.To_Unbounded_String (Default);
    end if;
    return Local (State);
  end Local_Conditional;

  --
  -- Get named numeric field, raise error on invalid type.
  --

  function Named_Local
    (State : in State_Access_t;
     Name  : in String) return Long_Float is
  begin
    Lua.Get_Field (State.all.Lua_State, -1, Name);
    if Value_Type_Is (State, Lua.T_Number) = False then
      Lua.Pop (State.all.Lua_State, 1);
      Type_Error
        (State    => State,
         Target   => Target_Value,
         Name     => Name,
         Expected => Lua.T_Number);
    end if;

    return Float_From_Stack (State);
  end Named_Local;

  function Named_Local
    (State   : in State_Access_t;
     Name    : in String) return Long_Integer
  is
    Temp_Float : constant Long_Float := (Named_Local
      (State => State,
       Name  => Name));
  begin
    return Long_Integer (Temp_Float);
  end Named_Local;

  --
  -- Get named numeric field if defined, return Default on nil, raise
  -- error on other type.
  --

  function Named_Local_Conditional
    (State   : in State_Access_t;
     Name    : in String;
     Default : in Long_Float := 0.0) return Long_Float is
  begin
    Lua.Get_Field (State.all.Lua_State, -1, Name);

    if Value_Type_Is (State, Lua.T_Nil) then
      Lua.Pop (State.all.Lua_State, 1);
      return Default;
    end if;

    if Value_Type_Is (State, Lua.T_Number) = False then
      Lua.Pop (State.all.Lua_State, 1);
      Type_Error
        (State    => State,
         Target   => Target_Value,
         Name     => Name,
         Expected => Lua.T_Number);
    end if;

    return Float_From_Stack (State);
  end Named_Local_Conditional;

  function Named_Local_Conditional
    (State   : in State_Access_t;
     Name    : in String;
     Default : in Long_Integer := 0) return Long_Integer is
  begin
    return Long_Integer (Named_Local_Conditional
      (State   => State,
       Name    => Name,
       Default => Long_Float (Default)));
  end Named_Local_Conditional;

  --
  -- Get named string field, raise error on other type.
  --

  function Named_Local
    (State : in State_Access_t;
     Name  : in String) return UString_t is
  begin
    Lua.Get_Field (State.all.Lua_State, -1, Name);

    if Value_Type_Is (State, Lua.T_String) = False then
      Lua.Pop (State.all.Lua_State, 1);
      Type_Error
        (State    => State,
         Target   => Target_Value,
         Name     => Name,
         Expected => Lua.T_String);
    end if;

    return String_From_Stack (State);
  end Named_Local;

  --
  -- Get string if defined, raise error on other type.
  --

  function Named_Local_Conditional
    (State   : in State_Access_t;
     Name    : in String;
     Default : in String := "") return UString_t is
  begin
    Lua.Get_Field (State.all.Lua_State, -1, Name);

    if Value_Type_Is (State, Lua.T_Nil) then
      Lua.Pop (State.all.Lua_State, 1);
      return UB_Strings.To_Unbounded_String (Default);
    end if;

    if Value_Type_Is (State, Lua.T_String) = False then
      Lua.Pop (State.all.Lua_State, 1);
      Type_Error
        (State    => State,
         Target   => Target_Value,
         Name     => Name,
         Expected => Lua.T_String);
    end if;

    return String_From_Stack (State);
  end Named_Local_Conditional;

  --
  -- Indexed local retrieval.
  --

  function Indexed_Local
    (State : in State_Access_t;
     Index : in Long_Integer) return UString_t is
  begin
    Lua.Push_Integer (State.all.Lua_State, Lua.Integer_t (Index));
    Lua.Get_Table (State.all.Lua_State, -1);

    if Value_Type_Is (State, Lua.T_String) = False then
      Lua.Pop (State.all.Lua_State, 1);
      Type_Error
        (State    => State,
         Target   => Target_Value,
         Name     => Long_Integer'Image (Index),
         Expected => Lua.T_String);
    end if;

    return String_From_Stack (State);
  end Indexed_Local;

  function Indexed_Local
    (State : in State_Access_t;
     Index : in Long_Integer) return Long_Float is
  begin
    Lua.Push_Integer (State.all.Lua_State, Lua.Integer_t (Index));
    Lua.Get_Table (State.all.Lua_State, -1);

    if Value_Type_Is (State, Lua.T_Number) = False then
      Lua.Pop (State.all.Lua_State, 1);
      Type_Error
        (State    => State,
         Target   => Target_Value,
         Name     => Long_Integer'Image (Index),
         Expected => Lua.T_Number);
    end if;

    return Float_From_Stack (State);
  end Indexed_Local;

  function Indexed_Local
    (State : in State_Access_t;
     Index : in Long_Integer) return Long_Integer
  is
    Temp_Float : constant Long_Float := (Indexed_Local
      (State => State,
       Index => Index));
  begin
    return Long_Integer (Temp_Float);
  end Indexed_Local;

  function Indexed_Local_Conditional
    (State   : in State_Access_t;
     Index   : in Long_Integer;
     Default : in String := "") return UString_t is
  begin
    Lua.Push_Integer (State.all.Lua_State, Lua.Integer_t (Index));
    Lua.Get_Table (State.all.Lua_State, -1);

    if Value_Type_Is (State, Lua.T_Nil) then
      Lua.Pop (State.all.Lua_State, 1);
      return UB_Strings.To_Unbounded_String (Default);
    end if;

    if Value_Type_Is (State, Lua.T_String) = False then
      Lua.Pop (State.all.Lua_State, 1);
      Type_Error
        (State    => State,
         Target   => Target_Value,
         Name     => Long_Integer'Image (Index),
         Expected => Lua.T_String);
    end if;

    return String_From_Stack (State);
  end Indexed_Local_Conditional;

  function Indexed_Local_Conditional
    (State   : in State_Access_t;
     Index   : in Long_Integer;
     Default : in Long_Float := 0.0) return Long_Float is
  begin
    Lua.Push_Integer (State.all.Lua_State, Lua.Integer_t (Index));
    Lua.Get_Table (State.all.Lua_State, -1);

    if Value_Type_Is (State, Lua.T_Nil) then
      Lua.Pop (State.all.Lua_State, 1);
      return Default;
    end if;

    if Value_Type_Is (State, Lua.T_Number) = False then
      Lua.Pop (State.all.Lua_State, 1);
      Type_Error
        (State    => State,
         Target   => Target_Value,
         Name     => Long_Integer'Image (Index),
         Expected => Lua.T_Number);
    end if;

    return Float_From_Stack (State);
  end Indexed_Local_Conditional;

  function Indexed_Local_Conditional
    (State   : in State_Access_t;
     Index   : in Long_Integer;
     Default : in Long_Integer := 0) return Long_Integer is
  begin
    return Long_Integer (Indexed_Local_Conditional
      (State   => State,
       Index   => Index,
       Default => Long_Float (Default)));
  end Indexed_Local_Conditional;

  --
  -- Push table 'Name' onto stack.
  --

  procedure Table_Start
    (State : in State_Access_t;
     Name  : in String) is
  begin
    Lua.Get_Field (State.all.Lua_State, -1, Name);
    if Value_Type_Is (State, Lua.T_Table) = False then
      Type_Error
        (State    => State,
         Target   => Target_Value,
         Name     => Name,
         Expected => Lua.T_Table);
    end if;
    Add_Name_Component (State, Name);
  end Table_Start;

  --
  -- Remove table from stack.
  --

  procedure Table_End (State : in State_Access_t) is
  begin
    if Value_Type_Is (State, Lua.T_Table) = False then
      Type_Error
        (State    => State,
         Target   => Target_Value,
         Expected => Lua.T_Table);
    end if;
    Remove_Name_Component (State);
    Lua.Pop (State.all.Lua_State, 1);
  end Table_End;

  --
  -- Iterate over table, calling Process for each value.
  --

  procedure Table_Iterate
    (State    : in State_Access_t;
     Process  : not null access procedure
       (State : in State_Access_t))
  is
    F_Index : Long_Float;
    Index  : Integer;
    Added  : Boolean;
  begin
    if Value_Type_Is (State, Lua.T_Table) = False then
      Type_Error
        (State    => State,
         Target   => Target_Value,
         Expected => Lua.T_Table);
    end if;

    -- Iterate over table keys.
    Lua.Push_Nil (State.all.Lua_State);
    while (Lua.Next (State.all.Lua_State, -2) /= 0) loop
      Added := False;

      -- build String Name based on Key type and value
      case Key_Type (State) is
        when Lua.T_Number =>
          F_Index := Key (State);
          Index   := Integer (F_Index);
          declare
            Str : constant String :=
              "[" & Fixed_Strings.Trim (Integer'Image (Index), Strings.Left) & "]";
          begin
            Add_Name_Component (State, Str);
            Added := True;
          end;
        when Lua.T_String =>
          Add_Name_Component (State, UB_Strings.To_String (Key (State)));
          Added := True;
        when others =>
          null;
      end case;

      -- Call Process ()
      begin
        Process (State);
      exception
        when Load_Error =>
          if Added then
            Remove_Name_Component (State);
          end if;
          raise;
      end;

      if Added then
        Remove_Name_Component (State);
      end if;
      Lua.Pop (State.all.Lua_State, 1);
    end loop;
  end Table_Iterate;

  --
  -- Return error string.
  --

  function Error_String (State : in State_Access_t) return String is
  begin
    return UB_Strings.To_String (State.all.Err_String);
  end Error_String;

  function Name_Code (State : in State_Access_t) return String is
  begin
    return UB_Strings.To_String (State.all.Name_Code);
  end Name_Code;

end Lua.Load;
