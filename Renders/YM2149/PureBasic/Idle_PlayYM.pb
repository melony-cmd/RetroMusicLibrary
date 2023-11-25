;*****************************************************************************
; Include: CSoundServer.pbi
; Author: Idle (11/15/23)
; Forum Link: https://www.purebasic.fr/english/viewtopic.php?t=82858&start=30
;*****************************************************************************

Prototype pUSERCALLBACK(*pBuffer,bufferlen.l)  

#REPLAY_RATE	=	44100
#REPLAY_DEPTH	=	16
#REPLAY_SAMPLELEN	= (#REPLAY_DEPTH/8)
#REPLAY_NBSOUNDBUFFER	= 2

Structure CSoundServer 
  m_Wnd.l
  m_bufferSize.l
  m_currentBuffer.l
  m_hWaveOut.l                                            ;HWAVEOUT
  m_waveHeader.WAVEHDR[#REPLAY_NBSOUNDBUFFER]
  *m_pSoundBuffer[#REPLAY_NBSOUNDBUFFER]
  *m_pUserCallback.pUSERCALLBACK 	 
EndStructure   

Macro IsRunning() 
  m_pUserCallback <> #Null
EndMacro   

Global CSoundServer.CSoundServer  
Declare CSoundServer_fillNextBuffer(*this.CSoundServer)

;
;
;
;// Internal WaveOut API callback function. We just call our sound handler ("playNextBuffer")
Procedure waveOutProc(hwo.l,uMsg.l,dwInstance.l,dwParam1.l,dwParam2.l)
  Protected *pserver.CSoundServer  
  If (#WOM_DONE = uMsg)    
    *pServer = dwInstance
    If *pServer     
      If *pServer\IsRunning()
        CSoundServer_fillNextBuffer(*pServer)
      EndIf   
    EndIf 
  EndIf   
EndProcedure 

;
;
;
Procedure CSoundServer_open(*this.CSoundServer,pUserCallback,totalBufferedSoundLen.l=4000)  
  *this\m_pUserCallback = pUserCallback
  *this\m_bufferSize = ((totalBufferedSoundLen * #REPLAY_RATE) / 1000) * #REPLAY_SAMPLELEN
  *this\m_bufferSize / #REPLAY_NBSOUNDBUFFER                                              
  
  Protected  wfx.WAVEFORMATEX	
  wfx\wFormatTag = 1                      ;// PCM standart.
  wfx\nChannels = 1                       ;// Mono
  wfx\nSamplesPerSec = #REPLAY_RATE
  wfx\nAvgBytesPerSec = #REPLAY_RATE * #REPLAY_SAMPLELEN
  wfx\nBlockAlign = #REPLAY_SAMPLELEN                 
  wfx\wBitsPerSample = #REPLAY_DEPTH                  
  wfx\cbSize = 0                                      
  errCode = waveOutOpen_(@*this\m_hWaveOut,#WAVE_MAPPER,@wfx,@waveOutProc(),*this,#CALLBACK_FUNCTION)
  
  If (errCode <> #MMSYSERR_NOERROR)
    ProcedureReturn #False
  EndIf 
  ;// Alloc the sample buffers.
  
  For i=0 To #REPLAY_NBSOUNDBUFFER-1
    *this\m_pSoundBuffer[i] = AllocateMemory(*this\m_bufferSize)
  Next 
  
  ;// Fill all the sound buffers
  *this\m_currentBuffer = 0
  For i=0 To #REPLAY_NBSOUNDBUFFER-1
    CSoundServer_fillNextBuffer(*this)
  Next 
  ProcedureReturn #True
EndProcedure 

;
;
;
Procedure CSoundServer_close(*this.CSoundServer)  
  If *this\IsRunning()    
    *this\m_pUserCallback = #Null             ;
    waveOutReset_(*this\m_hWaveOut)           ;// Reset tout.
    For i=0 To #REPLAY_NBSOUNDBUFFER-1      
      If *this\m_waveHeader[i]\dwFlags & #WHDR_PREPARED
        waveOutUnprepareHeader_(*this\m_hWaveOut,@*this\m_waveHeader[i],SizeOf(WAVEHDR))
      EndIf  
      FreeMemory(*this\m_pSoundBuffer[i])
    Next 
    waveOutClose_(*this\m_hWaveOut)
  EndIf   
EndProcedure 

;
;
;
Procedure  CSoundServer_fillNextBuffer(*this.CSoundServer)  
  ;// check If the buffer is already prepared (should Not !)
  If *this\m_waveHeader[*this\m_currentBuffer]\dwFlags & #WHDR_PREPARED 
    waveOutUnprepareHeader_(*this\m_hWaveOut,@*this\m_waveHeader[*this\m_currentBuffer],SizeOf(WAVEHDR))
  EndIf 
  ;// Call the user function To fill the buffer With anything you want ! :-)
  If (*this\m_pUserCallback)
    *this\m_pUserCallback(*this\m_pSoundBuffer[*this\m_currentBuffer],*this\m_bufferSize)
  EndIf 
  ;// Prepare the buffer To be sent To the WaveOut API
  *this\m_waveHeader[*this\m_currentBuffer]\lpData = *this\m_pSoundBuffer[*this\m_currentBuffer]
  *this\m_waveHeader[*this\m_currentBuffer]\dwBufferLength = *this\m_bufferSize
  waveOutPrepareHeader_(*this\m_hWaveOut,@*this\m_waveHeader[*this\m_currentBuffer],SizeOf(WAVEHDR))
  
  ;// Send the buffer the the WaveOut queue
  waveOutWrite_(*this\m_hWaveOut,@*this\m_waveHeader[*this\m_currentBuffer],SizeOf(WAVEHDR))
  
  *this\m_currentBuffer+1
  If *this\m_currentBuffer >= #REPLAY_NBSOUNDBUFFER
    *this\m_currentBuffer = 0
  EndIf     
EndProcedure 

;*****************************************************************************
; Probably should split into include files.
;*****************************************************************************

;-ymMusicInfo

Structure ymMusicInfo
	*pSongName
	*pSongAuthor
	*pSongComment
	*pSongType
	*pSongPlayer
	musicTimeInSec.l
	musicTimeInMs.l
EndStructure

PrototypeC YM_Init() : Global YM_Init.YM_Init
PrototypeC YM_Destroy(*pMusic) : Global YM_Destroy.YM_Destroy
PrototypeC.b YM_LoadFile(*pMusic,file.p-Ascii) : Global YM_LoadFile.YM_LoadFile
PrototypeC.b YM_LoadFromMemory(*pMusic,*pBlock,size.i) : Global YM_LoadFromMemory.YM_LoadFromMemory
PrototypeC YM_Play(*pMusic) : Global YM_Play.YM_Play
PrototypeC.b YM_ComputePCM(*pMusic,*pBuffer,nbSample.i) : Global YM_ComputePCM.YM_ComputePCM
PrototypeC YM_Information(*pMusic,*Info) : Global YM_Information.YM_Information
PrototypeC YM_LowpassFilter(*pMusic,bActive.b) : Global YM_LowpassFilter.YM_LowpassFilter
PrototypeC YM_SetLoopMode(*pMusic,bLoop.b) : Global YM_SetLoopMode.YM_SetLoopMode
PrototypeC.s YM_GetLastError(*pMusic) : Global YM_GetLastError.YM_GetLastError
PrototypeC.i YM_GetRegister(*pMusic,reg.i) : Global YM_GetRegister.YM_GetRegister
PrototypeC YM_Pause(*pMusic) : Global YM_Pause.YM_Pause
PrototypeC YM_Stop(*pMusic) : Global YM_Stop.YM_Stop
PrototypeC.b YM_IsOver(*pMusic) : Global YM_IsOver.YM_IsOver
PrototypeC YM_Restart(*pMusic) : Global YM_Restart.YM_Restart
PrototypeC.b YM_IsSeekable(*pMusic) : Global YM_IsSeekable.YM_IsSeekable
PrototypeC.l YM_GetPosition(*pMusic) : Global YM_GetPosition.YM_GetPosition
PrototypeC  YM_MusicSeek(*pMusic,timeInMs.l) : Global YM_MusicSeek.YM_MusicSeek

Global pmusic,pos  

Procedure SoundServerCallback(*pBuffer,size.i)
  Protected nbSample     
  Debug YM_GetPosition(pMusic) 
  Debug size 
  If (pMusic)
		nbSample = size / 2;    
		YM_ComputePCM(pMusic,*pBuffer,nbSample); 
	EndIf 	
EndProcedure 

If OpenLibrary(0,"D:\Work\Code\SDK\StSoundPackage\Release\YM2149SSND.dll")
  Debug "Library Open"
  
  YM_Init = GetFunction(0, "YM_Init")
  YM_Destroy = GetFunction(0, "YM_Destroy")
  YM_LoadFile = GetFunction(0, "YM_LoadFile")
  YM_LoadFromMemory = GetFunction(0, "YM_LoadFromMemory")    
  YM_Play = GetFunction(0, "YM_Play")
  YM_ComputePCM = GetFunction(0, "YM_ComputePCM")
  YM_Information = GetFunction(0, "YM_Information")  
  YM_LowpassFilter = GetFunction(0, "YM_LowpassFilter")
  YM_SetLoopMode = GetFunction(0, "YM_SetLoopMode")
  YM_GetLastError = GetFunction(0, "YM_GetLastError")
  YM_GetRegister = GetFunction(0, "YM_GetRegister")
  YM_Pause = GetFunction(0, "YM_Pause")
  YM_Stop = GetFunction(0, "YM_Stop")
  YM_IsOver = GetFunction(0, "YM_IsOver")
  YM_Restart = GetFunction(0, "YM_Restart")
  YM_IsSeekable = GetFunction(0, "YM_IsSeekable")
  YM_GetPosition = GetFunction(0, "YM_GetPosition")
  YM_MusicSeek = GetFunction(0, "YM_MusicSeek")
     
  ; Bring sally up.
  pMusic = YM_Init()        
  If pMusic
    file.s = "Music/Big - Warhawk.ym" ; "Decade3DDots.ym"
    If YM_LoadFile(pMusic,file)        
      YM_LowpassFilter(pmusic,1)   
      
      ymInfo.ymMusicInfo
      YM_Information(pMusic,@ymInfo)
      
      If ymInfo\pSongName 
        Debug PeekS(ymInfo\pSongName,-1,#PB_Ascii)
      EndIf 
      
      Debug PeekS(ymInfo\pSongComment,-1,#PB_Ascii)
      Debug PeekS(ymInfo\pSongPlayer,-1,#PB_Ascii)
      Debug PeekS(ymInfo\pSongType,-1,#PB_Ascii)
      Debug PeekS(ymInfo\pSongAuthor,-1,#PB_Ascii)
      Debug "time in ms " + Str(ymInfo\musicTimeInMs)
      len = ymInfo\musicTimeInMs   
    
      If CsoundServer_open(CSoundServer,@soundServerCallback(),500)        
        YM_Play(pMusic)
        et = ElapsedMilliseconds() + len 
        Repeat  
           Delay(1) 
        Until ElapsedMilliseconds() > et  
        CsoundServer_close(CSoundServer);
      EndIf
      
      ; Bring sally down.
      YM_Destroy(pMusic)
    EndIf 
  EndIf 
  CloseLibrary(0)
Else
  Debug "Balls!"  
EndIf    


; IDE Options = PureBasic 6.03 LTS (Windows - x86)
; CursorPosition = 16
; Folding = --
; EnableXP
; DPIAware