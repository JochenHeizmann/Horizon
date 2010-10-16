
SuperStrict

Import BaH.Persistence

Type TSavedGame
	Method Serialize(stream:TStream)
		Local persistance:TPersist = New TPersist
		Local str:String = persistance.SerializeToString(Self)
		WriteInt(stream, str.length)
		WriteString(stream, str)
	End Method
	
	Function Deserialize:Object(stream:TStream)
		Local persistance:TPersist = New TPersist
		Local l:Int = ReadInt(stream)
		Local str:String = ReadString(stream, l)
		Return persistance.DeSerializeObject(str)
	End Function
End Type
