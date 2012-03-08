SuperStrict

Import "LuaArgument.bmx"

Type TLuaArgumentObject Extends TLuaArgument
	Function Create:TLuaArgumentObject(v:Object)
		Local arg:TLuaArgumentObject = New TLuaArgumentObject
		arg.typeId = ObjectTypeId
		arg.value = v
		Return arg
	End Function

	Method Push(L:Byte Ptr)
		TLua.PushObject(L, value)
	End Method
End Type