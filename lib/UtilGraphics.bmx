
SuperStrict

Type TUtilGraphics
	Rem
	bbdoc: Set Virtual drawing viewport
	about:
	The current ViewPort defines an area within the back buffer that all drawing is clipped to. Any
	regions of a DrawCommand that fall outside the current Virtual ViewPort are not drawn.
	End Rem
	Function SetVirtualViewport(X:Int, Y:Int, Width:Int, Height:Int)
		Local xx:Float = GraphicsWidth() / VirtualResolutionWidth()
		Local yy:Float = GraphicsHeight() / VirtualResolutionHeight()
		X = Floor(xx * X)
		Y = Floor(yy * Y)
		w = Floor(xx * w)
		h = Floor(yy * h)
		SetOrigin X / xx, Y / yy
		SetViewport X, Y, w + 2, h + 2
	End Function
End Type