
SuperStrict

Framework BRL.GLMax2D
Import BRL.PNGLoader
Import MaxGUI.cocoamaxgui
Import BRL.Timer
Import BRL.EventQueue
Import BRL.Retro

Import "../../lib/Particle.bmx"
Import "../../lib/ParticleEmitter.bmx"
Import "../../lib/ParticleFX.bmx"

' modules which may be required:
' Import BRL.BMPLoader
' Import BRL.TGALoader
' Import BRL.JPGLoader

Global CurrentFileName:String = ""

TParticle.SetImage("gfx/Particles.png")

Global tp:TParticleFX = New TParticleFX

Global CurrentLayer:Int = 0
tp.Emitter[0].RenderType = TParticleEmitter.RENDER_ALPHA
tp.SetLoop(True)

Global tempE:TParticleEmitter
tempE = New TParticleEmitter

Global LayerOnOff:Byte[10]
For Local i:Int = 0 To 9
	LayerOnOff[i] = True
Next

Global SelectImageView:Byte = False
Global CurrentSelection:Int = -1

AppTitle = "SmashEd - Unknown File"
Global ParticleEditor:TGadget
Global RenderFrame:TGadget
Global Layer:TGadget
Global EmitterDelay:TGadget
Global EmitterDuration:TGadget
Global EmitterRate:TGadget
Global SelectImage:TGadget
Global lblLabel0:TGadget
Global lblLabel1:TGadget
Global lblLabel2:TGadget
Global XSpeed:TGadget
Global YSpeed:TGadget
Global XSpeedVar:TGadget
Global YSpeedVar:TGadget
Global lblLabel3:TGadget
Global lblLabel4:TGadget
Global lblLabel5:TGadget
Global lblLabel6:TGadget
Global SizeVar:TGadget
Global LaunchSize:TGadget
Global Grow:TGadget
Global MinSize:TGadget
Global MaxSize:TGadget
Global lblLabel7:TGadget
Global lblLabel8:TGadget
Global lblLabel9:TGadget
Global lblLabel10:TGadget
Global lblLabel11:TGadget
Global Alpha:TGadget
Global AlphaVar:TGadget
Global AlphaChange:TGadget
Global lblLabel12:TGadget
Global lblLabel13:TGadget
Global lblLabel14:TGadget
Global RotationSpeed:TGadget
Global RotationSpeedVar:TGadget
Global StartOffsetX:TGadget
Global lblLabel15:TGadget
Global lblLabel16:TGadget
Global StartOffsetY:TGadget
Global StartOffsetXVar:TGadget
Global StartOffsetYVar:TGadget
Global lblLabel18:TGadget
Global lblLabel19:TGadget
Global lblLabel20:TGadget
Global lblLabel21:TGadget
Global SelectColor:TGadget
Global ColorchangeR:TGadget
Global ColorchangeG:TGadget
Global ColorchangeB:TGadget
Global lblLabel22:TGadget
Global lblLabel23:TGadget
Global lblLabel25:TGadget
Global Lifetime:TGadget
Global lblLabel26:TGadget
Global RenderType:TGadget
Global RenderFrame_BG:TImage = LoadImage("gfx/bg.png")
ParticleEditor=CreateWindow("SmashEd - Unknown File",0,0,840,785,Desktop(),WINDOW_TITLEBAR|WINDOW_MENU|WINDOW_STATUS)
RenderFrame=CreateCanvas(0,0,496,710,ParticleEditor)
Layer=CreateComboBox(504,0,326,24,ParticleEditor)

AddGadgetItem Layer,"Layer 1"
AddGadgetItem Layer,"Layer 2"
AddGadgetItem Layer,"Layer 3"
AddGadgetItem Layer,"Layer 4"
AddGadgetItem Layer,"Layer 5"
AddGadgetItem Layer,"Layer 6"
AddGadgetItem Layer,"Layer 7"
AddGadgetItem Layer,"Layer 8"
AddGadgetItem Layer,"Layer 9"
AddGadgetItem Layer,"Layer 10"

SelectGadgetItem Layer,0
EmitterDelay=CreateSlider(624,32,152,16,ParticleEditor,1)
SetSliderRange(EmitterDelay,1,101)

EmitterDuration=CreateSlider(624,48,152,16,ParticleEditor,1)
SetSliderRange(EmitterDuration,1,101)

EmitterRate=CreateSlider(624,64,152,16,ParticleEditor,1)
SetSliderRange(EmitterRate,1,101)

lblLabel0=CreateLabel("Emitter Delay",504,32,120,16,ParticleEditor,0)
lblLabel1=CreateLabel("Emitter Duration",504,48,120,16,ParticleEditor,0)
lblLabel2=CreateLabel("Emission Rate",504,64,120,16,ParticleEditor,0)

Global lblLabel2_2:TGadget=CreateLabel("Launch Rate",504,80,120,16,ParticleEditor,0)
Global EmitterFrame:TGadget=CreateSlider(624,80,152,16,ParticleEditor,1)
SetSliderRange(EmitterFrame,1,101)

Global lb0:TGadget=CreateTextField(780,32,50,18,ParticleEditor,0)
Global lb1:TGadget=CreateTextField(780,48,50,18,ParticleEditor,0)
Global lb2:TGadget=CreateTextField(780,64,50,18,ParticleEditor,0)
Global lbemitterframe:TGadget=CreateTextField(780,80,50,18,ParticleEditor,0)

XSpeed=CreateSlider(624,205,152,16,ParticleEditor,1)
YSpeed=CreateSlider(624,221,152,16,ParticleEditor,1)
XSpeedVar=CreateSlider(624,237,152,16,ParticleEditor,1)
YSpeedVar=CreateSlider(624,253,152,16,ParticleEditor,1)

SetSliderRange(XSpeed,1,101)
SetSliderRange(YSpeed,1,101)
SetSliderRange(XSpeedVar,1,101)
SetSliderRange(YSpeedVar,1,101)


