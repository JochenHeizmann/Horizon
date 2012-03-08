Import BRL.Reflection

Extern
	Function bbRefPushObject(p:Byte Ptr,obj:Object)
	Function bbRefGetObjectClass(obj:Object)
	Function bbRefGetSuperClass(class:Int)	
End Extern

Type TDelegate Abstract
	Method Invoke:Object(args:Object[] = Null) Abstract

	Method Push:Byte Ptr(sp:Byte Ptr, typeId:TTypeId, value:Object)
		Select typeId
			Case ByteTypeId,ShortTypeId,IntTypeId
				(Int Ptr sp)[0] = value.ToString().ToInt()
				Return sp+4
			Case LongTypeId
				(Long Ptr sp)[0] = value.ToString().ToLong()
				Return sp+8
			Case FloatTypeId
				(Float Ptr sp)[0] = value.ToString().ToFloat()
				Return sp+4
			Case DoubleTypeId
				(Double Ptr sp)[0] = value.ToString().ToDouble()
				Return sp+8
			Case StringTypeId
				If Not value Then value=""
				bbRefPushObject(sp, value)
				Return sp+4
			Default
				If value
					Local c:Int = typeId._class
					Local t:Int = bbRefGetObjectClass(value)
					While t And t<>c
						t = bbRefGetSuperClass(t)
					Wend
					If Not t Then Throw "ERROR"
				End If
				bbRefPushObject(sp,value)
				Return sp+4
		End Select
	End Method
End Type