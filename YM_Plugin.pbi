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
; Initalize YM
;*****************************************************************************

;/****** SNDH_Plugin.pbi/YM_OpenLibrary **************************************
;* 
;*   NAME	
;* 	     YM_OpenLibrary -- Opens SNDH dll.
;*
;*   SYNOPSIS
;*	     long library = YM_OpenLibrary(library.s=#YM2149SSND_PLUGIN)
;*
;*   FUNCTION
;*       Prototype the DLL functions.
;*
;*   INPUTS
;* 	     string library - can be ignored if the dll is in the location
;*       held in #YM2149SSND_PLUGIN, else you can pass your own path.
;*	
;*   RESULT
;*       library pointer - value passed back from OpenLibrary()
;* 	     error - #False
;* 
;*****************************************************************************
Procedure RML_YM_OpenLibrary(library.s=#YM2149SSND_PLUGIN)
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
    
    SoundServer::p\library = dll_plugin
  Else 
    ProcedureReturn #False 
  EndIf
  ProcedureReturn dll_plugin
EndProcedure

;/****** SNDH_Plugin.pbi/SNDH_Close ******************************************
;* 
;*   NAME	
;* 	     YM_Close -- Shut down YM dll
;*
;*   FUNCTION
;*       Closes the server library currently open. While it might seem still
;*       ridiculous to wrapper such a function as CloseLibrary() in this way
;*       it's future proofing, in the event that futre additions might require
;*       more deinitializing than just simply closing the library.
;* 
;*****************************************************************************
Procedure RML_YM_Close()
  CloseLibrary(SoundServer::p\library)
EndProcedure

;*****************************************************************************
; Sound Server Procedures
;*****************************************************************************

;/****** SNDH_Plugin.pbi/YM_Render *******************************************
;* 
;*   NAME	
;* 	     YM_Render -- calls SNDH render
;*
;*   SYNOPSIS
;*	     None  YM_Render(pMusic,*pBuffer,size.i)
;*
;*   FUNCTION
;*       Calls YM2149SSND.dll to render the tune to PCM for play back, this 
;*       Procedure is called by SoundServer, it's done this way for many
;*       reasons, mainly because each ??_Plugin.pbi / sound format or dll has
;*       it's own way of of rendering, so it's in the plugin just in case
;*       we need to do other things, not just the over simplification here.
;*
;*   INPUTS
;* 	     pMusic - 
;*       *pBuffer -
;*       int size -
;* 
;*****************************************************************************
Procedure RML_YM_Render(pmusic,*pBuffer,size.i)
  Protected nbSample   
  If (pMusic)
    nbSample = size >> 1;    
    YM_ComputePCM(pMusic,*pBuffer,nbSample); 
  EndIf 
EndProcedure

;
; Play Thread 
;
Procedure RML_YM_Play(*sound)
  Debug "--- Play Thread ---"
  Repeat  
    Delay(1) 
  ForEver
EndProcedure 

;
; Stop
;
Procedure RML_YM_Stop()
EndProcedure 

;
; Pause
;
Procedure RML_YM_Pause()
EndProcedure

;/****** YM_Plugin.pbi/YM_Initialize_SoundServer *****************************
;* 
;*   NAME	
;* 	     YM_Initialize_SoundServer -- sets up Soundserver
;*
;*   FUNCTION
;*       Initializes the SoundServer with the appropriate procedures to call
;*       for playing tunes in YM format, we keep these here because other
;*       ??_Plugin.pbi included would overwrite each other if all included at
;*       the same time, hence this should be step 1 in your code. 
;*
;*****************************************************************************
Procedure YM_Initialize_SoundServer()
  SoundServer::p\Render=@RML_YM_Render()
  SoundServer::p\Play=@RML_YM_Play()
  SoundServer::p\Stop=@RML_YM_Stop()
  SoundServer::p\Pause=@RML_YM_Pause()
EndProcedure

;*****************************************************************************
; Helpper Procedures
;*****************************************************************************



;*****************************************************************************
;                 !!ONLY!! -- Testing Purposes -- !!ONLY!!
;*****************************************************************************
; IDE Options = PureBasic 6.03 LTS (Windows - x86)
; CursorPosition = 88
; FirstLine = 63
; Folding = --
; EnableXP
; DPIAware