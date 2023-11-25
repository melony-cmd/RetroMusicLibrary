;Author T.J.Roughton (Inner)
;Windows x86 
;Requires "SNDH.dll"
;http://leonard.oxg.free.fr/download/StSound_1_43.zip

#SNDH_DEBUG_PLUGIN = #True

#SNDH_PLUGIN = "x86_Plugins/SNDH.dll"

;*****************************************************************************
; Structure SNDH
;*****************************************************************************

Structure SubSongInfo
    subsongCount.i
    playerTickCount.i
    playerTickRate.i
    samplePerTick.i
    *musicName
    *musicAuthor
    *year
EndStructure

;*****************************************************************************
; Prototypes SNDH
;*****************************************************************************

PrototypeC.b SNDH_Load(*rawSndhFile,sndhFileSize.i,hostReplayRate.i) : Global SNDH_Load.SNDH_Load
PrototypeC   SNDH_Unload()                                           : Global SNDH_Unload.SNDH_Unload
PrototypeC.b SNDH_InitSubSong(subSongId.i)                           : Global SNDH_InitSubSong.SNDH_InitSubSong
PrototypeC.i SNDH_AudioRender(*buffer,count.i,*pSampleViewInfo = 0)  : Global SNDH_AudioRender.SNDH_AudioRender
PrototypeC.i SNDH_GetSubsongCount()                                  : Global SNDH_GetSubsongCount.SNDH_GetSubsongCount
PrototypeC.i SNDH_GetDefaultSubsong()                                : Global SNDH_GetDefaultSubsong.SNDH_GetDefaultSubsong
PrototypeC.b SNDH_GetSubSongInfo(subSongId.i,*pinfo)                 : Global SNDH_GetSubSongInfo.SNDH_GetSubSongInfo 

PrototypeC   SNDH_GetRawData()                                       : Global SNDH_GetRawData.SNDH_GetRawData
PrototypeC.i SNDH_GetRawDataSize()                                   : Global SNDH_GetRawDataSize.SNDH_GetRawDataSize

XIncludeFile "SoundServer.pbi"

;*****************************************************************************
; Initalize SNDH
;*****************************************************************************

