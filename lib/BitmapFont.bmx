SuperStrict

Rem

This code is based / is from the great blitz module chaos.bmpfont, Version: 1.13


Author: d-bug / YellowRider
License: Public Domain
Contact: d-bug@chaos-interactive.de
Homepage: www.chaos-interactive.de
End Rem


Import brl.max2d
Import brl.pngloader
Import brl.standardio
Import brl.endianstream

'-- KONSTANTEN -------------------------------------------------------------------------------------------------------------
Const STATICFONT:Int	= 1
Const BITMAPFONT:Int 	= 1024
Const SUCOFONT:Int		= 2048
Const CANDYFONT:Int	= 4096

AddFontLoader New TChaosFontLoader

Type TBitmapFont
	Function Load:TImageFont (url:Object, style:Int = SMOOTHFONT, charspacing:Int = 0)
		TChaosFontLoader.CharList = String(url)[0..String(url).FindLast(".")]+".suc"
		If ValidatePath(TChaosFontLoader.CharList) = "failed" 
			TChaosFont.Error("File "+TChaosFontLoader.CharList+" Not found...")
			Return Null
		EndIf
		If style & SMOOTHFONT
			TChaosFontLoader.ImageFlags = FILTEREDIMAGE|MIPMAPPEDIMAGE|MASKEDIMAGE
		Else
			TChaosFontLoader.ImageFlags = MASKEDIMAGE
		EndIf
		TChaosFontLoader.Flags = SUCOFONT
		TChaosFontLoader.charspacing = charspacing
		Return TImageFont.Load(url,0,style)
	EndFunction

	Function LoadBitmapFont:TImageFont (url:Object, tilewidth:Int, tileheight:Int, spacesize:Int, charlist:String ,charspacing:Int = 2,flags:Int = 0)
		TChaosFontLoader.CharList = charlist
		TChaosFontLoader.SpaceSize = spacesize
		TChaosFontLoader.TileHeight = tileheight
		TChaosFontLoader.ImageFlags = MASKEDIMAGE|FILTEREDIMAGE|MIPMAPPEDIMAGE
		TChaosFontLoader.Flags = flags
		TChaosFontLoader.Flags:|BITMAPFONT
		TChaosFontLoader.charspacing = charspacing
		Return TImageFont.Load(url,tilewidth,SMOOTHFONT)
	EndFunction

	Function LoadCandy:TImageFont (url:Object, style:Int = SMOOTHFONT, charspacing:Int = 0)
		TChaosFontLoader.CharList = String(url)[0..String(url).FindLast(".")]+".dat"
		If ValidatePath(TChaosFontLoader.CharList) = "failed" 
			TChaosFont.Error("File "+TChaosFontLoader.CharList+" Not found...")
			Return Null
		EndIf
		If style & SMOOTHFONT
			TChaosFontLoader.ImageFlags = FILTEREDIMAGE|MIPMAPPEDIMAGE|MASKEDIMAGE
		Else
			TChaosFontLoader.ImageFlags = MASKEDIMAGE
		EndIf
		TChaosFontLoader.Flags = CANDYFONT
		TChaosFontLoader.charspacing = charspacing
		Return TImageFont.Load(url,0,style)
	EndFunction
End Type

'-- INTERNE FUNKTIONEN ---------------------------------------------------------------------------------------------------
Private

Function ValidatePath:String (url:String)
	url = url.ToLower()
	If url.Find("incbin::") = -1
		FixPath(url)
		If FileType(url) Then Return url
	Else
		Return url
	EndIf
	Return "failed"
EndFunction

Function StripSuffix:String (url:String)
	If url.FindLast(".") <> -1 Return url[url.FindLast(".")..]
	Return "failed"
EndFunction
	
Type TChaosFontGlyph Extends BRL.Font.TGlyph
	Field G_Pixmap:TPixmap
	Field G_Advance:Float
	Field G_X:Int
	Field G_Y:Int
	Field G_Width:Int
	Field G_Height:Int

	Method Pixels:TPixmap ()
		Return Self.G_Pixmap
	EndMethod

	Method Advance:Float ()
		Return Self.G_Advance
	EndMethod

	Method GetRect (x:Int Var, y:Int Var, width:Int Var, height:Int Var)
		x		= Self.G_X
		y		= Self.G_Y
		width	= Self.G_Width
		height	= Self.G_Height
	EndMethod	
EndType