lblLabel3=CreateLabel("X-Speed",504,205,120,16,ParticleEditor,0)
lblLabel4=CreateLabel("Y-Speed",504,221,120,16,ParticleEditor,0)
lblLabel5=CreateLabel("X-Speed Variation",504,237,120,16,ParticleEditor,0)
lblLabel6=CreateLabel("Y-Speed Variation",504,253,120,16,ParticleEditor,0)

Global lb3:TGadget=CreateTextField(780,205,50,18,ParticleEditor,0)
Global lb4:TGadget=CreateTextField(780,221,50,18,ParticleEditor,0)
Global lb5:TGadget=CreateTextField(780,237,50,18,ParticleEditor,0)
Global lb6:TGadget=CreateTextField(780,253,50,18,ParticleEditor,0)

LaunchSize=CreateSlider(624,110+(16*0),152,16,ParticleEditor,1)
SizeVar=CreateSlider(624,110+(16*1),152,16,ParticleEditor,1)
Grow=CreateSlider(624,110+(16*2),152,16,ParticleEditor,1)
MinSize=CreateSlider(624,110+(16*3),152,16,ParticleEditor,1)
MaxSize=CreateSlider(624,110+(16*4),152,16,ParticleEditor,1)

SetSliderRange(SizeVar,1,101)
SetSliderRange(LaunchSize,1,101)
SetSliderRange(Grow,1,101)
SetSliderRange(MinSize,1,101)
SetSliderRange(MaxSize,1,101)

Global GrvityXLbl:TGadget = CreateLabel("Gravity X",504,269,120,16,ParticleEditor)
Global GravityX:TGadget = CreateSlider(624,269,152,16,ParticleEditor,1)
Global GravityXTxt:Tgadget = CreateTextField(780,269,50,18,ParticleEditor,0)

Global GrvityYLbl:TGadget = CreateLabel("Gravity Y",504,285,120,16,ParticleEditor)
Global GravityY:TGadget = CreateSlider(624,285,152,16,ParticleEditor,1)
Global GravityYTxt:Tgadget = CreateTextField(780,285,50,18,ParticleEditor,0)

SetSliderRange(GravityX,1,101)
SetSliderRange(GravityY,1,101)


'---------------------
Local m:Int = 0

lblLabel7=CreateLabel("Startsize",504,110+(16*0)+m,120,16,ParticleEditor,0)
lblLabel8=CreateLabel("Size Variation",504,110+m+(16*1),120,16,ParticleEditor,0)
lblLabel9=CreateLabel("Growing",504,110+m+(16*2),120,16,ParticleEditor,0)
lblLabel10=CreateLabel("Min. Size",504,110+m+(16*3),120,16,ParticleEditor,0)
lblLabel11=CreateLabel("Max. Size",504,110+m+(16*4),120,16,ParticleEditor,0)

Global lb7:TGadget=CreateTextField(780,110+m+(16*0),50,18,ParticleEditor,0)
Global lb8:TGadget=CreateTextField(780,110+m+(16*1),50,18,ParticleEditor,0)
Global lb9:TGadget=CreateTextField(780,110+m+(16*2),50,18,ParticleEditor,0)
Global lb10:TGadget=CreateTextField(780,110+m+(16*3),50,18,ParticleEditor,0)
Global lb11:TGadget=CreateTextField(780,110+m+(16*4),50,18,ParticleEditor,0)

'-------------------
m=40

Alpha=CreateSlider(624,280+m,152,16,ParticleEditor,1)
AlphaVar=CreateSlider(624,296+m,152,16,ParticleEditor,1)
AlphaChange=CreateSlider(624,312+m,152,16,ParticleEditor,1)
SetSliderRange(Alpha,1,101)
SetSliderRange(AlphaVar,1,101)
SetSliderRange(AlphaChange,1,101)
lblLabel12=CreateLabel("Alpha (Start)",504,280+m,120,16,ParticleEditor,0)
lblLabel13=CreateLabel("Alpha Variation",504,296+m,120,16,ParticleEditor,0)
lblLabel14=CreateLabel("Alpha Change",504,312+m,120,16,ParticleEditor,0)

Global lb12:TGadget=CreateTextField(780,280+m,50,18,ParticleEditor,0)
Global lb13:TGadget=CreateTextField(780,296+m,50,18,ParticleEditor,0)
Global lb14:TGadget=CreateTextField(780,312+m,50,18,ParticleEditor,0)

m=40+8

RotationSpeed=CreateSlider(624,336+m,152,16,ParticleEditor,1)
RotationSpeedVar=CreateSlider(624,352+m,152,16,ParticleEditor,1)

SetSliderRange(RotationSpeed,1,101)
SetSliderRange(RotationSpeedVar,1,101)

lblLabel15=CreateLabel("Rotationspeed",504,336+m,120,16,ParticleEditor,0)
lblLabel16=CreateLabel("Rotationspeed Var.",504,352+m,140,16,ParticleEditor,0)
'-----------------
Global lb15:TGadget=CreateTextField(780,336+m,50,18,ParticleEditor,0)
Global lb16:TGadget=CreateTextField(780,352+m,50,18,ParticleEditor,0)

Global RStartLbl:TGadget = CreateLabel("Start Angle",504,368+m,120,16,ParticleEditor)
Global RStart:TGadget = CreateSlider(624,368+m,152,16,ParticleEditor,1)
Global RStartTxt:Tgadget = CreateTextField(780,368+m,50,18,ParticleEditor,0)
SetSliderRange(RStart,1,360)

'---------------------

StartOffsetX=CreateSlider(624,612,152,16,ParticleEditor,1)
StartOffsetY=CreateSlider(624,628,152,16,ParticleEditor,1)
StartOffsetXVar=CreateSlider(624,644,152,16,ParticleEditor,1)
StartOffsetYVar=CreateSlider(624,660,152,16,ParticleEditor,1)

SetSliderRange(StartOffsetX,1,101)
SetSliderRange(StartOffsetY,1,101)
SetSliderRange(StartOffsetXVar,1,101)
SetSliderRange(StartOffsetYVar,1,101)