;/****** SNDH_Plugin.pbi/RML_SNDH_OpenLibrary ********************************
;* 
;*   NAME	
;* 	     RML_SNDH_OpenLibrary -- Opens SNDH dll.
;*
;*   SYNOPSIS
;*	     long library = RML_SNDH_OpenLibrary(library.s=#SNDH_PLUGIN)
;*
;*   FUNCTION
;*       Prototype the DLL functions.
;*
;*   INPUTS
;* 	     string library - can be ignored if the dll is in the location
;*       held in #SNDH_PLUGIN, else you can pass your own path.
;*	
;*   RESULT
;*       library pointer - value passed back from OpenLibrary()
;* 	     error - #False
;* 
;*****************************************************************************
Procedure RML_SNDH_OpenLibrary(library.s=#SNDH_PLUGIN)  
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
    ProcedureReturn #False    
  EndIf
  ProcedureReturn dll_plugin
EndProcedure

;/****** SNDH_Plugin.pbi/RML_SNDH_Close **************************************
;* 
;*   NAME	
;* 	     RML_SNDH_Close -- Shut down SNDH dll
;*
;*   FUNCTION
;*       Closes the server library currently open. While it might seem still
;*       ridiculous to wrapper such a function as CloseLibrary() in this way
;*       it's future proofing, in the event that futre additions might require
;*       more deinitializing than just simply closing the library.
;* 
;*****************************************************************************
Procedure RML_SNDH_Close()
  CloseLibrary(SoundServer::p\library)
EndProcedure

;*****************************************************************************
; Sound Server Procedures
;*****************************************************************************

;    NOTES:
;        The reason we do this is because there SoundServer would get bloated
;        if it had to handle all the variations of how each and every plugin
;        likes to operate thus SoundServer calls into the plugin to tell it 
;        how to play, stop, pause, etc. sometimes these procedure may even
;        call back into the SoundServer, beause certain features may not exist
;        in whichever render dll plugin is being used.
;
;        SNDH for example has no stop/pause features so this has to be handled
;        by the server so these commands will call server functions to perform
;        the desired action.

;/****** SNDH_Plugin.pbi/RML_SNDH_Render *************************************
;* 
;*   NAME	
;* 	     RML_SNDH_Render -- calls SNDH render
;*
;*   SYNOPSIS
;*	     None  RML_SNDH_Render(pMusic,*pBuffer,size.i)
;*
;*   FUNCTION
;*       Calls SNDH.dll to render the tune to PCM for play back, this 
;*       Procedure is called by SoundServer, it's done this way for many
;*       reasons, mainly because each ??_Plugin.pbi / sound format or dll has
;*       it's own way of of rendering, so it's in the plugin just in case
;*       we need to do other things, not just the over simplification here.
;*
;*   INPUTS
;* 	     pMusic - 
;*       *pBuffer -
;*       int size -
;* 
;*****************************************************************************
Procedure RML_SNDH_Render(pMusic,*pBuffer,size.i)
  If (pMusic)
    SNDH_AudioRender(*pBuffer,size)
  EndIf 
EndProcedure 

;
; Play Thread 
;
Procedure RML_SNDH_Play(pMusic)
  Debug "--- Play Thread ---"
  Repeat  
    Delay(1) 
  ForEver
EndProcedure 

;
; Stop
;
Procedure RML_SNDH_Stop(pMusic)
  Debug "--- Stop ---"
EndProcedure 

;
; Pause
;
Procedure RML_SNDH_Pause(pMusic)
  Debug "--- Pause ---"
EndProcedure

;/****** SNDH_Plugin.pbi/RML_SNDH_Initialize_SoundServer *********************
;* 
;*   NAME	
;* 	     RML_SNDH_Initialize_SoundServer -- sets up Soundserver
;*
;*   FUNCTION
;*       Initializes the SoundServer with the appropriate procedures to call
;*       for playing tunes in SNDH format, we keep these here because other
;*       ??_Plugin.pbi included would overwrite each other if all included at
;*       the same time, hence this should be step 1 in your code. 
;*
;*****************************************************************************
Procedure RML_SNDH_Initialize_SoundServer()
  SoundServer::p\Render=@RML_SNDH_Render()
  SoundServer::p\Play=@RML_SNDH_Play()
  SoundServer::p\Stop=@RML_SNDH_Stop()
  SoundServer::p\Pause=@RML_SNDH_Pause()
EndProcedure

;*****************************************************************************
; Helpper Procedures
;*****************************************************************************

;/****** SNDH_Plugin.pbi/RML_SNDH_LoadMusic **********************************
;* 
;*   NAME	
;* 	     RML_SNDH_LoadMusic -- 
;*
;*   SYNOPSIS
;*	     long  = RML_SNDH_LoadMusic(file.s)
;*
;*   FUNCTION
;*       Loads a tune into the DLL for play back.
;*
;*   INPUTS
;* 	     string file - file path to a sndh tune.
;*	
;*   RESULT
;* 	     long handle - the result of calling SNDH_Load()
;* 
;*   NOTES
;*       In theory sndh_mem should be stored in STRUCT_AUDIOSERVER
;*       however STRUCT_AUDIOSERVER is inaccessable as its private to SoundServer
;*       this shouldn't matter anyway as once SNDH_Load() has been given the
;*       memory containing the sndh file data, sndh_mem becomes orphaned by vertue
;*       of SNDH_Load() internally decompressing the sndh file from ICE and thus
;*       it is now working from the decompressed data not the memory we gave it.
;* 
;*       All of that said; it's quite possible to have an uncompressed sndh file
;*       though rare! so it should not be assumed that we can actually free it,
;*       now if we was talking about flac/mp3 or other formats I'd be really 
;*       concerned about over memory usage, even still it does now free the memory.
;* 
;*****************************************************************************
Procedure.l RML_SNDH_LoadMusic(file.s) 
  fn = OpenFile(#PB_Any,file)
  If fn
    filesize = FileSize(file) 
    sndh_mem = AllocateMemory(filesize)
    If sndh_mem
      ReadData(fn,sndh_mem,filesize)       
      result = SNDH_Load(sndh_mem,filesize,44100)
      ; we no longer need the file anymore SNDH.dll 
      ; has used ICE to decompress it.
      FreeMemory(sndh_mem)                  
    EndIf      
    CloseFile(fn)
  EndIf  
  ProcedureReturn result
EndProcedure
  
;*****************************************************************************
;                 !!ONLY!! -- Testing Purposes -- !!ONLY!!
;*****************************************************************************
CompilerIf #SNDH_DEBUG_PLUGIN = #True
  RML_SNDH_Initialize_SoundServer()
  RML_SNDH_OpenLibrary()
  
  info.SubSongInfo
  
  If RML_SNDH_LoadMusic("decade_demo-loader.sndh")=1
    SNDH_InitSubSong(1)
    SNDH_GetSubSongInfo(1,@info)   
    Debug "info\musicName = "+PeekS(info\musicName,-1,#PB_Ascii)
    Debug "info\Author = "+PeekS(info\musicAuthor,-1,#PB_Ascii)
    
    If info\year<>#Null
      Debug "info\musicName = "+PeekS(info\year,-1,#PB_Ascii)
    EndIf
    
    Debug "info\playerTickCount = "+Str(info\playerTickCount)
    Debug "info\playerTickRate = "+Str(info\playerTickRate)
    Debug "info\samplePerTick = "+Str(info\samplePerTick)
    Debug "info\subsongCount = "+Str(info\subsongCount)
    
    SoundServer::Play()
    
    Delay(5000)
    
    SoundServer::Pause()
    SoundServer::Stop()
    
  EndIf  
  RML_SNDH_Close()
CompilerEndIf
; IDE Options = PureBasic 6.03 LTS (Windows - x86)
; CursorPosition = 105
; FirstLine = 99
; Folding = --
; EnableXP
; DPIAware