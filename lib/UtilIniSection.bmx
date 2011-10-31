SuperStrict

Import BRL.LinkedList

Type TUtilIniSection
	Field name : String
	Field keys : TList

	Method New()
		Self.keys = New TList
	End Method
End Type