Type TChaosFont Extends BRL.Font.TFont
	Field NullGlyph:TChaosFontGlyph = New TChaosFontGlyph
	Field Glyphs:TChaosFontGlyph[]
	Field FontHeight:Int
	Field ImageFlags:Int
	Field Flags:Int

	Method Style:Int ()
		If Self.Flags & SUCOFONT Return SUCOFONT
		If Self.Flags & CANDYFONT Return CANDYFONT
		If Self.Flags & STATICFONT Return STATICFONT|BITMAPFONT
		Return BITMAPFONT
	EndMethod

	Method Height:Int ()
		Return Self.FontHeight
	EndMethod

	Method CountGlyphs:Int ()
		Return Self.Glyphs.Length
	EndMethod

	Method CharToGlyph:Int (char:Int)
		If char > 31 And char < 255 Return char-32
		Return -1
	EndMethod

	Method LoadGlyph:TGlyph (index:Int)
		If Self.Glyphs[Index] Return Self.Glyphs[Index]
		Return Self.NullGlyph
	EndMethod

	'Spezieller Loader für BMP und PNG Fonts
	'url			= Pfad zum Image
	'tilesize		= Größer der Tiles (16x16, 32x32 usw.)
	'spacesize	= Größe eines Leerzeichens
	'charlist		= Alle Zeichen des Fonts in Reihenfolge der Tiles
	'flags		= Siehe BRL.LoadImage
	'static		= Zeichenabmaße statisch (Breite und Höhe werden als tilesize gesetzt)
	Function Load:TChaosFont (url:String, tilewidth:Int, tileheight:Int, spacesize:Int, charlist:String, charspacing:Int, imageflags:Int, flags:Int) 
		If ValidatePath(url) = "failed" 
			TChaosFont.Error("File "+url+" Not found...")
			Return Null
		EndIf
		Local font:TChaosFont = New TChaosFont
		font.Glyphs = New TChaosFontGlyph[255]
		font.Imageflags = imageflags
		font.Flags = flags
		If font.Flags & BITMAPFONT
			font = TChaosFont.AutoSizedFontLoader (font, url, tilewidth, tileheight, spacesize, charlist, charspacing)
		ElseIf font.Flags = SUCOFONT
			font = TChaosFont.SucoFontLoader (font, url, charlist, charspacing)
		ElseIf font.Flags = CANDYFONT
			font = TChaosFont.FontCandyLoader (font, url, charlist, charspacing)
		EndIf
		Return font
	EndFunction

	'Fontloader für FontCandy
	Function FontCandyLoader:TChaosFont (font:TChaosFont, url:String, charlist:String, charspacing:Int)
		Local stream:TStream = ReadFile(charlist)
		If Not stream Return Null

		'--------------------------------- BugFix 1.12
		?MacOSPPC
				stream = LittleEndianStream (stream)
		?
		'-------------------------------------------

		stream.ReadInt()
		stream.ReadInt()
		Local mask_R:Int = stream.ReadInt()
		Local mask_G:Int = stream.ReadInt()
		Local mask_B:Int = stream.ReadInt()
		Local max_index:Int = stream.ReadInt() 
		font.Fontheight = Stream.ReadInt()
		TChaosFont.CreateSpace (font, Stream.ReadInt())
		stream.ReadInt()
		Local Image:TImage = TImage.Load (url,font.imageflags,mask_R,mask_G,mask_B)
		For Local index:Int = 0 To max_index
			Local ascii:Int = Stream.ReadInt()
			Local glyph_x:Int = Stream.ReadInt()
			Local glyph_y:Int = Stream.ReadInt()
			Local glyph_width:Int = Stream.ReadInt()
			If (ascii > 31) And (ascii < 255)
				font.Glyphs[ascii - 32] = New TChaosFontGlyph
				font.Glyphs[ascii - 32].G_Pixmap = image.pixmaps[0].Window(glyph_x,glyph_y,glyph_width,font.Fontheight).Copy()
				font.Glyphs[ascii - 32].G_Width = glyph_width
				font.Glyphs[ascii - 32].G_Height = font.Fontheight
				font.Glyphs[ascii - 32].G_Advance = glyph_width + charspacing
			EndIf
			Next
		stream.close()
		Return font
	EndFunction

	'Fontloader für Suco-X' Fontextractor Files (*.suc)
	Function SucoFontLoader:TChaosFont (font:TChaosFont, url:String, charlist:String, charspacing:Int)
		Local stream:TStream = ReadFile(charlist)
		If Not stream Return Null

		'--------------------------------- BugFix 1.12
		?MacOSPPC
 				stream = LittleEndianStream (stream)
		?
		'-------------------------------------------

		Local CellCount:Int = Stream.ReadInt()
		Local CellSize:Int = Stream.ReadInt()
		font.Fontheight = Stream.ReadInt()
		TChaosFont.CreateSpace (font, Stream.ReadInt())
		Local Image:TImage = .LoadAnimImage (url,CellSize,CellSize,0,CellCount,font.imageflags)
		Local i:Int
		While Not Stream.Eof()
			Local ascii:Int = Stream.ReadInt()
			Local txtw:Int = Stream.ReadInt()
			Local txth:Int = Stream.ReadInt()
			Local offx:Int = Stream.ReadFloat()
			Local offy:Int = Stream.ReadFloat()
			Local advance:Float = Stream.ReadFloat()
			If (ascii > 31) And (ascii < 255)
				font.Glyphs[ascii - 32] = New TChaosFontGlyph			
				font.Glyphs[ascii - 32].G_Pixmap = image.pixmaps[i].Copy()
				font.Glyphs[ascii - 32].G_Width = txtw
				font.Glyphs[ascii - 32].G_Height = txth
				font.Glyphs[ascii - 32].G_X = -offx
				font.Glyphs[ascii - 32].G_Y = -offy
				font.Glyphs[ascii - 32].G_Advance = advance + charspacing
				i :+ 1
			EndIf
		Wend
		stream.close()
		Return font
	EndFunction

	'Standard Loader
	Function AutoSizedFontLoader:TChaosFont (font:TChaosFont, url:String, tilewidth:Int, tileheight:Int, spacesize:Int, charlist:String, charspacing:Int)
		Local image:TImage = .LoadAnimImage (url,tilewidth,tileheight,0,charlist.length,font.imageflags)
		TChaosFont.CreateSpace (font, spacesize)
		For Local i:Int = 0 Until charlist.length
			Local ascii:Int = Asc(charlist[i..i+1])
			If (ascii > 31) And (ascii < 255)
				'Local index:Int = ascii - 32
				font.Glyphs[ascii - 32] = New TChaosFontGlyph
				font.Glyphs[ascii - 32].G_Pixmap = image.pixmaps[i].Copy()
				Local x:Int, y:Int
				Local StartX:Int, EndX:Int
				Local StartY:Int, EndY:Int
				If font.flags & STATICFONT
					font.Glyphs[ascii - 32].G_Width = tilewidth
					font.Glyphs[ascii - 32].G_Height = tileheight
					font.Glyphs[ascii - 32].G_X = 0
					font.Glyphs[ascii - 32].G_Y = -tileheight
					font.Glyphs[ascii - 32].G_Advance = tilewidth
					font.FontHeight = tileheight
				Else
					For y = 0 Until tileheight
						For x = 0 Until tilewidth
							If ((font.Glyphs[ascii - 32].G_Pixmap.ReadPixel(x,y) Shr 24) & $FF) > $00
								If StartX = 0 Or StartX < x StartX = x
								EndIf
								If ((font.Glyphs[ascii - 32].G_Pixmap.ReadPixel(tilewidth - x - 1,y) Shr 24) & $FF) > $00
									If EndX = 0 Or EndX > (tilewidth - x - 1) EndX = (tilewidth - x - 1)
									EndIf
						Next
					Next
					font.Glyphs[ascii - 32].G_Width = StartX - EndX
					font.Glyphs[ascii - 32].G_Height = tileheight
					font.Glyphs[ascii - 32].G_X = -EndX
					font.Glyphs[ascii - 32].G_Y = -tileheight
					font.Glyphs[ascii - 32].G_Advance = font.Glyphs[ascii - 32].G_Width + charspacing 
				EndIf
			EndIf
		Next
		font.FontHeight = tileheight
		image = Null
		Return font
	EndFunction


	'Leerzeichen erstellen und in das Glypharray eintragen
	Function CreateSpace (font:TChaosFont, spacesize:Int)
		font.Glyphs[0] = New TChaosFontGlyph
		font.Glyphs[0].G_Advance = spacesize
		font.Glyphs[0].G_X = 0
		font.Glyphs[0].G_Y = 0
		font.Glyphs[0].G_Width = spacesize
		font.Glyphs[0].G_Height = 1
		font.Glyphs[0].G_Pixmap = TPixmap.Create (font.Glyphs[0].G_Width,font.Glyphs[0].G_Height,PF_RGBA8888)
		For Local sx:Int = 0 To spacesize
			Local p:Byte Ptr = font.Glyphs[0].G_Pixmap.PixelPtr(sx,0)
			p[3] = $00
		Next
	EndFunction

	Function Error (Message:String)
		Message = "ChaosFont @ "+MilliSecs()+" > ERROR: "+Message
		?Debug
			DebugLog Message
			Return
		?
		Notify Message
		Return
	EndFunction
EndType

'-----------------------------------------------------------------------------------------------------------------------------
'Neuen Fontloader im System etablieren, der BMP, JPG, TGA und PNG Dateien umleitet.
'Alle weiteren Fonts werden weiterhin mit dem FreeTypeFontLoader geladen.
Type TChaosFontLoader Extends TFontLoader
	Global CharList:String
	Global charspacing:Int
	Global SpaceSize:Int
	Global ImageFlags:Int
	Global Flags:Int
	Global TileHeight:Int

	Method LoadFont:TChaosFont (url:Object, size:Int, style:Int = SMOOTHFONT)
		Local src:String = String(url)
		If src
			Select StripSuffix(src)
				Case ".png",".bmp",".tga",".jpg" ; Return TChaosFont.Load(src,size,TChaosFontLoader.TileHeight,TChaosFontLoader.SpaceSize,TChaosFontLoader.CharList,TChaosFontLoader.charspacing,TChaosFontLoader.ImageFlags,TChaosFontLoader.Flags)
			End Select
		EndIf
	EndMethod
EndType