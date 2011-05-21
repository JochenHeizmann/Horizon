SuperStrict

Import "Language.bmx"
Import "UtilIniKey.bmx"

'shortcut function
Function _:TUtilIniKey(section:String, key:String)
	Return TLocalization.GetInstance().Get(section, key)
End Function

Type TLocalization
	Global instance:TLocalization
	
	Field languages:TMap
	Field currentLanguage:TLanguage
	Field defaultLanguage:TLanguage

	Function GetInstance:TLocalization()
		If Not Self.instance
			Self.instance = New Self
		End If
		Return Self.instance
	End Function
	
	Method New()
		languages = CreateMap()
	End Method
	
	Method addLanguage(file:String, defaultLanguage:Byte = False)
		Local l:TLanguage = New TLanguage
		l.Load(file)
		languages.Insert(file, l)
		If (defaultLanguage)
			setLanguage(file)
			SetDefaultLanguage(file)
		End If
	End Method
	
	Method setLanguage(file:String)
		currentLanguage = TLanguage(languages.ValueForKey(file))
		If (Not currentLanguage) Then RuntimeError "Language " + file + " not found!"
	End Method
	
	Method SetDefaultLanguage(file:String)
		defaultLanguage = TLanguage(languages.ValueForKey(file))
		If (Not defaultLanguage) Then RuntimeError "Language " + file + " not found!"
	End Method
	
	Method Get:TUtilIniKey(section:String, key:String)
		Return currentLanguage.Get(section, key)
	End Method	
End Type
