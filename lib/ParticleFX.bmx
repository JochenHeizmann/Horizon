SuperStrict

Import "ParticleEmitter.bmx"

Type TParticleFX
	Field Emitter:TParticleEmitter[10]
	Field LoopFX:Byte
	Field Running:Byte
	
	Method New()
		For Local i:Int = 0 To 9
			Emitter[i] = New TParticleEmitter
		Next		
		
		LoopFX = False
		Running = True
	End Method
		
	Function DuplicateFrom:TParticleFX(pfx:TParticleFX)
		Local n:TParticleFX = New TParticleFX
		n.LoopFX = pfx.LoopFX
		n.Running = pfx.Running
		For Local i:Int = 0 To 9
			n.Emitter[i].X = pfx.Emitter[i].X
			n.Emitter[i].Y = pfx.Emitter[i].Y
			n.Emitter[i].EmitterDelay = pfx.Emitter[i].EmitterDelay 
			n.Emitter[i].EmitterDuration = pfx.Emitter[i].EmitterDuration 
			n.Emitter[i].EmissionRate = pfx.Emitter[i].EmissionRate 
			n.Emitter[i].EmissionEachFrame = pfx.Emitter[i].EmissionEachFrame 
			n.Emitter[i].Image = pfx.Emitter[i].Image 
			n.Emitter[i].SpeedX = pfx.Emitter[i].SpeedX 
			n.Emitter[i].SpeedY = pfx.Emitter[i].SpeedY 
			n.Emitter[i].SpeedVarX = pfx.Emitter[i].SpeedVarX 
			n.Emitter[i].SpeedVarY = pfx.Emitter[i].SpeedVarY 
			n.Emitter[i].LaunchSize = pfx.Emitter[i].LaunchSize 
			n.Emitter[i].SizeVar = pfx.Emitter[i].SizeVar 
			n.Emitter[i].Grow = pfx.Emitter[i].Grow 
			n.Emitter[i].MinSize = pfx.Emitter[i].MinSize 
			n.Emitter[i].MaxSize = pfx.Emitter[i].MaxSize 
			n.Emitter[i].Alpha = pfx.Emitter[i].Alpha 
			n.Emitter[i].AlphaVar = pfx.Emitter[i].AlphaVar 
			n.Emitter[i].AlphaChange = pfx.Emitter[i].AlphaChange 
			n.Emitter[i].RotationSpeed = pfx.Emitter[i].RotationSpeed 
			n.Emitter[i].RotationVar = pfx.Emitter[i].RotationVar 
			n.Emitter[i].RotationStart = pfx.Emitter[i].RotationStart 
			n.Emitter[i].ColorR = pfx.Emitter[i].ColorR 
			n.Emitter[i].ColorG = pfx.Emitter[i].ColorG 
			n.Emitter[i].ColorB = pfx.Emitter[i].ColorB 
			n.Emitter[i].ColorChangeR = pfx.Emitter[i].ColorChangeR 
			n.Emitter[i].ColorChangeG = pfx.Emitter[i].ColorChangeG 
			n.Emitter[i].ColorChangeB = pfx.Emitter[i].ColorChangeB 
			n.Emitter[i].StartOffsetX = pfx.Emitter[i].StartOffsetX 
			n.Emitter[i].StartOffsetY = pfx.Emitter[i].StartOffsetY 
			n.Emitter[i].StartOffsetVarX = pfx.Emitter[i].StartOffsetVarX 
			n.Emitter[i].StartOffsetVarY = pfx.Emitter[i].StartOffsetVarY 
			n.Emitter[i].GravityX = pfx.Emitter[i].GravityX 
			n.Emitter[i].GravityY = pfx.Emitter[i].GravityY 
			n.Emitter[i].LifeTime = pfx.Emitter[i].LifeTime 
			n.Emitter[i].RenderType = pfx.Emitter[i].RenderType 
		Next
		Return n		
	End Function
	
	Method SetLoop(t:Byte)
		LoopFX = t
	End Method
	
	Method MoveTo(x:Float, y:Float)
		For Local i:Int = 0 To 9
			Emitter[i].x = x
			Emitter[i].y = y
		Next
	End Method
		
	Method Render(delta:Float = 1.0, LaunchNewParticles:Byte=True)
		Local a:Float = GetAlpha()
		Local r:Float = GetRotation()
		Local sx:Float, sy:Float
		GetScale(sx,sy)
		Local red:Int, g:Int, b:Int
		GetColor(red,g,b)
	
		If Running
			For Local i:Int = 0 To 9
				Emitter[i].Render(delta,LaunchNewParticles)
				If LoopFX
					Emitter[i].Loop()
				End If			
			Next	
		End If
		
		SetAlpha(a)
		SetRotation(r)
		SetScale(sx,sy)
		SetColor(red,g,b)
	End Method
	
	Method Finished:Byte()
		Local count:Int = 0
		For Local i:Int = 0 To 9
			If Emitter[i].Finished() Or Emitter[i].RenderType = TParticleEmitter.RENDER_OFF Then count:+1
		Next
		If count>9 Then Return True Else Return False
	End Method
	
	Function Load:TParticleFX(Filename:Object, Loop:Byte = False)
		Local t:TParticleFX = New TParticleFX
		t.LoadFX(Filename)
		t.LoopFX = Loop
		Return t		
	End Function
	
	Method Stop()
		Running = False
	End Method
	
	Method Restart()
		For Local i:Int = 0 To 9
			Emitter[i].frame = 0
		Next
		Running = True
	End Method
	
	Method Reset()
		For Local i:Int = 0 To 9
			Emitter[i].Reset()	
		Next
	End Method
	
	Method LoadFX (Filename:Object)
		Local f:TStream = ReadFile(Filename)
		If (f)
			For Local i:Int = 0 To 9
				Emitter[i].EmitterDelay = ReadFloat(f)
				Emitter[i].EmitterDuration = ReadFloat(f)
				Emitter[i].EmissionRate = ReadFloat(f)
				Emitter[i].EmissionEachFrame = ReadFloat(f)
				Emitter[i].SpeedX = ReadFloat(f)
				Emitter[i].SpeedY = ReadFloat(f)
				Emitter[i].SpeedVarX = ReadFloat(f)
				Emitter[i].SpeedVarY = ReadFloat(f)
				Emitter[i].SizeVar = ReadFloat(f)
				Emitter[i].LaunchSize = ReadFloat(f)
				Emitter[i].Grow = ReadFloat(f)
				Emitter[i].MinSize	 = ReadFloat(f)
				Emitter[i].MaxSize = ReadFloat(f)
				Emitter[i].Alpha = ReadFloat(f)
				Emitter[i].AlphaVar = ReadFloat(f)
				Emitter[i].AlphaChange = ReadFloat(f)
				Emitter[i].RotationSpeed  = ReadFloat(f)
				Emitter[i].RotationVar 	 = ReadFloat(f)
				Emitter[i].RotationStart 	 = ReadFloat(f)
				Emitter[i].StartOffsetX 	 = ReadFloat(f)
				Emitter[i].StartOffsetY  = ReadFloat(f)
				Emitter[i].StartOffsetVarX	 = ReadFloat(f)
				Emitter[i].StartOffsetVarY = ReadFloat(f)
				Emitter[i].ColorChangeR	 = ReadFloat(f)
				Emitter[i].ColorChangeG	 = ReadFloat(f)
				Emitter[i].ColorChangeB = ReadFloat(f)
				Emitter[i].LifeTime	 = ReadFloat(f)
				Emitter[i].RenderType = ReadInt(f)
				Emitter[i].Image	 = ReadInt(f)
				Emitter[i].ColorR	 = ReadFloat(f)
				Emitter[i].ColorG	 = ReadFloat(f)
				Emitter[i].ColorB = ReadFloat(f)
				Emitter[i].GravityX = ReadFloat(f)
				Emitter[i].GravityY = ReadFloat(f)
			Next
			CloseFile(f)
		Else
			RuntimeError "Could not load Particle FX"
		End If
	End Method
	
	Method SaveFX (Filename:Object)
		Local f:TStream = WriteFile(Filename)

		If (f)
			For Local i:Int = 0 To 9
				WriteFloat(f, Emitter[i].EmitterDelay)
				WriteFloat(f, Emitter[i].EmitterDuration )	
				WriteFloat(f, Emitter[i].EmissionRate)	
				WriteFloat(f, Emitter[i].EmissionEachFrame)
				WriteFloat(f, Emitter[i].SpeedX )	
				WriteFloat(f, Emitter[i].SpeedY )	
				WriteFloat(f, Emitter[i].SpeedVarX)	
				WriteFloat(f, Emitter[i].SpeedVarY)	
				WriteFloat(f, Emitter[i].SizeVar)	
				WriteFloat(f, Emitter[i].LaunchSize )	
				WriteFloat(f, Emitter[i].Grow)	
				WriteFloat(f, Emitter[i].MinSize)	
				WriteFloat(f, Emitter[i].MaxSize)	
				WriteFloat(f, Emitter[i].Alpha)	
				WriteFloat(f, Emitter[i].AlphaVar )	
				WriteFloat(f, Emitter[i].AlphaChange)	
				WriteFloat(f, Emitter[i].RotationSpeed )	
				WriteFloat(f, Emitter[i].RotationVar )	
				WriteFloat(f, Emitter[i].RotationStart )	
				WriteFloat(f, Emitter[i].StartOffsetX )	
				WriteFloat(f, Emitter[i].StartOffsetY )	
				WriteFloat(f, Emitter[i].StartOffsetVarX)	
				WriteFloat(f, Emitter[i].StartOffsetVarY)	
				WriteFloat(f, Emitter[i].ColorChangeR )	
				WriteFloat(f, Emitter[i].ColorChangeG )	
				WriteFloat(f, Emitter[i].ColorChangeB )	
				WriteFloat(f, Emitter[i].LifeTime )	
				WriteInt(f, Emitter[i].RenderType )	
				WriteInt(f, Emitter[i].Image )	
				WriteFloat(f, Emitter[i].ColorR )	
				WriteFloat(f, Emitter[i].ColorG )	
				WriteFloat(f, Emitter[i].ColorB )	
				WriteFloat(f, Emitter[i].GravityX )
				WriteFloat(f, Emitter[i].GravityY )
			Next
			
			CloseFile(f)
		Else
			RuntimeError "Could not save Particle FX"
		End If
	End Method	
End Type
