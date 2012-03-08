SuperStrict

Import "LuaArgument.bmx"

Type TLuaArgumentInt Extends TLuaArgument
	Function Create:TLuaArgumentInt(v:Int)
		Local arg:TLuaArgumentInt = New TLuaArgumentInt
		arg.typeId = IntTypeId
		arg.value = String(v)
		Return arg
	End Function
	
	Method Push(L:Byte Ptr)
		lua_pushinteger(L, value.ToString().ToInt())
	End Method
End Type
