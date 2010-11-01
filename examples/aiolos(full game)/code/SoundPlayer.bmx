
SuperStrict

Import BRL.RamStream
?Win32
	Import BRL.DirectSoundAudio
?Not Win32
	Import BRL.FreeAudioAudio
?
Import BRL.OGGLoader
Import BRL.PolledInput

Incbin "../data/sfx/collect1.ogg"
Incbin "../data/sfx/collect2.ogg"
Incbin "../data/sfx/collide.ogg"
Incbin "../data/sfx/door_open.ogg"
Incbin "../data/sfx/xplode.ogg"
Incbin "../data/sfx/music.ogg"

Type TSoundPlayer
	Global instance:TSoundPlayer
	
	Const SFX_COLLECT1:Int = 0
	Const SFX_COLLECT2:Int = 1
	Const SFX_COLLIDE:Int = 2
	Const SFX_OPENDOOR:Int = 3
	Const SFX_XPLODE:Int = 4
	Const NUM_SFX:Int = 5
	
	Field sounds:TSound[NUM_SFX]
	Field music:TSound, musicChannel:TChannel
	
	Function GetInstance:TSoundPlayer()
		If Not Self.instance
			Self.instance = New Self
		End If
		Return Self.instance
	End Function
	
	Method New()
		sounds[SFX_COLLECT1] = LoadSound("incbin::../data/sfx/collect1.ogg")
		sounds[SFX_COLLECT2] = LoadSound("incbin::../data/sfx/collect2.ogg")
		sounds[SFX_COLLIDE] = LoadSound("incbin::../data/sfx/collide.ogg")
		sounds[SFX_OPENDOOR] = LoadSound("incbin::../data/sfx/door_open.ogg")
		sounds[SFX_XPLODE] = LoadSound("incbin::../data/sfx/xplode.ogg")
		music = LoadSound("incbin::../data/sfx/music.ogg", SOUND_LOOP)
	End Method
	
	Method PlaySFX(sound:Int)
		PlaySound(sounds[sound])
	End Method	
	
	Method PlayMusic()
		musicChannel = PlaySound(music)
	End Method
	
	Method StopMusic()
		If (musicChannel)
			StopChannel(musicChannel)
		End If
	End Method
End Type
