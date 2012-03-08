SuperStrict

Import "LuaArgument.bmx"

Type TLuaArgumentNumber Extends TLuaArgument
	Function Create:TLuaArgumentNumber(v:Double)
		Local arg:TLuaArgumentNumber = New TLuaArgumentNumber
		arg.typeId = DoubleTypeId
		arg.value = String(v)
		Return arg
	End Function

	Method Push(L:Byte Ptr)
		lua_pushnumber(L, Double(value.ToString().ToDouble()))
	End Method
End Type