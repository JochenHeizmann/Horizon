
SuperStrict

Import BRL.Max2D

Import "PhysicObject.bmx"

Type TParticle Extends TPhysicObject
	Field lifetime:Int
	Field destroy:Byte = False
	
	Method New()
		fraction = 0.99
		x = 250
		y = 250
		lifetime = 100
	End Method	
	
	Method Init(x:Double, y:Double, dx:Double, dy:Double, lifetime:Int = 100)
		Self.x = x
		Self.y = y
		Self.dx = dx
		Self.dy = dy
		Self.lifetime = lifetime
	End Method
	
	Method PostUpdate()
		lifetime :- 1
		If (lifetime <= 0) Then destroy = True
	End Method
	
	Method Render(particleImage:TImage, offsetX:Double = 0, offsetY:Double = 0)
		SetAlpha(GetHealth())
		DrawImage particleImage, x - offsetX, y - offsetY
	End Method
	
	Method GetHealth:Float()
		Return (lifetime-60) / 100.0
	End Method
End Type
