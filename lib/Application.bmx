
SuperStrict

Import BRL.GLMax2D
Import BRL.Graphics

Import "Scene.bmx"
Import "Fader.bmx"
Import "InputControllerMouse.bmx"

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
	
	Function InitGraphics(width:Int, height:Int, depth:Int = 0, hertz:Int = 0, flags:Int = 0)
		SetGraphicsDriver GLMax2DDriver()
		gfx = Graphics(width, height, depth, hertz, flags)
		If (hertz <> 0)
			skipTicks = Float(1000) / hertz
		End If
		SetBlend(ALPHABLEND)
	End Function
	
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
	End Method
	
	Method Trace(s:String)
		?Debug
			ListAddLast(debugMessages, s)
		?
	End Method
		
	Method Run()	
		InitGameloop()
		Local nextGameTick:Float = MilliSecs()
		Local sleepTime:Int = 0
		Local loops:Int = 0

		?Debug
			Local fpsTimer:Float = MilliSecs() + 1000
			Local fpsFrame:Int = 1
			Local fps:Int = 0			
		?
		
		While (Not exitApp)
			Update()
			Render()
			nextGameTick :+ skipTicks
			
			?Debug
				Local alpha:Float = GetAlpha()
				If (KeyDown(KEY_TAB))
					SetAlpha(0.8)
					SetColor(0,0,0)
					DrawRect(0,0,GraphicsWidth(), GraphicsHeight())
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
				End If
				
				DrawText ("Frames: " + fps + "/s", 5, 2)
				DrawText ("Mouse Pos: "+MouseX()+"/"+MouseY(),5, 14)
				DrawText ("GCCollect: "+String(GCCollect()/1024)+"kb",5,26)
				DrawText ("GCMemAlloced: "+String(GCMemAlloced()/1024)+"kb",5,38)
				Local y:Int = 50
				For Local s:String = EachIn debugMessages
					DrawText (s,5,y)
					y :+ 12
				Next
				SetAlpha(alpha)
			?
			
			Flip(vSync)
			
			sleepTime = nextGameTick - MilliSecs()
			If (sleepTime > 0)
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