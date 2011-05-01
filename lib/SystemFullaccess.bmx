
SuperStrict

?Win32
	Import "external/SystemFullaccess.cpp"
	Import "-ladvapi32"

	Const PATH_SEPERATOR:String = "\"
	
	Extern "Win32"
	Function SHGetSpecialFolderLocation:Int(hwndOwner:Int, nFolder:Int, pIdl:Byte Ptr)
	Function SHGetPathFromIDList:Int(pidList:Int, lpBuffer:Byte Ptr)
	
	Function CreateFile(lpString:Byte Ptr,dwDesiredAccess:Int,dwShareMode:Int,..
		lpSecurityAttributes:Byte Ptr,dwCreationDisposition:Int,dwFlagsAndAttributes:Int,hWnd:Int)
	End Extern
	
	Extern
		Function GiveDirectoryUserFullAccess:Int(lpPath$z)
	EndExtern
	
	Const CSIDL_DESKTOP:Int = $0
	Const CSIDL_INTERNET:Int = $1
	Const CSIDL_PROGRAMS:Int = $2
	Const CSIDL_CONTROLS:Int = $3
	Const CSIDL_PRINTERS:Int = $4
	Const CSIDL_PERSONAL:Int = $5
	Const CSIDL_FAVORITES:Int = $6
	Const CSIDL_STARTUP:Int = $7
	Const CSIDL_RECENT:Int = $8
	Const CSIDL_SENDTO:Int = $9
	Const CSIDL_BITBUCKET:Int = $A
	Const CSIDL_STARTMENU:Int = $B
	Const CSIDL_DESKTOPDIRECTORY:Int = $10
	Const CSIDL_DRIVES:Int = $11
	Const CSIDL_NETWORK:Int = $12
	Const CSIDL_NETHOOD:Int = $13
	Const CSIDL_FONTS:Int = $14
	Const CSIDL_TEMPLATES:Int = $15
	Const CSIDL_COMMON_STARTMENU:Int = $16
	Const CSIDL_COMMON_PROGRAMS:Int = $17
	Const CSIDL_COMMON_STARTUP:Int = $18
	Const CSIDL_COMMON_DESKTOPDIRECTORY:Int = $19
	Const CSIDL_APPDATA:Int = $1A
	Const CSIDL_PRINTHOOD:Int = $1B
	Const CSIDL_LOCAL_APPDATA:Int = $1C
	Const CSIDL_ALTSTARTUP:Int = $1D
	Const CSIDL_COMMON_ALTSTARTUP:Int = $1E
	Const CSIDL_COMMON_FAVORITES:Int = $1F
	Const CSIDL_INTERNET_CACHE:Int = $20
	Const CSIDL_COOKIES:Int = $21
	Const CSIDL_HISTORY:Int = $22
	Const CSIDL_COMMON_APPDATA:Int = $23
?

?MacOs
	Const PATH_SEPERATOR:String = "/"
	Const kUserDomain:Int=-32763
	Const kVolumeRootFolderType:Int=Asc("r") Shl 24 | Asc("o") Shl 16 | Asc( "o") Shl 8 | Asc("t")
	
	Extern
		Function FSFindFolder( vRefNum:Int,folderType:Int,createFolder:Byte,foundRef:Byte Ptr )
		Function FSRefMakePath( ref:Byte Ptr,path:Byte Ptr,maxPathsize:Int )
	End Extern
?

Type TSystemFullaccess	
	Global Path:String

	Function GetSpecialFolder:String(folder_id:Int)		
		?Win32 
			Local  idl:TBank = CreateBank (8) 
			Local  pathbank:TBank = CreateBank (260) 
			If SHGetSpecialFolderLocation(0,folder_id,BankBuf(idl)) = 0		
				SHGetPathFromIDList PeekInt( idl,0), BankBuf(pathbank)
				Return String.FromCString(pathbank.Buf()) + PATH_SEPERATOR
			EndIf
		?
		?MacOs
			Local buf:Byte[1024],ref:Byte[80]
		
			If FSFindFolder( kUserDomain,kVolumeRootFolderType,False,ref ) Then Return PATH_SEPERATOR + "Library" + PATH_SEPERATOR + "Preferences" + PATH_SEPERATOR
			If FSRefMakePath( ref,buf,1024 ) Then Return PATH_SEPERATOR + "Library" + PATH_SEPERATOR + "Preferences" + PATH_SEPERATOR
		
			Return String.FromCString( buf ) + PATH_SEPERATOR + "Library" + PATH_SEPERATOR + "Preferences" + PATH_SEPERATOR
		?
	End Function
	
	Function SetPath(mypath:String)
		DebugLog "SetPath: " + mypath
		?Win32
			Path = GetSpecialFolder(CSIDL_COMMON_APPDATA)+mypath
		?
		?MacOs
			Path = GetSpecialFolder(0)+mypath
		?
		If ReadDir(Path) = 0 Then
			DebugLog "Creating New Folder: "+Path
			DebugLog "CreateDir="+CreateDir(Path,True) 'create subfolders
			?Win32
				DebugLog "FullAccess="+GiveDirectoryUserFullAccess(Path)
			?
		Else
			DebugLog "Folder already exists: "+Path
		EndIf		
	End Function

	Function GetPath:String()
		DebugLog "GET PATH...."
		If (Path = "") Then SetPath(AppTitle + PATH_SEPERATOR)
		Return Path
	End Function	
End Type