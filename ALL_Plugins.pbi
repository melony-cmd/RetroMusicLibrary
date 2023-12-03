;
; Include all RML_Plugins
;
IncludeFile "SNDH_Plugin.pbi"
IncludeFile "YM_Plugin.pbi"

;
IncludeFile "Soxr_Processing_Plugin.pbi"

RML_SOXR_OpenLibrary()

;*****************************************************************************
; YM TEST
;*****************************************************************************

RML_YM_OpenLibrary()
RML_YM_Initialize_SoundServer()
  
If RML_YM_LoadMusic("Music/Decade3DDots.ym")   
  SoundServer::Play()
EndIf
    
Delay(5000)    

SoundServer::Pause()

Delay(1000)

SoundServer::Resume()

Delay(5000)

RML_YM_Close()

;*****************************************************************************
; SNDH TEST
;*****************************************************************************

RML_SNDH_Initialize_SoundServer()  
RML_SNDH_OpenLibrary()
  
info.SubSongInfo

If RML_SNDH_LoadMusic("Music/decade_demo-loader.sndh")=1
  SNDH_InitSubSong(1)
  SNDH_GetSubSongInfo(1,@info)   
   
  If info\year<>#Null
    Debug "info\musicName = "+PeekS(info\year,-1,#PB_Ascii)
  EndIf
    
  Debug "info\playerTickCount = "+Str(info\playerTickCount)
  Debug "info\playerTickRate = "+Str(info\playerTickRate)
  Debug "info\samplePerTick = "+Str(info\samplePerTick)
  Debug "info\subsongCount = "+Str(info\subsongCount)
    
  SoundServer::Play()
    
  Delay(3000)
    
  SoundServer::Stop()
Else
  Debug "Unable to open music file"
EndIf  

SoundServer::Stop()
  
RML_SNDH_Close()

RML_SOXR_Close()

; IDE Options = PureBasic 6.03 LTS (Windows - x86)
; CursorPosition = 9
; EnableXP
; DPIAware