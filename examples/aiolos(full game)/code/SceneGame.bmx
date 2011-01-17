
SuperStrict

Import BRL.System
Import BRL.PNGLoader
Import BRL.Max2D

Import "../../../lib/Scene.bmx"
Import "../../../lib/TileMap.bmx"
Import "../../../lib/BitmapFont.bmx"
Import "../../../lib/Application.bmx"
Import "../../../lib/GuiWidgetTextButton.bmx"

Import "EmitterEnemy.bmx"
Import "EmitterPointer.bmx"
Import "Balloon.bmx"
Import "EnergyBar.bmx"
Import "ScoreBar.bmx"
Import "SoundPlayer.bmx"

Incbin "../data/img/tilemap.png"
Incbin "../data/levels.map"
Incbin "../data/img/bg2.png"

Type TSceneGame Extends TScene
	Field pointer:TEmitterPointer
	Field balloon:TBalloon
	Field energyBar:TEnergyBar
	Field scorebar:TScoreBar
	
	Const NUM_LEVELS:Int = 6

	Field fontBig:TBitmapFont
	Field fontMedium:TBitmapFont
	
	Field level:Int
	Field tileMap:TTileMap
	Field emitterEnemies:TEmitterEnemy
	
	Field parallaxLayer:TImage
	
	Const LEVEL_SIZE_IN_BYTES:Int = ((200 * 200 * 4) + 4 + (200 * 200 * 4))
	Field emitterLayer:Int[200, 200]
		
	Const STATE_GET_READY:Int = 0
	Const STATE_GAME_RUNNING:Int = 1
	Const STATE_GAME_OVER:Int = 2
	Const STATE_LEVEL_COMPLETE:Int = 3
	Const STATE_TIME_OUT:Int = 4
	Const STATE_GAME_COMPLETE:Int = 5
	
	Field gameState:Int
	Field time:Int = 0, timeActive:Byte
	
	Const BTN_RETRY:Int = 0
	Const BTN_LEAVE:Int = 1
	Const BTN_OK:Int = 2
	Const BTN_NUM:Int = 3
	Field buttons:TGuiWidgetTextButton[BTN_NUM]
				
	Method InitLevel(lvl:Int)
		HideMouse()
		
		emitterEnemies = New TEmitterEnemy
		emitterEnemies.Init()
				
		gameState = STATE_GET_READY
		level = lvl
		energyBar.Reset()
		scorebar.points = scorebar.pointsLastLevel

		tileMap = New TTileMap
		tileMap.LoadTileMap("incbin::../data/img/tilemap.png", 50)
		tileMap.SetMapSize(200, 200)

		Local file:TStream = ReadStream("incbin::../data/levels.map")
		timeActive = True
		If (file)
			Local pos:Int = LEVEL_SIZE_IN_BYTES * lvl
			SeekStream(file, pos)
			tileMap.ReadMapDataFromStream(file)			
			time = ReadInt(file)
			If time = 0 Then timeActive = False
			time :* 60
			For Local x:Int = 0 To tileMap.mapSizeX-1
				For Local y:Int = 0 To tileMap.mapSizeY-1
					emitterLayer[x, y] = ReadInt(file)
				Next
			Next
			CloseStream(file)
		Else
			RuntimeError "Could not load data/levels.map!"
		End If
		tileMap.SetAllTilesToCollisionLayer(COLLISION_LAYER_1) 'background collisions
		tileMap.SetTileCollisionLayer(0, COLLISION_LAYER_2)	   'jewels collision
		tileMap.SetTileCollisionLayer(1, COLLISION_LAYER_3)	   'music collision
		tileMap.SetTileCollisionLayer(15, COLLISION_LAYER_4)   'instant death layer
		tileMap.SetTileCollisionLayer(16, COLLISION_LAYER_4)   'instant death layer
		tileMap.SetTileCollisionLayer(17, COLLISION_LAYER_4)   'instant death layer
		tileMap.SetTileCollisionLayer(18, COLLISION_LAYER_4)   'instant death layer
		tileMap.SetTileCollisionLayer(19, COLLISION_LAYER_5)   'collectable key
		tileMap.SetTileCollisionLayer(20, COLLISION_LAYER_5)   'collectable key
		tileMap.SetTileCollisionLayer(21, COLLISION_LAYER_5)   'collectable key
		tileMap.SetTileCollisionLayer(22, COLLISION_LAYER_5)   'collectable key
		tileMap.SetTileCollisionLayer(23, COLLISION_LAYER_6)   'door
		tileMap.SetTileCollisionLayer(24, COLLISION_LAYER_6)   'door
		tileMap.SetTileCollisionLayer(25, COLLISION_LAYER_6)   'door
		tileMap.SetTileCollisionLayer(26, COLLISION_LAYER_6)   'door
		tileMap.SetTileCollisionLayer(27, COLLISION_LAYER_6)   'door
		tileMap.SetTileCollisionLayer(28, COLLISION_LAYER_6)   'door
		tileMap.SetTileCollisionLayer(29, COLLISION_LAYER_6)   'door
		tileMap.SetTileCollisionLayer(30, COLLISION_LAYER_6)   'door
		
		scorebar.jewlesCount = tileMap.GetTileCount(0) 'jewles
		scorebar.jewlesCountStart = scorebar.jewlesCount  'music notes	

		TSoundPlayer.GetInstance().StopMusic()
		
		Local x:Int = 0, y:Int = 0
		Local tileSize:Int = tileMap.GetTileSize()
		tileMap.GetNextTileXY(31, x,y)		
		If (x > 0 And y > 0)
			balloon.x = x * tileSize + tileSize / 2
			balloon.y = y * tileSize + tileSize / 2
			tileMap.SetTile(x, y, -1)
		Else
			DebugLog "Startpoint not found in level " + level
		End If
		
		balloon.SetTileMap(tileMap)
		balloon.SetEnergyBar(energyBar)
		balloon.SetScoreBar(scorebar)
		balloon.Reset()
	
		TSoundPlayer.GetInstance().PlayMusic()
	End Method

	Method OnEnter()	
		fontBig = New TBitmapFont
		fontBig.Load("incbin::../data/fonts/font60")
		
		fontMedium = New TBitmapFont
		fontMedium.Load("incbin::../data/fonts/font36")
		
		SetClsColor(105,23,16)		
		HideMouse
		AutoMidHandle True
		pointer = New TEmitterPointer
		pointer.Init()
		
		balloon = New TBalloon
		energyBar = New TEnergyBar

		scorebar = New TScoreBar
		scorebar.SetBigFont(fontBig)
		scorebar.SetSmallFont(fontMedium)

		parallaxLayer = LoadImage("incbin::../data/img/bg2.png")		

		buttons[BTN_RETRY] = TGuiWidgetTextButton.Create("incbin::../data/img/button_small.png", GraphicsWidth() / 2 - 110, GraphicsHeight() / 2 + 80, 220)
		buttons[BTN_RETRY].SetText("Retry")
		buttons[BTN_RETRY].SetFont(fontMedium)

		buttons[BTN_LEAVE] = TGuiWidgetTextButton.Create("incbin::../data/img/button_small.png", GraphicsWidth() / 2 - 110, GraphicsHeight() / 2 + 150, 220)
		buttons[BTN_LEAVE].SetText("Leave")
		buttons[BTN_LEAVE].SetFont(fontMedium)

		buttons[BTN_OK] = TGuiWidgetTextButton.Create("incbin::../data/img/button_small.png", GraphicsWidth() / 2 - 110, GraphicsHeight() / 2 + 80, 220)
		buttons[BTN_OK].SetText("Okay")
		buttons[BTN_OK].SetFont(fontMedium)
				
		InitLevel(5)
	End Method	
	
	Method OnLeave()
		TSoundPlayer.GetInstance().StopMusic()
	EndMethod
	
	Method Update()
		Select gamestate
			Case STATE_GAME_RUNNING
				ResetCollisions()
				SetRotation(0)
				tileMap.UpdateCollisionLayer()
		
				balloon.CalcNewSpeed(pointer.particleList)
				balloon.CalcNewSpeed(emitterEnemies.particleList, True, 0.05)
				
				balloon.Update()
				pointer.SetEmitPoint(balloon.x - balloon.offsetX, balloon.y - balloon.offsetY)
				pointer.Update()
				
				'calculate scroll position
				Local x:Int = balloon.x - (GraphicsWidth() / 2)
				Local y:Int = balloon.y - (GraphicsHeight() / 2)
				tileMap.SetOffset(x, y)		
			
				If scorebar.jewlesCount <= 0 Then gamestate = STATE_LEVEL_COMPLETE
				If energyBar.energy <= 0 And balloon.IsAlive() Then balloon.Explode()
				If balloon.IsDead() Then gamestate = STATE_GAME_OVER
				If timeActive And Time <=0 Then gamestate = STATE_TIME_OUT
				
				If timeActive
					time :- 1
					scorebar.SetTime(time/60)
				Else
					scorebar.SetTime(-1)
				End If
								
				If time Mod 2 = 0
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
							Local tile:Int = emitterLayer[x,y]
							If (tile > -1)				
								Local dx:Int = 0, dy:Int = 0
								If tile = 0 Then dx = -2 ; dy = 0
								If tile = 1 Then dx = 0; dy = -2
								If tile = 2 Then dx = 2; dy = 0
								If tile = 3 Then dx = 0; dy = 2
								If tile = 4 Then dx = -4 ; dy = 0
								If tile = 5 Then dx = 0; dy = -4
								If tile = 6 Then dx = 4; dy = 0
								If tile = 7 Then dx = 0; dy = 4						
								emitterEnemies.LaunchParticle(x * tileMap.tileSize + tileMap.tileSize / 2, y * tileMap.tileSize + tileMap.tileSize / 2, dx, dy)	
							End If
						Next
					Next
				End If
								
				emitterEnemies.Update()
				
				If KeyDown(KEY_ESCAPE) Then gameState = STATE_GAME_OVER
				
			Case STATE_GET_READY
				buttons[BTN_OK].Update()
				If buttons[BTN_OK].IsClicked() Then gameState = STATE_GAME_RUNNING ; HideMouse()
				
			Case STATE_GAME_OVER								
				buttons[BTN_RETRY].Update()
				buttons[BTN_LEAVE].Update()
				If buttons[BTN_RETRY].IsClicked() Then InitLevel(level)
				If buttons[BTN_LEAVE].IsClicked() Then TApplication.GetInstance().SetNextScene("mainMenu")
			
			Case STATE_LEVEL_COMPLETE
				buttons[BTN_OK].Update()
				If buttons[BTN_OK].IsClicked() Then NextLevel()
				
			Case STATE_TIME_OUT
				buttons[BTN_RETRY].Update()
				buttons[BTN_LEAVE].Update()
				If buttons[BTN_RETRY].IsClicked() Then InitLevel(level)
				If buttons[BTN_LEAVE].IsClicked() Then TApplication.GetInstance().SetNextScene("mainMenu")
				
			Case STATE_GAME_COMPLETE
				buttons[BTN_OK].Update()
				If buttons[BTN_OK].IsClicked() Then TApplication.GetInstance().SetNextScene("mainMenu")			
		End Select
		
		
	End Method
	
	Method NextLevel()
		level :+ 1
		Local numLevels:Int = FileSize("incbin::../data/levels.map") / LEVEL_SIZE_IN_BYTES
		If level >= NUM_LEVELS
			gameState = STATE_GAME_COMPLETE
			Return
		Else
			InitLevel(level)
		End If
	End Method

	Method Render()
		Cls
		SetAlpha(0.5)
		SetRotation(0)
		TileImage(parallaxLayer, -tileMap.GetOffsetX() * 0.3, -tileMap.GetOffsetY() * 0.3)
		SetAlpha(1)
		tileMap.Render()
		balloon.SetOffset(tileMap.GetOffsetX(), tileMap.GetOffsetY())
		balloon.Render()		
		energyBar.Render()		
		scoreBar.Render()
		
		emitterEnemies.Render(tileMap.GetOffsetX(), tileMap.GetOffsetY())
		
		Select gamestate
			Case STATE_GAME_RUNNING
				pointer.Render()
				'default state
				
			Case STATE_GAME_OVER
				ShowMouse()				
				RenderTextScreen("YOU FAILED", "Try harder the next time...")
				buttons[BTN_RETRY].Render()
				buttons[BTN_LEAVE].Render()
				
			Case STATE_TIME_OUT
				ShowMouse()				
				RenderTextScreen("OUT OF TIME", "Start playing, stop wasting time...")
				buttons[BTN_RETRY].Render()
				buttons[BTN_LEAVE].Render()
			
			Case STATE_LEVEL_COMPLETE
				ShowMouse()				
				RenderTextScreen("LEVEL COMPLETE", "This was awesome!")				
				buttons[BTN_OK].Render()
				
			Case STATE_GAME_COMPLETE
				ShowMouse()				
				RenderTextScreen("GAME COMPLETE", "Congratulation! We hope you enjoyed this game.")				
				buttons[BTN_OK].Render()
				
			Case STATE_GET_READY
				ShowMouse()				
				RenderTextScreen("GET READY", "Collect all jewles to complete stage.")				
				buttons[BTN_OK].Render()
				

		End Select		
	End Method	
	
	Method RenderTextScreen(headline:String, subhead:String)
		SetAlpha(0.7)
		SetRotation(0)
		SetColor(0,0,0)
		DrawRect 0,0,GraphicsWidth(), GraphicsHeight()
		SetAlpha(1)
		SetColor(255,255,255)

		fontBig.Draw(headline, GraphicsWidth() / 2, GraphicsHeight() / 2 - 30, True)
		fontMedium.Draw(subhead, GraphicsWidth() / 2, GraphicsHeight() / 2 + 30, True)
	End Method
End Type
