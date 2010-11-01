
SuperStrict

Import BRL.Max2D
Import BRL.PNGLoader
Import BRL.Random

Import "../../../lib/TileMap.bmx"

Import "PhysicObject.bmx"
Import "EmitterPointer.bmx"
Import "EnergyBar.bmx"
Import "ScoreBar.bmx"
Import "SoundPlayer.bmx"

Incbin "../data/img/balloon.png"
Incbin "../data/img/balloon_glow.png"

Type TBalloon Extends TPhysicObject
	Field imgBalloon:TImage, imgBalloonGlow:TImage
	Field offsetX:Int, offsetY:Int
	Field tileMap:TTileMap
	Field energyBar:TEnergyBar
	Field scorebar:TScoreBar
	Field emitter:TEmitter

	Const STATE_GAME:Int = 0
	Const STATE_EXPLODE:Int = 1
	Const STATE_DEAD:Int = 2
	
	Field state:Int
	Field explFrame:Int

	Const KEY_GREEN:Int = 0
	Const KEY_BLUE:Int = 1
	Const KEY_YELLOW:Int = 2
	Const KEY_RED:Int = 3
	
	Const NO_KEY_SLOTS:Int = 4
	
	Field keySlot:Int[NO_KEY_SLOTS]
	
	Method Reset()
		emitter = New TEmitter
		emitter.Init()
		state = STATE_GAME
		For Local i:Int = 0 To NO_KEY_SLOTS-1
			keySlot[i] = -1
		Next
		dx = 0
		dy = 0
	End Method
	
	Method New()
		AutoMidHandle True
		imgBalloon = LoadImage("incbin::../data/img/balloon.png")
		imgBalloonGlow = LoadImage("incbin::../data/img/balloon_glow.png")
		fraction = 0.99
		x = 120
		y = 120
		offsetX = 0
		offsetY = 0
	End Method	
	
	Method IsAlive:Byte()
		Return state = STATE_GAME
	End Method
	
	Method Explode()
		state = STATE_EXPLODE
		explFrame = 0
		TSoundPlayer.GetInstance().PlaySFX(TSoundPlayer.SFX_XPLODE)
	End Method

	Method IsDead:Byte()
		Return state = STATE_DEAD
	End Method
		
	Method SetTileMap(t:TTileMap)
		tileMap = t
	End Method
	
	Method SetEnergyBar(e:TEnergyBar)
		energyBar = e
	End Method

	Method SetScoreBar(s:TScoreBar)
		scorebar = s
		scorebar.SetKeySlot(Varptr(keySlot[0]))
		scorebar.SetTileMap(tileMap.tiles)
	End Method
	
	Method SetOffset(x:Int, y:Int)
		offsetX = x
		offsetY = y
	End Method
	
	Method Render()
		If state <> STATE_GAME
			emitter.Render(tileMap.GetOffsetX(), tileMap.GetOffsetY())
		Else
			DrawImage imgBalloon, x - offsetX, y - offsetY
		End If
	End Method	
	
	Method Update()
		If state <> STATE_GAME
			If state = STATE_EXPLODE
				explFrame :+ 1
				If explFrame < 13
					For Local i:Int = 0 To 17
						emitter.LaunchParticle(x , y , Rand(-8, 8) + dx, Rand(-8, 8) + dy, Rand(70,200))
					Next
				End If
				If explFrame > 140 Then state = STATE_DEAD
			End If
			emitter.Update()
		End If
		
		Super.Update()
	End Method
	
	Method PreUpdate()
		If state = STATE_GAME
			'check for ball<-->wall collision
			If (CollideImage(imgBalloon, x - offsetX + dx, y - offsetY, 0, COLLISION_LAYER_1, 0))
				dx :* -1
				TSoundPlayer.GetInstance().PlaySFX(TSoundPlayer.SFX_COLLIDE) 
				'; energyBar.energy :- Abs(dx)
			End If
			
			If (CollideImage(imgBalloon, x - offsetX, y - offsetY + dy, 0, COLLISION_LAYER_1, 0))
				dy :* -1 
				'; energyBar.energy :- Abs(dy)
				TSoundPlayer.GetInstance().PlaySFX(TSoundPlayer.SFX_COLLIDE) 
			End If
			
			Local checkJewles:Byte = False
			Local checkNotes:Byte = False
			Local checkForKey:Byte = False
			Local checkForDoor:Byte = False
			
			'check for ball<-->jewels collision
			If (CollideImage(imgBalloon, x - offsetX + dx, y - offsetY + dy, 0, COLLISION_LAYER_2, 0)) Then checkJewles = True			
	
			'check for ball<-->music note collision
			If (CollideImage(imgBalloon, x - offsetX + dx, y - offsetY + dy, 0, COLLISION_LAYER_3, 0)) Then checkNotes = True
	
			'check for ball<-->instant death layer
			If (CollideImage(imgBalloon, x - offsetX + dx, y - offsetY + dy, 0, COLLISION_LAYER_4, 0)) Then energyBar.energy = 0
	
			'check for ball<-->key
			If (CollideImage(imgBalloon, x - offsetX + dx, y - offsetY + dy, 0, COLLISION_LAYER_5, 0)) Then checkForKey = True
			
			'cehck for ball<-->door
			If (CollideImage(imgBalloon, x- offsetX + dx, y - offsetY + dy, 0, COLLISION_LAYER_6, 0)) Then checkForDoor = True
			
			'TODO: Clean up this code
			If (checkJewles Or checkNotes Or checkForKey Or checkForDoor)
				Local startX:Int = tileMap.GetOffsetX() / tileMap.tileSize
				Local startY:Int = tileMap.GetOffsetY() / tileMap.tileSize
				Local endX:Int = startX + (GraphicsWidth() / tileMap.tileSize)
				Local endY:Int = startY + (GraphicsHeight() / tileMap.tileSize)
				
				If (startX < 0) Then startX = 0
				If (startY < 0) Then startY = 0
				If (endX >= tileMap.mapSizeX) Then endX = tileMap.mapSizeX-1
				If (endY >= tileMap.mapSizeY) Then endY = tileMap.mapSizeY-1
				
				For Local x:Int = startX To endX
					For Local y:Int = startY To endY
						If checkJewles And tileMap.grid[x,y] = 0 And ImagesCollide(imgBalloon, Self.x-offsetX+dx, Self.y-offsetY+dy, 0, tileMap.tiles, x * tileMap.tileSize - tileMap.GetOffsetX(), y * tileMap.tileSize - tileMap.GetOffsetY(), 0)
							tileMap.SetTile(x,y, -1)
							scorebar.AddScore(200)
							scorebar.jewlesCount :- 1
							TSoundPlayer.GetInstance().PlaySFX(TSoundPlayer.SFX_COLLECT1) 
						End If
						
						If checkForDoor And tileMap.grid[x,y] >= 23 And tileMap.grid[x,y] <= 30 And ImagesCollide(imgBalloon, Self.x-offsetX+dx, Self.y-offsetY+dy, 0, tileMap.tiles, x * tileMap.tileSize - tileMap.GetOffsetX(), y * tileMap.tileSize - tileMap.GetOffsetY(), tileMap.grid[x,y])
							Local reqKey:Int = Floor((tileMap.grid[x,y] - 23) / 2.0)
							Local keyFoundInSlot:Int = -1
							For Local i:Int = 0 To NO_KEY_SLOTS-1
								If keySlot[i] = reqKey Then keyFoundInSlot = i ; Exit
							Next
							If keyFoundInSlot > -1 
								keySlot[keyFoundInSlot] = -1
								tileMap.grid[x,y] = -1	
								TSoundPlayer.GetInstance().PlaySFX(TSoundPlayer.SFX_OPENDOOR)		
							Else
								If (CollideImage(imgBalloon, Self.x - offsetX + dx, Self.y - offsetY, 0, COLLISION_LAYER_6, 0)) Then dx :* -1 ; TSoundPlayer.GetInstance().PlaySFX(TSoundPlayer.SFX_COLLIDE)
								If (CollideImage(imgBalloon, Self.x - offsetX, Self.y - offsetY + dy, 0, COLLISION_LAYER_6, 0)) Then dy :* -1 ; TSoundPlayer.GetInstance().PlaySFX(TSoundPlayer.SFX_COLLIDE)
							End If
						End If
						
						If checkForKey And tileMap.grid[x,y] >= 19 And tileMap.grid[x,y] <= 22 And ImagesCollide(imgBalloon, Self.x-offsetX+dx, Self.y-offsetY+dy, 0, tileMap.tiles, x * tileMap.tileSize - tileMap.GetOffsetX(), y * tileMap.tileSize - tileMap.GetOffsetY(), tileMap.grid[x,y])
							For Local i:Int = 0 To NO_KEY_SLOTS-1
								If keySlot[i] = -1			
									keySlot[i] = tileMap.grid[x,y] - 19
									tileMap.SetTile(x,y, -1)
									scorebar.AddScore(25)
									TSoundPlayer.GetInstance().PlaySFX(TSoundPlayer.SFX_COLLECT2)
									Exit
								End If
							Next						
						End If
						If checkNotes And tileMap.grid[x,y] = 1 And ImagesCollide(imgBalloon, Self.x-offsetX+dx, Self.y-offsetY+dy, 0, tileMap.tiles, x * tileMap.tileSize - tileMap.GetOffsetX(), y * tileMap.tileSize - tileMap.GetOffsetY(), 1)
							tileMap.SetTile(x,y, -1)
							scorebar.AddScore(200)						
							TSoundPlayer.GetInstance().PlaySFX(TSoundPlayer.SFX_COLLECT1)
						End If
					Next
				Next
			End If
		End If
	End Method

	Method CalcNewSpeed(particleList:TList, useOffset:Byte = False, factor:Double = 0.007)
		If state = STATE_GAME
			For Local p:TParticle = EachIn particleList
				Local ox:Double = offsetX
				Local oy:Double = offsetY
				If (useOffset)
					ox :- tileMap.GetOffsetX()
					oy :- tileMap.GetOffsetY()
				End If
				If (ImagesCollide(TEmitter.imgParticle, p.x + ox, p.y + oy, 0, imgBalloon, x, y, 0))
					Local factor:Float = p.GetHealth() * factor
					factor = Max(factor, 0)
	 				dx :+ p.dx * factor
					dy :+ p.dy * factor
					p.dx :* (1 - factor)
					p.dy :* (1 - factor)
				End If
			Next
		End If
	End Method
End Type
