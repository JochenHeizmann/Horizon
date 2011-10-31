SuperStrict

Import "Point.bmx"
Import BRL.LinkedList
Import BRL.Max2D


Type TPath
	Field Points:TList
	
	Method New()
		Points = CreateList()
	End Method
	
	Method IsPointInsideArea:Byte(x:Double, y:Double)
		Local npol:Int = CountList(Points)
		Local pol:Object[] = ListToArray(Points)
		Local i:Int, j:Int, c:Byte
		j=npol-1
		For i=0 To npol-1
			Local ypi:Double= TPoint(pol[i]).y
			Local xPi:Double= TPoint(pol[i]).x
			Local ypj:Double= TPoint(pol[j]).y
			Local xPj:Double= TPoint(pol[j]).x
			If ((((ypi<=y) And (y<ypj)) Or ((ypj<=y) And (y<ypi))) And (x < (xpj - xpi) * (y-ypi) / (ypj - ypi) + xpi))
				c = Not c
			End If
			j = i
		Next
		Return c
	End Method
	
	Method AddPoint(x:Int, y:Int)
		Local p:TPoint = New TPoint
		p.x = x
		p.y = y
		ListAddLast(Points,p)
	End Method
	
	Method DebugPoints()
		For Local p:TPoint = EachIn Points
			DebugLog p.x+"/"+p.y
		Next
	End Method
	
	Method DrawPoints()
		Local ox:Int, oy:Int
		ox=-1
		oy=-1
		Local fx:Int, fy:Int
		For Local p:TPoint = EachIn Points
			If ox=-1 Then fx=p.x ; fy=p.y
			If ox>-1 Then DrawLine ox,oy,p.x,p.y
			ox = p.x
			oy = p.y
		Next
		DrawLine ox,oy,fx,fy
	End Method
	
	Method GetNextPoint(ax:Int Var, ay:Int Var)
		Local oax:Int = ax
		Local oay:Int = ay
		
		Local radius:Int = 0
		Local deg:Int = 0
		
		While (Not IsPointInsideArea(ax,ay))
			deg :+ 15
			If deg >= 360 Then deg :- 360 ; radius :+ 4
			ax = oax + (Cos(deg) * radius)
			ay = oay + (Sin(deg) * radius)			
		Wend
		
		Local t:TPoint = New TPoint
	End Method	
End Type


