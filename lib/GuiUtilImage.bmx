SuperStrict

Import BRL.FileSystem
Import BRL.Max2D
Import "GuiSystem.bmx"

Type TGuiUtilImage
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
		
		Local viewportX:Int, viewportY:Int, viewportW:Int, viewportH:Int

		If (x > TGuiVP.vpX) Then viewportX = x Else viewportX = TGuiVP.vpX
		If (y > TGuiVP.vpY) Then viewportY = y Else viewportY = TGuiVP.vpY
		If (TGuiVP.vpX + TGuiVP.vpW) > (viewportX + viewportW) Then viewportW = w Else viewportW = (viewportX + viewportW) - (TGuiVP.vpX + TGuiVP.vpW)
		If (h < TGuiVP.vpH) Then viewportH = h Else viewportH = TGuiVP.vpH

		Local difX:Int = (TGuiVP.vpX + TGuiVP.vpW) - (viewportX + viewportW)	
		Local x2:Int = viewportX + viewportW
		Local oldX2:Int = TGuiVP.vpX + TGuiVP.vpW
		If (difX < 0) Then viewportW :+ difX
		
		Local difY:Int = (TGuiVP.vpY + TGuiVP.vpH) - (viewportY + viewportH)	
		Local y2:Int = viewportY + viewportH
		Local oldY2:Int = TGuiVP.vpY + TGuiVP.vpH
		If (difY < 0) Then viewportH :+ difY	
		
		If x < 0 Then viewportW :+ x
		If x < 0 Then viewportH :+ y
		
		TGuiVP.Add(viewportX, viewportY, viewportW, viewportH)
		TileImage IMG, X, Y, frame
		TGuiVP.Pop()
	End Function
End Type
