
SuperStrict
Import BRL.Retro
Import BRL.Max2D
Import BRL.PNGLoader
Import "GuiWidgetFrame.bmx"
Import "Color.bmx"
Import "GuiUtilImage.bmx"

Type TGuiWidgetTextbox Extends TGuiWidgetFrame

	Field PADDING:Int = 2

	Field font:TImageFont
		
	Field multiline:Byte = False
	Field text:String
	Field maxLen : Int
	Field cPos : Int
	Field cursorJump:Byte
	Field allowedChars:String
	Field textColor:TColor
	
	Function CreateTextbox : TGuiWidgetTextbox(x:Int, y:Int, w:Int, h:Int)
		Local t:TGuiWidgetTextbox = New TGuiWidgetTextBox
		t.rect.x = x
		t.rect.y = y
		t.rect.w = w
		t.rect.h = h
		t.style = 0
		t.text = ""
		Return t
	End Function
	
	Method SetText(t:String)
		text = Mid(t, 0, maxLen + 1)		
	End Method
	
	Method New()
		topBar = LoadImage(TGuiSystem.SKIN_PATH + "window/bottomborder.png")
		rightBorder = LoadImage(TGuiSystem.SKIN_PATH + "window/rightborder.png")
		leftBorder = LoadImage(TGuiSystem.SKIN_PATH + "window/leftborder.png")
		bottomBorder = LoadImage(TGuiSystem.SKIN_PATH + "window/bottomborder.png")
		maxLen = 10000
		allowedChars = ""
		textColor = TColor.Create(0,0,0)
	End Method
	
	Method Render()
		If parent
				TGuiVP.Add(TGuiWidgetFrame(parent).GetInnerWindowX(), TGuiWidgetFrame(parent).GetInnerWindowY(), TGuiWidgetFrame(parent).GetInnerWidth(), TGuiWidgetFrame(parent).GetInnerHeight())
			Else
				TGuiVP.Add(GetInnerWindowX(), GetInnerWindowY(), GetInnerWidth(), GetInnerHeight())
		EndIf
		If (TGuiSystem.activeElement = Self)
			SetColor($AA,$AA,$AA)
		Else
			SetColor($88,$88,$88)
			If (GetWidgetState() = HOVER) Then SetColor($99,$99,$99)
		End If
		
		Local x : Int = GetInnerWindowX()
		Local y : Int = GetInnerWindowY()
		DrawRect x,y, GetInnerWidth(), GetInnerHeight()
		x :+ PADDING
		y :+ PADDING
		SetImageFont(font)
		For Local Pos:Int = 0 To text.Length
			SetColor(textColor.r, textColor.g, textColor.B)
			Local char:String = Mid(text, Pos, 1)
			
			Local break : Byte = False
			Local tmpX : Int = x
			Local boundX : Int = GetInnerWindowX() + GetInnerWidth()
			Local c : Int = 0
			While (pos + c <= text.length)
				Local nc : String = Mid(text, pos + c, 1)
				c :+ 1
				tmpX :+ TextWidth(nc)
				If tmpX >= boundX Then break = True ; Exit
				If Asc(nc) = KEY_SPACE Then Exit
			Wend
			If break Or Asc(char) = KEY_ENTER
				y :+ TextHeight(text)
				x = GetInnerWindowX() + PADDING
			End If

			If (Asc(char) >= 32) 
				DrawText char, x, y
				x :+ TextWidth(char)
			End If
			
			If (TGuiSystem.activeElement = Self And cPos = Pos And MilliSecs() / 400 Mod 2 = 0)
				SetColor(255 - textColor.r, 255 - textColor.g, 255 - textColor.B)
				SetColor(0, 0, 0)
				If cPos = text.Length
					DrawRect x+2,y, TextWidth("G"), TextHeight("G")-3
				Else
					DrawRect x,y, 1, TextHeight("G")-3
				End If
			End If
			
			If (cursorJump)
				If (TGuiSystem.mouse.GetX() > x And TGuiSystem.mouse.GetY() > y)
					cPos = pos
				End If
			End If

			If (pos >= maxLen) Then Exit
		Next
		SetColor(255,255,255)
		TGuiVP.Pop()
		Super.Render()	
	End Method
	
	Method CursorToEnd()
		cPos = text.length
	End Method
	
	Method DrawTopBar()
		TGuiUtilImage.DrawRepeated(topBar, GetX(), GetY(), rect.w, ImageHeight(topBar))		
	End Method
	
	Method GetInnerHeight : Int()
		Return rect.h - ImageHeight(topBar) - ImageHeight(bottomBorder)
	End Method
	
	Method DrawBottomBorder()
		TGuiUtilImage.DrawRepeated(bottomBorder, GetX(), GetY() + rect.h - ImageHeight(bottomBorder), rect.w, ImageHeight(bottomBorder))		
	End Method	

	Method Update()
		cursorJump = False
		Super.Update()

		If (Self = TGuiSystem.activeElement)		
			If KeyHit(KEY_LEFT)
				cPos :- 1
				If cPos < 0 Then cPos = 0
			End If
		
			If KeyHit(KEY_RIGHT)
				cPos :+ 1
				If cPos > text.length Then cPos = text.length
			End If
		
			If KeyHit(KEY_DELETE) And cPos < text.length Then RemoveChar(cPos+1) ; cPos :+ 1
			If KeyHit(KEY_HOME) Then cPos = 0
			If KeyHit(KEY_END) Then cPos = text.length
	
			Local c:Int = GetChar()
			While (c > 0)			
				Select c									
					Case KEY_BACKSPACE
						RemoveChar(cpos)

					Case KEY_ENTER
						If (multiline) 
							InsertChar(Chr(c))
						Else
							TGuiSystem.activeElement = Null
						End If
						
					Default
						InsertChar(Chr(c))
				End Select
			
				c = GetChar()
			Wend
		End If
	End Method	
	
	Method InsertChar(c:String)
		If text.length >= maxLen Then Return
		
		If allowedChars <> ""
			Local found:Byte = False
			For Local i:Int = 0 To allowedChars.length
				If Mid(allowedChars, i, 1) = c Then found = True ; Exit
			Next
			If (Not found) Then Return
		End If
		
		Local firstSegment : String = Mid(text, 0, cPos + 1)
		text = firstSegment + c + Right(text, text.length - firstSegment.length)
		cPos :+ 1	
	End Method
	
	Method RemoveChar(pos:Int)
		If text.length > 0
			Local firstSegment : String = Mid(text, 0, pos)
			text = firstSegment + Right(text, text.length - firstSegment.length - 1)
			cPos :- 1
		End If
	End Method
	
	Method OnActivate()
		Super.OnActivate()
		FlushKeys()
	End Method	
	
	Method OnMouseHit()
		TGuiSystem.activeElement = Self
		cursorJump = True				
	End Method	
End Type