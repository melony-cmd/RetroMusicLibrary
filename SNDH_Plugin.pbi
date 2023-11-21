﻿;Author Idle 
;Windows x86 
;Requires "SNDH.dll"
;http://leonard.oxg.free.fr/download/StSound_1_43.zip
#SNDH_PLUGIN = "x86_Plugins/SNDH.dll"
  
Structure SubSongInfo
    subsongCount.i
    playerTickCount.i
    playerTickRate.i
    samplePerTick.i
    *musicName
    *musicAuthor
    *year
EndStructure

PrototypeC.b SNDH_Load(*rawSndhFile,sndhFileSize.i,hostReplayRate.i) : Global SNDH_Load.SNDH_Load
PrototypeC   SNDH_Unload()                                           : Global SNDH_Unload.SNDH_Unload
PrototypeC.b SNDH_InitSubSong(subSongId.i)                           : Global SNDH_InitSubSong.SNDH_InitSubSong
PrototypeC.i SNDH_AudioRender(*buffer,count.i,*pSampleViewInfo = 0)  : Global SNDH_AudioRender.SNDH_AudioRender
PrototypeC.i SNDH_GetSubsongCount()                                  : Global SNDH_GetSubsongCount.SNDH_GetSubsongCount
PrototypeC.i SNDH_GetDefaultSubsong()                                : Global SNDH_GetDefaultSubsong.SNDH_GetDefaultSubsong
PrototypeC.b SNDH_GetSubsongInfo(subSongId.i,*sndhinfo);

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
    nbSample = size >> 1;    
    SNDH_AudioRender(*pBuffer,nbSample)
  EndIf 
EndProcedure : SoundServer::p\Render=@SNDH_Render

;
; Play Thread 
;
Procedure SNDH_Play(*sound.STRUCT_PUBLIC_AUDIOSERVER)    
  If SoundServer::SoundServer_Open(*sound,SoundServer::p\Render,500)
    Repeat  
      Delay(1) 
    Until *sound\kill 
    CsoundServer_close(*sound);
    If MemorySize(*sound\sndh_mem) 
      FreeMemory(*sound\sndh_mem)
    EndIf 
    FreeMemory(*sound) 
    *sound = 0 
  EndIf 
EndProcedure : SoundServer::p\Play=@SNDH_Play

;
; Stop
;
Procedure SNDH_Stop()
EndProcedure : SoundServer::p\Stop=@SNDH_Stop

;
; Pause
;
Procedure SNDH_Pause()
EndProcedure : SoundServer::p\Stop=@SNDH_Pause

;*****************************************************************************
; Helpper Procedures
;*****************************************************************************

;
; Load Song
;
Procedure.l SNDH_LoadFile(file.s) 
  fn = OpenFile(#PB_Any,file)
  If fn
    filesize = FileSize(file) 
    sndh_mem = AllocateMemory(filesize)
    If sndh_mem
      ReadData(fn,sndh_mem,filesize)       
      *sound = SNDH_Load(sndh_mem,filesize,44100)
      ; we no longer need the file anymore SNDH.dll 
      ; has used ICE to decompress it.
      FreeMemory(sndh_mem)                          
    EndIf      
    CloseFile(fn)
    If *sound
      ProcedureReturn *sound 
    EndIf
  EndIf  
EndProcedure

;
;
; 
  
;*****************************************************************************
;                 !!ONLY!! -- Testing Purposes -- !!ONLY!!
;*****************************************************************************
SNDH_OpenLibrary()

sound = SNDH_LoadFile("decade_demo-loader.sndh")
SNDH_InitSubSong(1)



Debug sound


SNDH_CloseLibrary()
; IDE Options = PureBasic 6.03 LTS (Windows - x86)
; CursorPosition = 82
; FirstLine = 54
; Folding = --
; EnableXP
; DPIAware