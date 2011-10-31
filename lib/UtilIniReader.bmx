SuperStrict

Import BRL.FileSystem
Import BRL.LinkedList
Import BRL.Stream
Import BRL.Retro

Import "UtilIniSection.bmx"
Import "UtilIniKey.bmx"

Type TUtilIniReader
	Field sections : TList

	Method New()
		Self.sections = New TList
	End Method

	Method GetValue:String(section:String, key:String)
		Local found:Int, section2:TUtilIniSection, key2:TUtilIniKey
		section2 = GetSection(section)
		
		If (section2)
			For key2 = EachIn section2.keys
				If key2.name.ToLower() = key.ToLower() Then Return key2.value
			Next
		End If
		
		Return ""
	End Method

	Method getKey:TUtilIniKey(section:String, key:String)
		Local found:Int, section2:TUtilIniSection, key2:TUtilIniKey
		section2 = GetSection(section)
		
		If (section2)
			For key2 = EachIn section2.keys
				If key2.name.ToLower() = key.ToLower() Then Return key2
			Next
		End If
		Throw "Key " + section + " -> " + key + " not found!"
	End Method
	
	Method GetSection:TUtilIniSection(section:String)
		Local found:Int, section2:TUtilIniSection

		section = section.ToLower()
		For section2 = EachIn Self.sections
			If section2.name.ToLower() = section Then
				Return section2
			End If
		Next
		
		Return Null
	End Method

	Function Load:TUtilIniReader(URL:Object)
		Local stream:TStream, reader:TUtilIniReader, section:TUtilIniSection
		Local key:TUtilIniKey, line:String, position:Int, found:Int

		stream = ReadStream(URL)
		If Not stream Then Return Null

		reader = New TUtilIniReader

		While Not stream.Eof()
			line = stream.ReadLine()			

			' Check for white spaces at the beginning
			If line.length > 0 And (line[0] = 9 Or line[0]) = 32 Then
				found = 0
				For position = 1 Until line.length
					If line[position] <> 9 And line[position] <> 32 Then
						found = position
						Exit
					End If
				Next

				' Trim white spaces
				line = line[found..]

				' Only comments and keys can begin with white spaces
				If line[0] = 91 Then
					stream.Close()
					Throw "Sections can't begin with white spaces."
					Return Null
				End If
			End If

			' Check for a comment
			found = line.find(";")
			If found => 0 Then
				If found > 0 And (Not (line[found - 1] = 9 Or ..
				                       line[found - 1] = 32)) Then
					stream.Close()
					Throw "Expected spacing character before ';'."
					Return Null
				End If
				
				line = line[..found]
			End If

			' Check for empty line
			If line.Length = 0 Then Continue

			' Check for a section
			If line[0] = 91 Then
				found = 0
				For position = 1 Until line.length
					If line[position] = 9 Or line[position] = 32 Then
						stream.Close()
						Throw "Sectionnames can't contain white spaces."
						Return Null
					End If

					If line[position] = 93 Then
						found = position
						Exit
					End If
				Next

				If Not found Then
					stream.Close()
					Throw "Expected ']'."
					Return Null
				End If

				section = New TUtilIniSection
				section.name = line[1..found]

				reader.sections.AddLast(section)
				Continue
			End If

			' Check if a section exists
			If Not section
				stream.Close()
				Throw "Expected '[Section]' before."
				Return Null
			End If

			' Check for a key
			found = line.Find("=")
			If Not found Then
				stream.Close()
				Throw "Expected '='."
				Return Null
			End If

			found = 0
			For position = 0 Until line.length
				If found = 0 And (line[position] = 9 Or line[position] = 32) Then
					found = position
				Else If found > 0 And line[position] <> 61 Then
					stream.Close()
					Throw "Keynames can't contain white spaces."
					Return Null
				Else If line[position] = 61 Then
					found = position
					Exit
				End If
			Next

			key = New TUtilIniKey
			key.name  = line[..found].Replace(" ", "").Replace("	", "")
			key.value = Trim(line[found + 1..])
			key.value = key.value.Replace("~~n", "~n")
			section.Keys.AddLast(key)
		Wend

		stream.Close()
		Return reader
	End Function
End Type
