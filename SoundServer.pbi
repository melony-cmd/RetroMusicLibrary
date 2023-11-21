;Author Idle 
;Windows x86 
;Requires "YM2149SSND.dll
;http://leonard.oxg.free.fr/download/StSound_1_43.zip

;*****************************************************************************
; Declaration of Sound Server
;*****************************************************************************
DeclareModule SoundServer  
  
  #REPLAY_RATE	=	44100
  #REPLAY_DEPTH	=	16
  #REPLAY_SAMPLELEN	= (#REPLAY_DEPTH/8)
  #REPLAY_NBSOUNDBUFFER	= 2
  
  ;
  ; _Plugin - Procedure Addresses
  ;
  Structure STRUCT_PLUGIN
    ; Current Plugin (.dll pointer)
    library.l
    ; Procedure Addresses
    Stop.l
    Play.l
    Pause.l
    Render.l
  EndStructure  
  p.STRUCT_PLUGIN
  
  ;
  ; w.i.p
  ;
  Structure STRUCT_PUBLIC_AUDIOSERVER 
    tid.i
    kill.i
    type.l
    pause.l
    *sndh_mem
    m_pmusic.l
    m_bufferSize.l
    m_currentBuffer.l
    m_hWaveOut.l 
    m_waveHeader.WAVEHDR[#REPLAY_NBSOUNDBUFFER]
    *m_pSoundBuffer[#REPLAY_NBSOUNDBUFFER]
    *m_pUserCallback.pUSERCALLBACK 	 
  EndStructure 
  
  Declare Open(*this,pUserCallback,totalBufferedSoundLen.l=4000)
  Declare Close(*this)
  Declare Play(*this)
  
EndDeclareModule 

;*****************************************************************************
; Sound Server
;*****************************************************************************
Module SoundServer
   
  Prototype pUSERCALLBACK(pmusic,*pBuffer,bufferlen.l)
  
  Structure STRUCT_AUDIOSERVER 
    tid.i
    kill.i
    type.l
    pause.l
    *sndh_mem
    m_pmusic.l
    m_bufferSize.l
    m_currentBuffer.l
    m_hWaveOut.l 
    m_waveHeader.WAVEHDR[#REPLAY_NBSOUNDBUFFER]
    *m_pSoundBuffer[#REPLAY_NBSOUNDBUFFER]
    *m_pUserCallback.pUSERCALLBACK 	 
  EndStructure  
  
  Declare FillNextBuffer(*this.STRUCT_AUDIOSERVER)
  
  ;*****************************************************************************
  ;-Server WaveOut
  ;*****************************************************************************
  
  ;
  ;
  ;
  Procedure WaveOutProc(hwo.l,uMsg.l,dwInstance.l,dwParam1.l,dwParam2.l)
    Protected *pserver.STRUCT_AUDIOSERVER    
    If (#WOM_DONE = uMsg)      
      *pServer = dwInstance;
      If *pServer        
        If *pServer\m_pUserCallback <> #Null 
          FillNextBuffer(*pServer)
        EndIf   
      EndIf 
    EndIf     
  EndProcedure 
  
  ;
  ;
  ;
  Procedure Open(*this.STRUCT_AUDIOSERVER,pUserCallback,totalBufferedSoundLen.l=4000)    
    *this\m_pUserCallback = pUserCallback;
    *this\m_bufferSize = ((totalBufferedSoundLen * #REPLAY_RATE) / 1000) * #REPLAY_SAMPLELEN
    *this\m_bufferSize / #REPLAY_NBSOUNDBUFFER
    
    Protected  wfx.WAVEFORMATEX	
    wfx\wFormatTag = 1
    wfx\nChannels = 1
    wfx\nSamplesPerSec = #REPLAY_RATE;
    wfx\nAvgBytesPerSec = #REPLAY_RATE * #REPLAY_SAMPLELEN
    wfx\nBlockAlign = #REPLAY_SAMPLELEN
    wfx\wBitsPerSample = #REPLAY_DEPTH
    wfx\cbSize = 0
    errCode = waveOutOpen_(@*this\m_hWaveOut,#WAVE_MAPPER,@wfx,@WaveOutProc(),*this,#CALLBACK_FUNCTION)
    
    If (errCode <> #MMSYSERR_NOERROR)
      ProcedureReturn #False
    EndIf 
    
    For i=0 To #REPLAY_NBSOUNDBUFFER-1
      *this\m_pSoundBuffer[i] = AllocateMemory(*this\m_bufferSize)
    Next 
    
    *this\m_currentBuffer = 0
    For i=0 To #REPLAY_NBSOUNDBUFFER-1
      FillNextBuffer(*this)
    Next 
    ProcedureReturn #True
  EndProcedure 
  
  ;
  ;
  ;
  Procedure Close(*this.STRUCT_AUDIOSERVER)    
    If  *this\m_pUserCallback <> #Null      
      *this\m_pUserCallback = #Null
      waveOutReset_(*this\m_hWaveOut)					
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
  Procedure  FillNextBuffer(*this.STRUCT_AUDIOSERVER)       
    If *this\m_waveHeader[*this\m_currentBuffer]\dwFlags & #WHDR_PREPARED 
      waveOutUnprepareHeader_(*this\m_hWaveOut,@*this\m_waveHeader[*this\m_currentBuffer],SizeOf(WAVEHDR));
    EndIf 
    
    If (*this\m_pUserCallback)
      *this\m_pUserCallback(*this,*this\m_pSoundBuffer[*this\m_currentBuffer],*this\m_bufferSize)
    EndIf 
    
    If *this\pause 
      FillMemory(*this\m_pSoundBuffer[*this\m_currentBuffer],*this\m_bufferSize,0,#PB_Unicode) 
    EndIf   
    
    *this\m_waveHeader[*this\m_currentBuffer]\lpData = *this\m_pSoundBuffer[*this\m_currentBuffer];
    *this\m_waveHeader[*this\m_currentBuffer]\dwBufferLength = *this\m_bufferSize                 ;
    waveOutPrepareHeader_(*this\m_hWaveOut,@*this\m_waveHeader[*this\m_currentBuffer],SizeOf(WAVEHDR));        
    waveOutWrite_(*this\m_hWaveOut,@*this\m_waveHeader[*this\m_currentBuffer],SizeOf(WAVEHDR));
     
    *this\m_currentBuffer+1
    If *this\m_currentBuffer >= #REPLAY_NBSOUNDBUFFER
      *this\m_currentBuffer = 0;
    EndIf           
  EndProcedure 
  
  ;
  ;
  ;
  Procedure Callback(pmusic,*pBuffer,size.i)
    Protected nbSample       
    If (pMusic)
      nbSample = size >> 1;
      ;instead references the structure above to find the address in ??_Plugin.pbi to render.      
      CallFunctionFast(SoundServer::p\Render,pMusic,*pBuffer,nbSample)
    EndIf        
  EndProcedure 
  ;
  ;
  ;
  
  
  
  ;*****************************************************************************
  ;-Server Commands
  ;*****************************************************************************
  
  ;
  ; 
  ;
  Procedure Play(*sound.STRUCT_AUDIOSERVER)
    If Not IsThread(*sound\tid)
      *sound\tid = CreateThread(SoundServer::p\Play,*sound)  
    EndIf
  EndProcedure
  
EndModule 

; CompilerIf #PB_Compiler_IsMainFile  
;   
;   UseModule YMPLAYER  
;   
;   sound = YMLoad("Decade3DDots.ym") 
;   sound1 = YMLoad("Union Tcb 2.ym") 
;   YMplay(sound) 
;   Delay(1000) 
;   YMPause(sound)
;   YMplay(sound1) 
;   Delay(1000)
;   YMpause(sound1) 
;   YMResume(sound) 
;   Delay(1000) 
;   YMresume(sound1)
;   Delay(3000) 
;   YMFree(sound1) 
;   
;   Repeat
;     Delay(20) 
;   Until YMIsOver(sound)  
;   YMFree(sound) 
;   
;   Debug "waited" 
;   
; CompilerEndIf 
; IDE Options = PureBasic 6.03 LTS (Windows - x86)
; CursorPosition = 212
; FirstLine = 177
; Folding = --
; EnableXP
; DPIAware