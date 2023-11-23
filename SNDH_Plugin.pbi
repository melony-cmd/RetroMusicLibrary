;Author Idle 
;Windows x86 
;Requires "SNDH.dll"
;http://leonard.oxg.free.fr/download/StSound_1_43.zip

#SNDH_DEBUG_PLUGIN = #True

#SNDH_PLUGIN = "x86_Plugins/SNDH.dll"

;*****************************************************************************
; Structure SNDH
;*****************************************************************************

Structure SubSongInfo
    subsongCount.i
    playerTickCount.i
    playerTickRate.i
    samplePerTick.i
    *musicName
    *musicAuthor
    *year
EndStructure

;*****************************************************************************
; Prototypes SNDH
;*****************************************************************************

PrototypeC.b SNDH_Load(*rawSndhFile,sndhFileSize.i,hostReplayRate.i) : Global SNDH_Load.SNDH_Load
PrototypeC   SNDH_Unload()                                           : Global SNDH_Unload.SNDH_Unload
PrototypeC.b SNDH_InitSubSong(subSongId.i)                           : Global SNDH_InitSubSong.SNDH_InitSubSong
PrototypeC.i SNDH_AudioRender(*buffer,count.i,*pSampleViewInfo = 0)  : Global SNDH_AudioRender.SNDH_AudioRender
PrototypeC.i SNDH_GetSubsongCount()                                  : Global SNDH_GetSubsongCount.SNDH_GetSubsongCount
PrototypeC.i SNDH_GetDefaultSubsong()                                : Global SNDH_GetDefaultSubsong.SNDH_GetDefaultSubsong
PrototypeC.b SNDH_GetSubSongInfo(subSongId.i,*pinfo)                 : Global SNDH_GetSubSongInfo.SNDH_GetSubSongInfo 

PrototypeC   SNDH_GetRawData()                                       : Global SNDH_GetRawData.SNDH_GetRawData
PrototypeC.i SNDH_GetRawDataSize()                                   : Global SNDH_GetRawDataSize.SNDH_GetRawDataSize

IncludeFile "SoundServer.pbi"

;*****************************************************************************
; Initalize SNDH
;*****************************************************************************

;
; SNDH - OpenLibrary
;
Procedure SNDH_OpenLibrary(library.s=#SNDH_PLUGIN)  
  dll_plugin = OpenLibrary(#PB_Any,library)
  If dll_plugin
    SNDH_Load = GetFunction(dll_plugin, "SNDH_Load")
    SNDH_Unload = GetFunction(dll_plugin, "SNDH_Unload")
    SNDH_InitSubSong = GetFunction(dll_plugin, "SNDH_InitSubSong")
    SNDH_AudioRender = GetFunction(dll_plugin, "SNDH_AudioRender")    
    SNDH_GetSubsongCount = GetFunction(dll_plugin, "SNDH_GetSubsongCount")
    SNDH_GetDefaultSubsong = GetFunction(dll_plugin, "SNDH_GetDefaultSubsong")
    SNDH_GetSubsongInfo = GetFunction(dll_plugin, "SNDH_GetSubsongInfo")  
    SNDH_GetRawData = GetFunction(dll_plugin, "SNDH_GetRawData")
    SNDH_GetRawDataSize = GetFunction(dll_plugin, "SNDH_GetRawDataSize")
    
    SoundServer::p\library = dll_plugin
  Else 
    MessageRequester("error","Can't open "+library) 
  EndIf  
EndProcedure

;
; SNDH - Close Library
;
Procedure SNDH_CloseLibrary()
  CloseLibrary(SoundServer::p\library)
EndProcedure

;*****************************************************************************
; Sound Server Procedures
;*****************************************************************************

;
; Render Procedure for Source Server
;
Procedure SNDH_Render(pmusic,*pBuffer,size.i)
  Protected nbSample
  If (pMusic)
    SNDH_AudioRender(*pBuffer,size)
  EndIf 
EndProcedure : SoundServer::p\Render=@SNDH_Render()

;
; Play Thread 
;
Procedure SNDH_Play(*sound)
  Debug "--- Play Thread ---"
  Repeat  
    Delay(1) 
  ForEver
EndProcedure : SoundServer::p\Play=@SNDH_Play()

;
; Stop
;
Procedure SNDH_Stop()
EndProcedure : SoundServer::p\Stop=@SNDH_Stop()

;
; Pause
;
Procedure SNDH_Pause()
  Debug "-=Pause=-"
EndProcedure : SoundServer::p\Pause=@SNDH_Pause()

;*****************************************************************************
; Helpper Procedures
;*****************************************************************************

; Load Song
; Arguments = FileName
; Results = 0 = Failure, 1 = Success

; nb: in theory sndh_mem should be stored in STRUCT_AUDIOSERVER
; however STRUCT_AUDIOSERVER is inaccessable as its private to SoundServer
; this shouldn't matter anyway as once SNDH_Load() has been given the
; memory containing the sndh file data, sndh_mem becomes orphaned by vertue
; of SNDH_Load() internally decompressing the sndh file from ICE and thus
; it is now working from the decompressed data not the memory we gave it.

; All of that said; it's quite possible to have an uncompressed sndh file
; though rare! so it should not be assumed that we can actually free it,
; now if we was talking about flac/mp3 or other formats I'd be really 
; concerned about over memory usage, even still it does now free the memory.

Procedure.l SNDH_LoadMusic(file.s) 
  fn = OpenFile(#PB_Any,file)
  If fn
    filesize = FileSize(file) 
    sndh_mem = AllocateMemory(filesize)
    If sndh_mem
      ReadData(fn,sndh_mem,filesize)       
      result = SNDH_Load(sndh_mem,filesize,44100)
      ; we no longer need the file anymore SNDH.dll 
      ; has used ICE to decompress it.
      FreeMemory(sndh_mem)                  
    EndIf      
    CloseFile(fn)
  EndIf  
  ProcedureReturn result
EndProcedure
  
;*****************************************************************************
;                 !!ONLY!! -- Testing Purposes -- !!ONLY!!
;*****************************************************************************
CompilerIf #SNDH_DEBUG_PLUGIN = #True  
  SNDH_OpenLibrary()
  
  info.SubSongInfo
  
  If SNDH_LoadMusic("decade_demo-loader.sndh")=1
    SNDH_InitSubSong(1)
    SNDH_GetSubSongInfo(1,@info)   
    Debug "info\musicName = "+PeekS(info\musicName,-1,#PB_Ascii)
    Debug "info\Author = "+PeekS(info\musicAuthor,-1,#PB_Ascii)
    
    If info\year<>#Null
      Debug "info\musicName = "+PeekS(info\year,-1,#PB_Ascii)
    EndIf
    
    Debug "info\playerTickCount = "+Str(info\playerTickCount)
    Debug "info\playerTickRate = "+Str(info\playerTickRate)
    Debug "info\samplePerTick = "+Str(info\samplePerTick)
    Debug "info\subsongCount = "+Str(info\subsongCount)
    
    SoundServer::Play()
    
    Delay(25000)    
  EndIf  
  SNDH_CloseLibrary()
CompilerEndIf
; IDE Options = PureBasic 6.03 LTS (Windows - x86)
; CursorPosition = 175
; FirstLine = 133
; Folding = --
; EnableXP
; DPIAware