lblLabel18=CreateLabel("StartOffset X",504,612,120,16,ParticleEditor,0)
lblLabel19=CreateLabel("StartOffset Y",504,628,120,16,ParticleEditor,0)
lblLabel20=CreateLabel("StartOffset X Var.",504,644,120,16,ParticleEditor,0)
lblLabel21=CreateLabel("StartOffset Y Var.",504,660,120,16,ParticleEditor,0)



Global lb18:TGadget=CreateTextField(780,612,50,18,ParticleEditor,0)
Global lb19:TGadget=CreateTextField(780,628,50,18,ParticleEditor,0)
Global lb20:TGadget=CreateTextField(780,644,50,18,ParticleEditor,0)
Global lb21:TGadget=CreateTextField(780,660,50,18,ParticleEditor,0)
'-----------------
m=12
SelectImage=CreateButton("Select Image...",504,448,326,24,ParticleEditor,BUTTON_PUSH)


SelectColor=CreateButton("Select Color...",504,506+m,272,24,ParticleEditor,BUTTON_PUSH)

Global Col:TGadget = CreateCanvas(780,507+m,50,22,ParticleEditor)
m:-6
ColorchangeR=CreateSlider(624,540+m,152,16,ParticleEditor,1)
ColorchangeG=CreateSlider(624,556+m,152,16,ParticleEditor,1)
ColorchangeB=CreateSlider(624,572+m,152,16,ParticleEditor,1)

SetSliderRange(ColorchangeR,1,101)
SetSliderRange(ColorchangeG,1,101)
SetSliderRange(ColorchangeB,1,101)


lblLabel22=CreateLabel("Colorchange (R)",504,540+m,120,16,ParticleEditor,0)
lblLabel23=CreateLabel("Colorchange (G)",504,556+m,120,16,ParticleEditor,0)
lblLabel25=CreateLabel("Colorchange (B)",504,572+m,120,16,ParticleEditor,0)

Global lb22:TGadget=CreateTextField(780,540+m,50,18,ParticleEditor,0)
Global lb23:TGadget=CreateTextField(780,556+m,50,18,ParticleEditor,0)
Global lb25:TGadget=CreateTextField(780,572+m,50,18,ParticleEditor,0)

Lifetime=CreateSlider(624,695,152,16,ParticleEditor,1)
SetSliderRange(Lifetime,1,101)
lblLabel26=CreateLabel("Lifetime",504,695,120,16,ParticleEditor,0)
Global lb26:TGadget=CreateTextField(780,695,50,18,ParticleEditor,0)

RenderType=CreateComboBox(504,476,327,20,ParticleEditor)
AddGadgetItem RenderType,"Blendmode: ALPHA"
AddGadgetItem RenderType,"Blendmode: ADD"
AddGadgetItem RenderType,"Blendmode: MUL"
AddGadgetItem RenderType,"Layer: off"
SelectGadgetItem RenderType,0

'-menus-----------------------------------------------------------------

'
' Create Menus
'

Global FileMenu:TGadget = CreateMenu("&File",0,ParticleEditor)
CreateMenu "New",101,FileMenu
CreateMenu "Open",102,FileMenu
CreateMenu "Save",103,FileMenu
CreateMenu "Save as...",104,FileMenu
CreateMenu "Exit",105,FileMenu

Global EditMenu:TGadget = CreateMenu ("Edit",0,ParticleEditor)
Global EditMenu1:TGadget = CreateMenu ("Cut",501,EditMenu)
Global EditMenu2:TGadget = CreateMenu ("Copy",502,EditMenu)
Global EditMenu3:TGadget = CreateMenu ("Paste",503,EditMenu)
DisableMenu (EditMenu3)

Global SettingsMenu:TGadget = CreateMenu ("Settings",0,ParticleEditor)
Global LoopMenu:TGadget = CreateMenu ("Loop Particle FX",301,SettingsMenu,0,0)
CheckMenu(LoopMenu)

Global Layers:TGadget = CreateMenu("Layers",400, SettingsMenu, 0, 0)
Global MLayer1:TGadget = CreateMenu("Layer 1",401, Layers, 0, 0)
Global MLayer2:TGadget = CreateMenu("Layer 2",402, Layers, 0, 0)
Global MLayer3:TGadget = CreateMenu("Layer 3",403, Layers, 0, 0)
Global MLayer4:TGadget = CreateMenu("Layer 4",404, Layers, 0, 0)
Global MLayer5:TGadget = CreateMenu("Layer 5",405, Layers, 0, 0)
Global MLayer6:TGadget = CreateMenu("Layer 6",406, Layers, 0, 0)
Global MLayer7:TGadget = CreateMenu("Layer 7",407, Layers, 0, 0)
Global MLayer8:TGadget = CreateMenu("Layer 8",408, Layers, 0, 0)
Global MLayer9:TGadget = CreateMenu("Layer 9",409, Layers, 0, 0)
Global MLayer10:TGadget = CreateMenu("Layer 10",410, Layers, 0, 0)
Global MLayer11:TGadget = CreateMenu("",411,Layers)
DisableMenu(MLayer11)
Global MLayer12:TGadget = CreateMenu("Only show current layer",412, Layers, 0, 0)
UncheckMenu(MLayer12)
Global MLayer13:TGadget = CreateMenu("",413,Layers)
DisableMenu(MLayer13)
Global MLayer14:TGadget = CreateMenu("Follow Mouse",414, Layers, 0, 0)
UncheckMenu(MLayer14)

Global HelpMenu:TGadget = CreateMenu("&Help",0,ParticleEditor)

CreateMenu "Info...",201,HelpMenu
CreateMenu "SmashEd Website",202,HelpMenu

CheckMenu(MLayer1)
CheckMenu(MLayer2)
CheckMenu(MLayer3)
CheckMenu(MLayer4)
CheckMenu(MLayer5)
CheckMenu(MLayer6)
CheckMenu(MLayer7)
CheckMenu(MLayer8)
CheckMenu(MLayer9)
CheckMenu(MLayer10)

