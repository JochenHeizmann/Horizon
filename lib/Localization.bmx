SuperStrict

Import "Language.bmx"
Import "UtilIniKey.bmx"
Import "UtilIniSection.bmx"

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
	
	Method Validate()
		Local error:Byte = False
		For Local s:TUtilIniSection = EachIn defaultLanguage.lan.sections
			For Local key:TUtilIniKey = EachIn s.Keys
				For Local lankey:String = EachIn languages.Keys()
					Local l:TLanguage = TLanguage(languages.ValueForKey(lankey))
					If l = defaultLanguage Then Continue
					Try
						l.Get(s.name, key.name)
					Catch e:String
						Print s.name + "/" + key.name + " not available in language " + lankey
						error = True
					End Try
				Next
			Next
		Next
		If (error)
			Print "Language File invalid!"
			End
		End If
	End Method
End Type
