
SuperStrict

Import "Point.bmx"

Type TRect
	Field x:Int, y:Int
	Field w:Int, h:Int

	Function Create:TRect(x:Int = 0, y:Int = 0, w:Int = 0, h:Int = 0)
		Local tr:TRect = New TRect
		tr.x = x
		tr.y = y
		tr.w = w
		tr.h = h
		Return tr
	End Function

	Method GetX2 : Int()
		Return x + w
	End Method
	
	Method GetY2 : Int()
		Return y + h
	End Method
	
	Method GetX : Int()
		Return x
	End Method
	
	Method GetY : Int()
		Return y
	End Method
	
	Method GetW : Int()
		Return w
	End Method
	
	Method GetH : Int()
		Return h
	End Method
	
	Method IsInRect : Byte(x : Int, y : Int)
		Return (x >= GetX() And y >= GetY() And x <= GetX2() And y <= GetY2())
	End Method	
	
	Method Move(dx:Int, dy:Int)
		x :+ dx
		y :+ dy
	End Method
	
	Method SetXY(x:Int, y:Int)
		Self.x = x
		Self.y = y
	End Method
	
	Method SetWidth(w:Int)
		Self.w = w
	End Method
	
	Method SetHeight(h:Int)
		Self.h = h
	End Method
End Type
