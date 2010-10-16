SuperStrict

Import BaH.FMOD

' This is a simple, easy-to-use wrapper for FMOD
Type TAudio
	Global instance:TAudio
	
	Const MAX_CHANNELS:Int = 32
	
	Field system:TFMODSystem
	Field music:TFMODSound
	Field musicChannel:TFMODChannel
	Field sfxChannel:TFMODChannel
	
	Function GetInstance:TAudio()
		If Not Self.instance
			Self.instance = New Self
		End If
		Return Self.instance
	End Function
	
	Method New()
		system:TFMODSystem = New TFMODSystem.Create()
		If (system.Init(MAX_CHANNELS) <> FMOD_OK) Then RuntimeError "Could not init audio system"
	End Method
	
	Method LoadMusic(file:String)
		music = system.CreateSoundURL(file, FMOD_SOFTWARE)
	End Method
	
	Method CreateSoundEffect:TFMODSound(file:String)
		Return system.CreateSoundURL(file, FMOD_SOFTWARE)
	End Method
	
	Method PlaySoundEffect(sound:TFMODSound, channel:Int)
		sfxChannel = system.PlaySound(channel, sound)
	End Method
	
	Method GetMusicNumChannels:Int()
		Local numChannel:Int = 0
		If (music)
			music.GetMusicNumChannels(numChannel)
		End If		
		Return numChannel
	End Method
	
	Method SetMusicChannelVolume(channel:Int, volume:Float = 1.0)
		If (music)
			music.SetMusicChannelVolume(channel, volume * 1065353216)
		End If
	End Method
	
	Method MuteAllMusicChannels()
		For Local i:Int = 0 To GetMusicNumChannels()-1
			SetMusicChannelVolume(i, 0)
		Next
	End Method
	
	Method PlayMusic()
		If (music)
			musicChannel = system.PlaySound(FMOD_CHANNEL_FREE, music)
			musicChannel.SetMode(FMOD_LOOP_OFF)
		End If
	End Method
	
	Method GetPatternPosition:Int()
		Local pos:Int = 0
		If (musicChannel)
			musicChannel.GetPosition(pos, FMOD_TIMEUNIT_MODORDER)
		End If
		Return pos
	End Method
	
	Method SetPatternPosition(pos:Int)
		If (musicChannel)
			musicChannel.SetPosition(pos, FMOD_TIMEUNIT_MODORDER)
		End If
	End Method
	
	Method JumpToNextPattern()
		SetPatternPosition(GetPatternPosition()+1)
	End Method
	
	Method GetCurrentRowPosition:Int()
		Local pos:Int
		If (musicChannel)
			musicChannel.GetPosition(pos, FMOD_TIMEUNIT_MODROW)
		End If
		Return pos
	End Method
	
	Method StopMusic()
		If (musicChannel)
			musicChannel.Stop()
		End If
	End Method
	
	Method IsMusicPlaying:Byte()
		Local playing:Int = False
		If (musicChannel)
			musicChannel.IsPlaying(playing)
		End If
		Return Byte(playing)
	End Method
	
	Method FreeMusic()
		If (musicChannel)
			musicChannel.Stop()
			musicChannel = Null
		End If
		If (music)
			music = Null
		End If
	End Method
EndType
