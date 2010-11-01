
SuperStrict

Type TPhysicObject
	Field x:Double, y:Double
	Field dx:Double, dy:Double
	Field fraction:Double
	
	Method Update()
		PreUpdate()
		DoUpdate()
		PostUpdate()
	End Method
	
	Method PostUpdate()
	End Method
	
	Method PreUpdate()
	End Method
	
	Method DoUpdate()
		x :+ dx
		y :+ dy
		dx :* fraction
		dy :* fraction		
	End Method
End Type
