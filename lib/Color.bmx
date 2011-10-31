
SuperStrict

Import BRL.Max2D

Type TColor
	Field r : Int, g : Int, b : Int

	Function Create : TColor(r : Int, g : Int, b : Int)
		Local c : TColor = New TColor
		c.r = r
		c.g = g
		c.b = b
		Return c
	End Function

	Method Set()
		SetColor(r, g, b)
	End Method
End Type