UncheckMenu(SettingsMenu)
UpdateWindowMenu ParticleEditor

'-mainloop--------------------------------------------------------------
CreateTimer 60

CurrentFilename = "examples/Default.par"
tp.LoadFx(CurrentFilename)

UpdateGadgetValues()
UpdateGadgetText()	

AddHook EmitEventHook, MyHook

Repeat
	Select WaitEvent()
		Case EVENT_TIMERTICK
			RedrawGadget RenderFrame

		Case EVENT_GADGETACTION						' interacted with gadget
			DoGadgetAction(EventSource(),EventData())
		Case EVENT_WINDOWCLOSE
			FreeGadget RenderFrame
			Exit
		Case EVENT_MENUACTION					' selected a menu
			DoMenuAction()
	  Case EVENT_GADGETPAINT
			UpdateCanvas()
			
		Case EVENT_MOUSEMOVE
			If SelectImageView
				Local count:Int = 0
				For Local x:Int = 0 To 2
					For Local y:Int = 0 To 2
						If EventX()>(128*x) And EventX()<((128*x)+128) And EventY()>(128*y) And EventY()<((128*y)+128)
							CurrentSelection = count
						End If
						count:+1
					Next
				Next
			End If
			
			For Local i:Int = 0 To 9
				If (MenuChecked(MLayer14)) 
					tp.Emitter[i].x = EventX()
					tp.Emitter[i].y = EventY()
				End If
			Next
			
		Case EVENT_MOUSEDOWN
		If EventSource()=RenderFrame
			If EventData()=2 
		      PopupWindowMenu ParticleEditor,Layers
			Else
				If SelectImageView
					Local count:Int = 0
					For Local x:Int = 0 To 2
						For Local y:Int = 0 To 2
							If EventX()>(128*x) And EventX()<((128*x)+128) And EventY()>(128*y) And EventY()<((128*y)+128)
								tp.Emitter[CurrentLayer].Image = count
							End If
							count:+1
						Next
					Next
					SelectImageView = False								
				Else
					For Local i:Int = 0 To 9
						tp.Emitter[i].x = EventX()
						tp.Emitter[i].y = EventY()
						tp.Emitter[i].frame = 0
					Next
				End If
			End If
		End If
			
	End Select
Forever

'-gadget actions--------------------------------------------------------

Function UpdateGadgetValues()
	SetSliderValue(EmitterDelay, tp.Emitter[CurrentLayer].EmitterDelay / 10)
	SetSliderValue(EmitterDuration, tp.Emitter[CurrentLayer].EmitterDuration / 10)
	SetSliderValue(EmitterRate, tp.Emitter[CurrentLayer].EmissionRate)
	SetSliderValue(XSpeed, ((tp.Emitter[CurrentLayer].SpeedX + 10) / 20) * 100)
	SetSliderValue(YSpeed, ((tp.Emitter[CurrentLayer].SpeedY + 10) / 20) * 100)
	SetSliderValue(XSpeedVar, (tp.Emitter[CurrentLayer].SpeedVarX/20)*100)
	SetSliderValue(YSpeedVar, (tp.Emitter[CurrentLayer].SpeedVarY/20)*100)
	SetSliderValue(SizeVar, tp.Emitter[CurrentLayer].SizeVar*100)
	SetSliderValue(LaunchSize, tp.Emitter[CurrentLayer].LaunchSize*10)
	SetSliderValue(Grow, ((tp.Emitter[CurrentLayer].Grow + 1) / 2) * 100)
	SetSliderValue(MinSize, tp.Emitter[CurrentLayer].MinSize*10)
	SetSliderValue(MaxSize, tp.Emitter[CurrentLayer].MaxSize*10)	
	SetSliderValue(Alpha, tp.Emitter[CurrentLayer].Alpha*100)
	SetSliderValue(AlphaVar, tp.Emitter[CurrentLayer].AlphaVar * 100)
	SetSliderValue(AlphaChange, ((tp.Emitter[CurrentLayer].AlphaChange + 1) / 2) * 100)
	SetSliderValue(RotationSpeed, ((tp.Emitter[CurrentLayer].RotationSpeed + 1) / 2) * 100)
	SetSliderValue(RotationSpeedVar, (tp.Emitter[CurrentLayer].RotationVar / 2) * 100)
	SetSliderValue(StartOffsetX, ((tp.Emitter[CurrentLayer].StartOffsetX + 320) * 100)/640)
	SetSliderValue(StartOffsetY, ((tp.Emitter[CurrentLayer].StartOffsetY + 320) * 100)/640)
	SetSliderValue(StartOffsetXVar, tp.Emitter[CurrentLayer].StartOffsetVarX)
	SetSliderValue(StartOffsetYVar, tp.Emitter[CurrentLayer].StartOffsetVarY)
	SetSliderValue(ColorchangeR, ((tp.Emitter[CurrentLayer].ColorChangeR + 63) / 128)*100)
	SetSliderValue(ColorchangeG, ((tp.Emitter[CurrentLayer].ColorChangeG + 63) / 128)*100)
	SetSliderValue(ColorchangeB, ((tp.Emitter[CurrentLayer].ColorChangeB + 63) / 128)*100)
	SetSliderValue(Lifetime, tp.Emitter[CurrentLayer].LifeTime / 10)	
	
	SetSliderValue(EmitterFrame, tp.Emitter[CurrentLayer].EmissionEachFrame)
	
	SetSliderValue(GravityX, ((tp.Emitter[CurrentLayer].GravityX + 1) / 2) * 100)
	SetSliderValue(GravityY, ((tp.Emitter[CurrentLayer].GravityY + 1) / 2) * 100)
	SetSliderValue(RStart, (tp.Emitter[CurrentLayer].RotationStart))
			
	SelectGadgetItem(Layer, CurrentLayer)
	SelectGadgetItem(RenderType,tp.Emitter[CurrentLayer].RenderType)
		
