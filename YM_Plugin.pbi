;Author Idle 
;Windows x86 
;Requires "YM2149SSND.dll"
;http://leonard.oxg.free.fr/download/StSound_1_43.zip

#YM2149SSND_PLUGIN = "x86_Plugins/YM2149SSND.dll"

Enumeration
  #YM_REG_PERIOD_VOICE_A
  #YM_REG_FINE_PERIOD_VOICE_A
  #YM_REG_PERIOD_VOICE_B
  #YM_REG_FINE_PERIOD_VOICE_B
  #YM_REG_PERIOD_VOICE_C
  #YM_REG_FINE_PERIOD_VOICE_C
  #YM_REG_NOISE_PERIOD
  #YM_REG_MIXER_CONTROL
  #YM_REG_VOLUME_A
  #YM_REG_VOLUME_B
  #YM_REG_VOLUME_C
  #YM_REG_ENVELOPE_HIGH_PERIOD
  #YM_REG_ENVELOPE_LOW_PERIOD
  #YM_REG_ENVELOPE_SHAPE
  #YM_REG_EXTENDED_DATA1
  #YM_REG_EXTENDED_DATA2
EndEnumeration

;*****************************************************************************
; Structure YM
;*****************************************************************************

Structure ymMusicInfo
  *pSongName
  *pSongAuthor
  *pSongComment
  *pSongType
  *pSongPlayer
  musicTimeInSec.l
  musicTimeInMs.l
EndStructure

;*****************************************************************************
; Prototypes YM
;*****************************************************************************

PrototypeC   YM_Destroy(*pMusic)                        : Global YM_Destroy.YM_Destroy
PrototypeC   YM_Init()                                  : Global YM_Init.YM_Init
PrototypeC.b YM_LoadFile(*pMusic,file.p-Ascii)          : Global YM_LoadFile.YM_LoadFile
PrototypeC.b YM_LoadFromMemory(*pMusic,*pBlock,size.i)  : Global YM_LoadFromMemory.YM_LoadFromMemory
PrototypeC   YM_Play(*pMusic)                           : Global YM_Play.YM_Play
PrototypeC.b YM_ComputePCM(*pMusic,*pBuffer,nbSample.i) : Global YM_ComputePCM.YM_ComputePCM
PrototypeC   YM_Information(*pMusic,*Info)              : Global YM_Information.YM_Information

PrototypeC   YM_LowpassFilter(*pMusic,bActive.b)        : Global YM_LowpassFilter.YM_LowpassFilter
PrototypeC   YM_SetLoopMode(*pMusic,bLoop.b)            : Global YM_SetLoopMode.YM_SetLoopMode
PrototypeC.s YM_GetLastError(*pMusic)                   : Global YM_GetLastError.YM_GetLastError
PrototypeC.i YM_GetRegister(*pMusic,reg.i)              : Global YM_GetRegister.YM_GetRegister
PrototypeC   YM_Pause(*pMusic)                          : Global YM_Pause.YM_Pause
PrototypeC   YM_Stop(*pMusic)                           : Global YM_Stop.YM_Stop
PrototypeC.b YM_IsOver(*pMusic)                         : Global YM_IsOver.YM_IsOver
PrototypeC   YM_Restart(*pMusic)                        : Global YM_Restart.YM_Restart
PrototypeC.b YM_IsSeekable(*pMusic)                     : Global YM_IsSeekable.YM_IsSeekable
PrototypeC.l YM_GetPosition(*pMusic)                    : Global YM_GetPosition.YM_GetPosition
PrototypeC   YM_MusicSeek(*pMusic,timeInMs.l)           : Global YM_MusicSeek.YM_MusicSeek

IncludeFile "SoundServer.pbi"

;*****************************************************************************
; Initalize SNDH
;*****************************************************************************

Procedure YM_OpenLibrary(library.s=#YM2149SSND_PLUGIN)
  plugin = OpenLibrary(#PB_Any,#YM2149SSND_PLUGIN)
  If plugin
    YM_Init = GetFunction(plugin, "YM_Init")
    YM_Destroy = GetFunction(plugin, "YM_Destroy")
    YM_LoadFile = GetFunction(plugin, "YM_LoadFile")
    YM_LoadFromMemory = GetFunction(plugin, "YM_LoadFromMemory")    
    YM_Play = GetFunction(plugin, "YM_Play")
    YM_ComputePCM = GetFunction(plugin, "YM_ComputePCM")
    YM_Information = GetFunction(plugin, "YM_Information")
    
    YM_LowpassFilter = GetFunction(plugin, "YM_LowpassFilter")
    YM_SetLoopMode = GetFunction(plugin, "YM_SetLoopMode")
    YM_GetLastError = GetFunction(plugin, "YM_GetLastError")
    YM_GetRegister = GetFunction(plugin, "YM_GetRegister")
    YM_Pause = GetFunction(plugin, "YM_Pause")
    YM_Stop = GetFunction(plugin, "YM_Stop")
    YM_IsOver = GetFunction(plugin, "YM_IsOver")
    YM_Restart = GetFunction(plugin, "YM_Restart")
    YM_IsSeekable = GetFunction(plugin, "YM_IsSeekable")
    YM_GetPosition = GetFunction(plugin, "YM_GetPosition")
    YM_MusicSeek = GetFunction(plugin, "YM_MusicSeek")  
  Else 
    MessageRequester("error","Can't open YM2149SSND.dll") 
  EndIf
EndProcedure

;*****************************************************************************
; Sound Server Procedures
;*****************************************************************************

;
; Render Procedure for Source Server
;
; * We can call this name anything we like, however obviously we're likely to prefix it with the format in which it is rendering.
; 
Procedure YM_Render(pmusic,*pBuffer,size.i)
  Protected nbSample   
  If (pMusic)
    nbSample = size >> 1;    
    YM_ComputePCM(pMusic,*pBuffer,nbSample); 
  EndIf 
EndProcedure : SoundServer::p\Render=@YM_Render()

;*****************************************************************************
; Helpper Procedures
;*****************************************************************************



;*****************************************************************************
;                 !!ONLY!! -- Testing Purposes -- !!ONLY!!
;*****************************************************************************
; IDE Options = PureBasic 6.03 LTS (Windows - x86)
; CursorPosition = 25
; Folding = -
; EnableXP
; DPIAware