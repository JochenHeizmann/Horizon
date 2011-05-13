
SuperStrict

Import BRL.GLMax2D
Import BRL.Graphics

Import "Scene.bmx"
Import "Fader.bmx"
Import "InputControllerMouse.bmx"
Import "SystemDesktop.bmx"

Type TApplication
	Const VSYNC_OFF:Int = 0
	Const VSYNC_ON:Int = 1

	Const SCENE_ENTERING:Int = 0
	Const SCENE_ACTIVE:Int = 1
	Const SCENE_LEAVING:Int = 2
	
	Const MAX_FRAMESKIP:Int = 10

	Global application:TApplication
	Global gfx:TGraphics
	Global skipTicks:Float
	
	Field scenes:TList, currentScene:TScene, nextScene:TScene
	Field faders:TList
		
	Field vSync:Int
	Field state:Int
	
	Field width:Int
	Field height:Int
	Field depth:Int
	Field hertz:Int
	Field flags:Int
	
	?Debug
		Field debugMessages:TList
	?
	
	Field exitApp:Byte
	
	' Public static methods
	
	Function GetInstance:TApplication()
		If Not Self.application
			Self.application = New Self
		End If
		Return Self.application
	End Function
	
	Function InitGraphics(width:Int, Height:Int, depth:Int = 0, hertz:Int = 0, Flags:Int = 0)
		?Win32
			SetGraphicsDriver D3D7Max2DDriver()