End Function

Function UpdateGadgetText()
	SetGadgetText(lb0,fp(tp.Emitter[CurrentLayer].EmitterDelay))
	SetGadgetText(lb1,fp(tp.Emitter[CurrentLayer].EmitterDuration))
	SetGadgetText(lb2,fp(tp.Emitter[CurrentLayer].EmissionRate))
	SetGadgetText(lb3,fp(tp.Emitter[CurrentLayer].SpeedX))
	SetGadgetText(lb4,fp(tp.Emitter[CurrentLayer].SpeedY))
	SetGadgetText(lb5,fp(tp.Emitter[CurrentLayer].SpeedVarX))
	SetGadgetText(lb6,fp(tp.Emitter[CurrentLayer].SpeedVarY))
	SetGadgetText(lb7,fp(tp.Emitter[CurrentLayer].LaunchSize))
	SetGadgetText(lb8,fp(tp.Emitter[CurrentLayer].SizeVar))
	SetGadgetText(lb9,fp(tp.Emitter[CurrentLayer].Grow))
	SetGadgetText(lb10,fp(tp.Emitter[CurrentLayer].MinSize))
	SetGadgetText(lb11,fp(tp.Emitter[CurrentLayer].MaxSize))
	SetGadgetText(lb12,fp(tp.Emitter[CurrentLayer].Alpha))
	SetGadgetText(lb13,fp(tp.Emitter[CurrentLayer].AlphaVar))
	SetGadgetText(lb14,fp(tp.Emitter[CurrentLayer].AlphaChange))
	SetGadgetText(lb15,fp(tp.Emitter[CurrentLayer].RotationSpeed))
	SetGadgetText(lb16,fp(tp.Emitter[CurrentLayer].RotationVar))
	SetGadgetText(lb18,fp(tp.Emitter[CurrentLayer].StartOffsetX))
	SetGadgetText(lb19,fp(tp.Emitter[CurrentLayer].StartOffsetY))
	SetGadgetText(lb20,fp(tp.Emitter[CurrentLayer].StartOffsetVarX))
	SetGadgetText(lb21,fp(tp.Emitter[CurrentLayer].StartOffsetVarY))
	SetGadgetText(lb22,fp(tp.Emitter[CurrentLayer].ColorChangeR))
	SetGadgetText(lb23,fp(tp.Emitter[CurrentLayer].ColorChangeG))
	SetGadgetText(lb25,fp(tp.Emitter[CurrentLayer].ColorChangeB))
	SetGadgetText(lb26,fp(tp.Emitter[CurrentLayer].LifeTime))
	SetGadgetText(lbemitterframe,fp(tp.Emitter[CurrentLayer].EmissionEachFrame))
	SetGadgetText(GravityXTxt, fp(tp.Emitter[CurrentLayer].GravityX))
	SetGadgetText(GravityYTxt, fp(tp.Emitter[CurrentLayer].GravityY))
	SetGadgetText(RStartTxt, fp(tp.Emitter[CurrentLayer].RotationStart))
	
End Function

