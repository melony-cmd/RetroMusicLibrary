
DeclareModule YMPLAYER  
  
  Structure ymMusicInfo
    *pSongName
    *pSongAuthor
    *pSongComment
    *pSongType
    *pSongPlayer
    musicTimeInSec.l
    musicTimeInMs.l
  EndStructure
    
  Declare playFile(ymfile.s) 
  Declare resume(sound) 
  Declare pause(sound) 
  Declare stop(sound) 
  Declare Wait(sound) 
  Declare kill(sound) 
  
EndDeclareModule 

Module YMPLAYER 
  
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
    
Prototype pUSERCALLBACK(pmusic,*pBuffer,bufferlen.l)  

#REPLAY_RATE	=	44100
#REPLAY_DEPTH	=	16
#REPLAY_SAMPLELEN	= (#REPLAY_DEPTH/8)
#REPLAY_NBSOUNDBUFFER	= 2

Structure CSoundServer 
  tid.i
  m_pmusic.l
  m_bufferSize.l
  m_currentBuffer.l
  m_hWaveOut.l ;HWAVEOUT
  m_waveHeader.WAVEHDR[#REPLAY_NBSOUNDBUFFER];
  *m_pSoundBuffer[#REPLAY_NBSOUNDBUFFER]     ;
  *m_pUserCallback.pUSERCALLBACK 	 
EndStructure   

Declare CSoundServer_fillNextBuffer(*this.CSoundServer)

;// Internal WaveOut API callback function. We just call our sound handler ("playNextBuffer")
Procedure waveOutProc(hwo.l,uMsg.l,dwInstance.l,dwParam1.l,dwParam2.l)
  Protected *pserver.CSoundServer
  
  If (#WOM_DONE = uMsg)
    
    *pServer = dwInstance;
    If *pServer
      
      If *pServer\m_pUserCallback <> #Null 
        CSoundServer_fillNextBuffer(*pServer)
      EndIf   
    EndIf 
  EndIf 
  
  EndProcedure 
  
 Procedure CSoundServer_open(*this.CSoundServer,pUserCallback,totalBufferedSoundLen.l=4000)
   
  *this\m_pUserCallback = pUserCallback;
  *this\m_bufferSize = ((totalBufferedSoundLen * #REPLAY_RATE) / 1000) * #REPLAY_SAMPLELEN;
  *this\m_bufferSize / #REPLAY_NBSOUNDBUFFER                                              ;
  
  Protected  wfx.WAVEFORMATEX	
  wfx\wFormatTag = 1;		// PCM standart.
  wfx\nChannels = 1 ;		// Mono
  wfx\nSamplesPerSec = #REPLAY_RATE;
  wfx\nAvgBytesPerSec = #REPLAY_RATE * #REPLAY_SAMPLELEN;
  wfx\nBlockAlign = #REPLAY_SAMPLELEN                 ;
  wfx\wBitsPerSample = #REPLAY_DEPTH                  ;
  wfx\cbSize = 0                                      ;
  errCode = waveOutOpen_(@*this\m_hWaveOut,#WAVE_MAPPER,@wfx,@waveOutProc(),*this,#CALLBACK_FUNCTION);
  
  If (errCode <> #MMSYSERR_NOERROR)
    ProcedureReturn #False;
  EndIf 
  ;// Alloc the sample buffers.
  
  For i=0 To #REPLAY_NBSOUNDBUFFER-1
    *this\m_pSoundBuffer[i] = AllocateMemory(*this\m_bufferSize);
  Next 
  
  ;// Fill all the sound buffers
  *this\m_currentBuffer = 0;
  For i=0 To #REPLAY_NBSOUNDBUFFER-1
    CSoundServer_fillNextBuffer(*this);
  Next 
  ProcedureReturn #True;
EndProcedure 

Procedure CSoundServer_close(*this.CSoundServer)
  
  If  *this\m_pUserCallback <> #Null
    
    *this\m_pUserCallback = #Null;
    waveOutReset_(*this\m_hWaveOut);					// Reset tout.
    For i=0 To #REPLAY_NBSOUNDBUFFER-1
      
      If *this\m_waveHeader[i]\dwFlags & #WHDR_PREPARED
        waveOutUnprepareHeader_(*this\m_hWaveOut,@*this\m_waveHeader[i],SizeOf(WAVEHDR));
      EndIf  
      FreeMemory(*this\m_pSoundBuffer[i]);
    Next 
    waveOutClose_(*this\m_hWaveOut);
  EndIf 
  
EndProcedure 

Procedure  CSoundServer_fillNextBuffer(*this.CSoundServer)
  
  ;// check If the buffer is already prepared (should Not !)
  If *this\m_waveHeader[*this\m_currentBuffer]\dwFlags & #WHDR_PREPARED 
    waveOutUnprepareHeader_(*this\m_hWaveOut,@*this\m_waveHeader[*this\m_currentBuffer],SizeOf(WAVEHDR));
  EndIf 
  ;// Call the user function To fill the buffer With anything you want ! :-)
  If (*this\m_pUserCallback)
    *this\m_pUserCallback(*this\m_pmusic,*this\m_pSoundBuffer[*this\m_currentBuffer],*this\m_bufferSize);
  EndIf 
  ;// Prepare the buffer To be sent To the WaveOut API
  *this\m_waveHeader[*this\m_currentBuffer]\lpData = *this\m_pSoundBuffer[*this\m_currentBuffer];
  *this\m_waveHeader[*this\m_currentBuffer]\dwBufferLength = *this\m_bufferSize                  ;
  waveOutPrepareHeader_(*this\m_hWaveOut,@*this\m_waveHeader[*this\m_currentBuffer],SizeOf(WAVEHDR));
  
  ;// Send the buffer the the WaveOut queue
  waveOutWrite_(*this\m_hWaveOut,@*this\m_waveHeader[*this\m_currentBuffer],SizeOf(WAVEHDR));
  
  *this\m_currentBuffer+1
  If *this\m_currentBuffer >= #REPLAY_NBSOUNDBUFFER
    *this\m_currentBuffer = 0;
  EndIf   
  
EndProcedure 

;-ymMusicInfo

If OpenLibrary(0,"YM2149SSND.dll")
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
Else 
  MessageRequester("error","Can't open YM2149SSND.dll") 
  End 
EndIf    

Procedure SoundServerCallback(pmusic,*pBuffer,size.i)
  Protected nbSample   
   
  If (pMusic)
		nbSample = size >> 1;    
		YM_ComputePCM(pMusic,*pBuffer,nbSample); 
	EndIf 
	
EndProcedure 

Procedure play_thread(*sound.CSoundServer)
  
  Protected et,len,ymInfo.ymMusicInfo
  
  If *sound\m_pmusic 
  YM_Information(*sound\m_pmusic,@ymInfo)
  len = ymInfo\musicTimeInMs 
  
  If CsoundServer_open(*sound,@soundServerCallback(),500)
     YM_Play(*sound\m_pmusic)
     
        et = ElapsedMilliseconds() + len 
        Repeat  
          Delay(1) 
        Until ElapsedMilliseconds() > et  
       CsoundServer_close(*sound);
           
       YM_Destroy(*sound\m_pmusic) 
       FreeMemory(*sound) 
       
    EndIf 
  EndIf  
EndProcedure   

Procedure playFile(ymfile.s) 
  
  Protected  *sound.CSoundServer = AllocateMemory(SizeOf(CSoundServer))  
     
  *sound\m_pmusic = YM_Init()        
  If *sound\m_pmusic
    If YM_LoadFile(*sound\m_pmusic,ymfile) 
       *sound\tid = CreateThread(@play_thread(),*sound)  
    EndIf  
  EndIf           
  
  ProcedureReturn *sound   
  
EndProcedure   

Procedure stop(*sound.CSoundServer) 
   YM_Stop(*sound\m_pmusic)  
EndProcedure 

Procedure  pause(*sound.CSoundServer) 
   YM_Pause(*sound\m_pmusic)
EndProcedure   

Procedure resume(*sound.CSoundServer) 
   YM_Play(*sound\m_pmusic) 
EndProcedure   

Procedure Wait(*sound.CSoundServer) 
   WaitThread(*sound\tid) 
EndProcedure 

Procedure Kill(*sound.CSoundServer) 
  
  YM_Stop(*sound\m_pmusic)   
  KillThread(*sound\tid) 
  CsoundServer_close(*sound);
  YM_Destroy(*sound\m_pmusic) 
  FreeMemory(*sound) 
  
EndProcedure   

EndModule 

CompilerIf #PB_Compiler_IsMainFile  
  
  UseModule YMPLAYER  
    
  sound = playfile("Decade3DDots.ym") 
  Delay(1000) 
  sound1 = playfile("Decade3DDots.ym") 
  Delay(1000) 
  pause(sound1) 
  Delay(1000) 
  resume(sound1)
  Delay(1000) 
  kill(sound1) 
  
  wait(sound) 
  

CompilerEndIf 


; IDE Options = PureBasic 6.03 LTS (Windows - x86)
; CursorPosition = 281
; FirstLine = 206
; Folding = ---
; EnableXP
; DPIAware