'			SetGraphicsDriver D3D9Max2DDriver()
		?
		?Not Win32
			SetGraphicsDriver GLMax2DDriver()
		?
			
		If (depth = 0)
			gfx = Graphics(width, Height, depth, hertz, Flags)
		Else
			gfx = Graphics(TSystemDesktop.GetWidth(), TSystemDesktop.GetHeight(), TSystemDesktop.GetDepth(), hertz, flags)
			SetVirtualResolution(width, height)
			SetViewport(0,0,GraphicsWidth(), GraphicsHeight())
		End If
		
		Print gfx.Driver().toString()
		
		If (Not gfx)
			RuntimeError "No working GFX Driver found!"
		End If
		
		SetBlend(ALPHABLEND)
		
		GetInstance().width = width
		GetInstance().height = height
		GetInstance().depth = depth
		GetInstance().hertz = hertz
		GetInstance().flags = flags
	End Function
	
	Method ToggleFullscreen()
		Local vw:Float = VirtualResolutionWidth()
		Local vh:Float = VirtualResolutionHeight()
		EndGraphics()
		GCCollect()
		If (depth = 0)
			depth = 32
		Else
			depth = 0
		End If
		If (depth = 0)
			gfx = Graphics(vw, vh, 0, hertz, Flags)
		Else
			gfx = Graphics(TSystemDesktop.GetWidth(), TSystemDesktop.GetHeight(), depth, hertz, Flags)
			SetVirtualResolution(vw,vh)
			SetViewport(0,0,GraphicsWidth(), GraphicsHeight())
		End If
		SetBlend(ALPHABLEND)
	End Method
	
	Method NavigateToURL(url:String)
		If (depth <> 0)
			ToggleFullscreen()
		End If
		OpenURL(url)
	End Method
	
	Function SetName(name:String)
		AppTitle = name
	End Function

	' Constructor / Destructor

	Method New()
		If (Not gfx) Then RuntimeError("Graphicmode not initialized")
		SetState(SCENE_ENTERING)
		SetVSync(VSYNC_ON)
		scenes = CreateList()
		faders = CreateList()
		exitApp = False
		?Debug
			debugMessages = CreateList()
		?
	End Method
	
	Method Delete()
		gfx = Null
	End Method
	
	' Methods
	
	Method SetVSync(vSync:Int)
		Self.vSync = vSync
	End Method
	
	Method AddFader(fader:TFader)
		ListAddLast(faders, fader)
	End Method
	
	Method RemoveAllFaders()
		ClearList(faders)
	End Method

	Method AddScene(scene:TScene, name:String = "")
		If (CountList(scenes) = 0) Then currentScene = scene
		If (name <> "") Then scene.name = name
		If (name = "" And scene.name = "") Then RuntimeError("Scene name not set!")
		ListAddLast(scenes, scene)
	End Method
	
	Method Render()
		If (currentScene) Then currentScene.Render()
		If (state <> SCENE_ACTIVE)
			For Local fader:TFader = EachIn faders
				fader.Render()
			Next
		End If
	End Method

	Method Update()
		?Debug
			ClearList(debugMessages)
		?
		TInputControllerMouse.GetInstance().Refresh()
		currentScene.Update()
		If (state <> SCENE_ACTIVE)
			Local changeState:Byte = True
			For Local fader:TFader = EachIn faders
				If (fader.IsFading())
					changeState = False
				End If
				fader.Update()
			Next
			If (changeState)
				If (state = SCENE_ENTERING) 
					SetState(SCENE_ACTIVE)
				Else If (state = SCENE_LEAVING)
					SetState(SCENE_ENTERING)					
					currentScene.OnLeave()
					currentScene = nextScene					
					If (Not currentScene)
						exitApp = True
					Else					
						currentScene.OnEnter()
						For Local fader:TFader = EachIn faders
							fader.FadeIn()
						Next
					End If
				End If				
			End If
		End If
	End Method
	
	Method SetNextScene(nextScene:String)
		If (Self.nextScene And nextScene = Self.nextScene.name) Then Return
		For Local scene:TScene = EachIn scenes
			If (scene.name = nextScene)
				SetState(SCENE_LEAVING)
				Self.nextScene = scene
				For Local fader:TFader = EachIn faders
					fader.FadeOut()
				Next
				Return
			End If
		Next
		RuntimeError("Scene not found!")
	End Method
	
	Method Leave()
		SetState(SCENE_LEAVING)
		Self.nextScene = Null
		For Local fader:TFader = EachIn faders
			fader.FadeOut()
		Next
	End Method
	
	Method GetState:Int()
		Return state
	End Method	
	
	Method SetState(state:Int)
		Self.state = state
	End Method

	Method InitGameloop()
		If (Not currentScene) Then RuntimeError("No scene found!")
		currentScene.OnEnter()
		For Local fader:TFader = EachIn faders
			fader.FadeIn()
		Next
		skipTicks = Float(1000) / Float(hertz)
	End Method
	
	Method Trace(s:String)
		?Debug
			ListAddLast(debugMessages, s)
		?
	End Method
		
	Method Run()	
		InitGameloop()
		Local nextGameTick:Double = MilliSecs()
		Local sleepTime:Int = 0
		Local loops:Int = 0
		Local allocedMemory:Int = 0

		?Debug
			Local fpsTimer:Float = MilliSecs() + 1000
			Local fpsFrame:Int = 1
			Local fps:Int = 0			
		?
		
		skipTicks = 1000.0 / 60.0
		
		While (Not exitApp)
			Update()
			Render()
			
			?Debug
				SetImageFont(Null)
				Local alpha:Float = GetAlpha()
				If (KeyDown(KEY_TAB))
					SetAlpha(0.8)
					SetColor(0,0,0)
					DrawRect(0,0,VirtualResolutionWidth(), VirtualResolutionHeight())
					SetColor(255,255,255)
					SetAlpha(1)
				Else
					SetAlpha(0.7)
					SetColor(255,255,255)
				End If
				SetScale(1,1)
				SetRotation(0)
								
				If (MilliSecs() < fpsTimer)
					fpsFrame :+ 1
				Else
					fps = fpsFrame
					fpsFrame = 1
					fpsTimer = MilliSecs() + 1000
					allocedMemory = GCMemAlloced()/1024
				End If
				
				DrawText ("Frames: " + fps + "/s", 5, 2)
				DrawText ("Mouse Pos: " + VirtualMouseX() + "/" + VirtualMouseY(), 5, 14)
				DrawText ("GCMemAlloced: "+String(allocedMemory)+"kb",5,26)
				Local y:Int = 50
				For Local s:String = EachIn debugMessages
					DrawText (s,5,y)
					y :+ 12
				Next
				SetAlpha(alpha)
			?

			
			If AppTerminate() Then Leave()
			Flip(vSync)
			
			nextGameTick :+ skipTicks			
			sleepTime = nextGameTick - MilliSecs()
			If (sleepTime >= 0)
				Delay(sleepTime)
			End If
		Wend
		
		CleanUp()
	End Method	
	
	Method CleanUp()
		scenes = Null
		faders = Null
	End Method
End Type