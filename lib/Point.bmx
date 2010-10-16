SuperStrict

Type TPoint
	Field x:Int
	Field y:Int
	Function Create:TPoint(x:Int, y:Int)
		Local p:TPoint = New TPoint
		p.x = x
		p.y = y
		Return p
	End Function
End Type
