
;/*
; *  AtariMachine C __declspec(dllexport)
; */
;void AtariM_Startup(uint32_t hostReplayRate);
PrototypeC AtariM_Startup(hostReplayRate.i) : Global AtariM_Startup.AtariM_Startup

;/*
; *  SndhFile C __declspec(dllexport)
; */
;bool SNDH_Load(const void* rawSndhFile, int sndhFileSize, uint32_t hostReplayRate);
;void SNDH_Unload();
;bool SNDH_InitSubSong(int subSongId);
;int SNDH_AudioRender(int16_t * buffer, int count, uint32_t * pSampleViewInfo);
;int SNDH_GetSubsongCount();
;int SNDH_GetDefaultSubsong();
;const void *SNDH_GetRawData();
;int SNDH_GetRawDataSize();
PrototypeC SNDH_Load(*rawSndhFile,sndhFileSize.i,hostReplayRate.i) : Global SNDH_Load.SNDH_Load
PrototypeC SNDH_Unload() : Global SNDH_Unload.SNDH_Unload
PrototypeC SNDH_InitSubSong(subSongId.i) : Global SNDH_InitSubSong.SNDH_InitSubSong
PrototypeC SNDH_AudioRender(*buffer,count.i,*pSampleViewInfo = 0) : Global SNDH_AudioRender.SNDH_AudioRender

PrototypeC SNDH_GetSubsongCount() : Global SNDH_GetSubsongCount.SNDH_GetSubsongCount
PrototypeC SNDH_GetDefaultSubsong() : Global SNDH_GetDefaultSubsong.SNDH_GetDefaultSubsong
PrototypeC SNDH_GetRawData() : Global SNDH_GetRawData.SNDH_GetRawData
PrototypeC SNDH_GetRawDataSize() : Global SNDH_GetRawDataSize.SNDH_GetRawDataSize


If OpenLibrary(0,"Sndh_DLL.dll")
  
  Debug("OPENED: Sndh_DLL.dll")
  AtariM_Startup = GetFunction(0, "AtariM_Startup")
  
  SNDH_GetSubsongCount = GetFunction(0, "SNDH_GetSubsongCount")
  SNDH_GetDefaultSubsong = GetFunction(0, "SNDH_GetDefaultSubsong")
  SNDH_GetRawData = GetFunction(0, "SNDH_GetRawData")
  SNDH_GetRawDataSize = GetFunction(0, "SNDH_GetRawDataSize")
  
  SNDH_Load = GetFunction(0, "SNDH_Load")
  SNDH_Unload = GetFunction(0, "SNDH_Unload")
  SNDH_InitSubSong = GetFunction(0, "SNDH_InitSubSong")
  SNDH_AudioRender = GetFunction(0, "SNDH_AudioRender")
  
  ;Decade_Demo-Main_Menu.sndh
  ;ReadData()
  file.s = "Decade_Demo-Main_Menu.sndh"
  filesize.l = FileSize(file)
  If OpenFile(0,file)    
    Debug("OPENED: "+file)    
    *memfilebuf_ptr = AllocateMemory(filesize)  ;// Memory Area for loaded file
    *memsndhbuf_ptr = AllocateMemory(44100*4)   ;// Memory Area for Audio PCM data    
    *memsampleviewbuf_ptr = AllocateMemory(512) ;// Memory Area for pSampleViewInfo for visual data of audio.
    ReadData(0,*memfilebuf_ptr,filesize)    
    CloseFile(0)
        
    ; next passed to SNDH ??
    Debug "SNDH_Load()"
    If SNDH_Load(*memfilebuf_ptr,filesize,44100)=1
      FreeMemory(*memfilebuf_ptr)                ;// It's likely been decompressed or it's raw either way we don't need this memory anymore.
      Debug "EJECT : FreeMemory(*memfilebuf_ptr)"      
      Debug "SNDH_Load() : Yarp! Loaded"      
      Debug "SNDH_GetRawData == "+Str(SNDH_GetRawData())
      Debug "SNDH_GetRawDataSize == "+Str(SNDH_GetRawDataSize())
      Debug "SNDH_GetSubsongCount == "+Str(SNDH_GetSubsongCount())
      Debug "SNDH_InitSubSong == "+Str(SNDH_InitSubSong(1))
      Debug "SNDH_GetDefaultSubsong == "+Str(SNDH_GetDefaultSubsong())
      
      If CreateFile(0,"raw.sndh")
        WriteData(0,SNDH_GetRawData(),SNDH_GetRawDataSize())
        CloseFile(0)
      EndIf
      ShowMemoryViewer(*memsndhbuf_ptr,512)
      
      If CreateFile(0,"raw.sndh.pcm")
        For i = 0 To 51200
          SNDH_AudioRender(*memsndhbuf_ptr,512,*memsampleviewbuf_ptr)      
          WriteData(0,*memsndhbuf_ptr,512)
        Next
        CloseFile(0)
      EndIf      
      SNDH_AudioRender(*memsndhbuf_ptr,512,*memsampleviewbuf_ptr)      
    
    EndIf
  EndIf
    
  CloseLibrary(0)
Else
  Debug("FAILED: Open Sndh_DLL.dll")  
EndIf

; IDE Options = PureBasic 6.03 LTS (Windows - x64)
; CursorPosition = 75
; FirstLine = 45
; EnableXP
; DPIAware