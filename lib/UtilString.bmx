
SuperStrict

Type TUtilString
	Function Split:String[](text:String, delim:String)
		Local textArr:String[1]
		Local rText:String = text
		Local i:Int = 0
	
		Repeat
			If rText.Length = 0 Then Exit
			Local sp:Int = rText.Find(delim)
			If sp = - 1
				textArr[i] = rText
				Exit
			End If
			textArr[i] = Left(rText, sp)
			rText = Right(rText,(rText.Length - sp)-1)
			i:+1
			textArr = textArr[..i+1]
		Forever
		
		Return textArr		
	End Function
End Type
