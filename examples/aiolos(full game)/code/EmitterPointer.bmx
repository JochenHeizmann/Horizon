
SuperStrict

Import BRL.Max2D
Import BRL.PNGLoader
Import BRL.Random

Import "Emitter.bmx"

Incbin "../data/img/particle_emitter.png"

Type TEmitterPointer Extends TEmitter
	Global imgPointer:TImage
	Field angle:Double

	Method Init()
		imgPointer = LoadImage("incbin::../data/img/particle_emitter.png")
		Super.init()
	End Method

	Method Update()	
		If (MouseDown(1))
			Local dx:Float =  (Sin(angle) * Rand(3,7))
			Local dy:Float = -(Cos(angle) * Rand(3,7))
			LaunchParticle(MouseX(), MouseY(), dx, dy, 140)
		End If
		
		Super.update()
	End Method
	
	Method Render(offsetX:Double = 0, offsetY:Double = 0)
		Super.Render()
		SetAlpha(1)				
		SetRotation(angle)
		DrawImage imgPointer, MouseX(), MouseY()
	End Method

	Method SetEmitPoint(x:Double, y:Double)
		Local destX:Double = x
		Local destY:Double = y
		angle = ATan2(destX - MouseX(), MouseY() - destY)
	End Method		
End Type
