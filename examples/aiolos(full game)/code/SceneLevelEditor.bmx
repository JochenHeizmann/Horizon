
SuperStrict

Import "../../../lib/Scene.bmx"
Import "../../../lib/TileMap.bmx"
Import "../../../lib/InputControllerMouse.bmx"
Import "EmitterEnemy.bmx"

Incbin "../data/img/tilemap.png"
Incbin "../data/levels.map"

Type TSceneLeveleditor Extends TScene
	Const NUM_LEVELS:Int = 6
	Const MAP_WIDTH:Int = 200
	Const MAP_HEIGHT:Int = 200
	
	Const SCROLL_SPEED:Int = 4
	Const SPEED_FACTOR:Int = 4
	
	Field level:Int
	Field tileMap:TTileMap[NUM_LEVELS], emitterLayer:Int[NUM_LEVELS, MAP_WIDTH, MAP_HEIGHT]
	Field time:Int[NUM_LEVELS]
	Field currentTile:Int = 0
	
	Field drawGrid:Byte = True
	Field showHelp:Byte = False
	
	Field emitterEnemies:TEmitterEnemy	
	
	Const LAYER_MAP:Int = 0
	Const LAYER_EMITTERS:Int = 1
	
	Field currentLayer:Int = LAYER_MAP
	
	Field selectTile:Byte = False
	Field newTile:Byte = False
	
	Method InitLevels()
		emitterEnemies = New TEmitterEnemy
		level = 0
		For Local i:Int = 0 To NUM_LEVELS - 1
			tileMap[i] = New TTileMap
			tileMap[i].LoadTileMap("data/img/tilemap.png", 50)
			tileMap[i].SetMapSize(MAP_WIDTH, MAP_HEIGHT)
			time[i] = 120
			For Local x:Int = 0 To MAP_WIDTH-1
				For Local y:Int = 0 To MAP_HEIGHT-1
					emitterLayer[i, x, y] = -1
				Next
			Next
		Next
		LoadLevels()
		InitLevel()
	End Method
	
	Method OnEnter()	
		SetClsColor(105,23,16)		
		HideMouse
		AutoMidHandle True
		InitLevels()
	End Method
	
	Method OnLeave()
	EndMethod
	
	Method SaveLevels()
		Local file:TStream = WriteStream("data/levels.map")
		If (file)
			For Local i:Int = 0 To NUM_LEVELS - 1
				tileMap[i].WriteMapDataToStream(file)			
				WriteInt(file, time[i])
				For Local x:Int = 0 To MAP_WIDTH-1
					For Local y:Int = 0 To MAP_HEIGHT-1
						WriteInt(file, emitterLayer[i, x, y])
					Next
				Next
			Next
			
			CloseStream(file)
		Else
			RuntimeError "Could not save data/levels.map!"
		End If
	End Method
	
	Method LoadLevels()
		Local file:TStream = ReadStream("data/levels.map")
		If (file)			
			For Local i:Int = 0 To NUM_LEVELS - 1
				DebugLog "readlevel " + i
				tileMap[i].ReadMapDataFromStream(file)			
				time[i] = ReadInt(file)
				For Local x:Int = 0 To MAP_WIDTH-1
					For Local y:Int = 0 To MAP_HEIGHT-1
						emitterLayer[i, x, y] = ReadInt(file)
					Next
				Next
			Next		
			CloseStream(file)
		Else
			RuntimeError "Could not save data/levels.map!"
		End If
	End Method

	Method ClearEmitterLayer()
	For Local x:Int = 0 To MAP_WIDTH-1
		For Local y:Int = 0 To MAP_HEIGHT-1
			emitterLayer[level, x, y] = -1
		Next
	Next
	End Method
	
	Method InitLevel()
		emitterEnemies = New TEmitterEnemy
		emitterEnemies.Init()
	End Method
	
	Method Update()
		If KeyHit(KEY_T) And currentLayer = LAYER_MAP Then selectTile = Not selectTile

		If selectTile
			UpdateSelectTile()
		Else
			UpdateMap()
		End If		
	End Method
	
	Method UpdateSelectTile()
		If MouseDown(1)
			selectTile = False
			Local x:Int = MouseX() / tileMap[level].GetTileSize()
			Local y:Int = MouseY() / tileMap[level].GetTileSize()
			Local cols:Int = GraphicsWidth() / tileMap[level].GetTileSize()
			Local newTileFrame:Int = (y * cols) + x
			If newTileFrame < tileMap[level].numTiles
				currentTile = newTileFrame
			End If
			newTile = True						
		End If
	End Method
	
	Method UpdateMap()
		Local x:Float = tileMap[level].GetOffsetX()
		Local y:Float = tileMap[level].GetOffsetY()
		
		Local scrollspeed:Int = SCROLL_SPEED
		If KeyDown(KEY_RSHIFT) Then scrollspeed :* SPEED_FACTOR
		
		If KeyDown(KEY_LEFT) Then x :- scrollspeed
		If KeyDown(KEY_RIGHT) Then x :+ scrollspeed
		If KeyDown(KEY_UP) Then y :- scrollspeed
		If KeyDown(KEY_DOWN) Then y :+ scrollspeed		
		
		If KeyHit(KEY_NUMMULTIPLY) Then level :+ 1 ; InitLevel()
		If KeyHit(KEY_NUMDIVIDE) Then level :- 1 ; InitLevel()
		
		If KeyHit(KEY_C) Then tileMap[level].MapClear() ; ClearEmitterLayer()
		
		If level < 0 Then level = 0
		If level > NUM_LEVELS - 1 Then level = NUM_LEVELS - 1
		
		tileMap[level].SetOffset(x,y)
		
		If KeyHit(KEY_NUMADD) Then currentTile :+ 1
		If KeyHit(KEY_NUMSUBTRACT) Then currentTile :- 1
		If currentTile < 0 Then currentTile = 0
		If currentTile > (tileMap[level].numTiles - 1) Then currentTile = tileMap[level].numTiles - 1
		
		If KeyHit(KEY_G) Then drawGrid = Not drawGrid
		If KeyHit(KEY_H) Then showHelp = Not showHelp
		
		If KeyDown(KEY_ESCAPE) Then SaveLevels() ; End
		
		If KeyDown(KEY_S) Then SaveLevels()
		If KeyDown(KEY_L) Then LoadLevels()
		
		If KeyDown(KEY_NUM1) Then currentLayer = LAYER_MAP
		If KeyDown(KEY_NUM2) Then currentLayer = LAYER_EMITTERS
		
		If newTile = False
			If currentLayer = LAYER_MAP
				If MouseDown(1) Then tileMap[level].SetTile(GetMouseGridPositionX(), GetMouseGridPositionY(), currentTile)
				If MouseDown(2) Then tileMap[level].SetTile(GetMouseGridPositionX(), GetMouseGridPositionY(), -1)		
			Else If currentLayer = LAYER_EMITTERS
				If MouseDown(1) Then emitterLayer[level, GetMouseGridPositionX(), GetMouseGridPositionY()] = currentTile
				If MouseDown(2) Then emitterLayer[level, GetMouseGridPositionX(), GetMouseGridPositionY()] = -1
			End If
		Else If Not MouseDown(1) And Not MouseDown(2)
			newTile = False
		End If
		
		time[level] :+ TInputControllerMouse.GetInstance().GetMouseWheel()
		If time[level] < 0 Then time[level] = 0
		If time[level] > 999 Then time[level] = 999
		
		
		Local startX:Int = tileMap[level].GetOffsetX() / tileMap[level].tileSize
		Local startY:Int = tileMap[level].GetOffsetY() / tileMap[level].tileSize
		Local endX:Int = startX + (GraphicsWidth() / tileMap[level].tileSize)
		Local endY:Int = startY + (GraphicsHeight() / tileMap[level].tileSize)
		
		If (startX < 0) Then startX = 0
		If (startY < 0) Then startY = 0
		If (endX >= tileMap[level].mapSizeX) Then endX = tileMap[level].mapSizeX-1
		If (endY >= tileMap[level].mapSizeY) Then endY = tileMap[level].mapSizeY-1
		
		For Local x:Int = startX To endX
			For Local y:Int = startY To endY
				Local tile:Int = emitterLayer[level, x,y]
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
					If tile > 7 Then currentTile = 7
				
					emitterEnemies.LaunchParticle(x * tileMap[level].tileSize + tileMap[level].tileSize / 2, y * tileMap[level].tileSize + tileMap[level].tileSize / 2, dx, dy)	
				End If
			Next
		Next
				
		emitterEnemies.Update()
		
	End Method

	Method Render()
		Cls		
		If selectTile
			RenderSelectTile()
		Else
			RenderMap()
		End If
	End Method

	Method RenderSelectTile()
		Local x:Int = 0
		Local y:Int = 0
		For Local i:Int = 0 To tileMap[level].numTiles-1
			DrawImage tileMap[level].tiles, x, y, i
			x :+ tileMap[level].GetTileSize()
			If x > GraphicsWidth() - tileMap[level].GetTileSize() Then x = 0 ; y :+ tileMap[level].GetTileSize()
		Next
		RenderGrid(False)
		RenderStats()
	End Method
	
	Method RenderMap()
		tileMap[level].Render()		
		
		emitterEnemies.Render(tileMap[level].GetOffsetX(), tileMap[level].GetOffsetY())
		SetColor(255,255,255)
		
		RenderGrid()
		RenderStats()
		RenderHelp()		
		
	End Method
	
	Method RenderHelp()
		If Not showHelp Then Return
		SetAlpha(0.95)
		SetColor(0,0,0)
		DrawRect 0,0,GraphicsWidth(), GraphicsHeight()
		SetAlpha(1)
		SetColor(255,255,255)
		Local strList:TList = CreateList()
		ListAddLast(strList, "Help")
		ListAddLast(strList, "")
		ListAddLast(strList, "---------- Keylist -----------------------------------")
		ListAddLast(strList, "CURSOR KEYS................Scroll trough map")
		ListAddLast(strList, "NUMPAD '+' / NUMPAD '-'....Change current tile")
		ListAddLast(strList, "G..........................Turn grid on/off")
		ListAddLast(strList, "S..........................Save all levels")
		ListAddLast(strList, "L..........................Load all levels")
		ListAddLast(strList, "C..........................Clear Level")
		ListAddLast(strList, "ESC........................Save levels and leave editor")
		ListAddLast(strList, "H..........................Toggle help on/off")
		ListAddLast(strList, "NUMPAD '/' NUMPAD '*' .....Previous / Next level")
		ListAddLast(strList, "T .........................Tileselector on/off (only in Tilemode)")
		ListAddLast(strList, "NUMPAD '1' / NUMPAD '2' ...Switch Tile- / Particlemode")
		ListAddLast(strList, "")
		ListAddLast(strList, "---------- Mouse -------------------------------------")
		ListAddLast(strList, "Left Button................Draw current tile")
		ListAddLast(strList, "Right Button...............Remove tile")
		ListAddLast(strList, "Mousewheel.................Change time")
		
		Local y:Int = 140
		For Local s:String = EachIn strList
			DrawText s, (GraphicsWidth() / 2) - 180, y
			y :+ 15
		Next
	End Method
	
	Method RenderGrid(useOffset:Byte = True)
		Local offX:Float = tileMap[level].GetOffsetX()
		Local offY:Float = tileMap[level].GetOffsetY()

		If (drawGrid)
			SetAlpha(0.5)
			Local x:Int = 0
			Local y:Int = 0			
			If useOffset = False Then tileMap[level].SetOffset(0,0)

			x :- tileMap[level].GetOffsetX() Mod tileMap[level].GetTileSize()
			y :- tileMap[level].GetOffsetY() Mod tileMap[level].GetTileSize()
			While (x < GraphicsWidth())
				DrawLine x,0,x,GraphicsHeight()
				x :+ tileMap[level].GetTileSize()
			Wend
			While (y < GraphicsHeight())
				DrawLine 0,y,GraphicsWidth(),y
				y :+ tileMap[level].GetTileSize()
			Wend			
		End If
		SetAlpha(0.1)
		DrawRect(GetMouseXPositionOnGrid(), GetMouseYPositionOnGrid(), tileMap[level].GetTileSize(), tileMap[level].GetTileSize())
		SetAlpha(1)
		If currentLayer = LAYER_MAP And Not selectTile
			DrawImage tileMap[level].tiles, GetMouseXPositionOnGrid(), GetMouseYPositionOnGrid(), currentTile
		Else If currentLayer = LAYER_EMITTERS And Not selectTile
			Local dx:Int = 0, dy:Int = -2
			
			If currentTile = 0 Then dx = -2 ; dy = 0
			If currentTile = 1 Then dx = 0; dy = -2
			If currentTile = 2 Then dx = 2; dy = 0
			If currentTile = 3 Then dx = 0; dy = 2
			If currentTile = 4 Then dx = -4 ; dy = 0
			If currentTile = 5 Then dx = 0; dy = -4
			If currentTile = 6 Then dx = 4; dy = 0
			If currentTile = 7 Then dx = 0; dy = 4
			If currentTile > 7 Then currentTile = 7
			
			emitterEnemies.LaunchParticle(tileMap[level].GetOffsetX() + GetMouseXPositionOnGrid() + tileMap[level].GetTileSize()/2, tileMap[level].GetOffsetY() + GetMouseYPositionOnGrid() + tileMap[level].GetTileSize()/2, dx, dy)
		End If

		SetColor 0,0,0
		DrawLine MouseX()-5, MouseY()-1, MouseX()+5, MouseY()-1
		DrawLine MouseX()-1, MouseY()-5, MouseX()-1, MouseY()+5
		SetColor 255,255,255
		DrawLine MouseX()-5, MouseY(), MouseX()+5, MouseY()
		DrawLine MouseX(), MouseY()-5, MouseX(), MouseY()+5

		If useOffset = False Then tileMap[level].SetOffset(offX,offY)

	End Method
	
	Method GetMouseXPositionOnGrid:Int()
		Return (Int(MouseX() + (tileMap[level].GetOffsetX() Mod tileMap[level].GetTileSize())) / tileMap[level].GetTileSize() * tileMap[level].GetTileSize()) - (tileMap[level].GetOffsetX() Mod tileMap[level].GetTileSize())	
	End Method
	
	Method GetMouseYPositionOnGrid:Int()
		Return Int(MouseY() + (tileMap[level].GetOffsetY() Mod tileMap[level].GetTileSize())) / tileMap[level].GetTileSize() * tileMap[level].GetTileSize() - (tileMap[level].GetOffsetY() Mod tileMap[level].GetTileSize())
	End Method
	
	Method GetMouseGridPositionX:Int()
		Return (tileMap[level].GetOffsetX() + MouseX()) / tileMap[level].GetTileSize()
	End Method

	Method GetMouseGridPositionY:Int()
		Return (tileMap[level].GetOffsetY() + MouseY()) / tileMap[level].GetTileSize()
	End Method
	
	Method RenderStats()
		SetAlpha(0.5)
		DrawText ("Level: " + (level + 1), GraphicsWidth() - 150, GraphicsHeight()-20)	
		DrawText ("Pos: " + Int(tileMap[level].GetOffsetX() / tileMap[level].GetTileSize()) + "," + Int(tileMap[level].GetOffsetY() / tileMap[level].GetTileSize()), GraphicsWidth() - 150, GraphicsHeight()-30)
		DrawText ("Mousepos: " + GetMouseGridPositionX() + "," + GetMouseGridPositionY(), GraphicsWidth() - 150, GraphicsHeight()-40)
	
		Local t:String = time[level]
		If time[level] <= 0 
			t = "OFF"
		Else
			Local minutes:Int = time[level] / 60
			Local seconds:Int = time[level] Mod 60
			If seconds >= 10
				t = minutes + ":" + seconds	
			Else 
				t = minutes + ":0" + seconds	
			End If
		End If
		
		DrawText ("Time: " + t, GraphicsWidth() - 150, GraphicsHeight()-50)	
		
		Local layerStr:String = "MAP"
		If currentLayer = LAYER_EMITTERS
			layerStr = "EMITTERS"
		End If
		DrawText (layerStr, GraphicsWidth() - 150, GraphicsHeight()-70)		
		
		SetAlpha(1)
	End Method
End Type
