﻿;YMPLAYER Module 
;Author Idle  
;Windows x86 
;Requires "YM2149SSND.dll and Sndh_DLL.dll built by inner
;                    
;http://leonard.oxg.free.fr/download/StSound_1_43.zip

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
  
  #YM  = 0 
  #SNDH = 1
  
  Declare YMLoad(ymfile.s,type=#YM)
  Declare YMLoadMemory(*adr,size,type=#YM) 
  Declare YMPlay(sound) 
  Declare YMResume(sound) 
  Declare YMPause(sound) 
  Declare YMStop(sound) 
  Declare YMFree(sound) 
  Declare YMIsOver(sound) 
  
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
  
  PrototypeC SNDH_Load(*rawSndhFile,sndhFileSize.i,hostReplayRate.i) : Global SNDH_Load.SNDH_Load
  PrototypeC SNDH_InitSubSong(subSongId.i) : Global SNDH_InitSubSong.SNDH_InitSubSong
  PrototypeC SNDH_AudioRender(*buffer,count.i,*pSampleViewInfo = 0) : Global SNDH_AudioRender.SNDH_AudioRender
    
  Prototype pUSERCALLBACK(pmusic,*pBuffer,bufferlen.l)  
  
  #REPLAY_RATE	=	44100
  #REPLAY_DEPTH	=	16
  #REPLAY_SAMPLELEN	= (#REPLAY_DEPTH/8)
  #REPLAY_NBSOUNDBUFFER	= 2
   
  
  Structure CSoundServer 
    tid.i
    kill.i
    type.l
    *sndh_mem
    m_pmusic.l
    m_bufferSize.l
    m_currentBuffer.l
    m_hWaveOut.l 
    m_waveHeader.WAVEHDR[#REPLAY_NBSOUNDBUFFER]
    *m_pSoundBuffer[#REPLAY_NBSOUNDBUFFER]
    *m_pUserCallback.pUSERCALLBACK 	 
  EndStructure   
  
  Declare CSoundServer_fillNextBuffer(*this.CSoundServer)
  
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
    errCode = waveOutOpen_(@*this\m_hWaveOut,#WAVE_MAPPER,@wfx,@waveOutProc(),*this,#CALLBACK_FUNCTION)
    
    If (errCode <> #MMSYSERR_NOERROR)
      ProcedureReturn #False
    EndIf 
    
    For i=0 To #REPLAY_NBSOUNDBUFFER-1
      *this\m_pSoundBuffer[i] = AllocateMemory(*this\m_bufferSize)
    Next 
    
    *this\m_currentBuffer = 0
    For i=0 To #REPLAY_NBSOUNDBUFFER-1
      CSoundServer_fillNextBuffer(*this)
    Next 
    ProcedureReturn #True
  EndProcedure 
  
  Procedure CSoundServer_close(*this.CSoundServer)
    
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
  
  Procedure  CSoundServer_fillNextBuffer(*this.CSoundServer)
    
    If *this\m_waveHeader[*this\m_currentBuffer]\dwFlags & #WHDR_PREPARED 
      waveOutUnprepareHeader_(*this\m_hWaveOut,@*this\m_waveHeader[*this\m_currentBuffer],SizeOf(WAVEHDR));
    EndIf 
    
    If (*this\m_pUserCallback)
      *this\m_pUserCallback(*this\m_pmusic,*this\m_pSoundBuffer[*this\m_currentBuffer],*this\m_bufferSize);
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
  
  ;-ymMusicInfo
  
  If OpenLibrary(0,"x86_Plugins/YM2149SSND.dll")
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
 
  If OpenLibrary(1,"x86_Plugins/SNDH.dll")
    Debug("OPENED: Sndh_DLL.dll")
    SNDH_Load = GetFunction(1, "SNDH_Load")
    SNDH_InitSubSong = GetFunction(1, "SNDH_InitSubSong")
    SNDH_AudioRender = GetFunction(1, "SNDH_AudioRender")
    
  Else    
    MessageRequester("error","Can't open Sndh_DLL.dll") 
    ;End 
  EndIf  
  
    
  Procedure SoundServerCallbackYM(pmusic,*pBuffer,size.i)
    Protected nbSample   
    
    If (pMusic)
       nbSample = size >> 1;    
       YM_ComputePCM(pMusic,*pBuffer,nbSample); 
    EndIf 
    
  EndProcedure 
  
  Procedure SoundServerCallbackSNHD(pmusic,*pBuffer,size.i)
    Protected nbSample   
    
    If (pMusic)
       nbSample = size >> 1;    
       SNDH_AudioRender(*pBuffer,nbSample)
    EndIf 
    
  EndProcedure 
   
  Procedure play_thread(*sound.CSoundServer)
    
    Protected et,len,ymInfo.ymMusicInfo
    
    If *sound\type = #YM 
      
      If *sound\m_pmusic 
        If CsoundServer_open(*sound,@soundServerCallbackYM(),500)
          YM_Play(*sound\m_pmusic)
          Repeat  
            Delay(1) 
          Until *sound\kill 
          CsoundServer_close(*sound);
          YM_Destroy(*sound\m_pmusic) 
          FreeMemory(*sound) 
          *sound = 0 
        EndIf 
      EndIf  
      
    ElseIf  *sound\type = #SNDH 
      
       If CsoundServer_open(*sound,@SoundServerCallbackSNHD(),500)
         If SNDH_InitSubSong(1)  
          Repeat  
            Delay(1) 
          Until *sound\kill 
         Else 
          ;error 
         EndIf   
         CsoundServer_close(*sound);
         If MemorySize(*sound\sndh_mem) 
           FreeMemory(*sound\sndh_mem)
         EndIf 
         FreeMemory(*sound) 
         *sound = 0 
      EndIf 
      
    EndIf  
       
    
  EndProcedure   
  
  Procedure  YMLoad(ymfile.s,type=#YM)  ;type = #YM or #SNDH
    Protected *sound.CSoundServer = AllocateMemory(SizeOf(CSoundServer))  
    If *sound 
      *sound\type = type 
      If *type = #YM 
        *sound\m_pmusic = YM_Init()  
        If *sound\m_pmusic
          If YM_LoadFile(*sound\m_pmusic,ymfile)     
            ProcedureReturn *sound 
          EndIf  
        EndIf 
      Else 
        fn= OpenFile(#PB_Any,ymfile)
        *sound\sndh_mem = AllocateMemory(filesize)
         ReadData(0,*sound\sndh_mem,filesize)       
        CloseFile(0)
        If SNDH_Load(*sound\sndh_mem,filesize,44100) 
          ProcedureReturn *sound 
        EndIf 
      EndIf 
    EndIf  
  EndProcedure   
  
  Procedure YMLoadMemory(*adr,size,type=#YM) 
    Protected *sound.CSoundServer = AllocateMemory(SizeOf(CSoundServer))  
    If *sound 
      If *type = #YM  
        *sound\m_pmusic = YM_Init()  
        If *sound\m_pmusic
          If YM_LoadFromMemory(*sound\m_pmusic,*adr,size)     
             ProcedureReturn *sound 
          EndIf  
        EndIf
      Else 
        *sound\sndh_mem=*adr
        If SNDH_Load(*sound\sndh_mem,size,44100) 
          ProcedureReturn *sound 
        EndIf 
      EndIf   
    EndIf   
  EndProcedure   
  
  Procedure YMPlay(*sound.CSoundServer) 
    If Not IsThread(*sound\tid)
      *sound\tid = CreateThread(@play_thread(),*sound)  
    EndIf   
  EndProcedure   
  
  Procedure YMStop(*sound.CSoundServer) 
    If *sound\type = #YM 
      YM_Stop(*sound\m_pmusic) 
    Else 
      PauseThread(*sound\tid) 
    EndIf   
  EndProcedure 
  
  Procedure YMPause(*sound.CSoundServer) 
     If *sound\type = #YM 
       YM_Pause(*sound\m_pmusic)
     Else 
       If IsThread(*sound\tid) 
         PauseThread(*sound\tid) 
       EndIf   
     EndIf   
  EndProcedure   
  
  Procedure YMResume(*sound.CSoundServer) 
    If *sound\type = #YM 
      YM_Play(*sound\m_pmusic)
    Else 
       If IsThread(*sound\tid) 
         ResumeThread(*sound\tid) 
       EndIf   
    EndIf   
  EndProcedure   
  
  Procedure YMFree(*sound.CSoundServer) 
    
    If *sound\type = #YM  
      YM_Stop(*sound\m_pmusic)   
      *sound\kill = 1
      If IsThread(*sound\tid) 
        WaitThread(*sound\tid) 
      EndIf   
    Else 
     *sound\kill = 1
      If IsThread(*sound\tid) 
        WaitThread(*sound\tid) 
      EndIf        
    EndIf 
    
  EndProcedure   
  
  Procedure YMIsOver(*sound.CSoundServer) 
    If *sound\type = #YM 
      ProcedureReturn YM_IsOver(*sound\m_pmusic)
    EndIf   
  EndProcedure  
  
EndModule 

CompilerIf #PB_Compiler_IsMainFile  
  
  UseModule YMPLAYER  
  
  sound = YMLoad("Music/Decade3DDots.ym",#YM) 
  sound1 = YMLoad("Music/Decade_Demo-Main_Menu.sndh",#SNDH)
  YMplay(sound) 
  Delay(1000) 
  YMPause(sound)
  YMplay(sound1) 
  Delay(1000)
  YMpause(sound1) 
  YMResume(sound) 
  Delay(1000) 
  YMresume(sound1)
  Delay(3000) 
  YMFree(sound1) 
  
  Repeat
    Delay(20) 
  ForEver ;Until YMIsOver(sound)  
  YMFree(sound) 
  
  Debug "waited" 
  
CompilerEndIf 




; IDE Options = PureBasic 6.03 LTS (Windows - x86)
; CursorPosition = 392
; FirstLine = 353
; Folding = ----
; EnableXP
; DPIAware