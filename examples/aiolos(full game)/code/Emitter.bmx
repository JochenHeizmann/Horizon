
SuperStrict

Import BRL.Max2D
Import BRL.PNGLoader
Import BRL.Random

Import "Particle.bmx"

Incbin "../data/img/particle.png"

Type TEmitter
	Global imgParticle:TImage
	
	Const particleVariation:Float = .7

	Field particleList:TList
	
	Field startR:Int, startG:Int, startB:Int
	
	Field offsetX:Double, offsetY:Double
	
	Method New()
		SetBlend ALPHABLEND
		AutoMidHandle True
		offsetX = 0
		offsetY = 0
		imgParticle = LoadImage("incbin::../data/img/particle.png") 
		particleList = CreateList()
	End Method
	
	Method Init()
		SetStartColor(255,255,255)
	End Method
	
	Method SetStartColor(r:Int, g:Int, b:Int)
		startR = r
		startG = g
		startB = b
	End Method
		
	Method LaunchParticle(x:Double, y:Double, dx:Double, dy:Double, lifetime:Int = 100)
		Local p:TParticle = New TParticle
		dx :+ Rnd(-particleVariation, particleVariation)
		dy :+ Rnd(-particleVariation, particleVariation)
		p.Init(x, y, dx, dy, lifetime)
		ListAddLast(particleList, p)
	End Method
	
	Method Update()	
		For Local p:TParticle = EachIn particleList
			p.Update()
		Next
	End Method
	
	Method Render(ox:Double = 0, oy:Double = 0)
		SetRotation(0)
		SetColor(startR, startG, startB)
		For Local p:TParticle = EachIn particleList
			p.Render(imgParticle, ox, oy)
			If (p.destroy = True) Then ListRemove(particleList, p)
		Next
	End Method	
End Type
