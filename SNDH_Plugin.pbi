;Author Idle 
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
Procedure SNDH_Play(*sound)
  *this.SoundServer::STRUCT_PUBLIC_AUDIOSERVER
  CopyStructure(*sound,*this, SoundServer::STRUCT_PUBLIC_AUDIOSERVER)
  
  If SoundServer::Open(*this,SoundServer::p\Render,500)
    Repeat  
      Delay(1) 
    Until *this\kill 
    SoundServer::Close(*this);
    If MemorySize(*this\sndh_mem) 
      FreeMemory(*this\sndh_mem)
    EndIf 
    FreeMemory(*this) 
    *this = 0 
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
; Arguments = FileName
; Results = 0 = Failure, 1 = Success

;
; nb: in theory sndh_mem should be stored in STRUCT_AUDIOSERVER
; however STRUCT_AUDIOSERVER is inaccessable as its private to SoundServer
; this shouldn't matter anyway as once SNDH_Load() has been given the
; memory containing the sndh file data, sndh_mem becomes orphaned by vertue
; of SNDH_Load() internally decompressing the sndh file from ICE and thus
; it is now working from the decompressed data not the memory we gave it.
;

; All of that said; it's quite possible to have an uncompressed sndh file
; though rare! so it should not be assumed that we can actually free it,
; now if we was talking about flac/mp3 or other formats I'd be really 
; concerned about over memory usage.

; thus it's commented out for now.

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
      ; FreeMemory(sndh_mem)                  
    EndIf      
    CloseFile(fn)
  EndIf  
  ProcedureReturn result
EndProcedure

;
;
; 
  
;*****************************************************************************
;                 !!ONLY!! -- Testing Purposes -- !!ONLY!!
;*****************************************************************************
SNDH_OpenLibrary()

If SNDH_LoadMusic("decade_demo-loader.sndh")=1
  SNDH_InitSubSong(1)
EndIf

SNDH_CloseLibrary()
; IDE Options = PureBasic 6.03 LTS (Windows - x86)
; CursorPosition = 88
; FirstLine = 23
; Folding = --
; EnableXP
; DPIAware