Function DoGadgetAction(source:Object, data:Int)
	Local d:Float = Float(data)/100.0
	Select source
		Case Layer
			' insert your action for Layer here
			CurrentLayer = data
			UpdateGadgetValues()
			UpdateGadgetText()

		Case EmitterDelay	' user modified slider
			tp.Emitter[CurrentLayer].EmitterDelay = d * 1000
			UpdateGadgetText()

		Case EmitterDuration	' user modified slider
			tp.Emitter[CurrentLayer].EmitterDuration = d * 1000
			UpdateGadgetText()

		Case EmitterRate	' user modified slider
			tp.Emitter[CurrentLayer].EmissionRate = d * 100
			UpdateGadgetText()
			
		Case EmitterFrame
			tp.Emitter[CurrentLayer].EmissionEachFrame = d * 100		
			UpdateGadgetText()

		Case SelectImage	' user pressed button
			SelectImageView = True

		Case XSpeed	' user modified slider
			tp.Emitter[CurrentLayer].SpeedX = -10 + (d * 20)
			UpdateGadgetText()

		Case YSpeed	' user modified slider
			tp.Emitter[CurrentLayer].SpeedY = -10 + (d * 20)
			UpdateGadgetText()
				
		Case XSpeedVar	' user modified slider
			tp.Emitter[CurrentLayer].SpeedVarX = (d * 20)
			UpdateGadgetText()

		Case YSpeedVar	' user modified slider
			tp.Emitter[CurrentLayer].SpeedVarY = (d * 20)
			UpdateGadgetText()

		Case SizeVar	' user modified slider
			tp.Emitter[CurrentLayer].SizeVar = d
			UpdateGadgetText()

		Case LaunchSize	' user modified slider
			tp.Emitter[CurrentLayer].LaunchSize = d * 10
			UpdateGadgetText()

		Case Grow	' user modified slider
			tp.Emitter[CurrentLayer].Grow = -1 + (d * 2)
			UpdateGadgetText()

		Case MinSize	' user modified slider
			tp.Emitter[CurrentLayer].MinSize = d * 10
			UpdateGadgetText()

		Case MaxSize	' user modified slider
			tp.Emitter[CurrentLayer].MaxSize = d * 10
			UpdateGadgetText()

		Case Alpha	' user modified slider
			tp.Emitter[CurrentLayer].Alpha = d
			UpdateGadgetText()

		Case AlphaVar	' user modified slider
			tp.Emitter[CurrentLayer].AlphaVar = d
			UpdateGadgetText()

		Case AlphaChange	' user modified slider
			tp.Emitter[CurrentLayer].AlphaChange = -1 + (d * 2)
			UpdateGadgetText()

		Case RotationSpeed	' user modified slider
			tp.Emitter[CurrentLayer].RotationSpeed = -1 + (d * 2)
			UpdateGadgetText()

		Case RotationSpeedVar	' user modified slider
			tp.Emitter[CurrentLayer].RotationVar = d*2
			UpdateGadgetText()
		
		Case RStart		
			tp.Emitter[CurrentLayer].RotationStart = data
			UpdateGadgetText()

		Case StartOffsetX	' user modified slider
			tp.Emitter[CurrentLayer].StartOffsetX = - 320 + (640 * d)
			UpdateGadgetText()

		Case StartOffsetY	' user modified slider
			tp.Emitter[CurrentLayer].StartOffsetY = - 320 + (640 * d)
			UpdateGadgetText()
			
		Case StartOffsetXVar	' user modified slider
			tp.Emitter[CurrentLayer].StartOffsetVarX = (100 * d)
			UpdateGadgetText()

		Case StartOffsetYVar	' user modified slider
			tp.Emitter[CurrentLayer].StartOffsetVarY = (100 * d)
			UpdateGadgetText()
			
		Case SelectColor	' user pressed button
					
			If RequestColor(tp.Emitter[CurrentLayer].ColorR ,tp.Emitter[CurrentLayer].ColorG ,tp.Emitter[CurrentLayer].ColorB )
				tp.Emitter[CurrentLayer].ColorR =RequestedRed()
				tp.Emitter[CurrentLayer].ColorG =RequestedGreen()
				tp.Emitter[CurrentLayer].ColorB =RequestedBlue()
			End If
			UpdateGadgetText()


		Case ColorchangeR	' user modified slider
			tp.Emitter[CurrentLayer].ColorChangeR = -63 + (126 * d)
			UpdateGadgetText()

		Case ColorchangeG	' user modified slider
			tp.Emitter[CurrentLayer].ColorChangeG = -63 + (126 * d)
			UpdateGadgetText()
			
		Case ColorchangeB	' user modified slider
			tp.Emitter[CurrentLayer].ColorChangeB = -63 + (126 * d)
			UpdateGadgetText()
			
		Case Lifetime	' user modified slider
			tp.Emitter[CurrentLayer].LifeTime = d * 1000
			UpdateGadgetText()
			
		Case GravityX
			tp.Emitter[CurrentLayer].GravityX = -1 + (d * 2)
			UpdateGadgetText()
		
		Case GravityY
			tp.Emitter[CurrentLayer].GravityY = -1 + (d * 2) 
			UpdateGadgetText()

		Case RenderType
			Select data
				Case 0
					tp.Emitter[CurrentLayer].RenderType = TParticleEmitter.RENDER_ALPHA
				Case 1
					tp.Emitter[CurrentLayer].RenderType = TParticleEmitter.RENDER_ADD
				Case 2
					tp.Emitter[CurrentLayer].RenderType = TParticleEmitter.RENDER_MUL
				Case 3
					tp.Emitter[CurrentLayer].RenderType = TParticleEmitter.RENDER_OFF
			End Select

			' insert your action for RenderType here

		Case lb0	
			tp.Emitter[CurrentLayer].EmitterDelay = Float(TextFieldText(lb0))
			UpdateGadgetValues()
		Case lb1
			tp.Emitter[CurrentLayer].EmitterDuration = Float(TextFieldText(lb1))
			UpdateGadgetValues()
		Case lb2
			 tp.Emitter[CurrentLayer].EmissionRate = Float(TextFieldText(lb2))
			UpdateGadgetValues()
		Case lb3
			 tp.Emitter[CurrentLayer].SpeedX = Float(TextFieldText(lb3))
			UpdateGadgetValues()
		Case lb4
			 tp.Emitter[CurrentLayer].SpeedY = Float(TextFieldText(lb4))
			UpdateGadgetValues()
		Case lb5
			 tp.Emitter[CurrentLayer].SpeedVarX = Float(TextFieldText(lb5))
			UpdateGadgetValues()
		Case lb6
			 tp.Emitter[CurrentLayer].SpeedVarY = Float(TextFieldText(lb6))
			UpdateGadgetValues()
		Case lb7
			 tp.Emitter[CurrentLayer].LaunchSize = Float(TextFieldText(lb7))
			UpdateGadgetValues()
		Case lb8
			 tp.Emitter[CurrentLayer].SizeVar = Float(TextFieldText(lb8))
			UpdateGadgetValues()
		Case lb9
			 tp.Emitter[CurrentLayer].Grow = Float(TextFieldText(lb9))
			UpdateGadgetValues()
		Case lb10
			 tp.Emitter[CurrentLayer].MinSize = Float(TextFieldText(lb10))
			UpdateGadgetValues()
		Case lb11
			 tp.Emitter[CurrentLayer].MaxSize = Float(TextFieldText(lb11))
			UpdateGadgetValues()
		Case lb12
			 tp.Emitter[CurrentLayer].Alpha = Float(TextFieldText(lb12))
			UpdateGadgetValues()
		Case lb13
			 tp.Emitter[CurrentLayer].AlphaVar = Float(TextFieldText(lb13))
			UpdateGadgetValues()
		Case lb14
			 tp.Emitter[CurrentLayer].AlphaChange = Float(TextFieldText(lb14))
			UpdateGadgetValues()
		Case lb15
			 tp.Emitter[CurrentLayer].RotationSpeed = Float(TextFieldText(lb15))
			UpdateGadgetValues()
		Case lb16
			 tp.Emitter[CurrentLayer].RotationVar = Float(TextFieldText(lb16))
			UpdateGadgetValues()
		Case lb18
			 tp.Emitter[CurrentLayer].StartOffsetX = Float(TextFieldText(lb18))
			UpdateGadgetValues()
		Case lb19
			 tp.Emitter[CurrentLayer].StartOffsetY = Float(TextFieldText(lb19))
			UpdateGadgetValues()
		Case lb20
			 tp.Emitter[CurrentLayer].StartOffsetVarX = Float(TextFieldText(lb20))
			UpdateGadgetValues()
		Case lb21
			 tp.Emitter[CurrentLayer].StartOffsetVarY = Float(TextFieldText(lb21))
			UpdateGadgetValues()
		Case lb22
			 tp.Emitter[CurrentLayer].ColorChangeR = Float(TextFieldText(lb22))
			UpdateGadgetValues()
		Case lb23
			 tp.Emitter[CurrentLayer].ColorChangeG = Float(TextFieldText(lb23))
			UpdateGadgetValues()
		Case lb25
			 tp.Emitter[CurrentLayer].ColorChangeB = Float(TextFieldText(lb25))
			UpdateGadgetValues()
		Case lb26
			 tp.Emitter[CurrentLayer].LifeTime = Float(TextFieldText(lb26))
			UpdateGadgetValues()
		Case lbemitterframe
			 tp.Emitter[CurrentLayer].EmissionEachFrame = Float(TextFieldText(lbemitterframe))	
			UpdateGadgetValues()
		Case RStartTxt
			tp.Emitter[CurrentLayer].RotationStart = Float(TextFieldText(RStartTxt))	
			UpdateGadgetValues()
	End Select
	
