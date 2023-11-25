;Author Idle 
;Windows x86 
;Requires "YM2149SSND.dll
;http://leonard.oxg.free.fr/download/StSound_1_43.zip

;*****************************************************************************
; Enumeration of File Format Types
;*****************************************************************************
Enumeration
  #RML_YM2149SSND
  #RML_SNDH
EndEnumeration

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
    ; Initilization
    init.l
    ; Current Plugin (.dll pointer)
    library.l
    ; Procedure Addresses
    *Stop
    *Play
    *Pause
    *Render
  EndStructure  
  p.STRUCT_PLUGIN
  
  Declare Render_CallBack(pmusic,*pBuffer,size.i)
  Declare Open(pUserCallback,totalBufferedSoundLen.l=4000)
  Declare Close()
  Declare Play()
  
EndDeclareModule 

;*****************************************************************************
; Sound Server
;*****************************************************************************
Module SoundServer
  
  #DEBUG_SOUNDSERVER = #False
  
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
  
  Global s_audioserver.STRUCT_AUDIOSERVER
  
  Declare FillNextBuffer()
  
  ;*****************************************************************************
  ;-Server WaveOut
  ;*****************************************************************************
  
  ;
  ;
  ;
  Procedure WaveOut_CallBack(hwo.l,uMsg.l,dwInstance.l,dwParam1.l,dwParam2.l)
    Protected *pserver.STRUCT_AUDIOSERVER
    If (#WOM_DONE = uMsg)      
      *pServer = dwInstance;
      If *pServer        
        If *pServer\m_pUserCallback <> #Null 
          FillNextBuffer()
        EndIf   
      EndIf 
    EndIf     
  EndProcedure 
  
  ;
  ;
  ;
  Procedure Open(pUserCallback,totalBufferedSoundLen.l=4000)    
    s_audioserver\m_pUserCallback = pUserCallback;
    s_audioserver\m_bufferSize = ((totalBufferedSoundLen * #REPLAY_RATE) / 1000) * #REPLAY_SAMPLELEN
    s_audioserver\m_bufferSize / #REPLAY_NBSOUNDBUFFER
    
    Protected  wfx.WAVEFORMATEX	
    wfx\wFormatTag = 1
    wfx\nChannels = 1
    wfx\nSamplesPerSec = #REPLAY_RATE;
    wfx\nAvgBytesPerSec = #REPLAY_RATE * #REPLAY_SAMPLELEN
    wfx\nBlockAlign = #REPLAY_SAMPLELEN
    wfx\wBitsPerSample = #REPLAY_DEPTH
    wfx\cbSize = 0
    errCode = waveOutOpen_(@s_audioserver\m_hWaveOut,#WAVE_MAPPER,@wfx,@WaveOut_CallBack(),s_audioserver,#CALLBACK_FUNCTION)
    
    If (errCode <> #MMSYSERR_NOERROR)
      ProcedureReturn #False
    EndIf 
    
    For i=0 To #REPLAY_NBSOUNDBUFFER-1
      s_audioserver\m_pSoundBuffer[i] = AllocateMemory(s_audioserver\m_bufferSize)
    Next 
    
    s_audioserver\m_currentBuffer = 0
    For i=0 To #REPLAY_NBSOUNDBUFFER-1
      FillNextBuffer()
    Next 
    ProcedureReturn #True
  EndProcedure 
  
  ;
  ;
  ;
  Procedure Close()    
    If  s_audioserver\m_pUserCallback <> #Null      
      s_audioserver\m_pUserCallback = #Null
      waveOutReset_(s_audioserver\m_hWaveOut)					
      For i=0 To #REPLAY_NBSOUNDBUFFER-1
        
        If s_audioserver\m_waveHeader[i]\dwFlags & #WHDR_PREPARED
          waveOutUnprepareHeader_(s_audioserver\m_hWaveOut,@s_audioserver\m_waveHeader[i],SizeOf(WAVEHDR))
        EndIf  
        FreeMemory(s_audioserver\m_pSoundBuffer[i])
      Next 
      waveOutClose_(s_audioserver\m_hWaveOut)
    EndIf     
  EndProcedure 
  
  ;
  ;
  ;
  Procedure  FillNextBuffer()       
    If s_audioserver\m_waveHeader[s_audioserver\m_currentBuffer]\dwFlags & #WHDR_PREPARED 
      waveOutUnprepareHeader_(s_audioserver\m_hWaveOut,@s_audioserver\m_waveHeader[s_audioserver\m_currentBuffer],SizeOf(WAVEHDR));
    EndIf 
    
    If (s_audioserver\m_pUserCallback)
      CompilerIf #DEBUG_SOUNDSERVER = #True
        Debug "FillNextBuffer()"
        Debug "SoundServer::p\Render="+Str(SoundServer::p\Render)
        Debug "SoundServer::p\Pause="+Str(SoundServer::p\Pause)
        Debug "s_audioserver\m_bufferSize="+Str(s_audioserver\m_bufferSize)     
        Debug "s_audioserver\m_currentBuffer="+Str(s_audioserver\m_currentBuffer)
        Debug "s_audioserver\m_pSoundBuffer="+Str(s_audioserver\m_pSoundBuffer)
      CompilerEndIf
      
      s_audioserver\m_pUserCallback(@Render_CallBack(),
                                    s_audioserver\m_pSoundBuffer[s_audioserver\m_currentBuffer],
                                    s_audioserver\m_bufferSize)
    EndIf 
    
    If s_audioserver\pause 
      FillMemory(s_audioserver\m_pSoundBuffer[s_audioserver\m_currentBuffer],s_audioserver\m_bufferSize,0,#PB_Unicode) 
    EndIf   
    
    s_audioserver\m_waveHeader[s_audioserver\m_currentBuffer]\lpData = s_audioserver\m_pSoundBuffer[s_audioserver\m_currentBuffer];
    s_audioserver\m_waveHeader[s_audioserver\m_currentBuffer]\dwBufferLength = s_audioserver\m_bufferSize
    ;
    waveOutPrepareHeader_(s_audioserver\m_hWaveOut,
                          @s_audioserver\m_waveHeader[s_audioserver\m_currentBuffer],
                          SizeOf(WAVEHDR));        
    
    waveOutWrite_(s_audioserver\m_hWaveOut,
                  @s_audioserver\m_waveHeader[s_audioserver\m_currentBuffer],
                  SizeOf(WAVEHDR));
       
    s_audioserver\m_currentBuffer+1
    If s_audioserver\m_currentBuffer >= #REPLAY_NBSOUNDBUFFER
      s_audioserver\m_currentBuffer = 0;
    EndIf           
  EndProcedure 
  
  ;
  ;
  ;
  Procedure Render_CallBack(pmusic,*pBuffer,size.i)
    Protected nbSample
    If (pMusic)
      nbSample = size >> 1;
      CompilerIf #DEBUG_SOUNDSERVER = #True
        Debug "Render_CallBack()"
        Debug "SoundServer::p\Render="+Str(SoundServer::p\Render)
        Debug "pMusic="+Str(pMusic)
        Debug "*pBuffer="+Str(*pBuffer)
        Debug "nbSample="+Str(nbSample)
      CompilerEndIf
      CallFunctionFast(SoundServer::p\Render,pMusic,*pBuffer,nbSample)      
    EndIf        
  EndProcedure 
  
  ;*****************************************************************************
  ;-Server Commands
  ;*****************************************************************************
     
  ;
  ; 
  ;
  Procedure Thread_Play(*sound.STRUCT_AUDIOSERVER)       
    If Not IsThread(*sound\tid)
      *sound\tid = CreateThread(SoundServer::p\Play,*sound)  
    EndIf        
  EndProcedure
  
  ;
  ;
  ;
  Procedure Play()    
    If SoundServer::Open(@Render_CallBack(),500)
      ;I don't understand the point of this thread?
      ;A. The callbacks function irrespective the thread existing or not.
      ;B. the thread other than looping doesn't do anything within the loop to either
      ;   fill the buffer or pretty much anything other than delay see point (a)           
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
; CursorPosition = 53
; FirstLine = 21
; Folding = --
; EnableXP
; DPIAware