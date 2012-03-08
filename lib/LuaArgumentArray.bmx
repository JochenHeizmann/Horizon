SuperStrict

Import "LuaArgument.bmx"
Import "Lua.bmx"

Type TLuaArgumentArray Extends TLuaArgument
	Field value:Object[]
	
	Function Create:TLuaArgumentArray(v:Object[])
		Local arg:TLuaArgumentArray = New TLuaArgumentArray
		arg.typeId = ArrayTypeId
		arg.value = v
		Return arg
	End Function

	Method Push(L:Byte Ptr)
		TLua.PushArray(L, value)
	End Method
End Type