End Function

'-menu actions--------------------------------------------------------

Function DoMenuAction()
	Select EventData()
		Case 101 'New
			ClearAllValues()
			
		Case 102 'Open
			CurrentFilename = RequestFile("Load Particle FX...","Particle Files:par",False,"")
			If CurrentFilename<>""
				tp.LoadFx(CurrentFilename)
				UpdateGadgetValues()
				UpdateGadgetText()		
			End If
		Case 103 'Save
			If CurrentFilename = "" 
				Notify("No file selected, please choose 'Save As...'",False)
			Else
				tp.SaveFX(CurrentFilename)
				Notify("File saved!",False)
			End If
		Case 104 'Save As
			CurrentFilename = RequestFile("Save Particle FX...","Particle Files:par",True,"")
			tp.SaveFX(CurrentFilename)
		Case 105 'Exit
			End
		Case 201 'Info
			Notify("Smash Particle Engine v"+TPARTICLE_VER+" - (C) Copyright 2007 by Intermediaware",False)
		Case 202
			OpenURL("http://www.intermediaware.com/index.php?id=291")
			
		Case 301 'Loop
			If MenuChecked(LoopMenu)
				UncheckMenu(LoopMenu)
				tp.SetLoop(False)
			Else
				CheckMenu(LoopMenu)
				tp.SetLoop(True)
			EndIf
			UpdateWindowMenu(ParticleEditor)

		Case 401 'Loop
			If MenuChecked(MLayer1)
				UncheckMenu(MLayer1)
				LayerOnOff[0] = False
			Else
				CheckMenu(MLayer1)
				LayerOnOff[0] = True
			EndIf
			UpdateWindowMenu(ParticleEditor)
			
		Case 402 'Loop
			If MenuChecked(MLayer2)
				UncheckMenu(MLayer2)
				LayerOnOff[1] = False
			Else
				CheckMenu(MLayer2)
				LayerOnOff[1] = True
			EndIf
			UpdateWindowMenu(ParticleEditor)
			
		Case 403 'Loop
			If MenuChecked(MLayer3)
				UncheckMenu(MLayer3)
				LayerOnOff[2] = False
			Else
				CheckMenu(MLayer3)
				LayerOnOff[2] = True
			EndIf
			UpdateWindowMenu(ParticleEditor)
			
		Case 404 'Loop
			If MenuChecked(MLayer4)
				UncheckMenu(MLayer4)
				LayerOnOff[3] = False
			Else
				CheckMenu(MLayer4)
				LayerOnOff[3] = True
			EndIf
			UpdateWindowMenu(ParticleEditor)
			
		Case 405 'Loop
			If MenuChecked(MLayer5)
				UncheckMenu(MLayer5)
				LayerOnOff[4] = False
			Else
				CheckMenu(MLayer5)
				LayerOnOff[4] = True
			EndIf
			UpdateWindowMenu(ParticleEditor)
			
		Case 406 'Loop
			If MenuChecked(MLayer6)
				UncheckMenu(MLayer6)
				LayerOnOff[5] = False
			Else
				CheckMenu(MLayer6)
				LayerOnOff[5] = True
			EndIf
			UpdateWindowMenu(ParticleEditor)
			
		Case 407 'Loop
			If MenuChecked(MLayer7)
				UncheckMenu(MLayer7)
				LayerOnOff[6] = False
			Else
				CheckMenu(MLayer7)
				LayerOnOff[6] = True
			EndIf
			UpdateWindowMenu(ParticleEditor)
			
		Case 408 'Loop
			If MenuChecked(MLayer8)
				UncheckMenu(MLayer8)
				LayerOnOff[7] = False
			Else
				CheckMenu(MLayer8)
				LayerOnOff[7] = True
			EndIf
			UpdateWindowMenu(ParticleEditor)
			
		Case 409 'Loop
			If MenuChecked(MLayer9)
				UncheckMenu(MLayer9)
				LayerOnOff[8] = False
			Else
				CheckMenu(MLayer9)
				LayerOnOff[8] = True
			EndIf
			UpdateWindowMenu(ParticleEditor)
			
		Case 410 'Loop
			If MenuChecked(MLayer10)
				UncheckMenu(MLayer10)
				LayerOnOff[9] = False
			Else
				CheckMenu(MLayer10)
				LayerOnOff[9] = True
			EndIf
			UpdateWindowMenu(ParticleEditor)
			
		Case 412
			If MenuChecked(MLayer12)
				UncheckMenu(MLayer12)
			Else
				CheckMenu(MLayer12)
			EndIf
			UpdateWindowMenu(ParticleEditor)		
		Case 414
			If MenuChecked(MLayer14)
				UncheckMenu(MLayer14)
			Else
				CheckMenu(MLayer14)
			EndIf
			UpdateWindowMenu(ParticleEditor)		
		
		Case 501 'Cut
			
			CopyObject(tp.Emitter[CurrentLayer], tempE)		
			ClearLayerValues()
			EnableMenu(EditMenu3)
			UpdateGadgetValues()
			UpdateGadgetText()	
			UpdateWindowMenu ParticleEditor

			
		Case 502 'Copy
		
			CopyObject(tp.Emitter[CurrentLayer], tempE)		
			EnableMenu(EditMenu3)
			UpdateGadgetValues()
			UpdateGadgetText()	
			UpdateWindowMenu ParticleEditor
			
		Case 503 'Paste
			CopyObject(tempE, tp.Emitter[CurrentLayer])		
			DisableMenu(EditMenu3)
			UpdateGadgetValues()
			UpdateGadgetText()	
			UpdateWindowMenu ParticleEditor

			
	End Select
	
	SetGadgetText(ParticleEditor, "SmashEd - " + CurrentFilename)
