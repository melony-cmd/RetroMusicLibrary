﻿;Author Idle 
;Windows x86 
;Requires "YM2149SSND.dll
;http://leonard.oxg.free.fr/download/StSound_1_43.zip

;*****************************************************************************
; Enumeration of File Format Types
;*****************************************************************************
Enumeration RML_TYPE
  #RML_YM2149SSND
  #RML_SNDH
  #RML_SIDPLAY3
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
    ; :: REMOVED FOR NOW AS IT'S FAR FAR FAR TO CRASH HAPPY!
    ; :: Don't get me wrong it's a really nice idea, it just doesn't work in practice.
    ; :: as it bombs with Invalid Memory Access. (Read Error at Address ####)
    ;*Stop
    ;*Play
    ;*Pause
    ;*Resume
    *Render
  EndStructure  
  p.STRUCT_PLUGIN
  
  Structure STRUCT_PROCESS_AUDIO
    libname.s                     ; name of library
    libaddr.l                     ; address of library
    libfunc.l                     ; single procedure address
    ;
    enabled.b                     ; is enabled = true /disabled = false
    priority.l                    ; [w.i.p] -127 to 127 order in which the processors are called.
    *liboutbuffer                 ; output processed memory buffer
    liboutbuffersize.l            ; size of processed memory buffer
  EndStructure  
  Global NewList pa.STRUCT_PROCESS_AUDIO()
  
  ;-Declare Plugin
  Declare Render_CallBack(pmusic,*pBuffer,size.i)
  Declare Open(pUserCallback,totalBufferedSoundLen.l=4000)
  Declare Close()
  Declare Stop()
  Declare Resume()
  Declare Play()
  Declare Pause()
  
  ;-Declare Process Audio
  Declare Add_Audio_Processor(libname.s,libaddr.l,libfunc.l,liboutbuffersize.l = 0,enabled=#True)
  Declare Remove_Audio_Processor(library.s)
  
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
    stop.b
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
  ;-Server Debug Log
  ;*****************************************************************************
  Procedure DebugServer(message.s)
    CompilerIf #DEBUG_SOUNDSERVER = #True
      If OpenFile(0,"DebugServer.log")
        FileSeek(0,Lof(0))
        WriteStringN(0,message)
        CloseFile(0)
      EndIf      
    CompilerEndIf
  EndProcedure
    
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
    
    DebugServer("totalBufferedSoundLen = "+Str(totalBufferedSoundLen))
    
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
    If s_audioserver\stop = #False
      waveOutPrepareHeader_(s_audioserver\m_hWaveOut,
                            @s_audioserver\m_waveHeader[s_audioserver\m_currentBuffer],
                            SizeOf(WAVEHDR));        
    
      waveOutWrite_(s_audioserver\m_hWaveOut,
                    @s_audioserver\m_waveHeader[s_audioserver\m_currentBuffer],
                    SizeOf(WAVEHDR));      
    EndIf
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
      If s_audioserver\stop = #False
        CallFunctionFast(SoundServer::p\Render,pMusic,*pBuffer,nbSample)
        ;
        ; Generial Concept:
        ; Each 'processing' library has a single function that takes a *pBuffer and the size of the
        ; memory buffer, this buffer is the decoded pcm audio genorated by a ??_Plugin.
        ;
        ; The problem: therefore *pBuffer is no longer the valid audio buffer, it's also a cyclic 
        ; problem, meaning there maybe quite a few audio processors all working on the same data.
        ;
        ; ** Because we don't have anything currently that actually outputs data that isn't a pile
        ; of corruption we shall pause development here, though the general idea would be to 
        ; free/backup & reuse *pBuffer'n'size or just overwrite *pbuffer with the address to the
        ; newest version of the buffer, which might be processed by the next audio processor and
        ; so on.
        ; 
        ; There is a priority structure item that has an intended use case to process the audio
        ; after render in a certain order.
        ;
        ; maybe this is where we might in future add VSTs 32/64? but not today.
        ;
        ForEach pa()
          If (pa()\libfunc<>0) And (pa()\enabled=#True)
            CallFunctionFast(pa()\libfunc,*pBuffer,size.i)
          EndIf          
        Next        
      EndIf
    EndIf        
  EndProcedure 
  
  ;*****************************************************************************
  ;-Server Commands
  ;*****************************************************************************
      
  ;
  ;
  ;
  Procedure Play()
    ; Must ensure SoundServer is closed before play start.
    SoundServer::Close()
    
    If SoundServer::Open(@Render_CallBack(),500)
      s_audioserver\stop = #False
    EndIf    
  EndProcedure
  
  ;
  ;
  ;
  Procedure Stop()
    s_audioserver\stop = #True
  EndProcedure
  
  ;
  ;
  ;
  Procedure Pause()
    s_audioserver\stop = #True
  EndProcedure
  
  ;
  ;
  ;
  Procedure Resume()
    s_audioserver\stop = #False
    FillNextBuffer()
  EndProcedure
  
  ;*****************************************************************************
  ;-Process Audio
  ;*****************************************************************************
  
  ;
  ;
  ;
  Procedure Add_Audio_Processor(libname.s,libaddr.l,libfunc.l,liboutbuffersize.l = 0, enabled=#True)
    AddElement(pa())
    pa()\libname = libname
    pa()\libaddr = libaddr
    pa()\libfunc = libfunc
    pa()\enabled = enabled
    If liboutbuffersize<>0 And enabled=#True
      pa()\liboutbuffer = AllocateMemory(liboutbuffersize)
      pa()\liboutbuffersize = liboutbuffersize
    EndIf    
  EndProcedure
  
  ;
  ;
  ;
  Procedure Remove_Audio_Processor(libraryname.s)
    ForEach pa()
      If pa()\libname=libraryname
        If pa()\liboutbuffer
          FreeMemory(pa()\liboutbuffer)
        EndIf        
        CloseLibrary(pa()\libaddr)
        DeleteElement(pa())
      EndIf      
    Next    
  EndProcedure
  
EndModule 

; IDE Options = PureBasic 6.03 LTS (Windows - x86)
; CursorPosition = 263
; FirstLine = 235
; Folding = ---
; EnableXP
; DPIAware