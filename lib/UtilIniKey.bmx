SuperStrict

Type TUtilIniKey
	Field name  : String
	Field value:String
	
	Field parameters:TMap
	
	Method New()
		parameters = CreateMap()
	End Method
	
	Method Assign:TUtilIniKey(key:String, value:String)
		parameters.Insert(key, value)
		Return Self
	End Method
	
	Method format:String()
		Local v:String = value
		For Local key:String = EachIn parameters.Keys()
			v = v.Replace("{" + key + "}", String(parameters.ValueForKey(key)))
		Next
		Return v
	End Method
End Type