End Function

Function fp:String(f:Float,decimals:Int=4)

	Local i:Long = (10^decimals)*f
	Local value:String = String.fromlong(i)
		
	If value.length<=decimals
		Return "0."+(RSet("",decimals-value.length)).Replace(" ","0")+value
	Else
		Return value[0..value.length-decimals] + "." + value[value.length-decimals..value.length]  
	EndIf
	
End Function 

Function MyHook:Object(iId:Int,tData:Object,tContext:Object)
  Local Event:TEvent=TEvent(tData)

  If Event.source=RenderFrame And Event.ID=EVENT_GADGETPAINT
     UpdateCanvas()
     Return Null
  EndIf

  If Event HandleEvent(event)

  Return tData
End Function

Function HandleEvent( event:TEvent )
  Select event.id
		Case EVENT_GADGETACTION
			DoGadgetAction(event.source,event.data)
			UpdateCanvas()
  End Select
End Function

Function UpdateCanvas:Int()

	SetGraphics CanvasGraphics (Col)
	SetClsColor tp.Emitter[CurrentLayer].ColorR,tp.Emitter[CurrentLayer].ColorG,tp.Emitter[CurrentLayer].ColorB
	Cls
	Flip
	
	SetGraphics CanvasGraphics (RenderFrame)			
	SetClsColor 0,0,0
	SetAlpha(1)
	SetColor 255,255,255
	SetBlend ALPHABLEND
	SetRotation(0)
	SetScale(1,1)
	Cls
	If SelectImageView
		Local count:Int = 0
		For Local x:Int = 0 To 2
			For Local y:Int = 0 To 2
				If count=tp.Emitter[CurrentLayer].Image Then SetColor 255,255,255 Else SetColor 128,128,128				
				If CurrentSelection = count Then SetColor 255,0,0
				DrawImage TParticle.ParticleSprites,64 + x*128,64 + y*128,count
				count:+1
			Next
		Next
	Else
		For Local x:Int = 0 To 550 Step 256
			For Local y:Int = 0 To 800 Step 256
				DrawImage RenderFrame_BG,x,y
			Next
		Next
		
		DrawText("Frame: "+String(tp.Emitter[0].frame),10,10)
		
		For Local i:Int = 0 To 9
				
				If (Not MenuChecked(MLayer12) And LayerOnOff[i]) Or (MenuChecked(MLayer12) And CurrentLayer = i)
					tp.Emitter[i].Render()
				End If
				If tp.LoopFX
					tp.Emitter[i].Loop()
				End If			
		Next	
		
	End If
	Flip			
End Function

Function ClearAllValues()			
	For Local i:Int = 0 To 9
		tp.Emitter[i] = Null
		tp.Emitter[i] = New TParticleEmitter
	Next
	tp.Emitter[0].RenderType = TParticleEmitter.RENDER_ALPHA
	CurrentFilename = "examples/Default.par"
	tp.LoadFx(CurrentFilename)	
	UpdateGadgetValues()
	UpdateGadgetText()
End Function

Function ClearLayerValues()			
	tp.Emitter[CurrentLayer] = Null
	tp.Emitter[CurrentLayer] = New TParticleEmitter
	tp.Emitter[CurrentLayer].RenderType = TParticleEmitter.RENDER_OFF
	UpdateGadgetValues()
	UpdateGadgetText()	
End Function

Function CopyObject(src:TParticleEmitter, dst:TParticleEmitter)
	dst.Frame = src.Frame
	dst.X = src.X
	dst.Y = src.Y
	dst.EmitterDelay = src.EmitterDelay
	dst.EmitterDuration = src.EmitterDuration
	dst.EmissionRate = src.EmissionRate
	dst.EmissionEachFrame = src.EmissionEachFrame
	dst.Image = src.Image
	dst.SpeedX = src.SpeedX
	dst.SpeedY = src.SpeedY
	dst.SpeedVarX = src.SpeedVarX
	dst.SpeedVarY = src.SpeedVarY
	dst.LaunchSize = src.LaunchSize
	dst.SizeVar = src.SizeVar
	dst.Grow = src.Grow
	dst.MinSize = src.MinSize
	dst.MaxSize = src.MaxSize
	dst.Alpha = src.Alpha
	dst.AlphaVar = src.AlphaVar
	dst.AlphaChange = src.AlphaChange
	dst.RotationSpeed = src.RotationSpeed
	dst.RotationVar = src.RotationVar
	dst.ColorR = src.ColorR
	dst.ColorG = src.ColorG
	dst.ColorB = src.ColorB
	dst.ColorChangeR = src.ColorChangeR
	dst.ColorChangeG = src.ColorChangeG
	dst.ColorChangeB = src.ColorChangeB
	dst.StartOffsetX = src.StartOffsetX
	dst.StartOffsetY = src.StartOffsetY
	dst.StartOffsetVarX = src.StartOffsetVarX
	dst.StartOffsetVarY = src.StartOffsetVarY
	dst.GravityX = src.GravityX
	dst.GravityY = src.GravityY
	dst.LifeTime = src.LifeTime
	dst.RenderType = src.RenderType
	dst.StartTime = src.StartTime
	dst.CurrTime = src.CurrTime
	dst.RotationStart = src.RotationStart 
End Function
