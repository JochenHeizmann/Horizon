
SuperStrict

Import BRL.Max2D
Import BRL.Random


Const MAX_EMITTER_SLOTS:Int = 10
Const TPARTICLE_VER:String = "1.1"

Type TParticle
	Global ParticleSprites:TImage 

	Function SetImage(File:Object)
		TParticle.ParticleSprites = LoadAnimImage(File,128,128,0,9)
		MidHandleImage(TParticle.ParticleSprites)
	End Function

	Field x:Float
	Field y:Float
	Field zoom:Float
	Field alpha:Float
	
	Field gravityX:Float, gravityY:Float
	
	Field dx:Float
	Field dy:Float
	
	Field r:Float, g:Float, b:Float
	
	Field rotation:Float
	Field rotation_speed:Float
	
	Field frame:Int
	
	Method New()
		zoom = 1.0
		frame = 0
	End Method
	
	Function Create:TParticle(x:Float, y:Float, zoom:Float = 1, dx:Float = 0, dy:Float = 0, alpha:Float = 1.0, r:Float = 255, g:Float = 255, b:Float = 255, rotation_speed:Float = 0, gravityX:Float = 0, gravityY:Float = 0, rotation:Float = 0)
		Local par:TParticle = New TParticle
		par.x = x
		par.y = y
		par.zoom = zoom
		par.dx = dx
		par.dy = dy
		par.alpha = alpha
		par.r = r
		par.g = g
		par.b = b
		par.rotation_speed = rotation_speed
		par.rotation = rotation
		par.gravityX = gravityX
		par.gravityY = gravityY
		Return par		
	End Function 
End Type