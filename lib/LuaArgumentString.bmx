SuperStrict

Import "LuaArgument.bmx"

Type TLuaArgumentString Extends TLuaArgument
	Function Create:TLuaArgumentString(v:String)
		Local arg:TLuaArgumentString = New TLuaArgumentString
		arg.typeId = StringTypeId
		arg.value = v
		Return arg
	End Function

	Method Push(L:Byte Ptr)
		lua_pushstring(L, value.ToString())
	End Method
End Type