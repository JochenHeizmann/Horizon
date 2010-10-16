SuperStrict

Import "Particle.bmx"

Type TParticleEmitter
	Const RENDER_ALPHA:Int = 0
	Const RENDER_ADD:Int = 1
	Const RENDER_MUL:Int = 2
	Const RENDER_OFF:Int = 3

	Global scaleFactor:Float = 1.0
	Global mapOffsetX:Double = 1.0
	Global mapOffsetY:Double = 1.0
	
	Field Frame:Int = 0

	Field Particles:TList
	
	Field X:Float, Y:Float
	
	Field EmitterDelay:Float	'Delay before Particles will be launched
	Field EmitterDuration:Float 'Duration how long Particles will be launched
	Field EmissionRate:Float    'How many Particles are launched in one second
	Field EmissionEachFrame:Float

	Field Image:Int				'ParticleSprite / Frame
	
	Field SpeedX:Float			'X-Speed
	Field SpeedY:Float			'Y-Speed
	Field SpeedVarX:Float		'Random-Variation of X-Speed
	Field SpeedVarY:Float		'Random-Variaiont of Y-Speed
	
	Field LaunchSize:Float		'1.0 = Original Size
	Field SizeVar:Float			'Variation of Size
	Field Grow:Float			'Growing of Particle
	Field MinSize:Float			'Min Size of a growing particle
	Field MaxSize:Float			'Max Size of a growing particle
	
	Field Alpha:Float
	Field AlphaVar:Float
	Field AlphaChange:Float
	
	Field RotationSpeed:Float
	Field RotationVar:Float
	Field RotationStart:Float	
	
	Field ColorR:Float
	Field ColorG:Float
	Field ColorB:Float
	
	Field ColorChangeR:Float
	Field ColorChangeG:Float
	Field ColorChangeB:Float
	
	Field StartOffsetX:Float	'in Pixel
	Field StartOffsetY:Float
	Field StartOffsetVarX:Float
	Field StartOffsetVarY:Float
	
	Field GravityX:Float, GravityY:Float
	
	Field LifeTime:Float
	
	Field RenderType:Int
	
	Field StartTime:Float, CurrTime:Float	

	Method Reset()
		For Local par:TParticle = EachIn Particles
			ListRemove(Particles, par) ; par = Null
		Next		
	End Method
	
	Method New()
		Particles = CreateList()
		
		EmissionEachFrame = 1.0
		
		X = 220
		Y = 330
		
		EmitterDelay 		= 0
		EmitterDuration 	= 10
		EmissionRate		= 1
		
		Image				= 4
		SpeedX				= 0
		SpeedY				= 0
		SpeedVarX			= 0
		SpeedVarY			= 0
		LaunchSize 		= 1
		SizeVar				= 0
		Grow				= 0.000
		MaxSize				= 1
		
		Alpha				= 1
		AlphaVar			= 0
		AlphaChange		= 0
		RotationSpeed		= 0
		RotationVar		= 0
		ColorR				= 255
		ColorG				= 255
		ColorB				= 255
		ColorChangeR		= 0
		ColorChangeG		= 0
		ColorChangeB		= 0
		
		StartOffsetX		= 0
		StartOffsetY		= 0
		StartOffsetVarX	= 0
		StartOffsetVarY	= 0
		
		GravityX = 0
		GravityY = 0
		
		LifeTime			= 100
		
		RotationStart 		= 0
		
		RenderType			= RENDER_OFF		
	End Method
	
	Function SetGlobalOffset(offX:Double, offY:Double, factor:Float)
		scaleFactor = factor
		mapOffsetX = offX
		mapOffsetY = offY
	End Function

	Method Loop()
		If (frame>EmitterDuration+EmitterDelay) Then frame=0
	End Method
	
	Method Finished:Byte()
		If (frame>(EmitterDuration+EmitterDelay+Lifetime)) Then Return True Else Return False
	End Method
	
	Method Render(delta:Float = 1.0, LaunchNewParticles:Byte = True)
	
		If RenderType = RENDER_OFF Then Return
	
		Local a:Float = GetAlpha()
		Local sx:Float, sy:Float
		GetScale(sx,sy)
		Local r:Float = GetRotation()
		Local cr:Int, cg:Int, cb:Int
		GetColor(cr,cg,cb)
		Local blend:Int = GetBlend()
			
		If frame=0 Then StartTime=MilliSecs()
		CurrTime = MilliSecs()-StartTime
		frame:+1
	
		'Update	
		If LaunchNewParticles And (frame Mod EmissionEachFrame = 0)
			If frame<=(EmitterDuration+EmitterDelay) And frame>=EmitterDelay
				For Local i:Int = 0 To EmissionRate
					ListAddLast(Particles, TParticle.Create(X + StartOffsetX + Rnd(-StartOffsetVarX,StartOffsetVarX), Y + StartOffsetY + Rnd(-StartOffsetVarY, StartOffsetVarY),LaunchSize + Rnd(-SizeVar,SizeVar), SpeedX + Rnd(-SpeedVarX,SpeedVarX), SpeedY + Rnd(-SpeedVarY, SpeedVarY),Alpha + Rnd(-AlphaVar,AlphaVar),ColorR, ColorG, ColorB,RotationSpeed+Rnd(-RotationVar,RotationVar),GravityX, GravityY, RotationStart))
				Next
			End If
		End If
		
		
		Select RenderType
			Case RENDER_ALPHA
				SetBlend ALPHABLEND
			Case RENDER_ADD
				SetBlend LIGHTBLEND
			Case Render_MUL
				SetBlend SHADEBLEND
		End Select
				
		For Local par:TParticle = EachIn Particles
		
			If par.zoom < MinSize Then par.zoom = MinSize
			If par.zoom > MaxSize Then par.zoom = MaxSize
			
			par.x :+ (par.dx*delta)
			par.y :+ (par.dy*delta)
			
			par.dx :+ (gravityX*delta)
			par.dy :+ (gravityY*delta)
			
			SetAlpha(par.alpha)
			SetScale(par.zoom * scaleFactor, par.zoom * scaleFactor)
			SetColor(par.r, par.g, par.b)
			SetRotation(par.rotation)
			
			DrawImage TParticle.ParticleSprites,(par.x + mapOffsetX) * scaleFactor, (par.y + mapOffsetY) * scaleFactor,Image
		
			par.r :+ (ColorChangeR*delta)
			par.g :+ (ColorChangeG*delta)
			par.b :+ (ColorChangeB*delta)
			
			par.alpha :+ (AlphaChange*delta)
			par.rotation :+ (par.rotation_speed*delta)
			
			par.zoom :+ (Grow*delta)
		
			' Check Lifespan
			par.frame :+ 1
			If par.frame>LifeTime Then ListRemove(Particles, par) ; par = Null
		Next

		SetAlpha(a)
		SetScale(sx,sy)
		SetRotation(r)
		SetColor(cr,cg,cb)			
		SetBlend(blend)
	End Method		
End Type

