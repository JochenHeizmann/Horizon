
SuperStrict

Import BRL.FileSystem
Import BRL.Max2D

Type TUtilImage
	Function LoadStrippedImage:TImage(fileName:String, frames:Int)
		If (FileType(filename) = 0) Then RuntimeError("File " + filename + " not found!")
		Local img:TImage = LoadImage(filename)
		Local w:Int = ImageWidth(img)
		Local h:Int = ImageHeight(img)
		img = LoadAnimImage(filename, w / frames, h, 0, frames)
		If (Not img) Then RuntimeError("Cannot load frames of file: " + filename)
		Return img
	End Function

	Function DrawRepeated(img:TImage, x:Int, y:Int, w:Int, h:Int, frame:Int = 0)
		If x < 0 Then w :+ x ; x = 0
		If y < 0 Then h :+ y ; y = 0
	
		Local oldViewportX:Int, oldViewportY:Int, oldViewportW:Int, oldViewportH:Int
		Local viewportX:Int, viewportY:Int, viewportW:Int, viewportH:Int
		GetViewport(oldViewportX, oldViewportY, oldViewportW, oldViewportH)
		If (x > oldViewportX) Then viewportX = x Else viewportX = oldViewportX
		If (y > oldViewportY) Then viewportY = y Else viewportY = oldViewportY
		If (oldViewportX + oldViewportW) > (viewportX + viewportW) Then viewportW = w Else viewportW = (viewportX + viewportW) - (oldViewportX + oldViewportW)
		If (h < oldViewportH) Then viewportH = h Else viewportH = oldViewportH

		Local difX:Int = (oldViewportX + oldViewportW) - (viewportX + viewportW)	
		Local x2:Int = viewportX + viewportW
		Local oldX2:Int = oldViewportX + oldViewportW
		If (difX < 0) Then viewportW :+ difX
		
		Local difY:Int = (oldViewportY + oldViewportH) - (viewportY + viewportH)	
		Local y2:Int = viewportY + viewportH
		Local oldY2:Int = oldViewportY + oldViewportH
		If (difY < 0) Then viewportH :+ difY	
		
		If x < 0 Then viewportW :+ x
		If x < 0 Then viewportH :+ y
		
		SetViewport(viewportX, viewportY, viewportW, viewportH)
		TileImage IMG, X, Y, frame
		SetViewport(oldViewportX, oldViewportY, oldViewportW, oldViewportH)
	End Function
End Type