
SuperStrict

Import BRL.Map
Import "MusicChannel.bmx"

Type TSoundManager
	Global instance:TSoundManager
	
	Const SFX_CHANNELS:Int = 8
	
	Field musicChannels:TMap
	Field sfxSounds:TMap
	Field globalMusicVolume:Float
	Field globalSfxVolume:Float
	
	Function GetInstance:TSoundManager()
		If (Not instance)
			instance = New TSoundManager
		End If
		Return instance
	End Function
	
	Method PreloadSoundEffects(sfxFilenames:String[])
		For Local I:Int = 0 To sfxFilenames.Length - 1
			LoadSfx(sfxFilenames[I])
		Next
	End Method
	
	Method LoadSfx(file:String)
		Local sfxCh:TSound = TSound(sfxSounds.ValueForKey(file))
		If (Not sfxCh)
			Local s:TSound = LoadSound(file)
			If (Not s) Then RuntimeError("sfx file not found: " + file)
			sfxSounds.Insert(file, s)
		End If
	End Method
	
	Method PlaySfx:TChannel(file:String, maxVol:Float = 1.0, pan:Float = 0.0, channel:TChannel = Null)
		Local sfxCh:TSound = TSound(sfxSounds.ValueForKey(file))
		?Debug
		If (Not sfxCh) Then DebugLog "WARNING! Sound " + file + " not loaded!"
		?
		If (sfxCh)
			channel = CueSound(sfxCh)
			SetChannelVolume(channel, globalSfxVolume * maxVol)
			SetChannelPan(channel, pan)
			ResumeChannel(channel)
		End If
		Return channel
	End Method
	
	Method FreeMusic()
		musicChannels.Clear()
	End Method
	
	Method FreeSfx()
		sfxSounds.Clear()
	End Method
	
	Method FreeAll()
		FreeMusic()
		FreeSfx()
	End Method
	
	Method New()
		musicChannels = CreateMap()
		sfxSounds = CreateMap()
	End Method
	
	Method Update()
		For Local mc:TMusicChannel = EachIn musicChannels.Values()
			mc.Update()
		Next
	End Method
	
	Method UpdateVolume()
		For Local mc:TMusicChannel = EachIn musicChannels.Values()
			mc.volumeFactor = globalMusicVolume
			mc.UpdateVolume()
		Next
	End Method

	Method StopMusic()
		For Local mc:TMusicChannel = EachIn musicChannels.Values()
			mc.FadeOut()
		Next
	End Method
	
	Method PauseMusic()
		For Local mc:TMusicChannel = EachIn musicChannels.Values()
			mc.FadeOut(True)
		Next
	End Method
	
	Method LoadAndPlayMusic:TMusicChannel(name:String, maxVol:Float = 1.0)
		DebugLog "LoadAndPlayMusic " + name
		Local newMusicCh:TMusicChannel = TMusicChannel(musicChannels.ValueForKey(name))
		If (Not newMusicCh)
			DebugLog "New Channel created: " + name + "vol: " + maxVol
			newMusicCh = TMusicChannel.Load(name, maxVol)
			If (Not newMusicCh) Then RuntimeError "Music " + name + " + could not be loaded!"
			musicChannels.Insert(name, newMusicCh)
		End If
		
		newMusicCh.Play(True)
		newMusicCh.State = TMusicChannel.FADE_IN

		UpdateVolume()
		
		Return newMusicCh
	End Method
End Type
