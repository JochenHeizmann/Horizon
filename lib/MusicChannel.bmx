
SuperStrict

Import BRL.Audio

?Win32
Import BRL.DirectSoundAudio
?

?Linux
Import BRL.OpenALAudio
?

?MacOS
Import BRL.FreeAudioAudio
?

Import BRL.OGGLoader

?Linux
If EnableOpenALAudio()
	SetAudioDriver("OpenAL Default")
Else 
	SetAudioDriver("FreeAudio")
End If
?

Type TMusicChannel
	Const FADE_IN:Int = 0
	Const FADE_OUT:Int = 1
	Const CH_PLAYING:Int = 2
	
	Const DEFAULT_FADESPEED:Float = 0.01
	
	Field fadespeed:Float
	Field channel:TChannel
	Field volume:Float
	Field maxVol:Float
	Field snd:TSound
	Field state:Int
	Field file:String
	Field pause:Byte
	Field volumeFactor:Float
	
	Method New()
			fadespeed = DEFAULT_FADESPEED
	End Method
	
	Method SetFadespeed:TMusicChannel(s:Float)
		fadespeed = s
		If (fadespeed >= 1.0)
			State = CH_PLAYING
			volume = maxVol
			SetVolume(volume)
		End If
		
		Return Self
	End Method
	
	Method ResetFadespeed:TMusicChannel()
		fadespeed = DEFAULT_FADESPEED
		Return Self
	End Method
	
	Function Load:TMusicChannel(fileName:String, maxVol:Float = 1.0)
		Local c:TMusicChannel = New TMusicChannel
		c.file = filename
		c.snd = LoadSound(filename, SOUND_LOOP)
		c.maxVol = maxVol
		c.pause = False
		c.volumeFactor = 1.0
		Return c
	End Function

	Method Restart(fadeIn:Byte)
		channel = Null
		channel = PlaySound(snd, channel)
		If (fadeIn)
			state = FADE_IN
			volume = 0.0
		Else
			state = CH_PLAYING
			volume = maxVol
		End If
		SetVolume(volume)
	End Method
	
	Method Play(fadeIn:Byte)
		If (fadeIn) Then State = FADE_IN Else State = CH_PLAYING
		If (channel)
			channel.SetPaused(False)
			If (Not ChannelPlaying(channel))
				Restart(fadeIn)
			End If
		Else
			Restart(fadeIn)
		End If		
	End Method
	
	Method Update()
		If (Not channel Or Not ChannelPlaying(channel)) Then Return
		If (state = FADE_IN)
			volume :+ FADESPEED
			If (volume >= maxVol) Then volume = maxVol ; State = CH_PLAYING ; DebugLog "Maxvol reached: " + maxVol
			SetVolume(volume)
		Else If (state = FADE_OUT)
			volume :- FADESPEED
			If (volume <= 0)
				volume = 0
				If (pause)
					channel.SetPaused(True)
				Else
					pause = False
					channel.Stop()
				End If
			End If
			SetVolume(volume)
		End If
	End Method
	
	Method SetVolume(volume:Float)
		If (channel)
			channel.SetVolume(volume * volumeFactor)
		End If
	End Method
	
	Method UpdateVolume()
		If (channel)
			channel.SetVolume(volume * volumeFactor)
		End If
	End Method
	
	Method FadeOut(Pause:Byte = False)
		If (ChannelPlaying(channel))
			State = FADE_OUT
			Self.Pause = Pause
		End If
	End Method
End Type


