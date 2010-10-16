
SuperStrict

Import "Point.bmx"

Type TRect
	Function Create:TRect(x:Int = 0, y:Int = 0, x2:Int = 0, y2:Int = 0)
		Local tr:TRect = New TRect
		tr.leftTop = TPoint.Create(x,y)
		tr.bottomRight = TPoint.Create(x2, y2)
		Return tr
	End Function
	Field leftTop:TPoint
	Field bottomRight:TPoint
End Type
