
SuperStrict

Type TUtilFont
	Function Draw(txt:String, x:Int, y:Int, boxWidth:Int, lineHeight:Float = 1.5)
		Local sy:Int = y
		For Local fline:String = EachIn txt.split("~n")
			For Local line:String = EachIn fline.split(Chr(KEY_ENTER))
				If (TextWidth(line) > boxWidth)
					Local px:Int = x
					For Local word:String = EachIn line.split(" ")
						If (TextWidth(word) + px > x + boxWidth)
							y :+ TextHeight(line) * lineHeight
							px = x
						End If
						DrawText (word + " ", px, y)
						px :+ TextWidth(word + " ")
					Next
				Else
					DrawText line, x, y
				End If
				y :+ TextHeight(line) * lineHeight
			Next
		Next
	End Function
	
	Function GetHeight:Int(txt:String, boxWidth:Int, lineHeight:Float = 1.5)
		Local x:Int = 0
		Local y:Int = 0
		
		For Local fline:String = EachIn txt.split("~n")
			For Local line:String = EachIn fline.split(Chr(KEY_ENTER))
				If (TextWidth(line) > boxWidth)
					Local px:Int = x
					For Local word:String = EachIn line.split(" ")
						If (TextWidth(word) + px > x + boxWidth)
							y :+ TextHeight(line) * lineHeight
							px = x
						End If
						px :+ TextWidth(word + " ")
					Next
				End If
				y :+ TextHeight(line) * lineHeight
			Next
		Next
		Return y
	End Function
End Type
