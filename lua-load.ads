with Ada.Strings.Unbounded;

package Lua.Load is
  package UB_Strings reNames Ada.Strings.Unbounded;

  --
  -- Types.
  --

  subtype UString_t is UB_Strings.Unbounded_String;

  type State_t is limited private;
  type State_Access_t is access all State_t;

  --
  -- API subprograms.
  --

  procedure Set_Lua
    (State     : in State_Access_t;
     Lua_State : in Lua.State_t);

  procedure Set_File
    (State : in State_Access_t;
     File  : in String);

  --
  -- Type retrieval.
  --

  function Key_Type (State : in State_Access_t) return Lua.Type_t;
  pragma Inline (Key_Type);

  function Key_Type_Is
    (State      : in State_Access_t;
     Type_Value : in Lua.Type_t) return Boolean;
  pragma Inline (Key_Type_Is);

  function Value_Type (State : in State_Access_t) return Lua.Type_t;
  pragma Inline (Value_Type);

  function Value_Type_Is
    (State      : in State_Access_t;
     Type_Value : in Lua.Type_t) return Boolean;
  pragma Inline (Value_Type_Is);

  function Key (State : in State_Access_t) return Long_Float;
  function Key (State : in State_Access_t) return Long_Integer;
  function Key (State : in State_Access_t) return UString_t;

  --
  -- Named local retrieval.
  --

  function Named_Local
    (State : in State_Access_t;
     Name  : in String) return UString_t;

  function Named_Local
    (State : in State_Access_t;
     Name  : in String) return Long_Float;

  function Named_Local
    (State : in State_Access_t;
     Name  : in String) return Long_Integer;

  function Named_Local_Conditional
    (State   : in State_Access_t;
     Name    : in String;
     Default : in String := "") return UString_t;

  function Named_Local_Conditional
    (State   : in State_Access_t;
     Name    : in String;
     Default : in Long_Float := 0.0) return Long_Float;

  function Named_Local_Conditional
    (State   : in State_Access_t;
     Name    : in String;
     Default : in Long_Integer := 0) return Long_Integer;

  --
  -- Indexed local retrieval.
  --

  function Indexed_Local
    (State : in State_Access_t;
     Index : in Long_Integer) return UString_t;

  function Indexed_Local
    (State : in State_Access_t;
     Index : in Long_Integer) return Long_Float;

  function Indexed_Local
    (State : in State_Access_t;
     Index : in Long_Integer) return Long_Integer;

  function Indexed_Local_Conditional
    (State   : in State_Access_t;
     Index   : in Long_Integer;
     Default : in String := "") return UString_t;

  function Indexed_Local_Conditional
    (State   : in State_Access_t;
     Index   : in Long_Integer;
     Default : in Long_Float := 0.0) return Long_Float;

  function Indexed_Local_Conditional
    (State   : in State_Access_t;
     Index   : in Long_Integer;
     Default : in Long_Integer := 0) return Long_Integer;

  --
  -- Current local retrieval.
  --

  function Local (State : in State_Access_t) return Long_Float;

  function Local (State : in State_Access_t) return Long_Integer;

  function Local (State : in State_Access_t) return UString_t;

  function Local_Conditional
    (State   : in State_Access_t;
     Default : in Long_Float := 0.0) return Long_Float;

  function Local_Conditional
    (State   : in State_Access_t;
     Default : in Long_Integer := 0) return Long_Integer;

  function Local_Conditional
    (State   : in State_Access_t;
     Default : in String := "") return UString_t;

  --
  -- Table handling.
  --

  procedure Table_Start
    (State : in State_Access_t;
     Name  : in String);

  procedure Table_Iterate
    (State   : in State_Access_t;
     Process : not null access procedure
      (State : in State_Access_t));

  procedure Table_End (State : in State_Access_t);

  --
  -- Error strings.
  --

  function Error_String (State : in State_Access_t) return String;
  pragma Inline (Error_String);

  function Name_Code (State : in State_Access_t) return String;
  pragma Inline (Name_Code);

  --
  -- Exceptions.
  --

  Load_Error : exception;

private

  type State_t is record
    Lua_State  : Lua.State_t;
    Name_Depth : Natural := 0;
    Name_Code  : UString_t;
    Name_File  : UString_t;
    Err_String : UString_t;
  end record;

end Lua.Load;
