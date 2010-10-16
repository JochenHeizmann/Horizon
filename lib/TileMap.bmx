
SuperStrict

Import BRL.Max2D

Type TTileMap
	Field tiles:TImage
	Field grid:Int[,]
	Field tileSize:Int = 0
	Field mapSizeX:Int = 0, mapSizeY:Int = 0
	Field offsetX:Int = 0, offsetY:Int = 0
	Field factorHoriz:Float = 1, factorVert:Float = 1
	Field numTiles:Int = 0
	Field tileCollisionLayer:Int[]
	
	Method LoadTileMap(file:String, tileSize:Int)
		Local tmpImg:TImage = LoadImage(file)
		numTiles = (ImageWidth(tmpImg) / tileSize) * (ImageHeight(tmpImg) / tileSize)
		tmpImg = Null
		AutoMidHandle False
		tiles = LoadAnimImage(file, tileSize, tileSize, 0, numTiles)
		Self.tileSize = tileSize
		tileCollisionLayer = New Int[tileSize]
	End Method
	
	Method WriteMapDataToStream(str:TStream)
		For Local x:Int = 0 To mapSizeX-1
			For Local y:Int = 0 To mapSizeX-1
				WriteInt(str, grid[x,y])
			Next
		Next
	End Method
	
	Method ReadMapDataFromStream(str:TStream)
		For Local x:Int = 0 To mapSizeX-1
			For Local y:Int = 0 To mapSizeX-1
				grid[x,y] = ReadInt(str)
			Next
		Next	
	End Method
	
	Method GetTileSize:Int()
		Return tileSIze
	End Method
	
	Method SetOffsetFactor(horiz:Float, vert:Float)
		factorHoriz = horiz
		factorVert = vert
	End Method
	
	Method GetTileCount:Int(tileId:Int)
		Local count:Int = 0
		For Local x:Int = 0 To mapSizeX-1
			For Local y:Int = 0 To mapSizeX-1
				If (grid[x,y] = tileId) Then count :+ 1
			Next
		Next		
		Return count
	End Method
	
	Method SetTileMap(img:TImage)
		tiles = img
		Self.tileSize = ImageWidth(tiles)
	End Method
	
	Method SetMapSize(sizeX:Int, sizeY:Int)
		grid = New Int[sizeX, sizeY]
		mapSizeX = sizeX
		mapSizeY = sizeY
		MapClear()
	End Method
	
	Method MapClear()
		For Local x:Int = 0 To (mapSizeX-1)
			For Local y:Int = 0 To (mapSizeY-1)
				grid[x,y] = -1
			Next
		Next
	End Method
	
	Method SetTile(posX:Int, posY:Int, tile:Int)
		grid[posX, posY] = tile
	End Method
	
	Method GetTile:Int(posX:Int, posY:Int)
		Return grid[posX, posY]
	End Method
	
	Method GetMapWidthInPixel:Int()
		Return (mapSizeX * tileSize)
	End Method
	
	Method GetMapHeightInPixel:Int()
		Return (mapSizeY * tileSize)
	End Method
	
	Method SetOffset(x:Int, y:Int)
		Local w:Int = GetMapWidthInPixel() - GraphicsWidth()
		Local h:Int = GetMapHeightInPixel() - GraphicsHeight()
'		If (x < 0) Then x = 0
'		If (y < 0) Then y = 0
'		If (x > w) Then x = w
'		If (y > h) Then y = h
		offsetX = x
		offsetY = y
	End Method

	Method GetOffsetX:Float()
		Return offsetX * factorHoriz
	End Method
	
	Method GetOffsetY:Float()
		Return offsetY * factorVert
	End Method
	
	Method GetNextTileXY(tileId:Int,rX:Int Var,rY:Int Var)
		For Local x:Int = rX To (mapSizeX-1)
			For Local y:Int = rY To (mapSizeY-1)
				If grid[x,y] = tileId
					rX = x
					rY = y
					Return
				End If
			Next
		Next	
		rX = -1
		rY = -1	
	End Method
	
	Method Render()
		Local startX:Int = GetOffsetX() / tileSize
		Local startY:Int = GetOffsetY() / tileSize
		Local endX:Int = startX + (GraphicsWidth() / tileSize) + 1
		Local endY:Int = startY + (GraphicsHeight() / tileSize) + 1
		
		If (startX < 0) Then startX = 0
		If (startY < 0) Then startY = 0
		If (endX >= mapSizeX) Then endX = mapSizeX-1
		If (endY >= mapSizeY) Then endY = mapSizeY-1
		
		For Local x:Int = startX To endX
			For Local y:Int = startY To endY
				If (grid[x,y] > -1)
					Local tx:Int = x * tileSize - GetOffsetX(), ty:Int = y * tileSize - GetOffsetY()
					DrawImage(tiles, tx, ty, grid[x, y])
					' DrawText(grid[x,y], tx, ty)
				End If
			Next
		Next
	End Method		
	
	'TODO: Remove copied code from Render()
	Method UpdateCollisionLayer()
		Local startX:Int = GetOffsetX() / tileSize
		Local startY:Int = GetOffsetY() / tileSize
		Local endX:Int = startX + (GraphicsWidth() / tileSize)
		Local endY:Int = startY + (GraphicsHeight() / tileSize)
		
		If (startX < 0) Then startX = 0
		If (startY < 0) Then startY = 0
		If (endX >= mapSizeX) Then endX = mapSizeX-1
		If (endY >= mapSizeY) Then endY = mapSizeY-1
		
		For Local x:Int = startX To endX
			For Local y:Int = startY To endY
				If (grid[x,y] > -1)
					CollideImage(tiles, x * tileSize - GetOffsetX(), y * tileSize - GetOffsetY(), grid[x,y], 0, tileCollisionLayer[grid[x,y]])
				End If
			Next
		Next
	End Method
	
	Method SetAllTilesToCollisionLayer(collisionLayer:Int)
		For Local i:Int = 0 To numTiles - 1
			tileCollisionLayer[i] = collisionLayer
		Next
	End Method
	
	Method SetTileCollisionLayer(numTile:Int, collisionLayer:Int)
		tileCollisionLayer[numTile] = collisionLayer
	End Method
End Type
