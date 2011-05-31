SuperStrict

Import "UtilIniReader.bmx"
Import "UtilIniKey.bmx"

Type TLanguage
	Field lan:TUtilIniReader
	
	Method Get:TUtilIniKey(section:String, key:String)
		return lan.getKey(section, key)
	End Method
	
	Method Load(file:String)
		lan = TUtilIniReader.Load(file)
	End Method
End Type