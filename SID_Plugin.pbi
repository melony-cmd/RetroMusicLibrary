#SID_DEBUG_PLUGIN = #True

CompilerIf #PB_Compiler_Processor = #PB_Processor_x86
  ;#SID_PLUGIN = "x86_Plugins/SID.dll"
  
  #SID_PLUGIN = "D:\Work\Code\PureBasic\RetroMusicLibrary\Renders\SID\Release\libsidplay.dll"
CompilerElseIf #PB_Compiler_Processor = #PB_Processor_x64
  #SID_PLUGIN = "x64_Plugins/"
CompilerEndIf

;*****************************************************************************
; Enumeration SID
;*****************************************************************************
Enumeration clock_t
  #CLOCK_UNKNOWN
  #CLOCK_PAL
  #CLOCK_NTSC
  #CLOCK_ANY
EndEnumeration

Enumeration model_t
  #SIDMODEL_UNKNOWN
  #SIDMODEL_6581
  #SIDMODEL_8580
  #SIDMODEL_ANY
EndEnumeration

Enumeration compatibility_t
  #COMPATIBILITY_C64   ;///< File is C64 compatible
  #COMPATIBILITY_PSID  ;///< File is PSID specific
  #COMPATIBILITY_R64   ;///< File is Real C64 only
  #COMPATIBILITY_BASIC ;///< File requires C64 Basic
EndEnumeration

;*****************************************************************************
; Constants
;*****************************************************************************
;/// Vertical-Blanking-Interrupt
#SPEED_VBI = 0

;/// CIA 1 Timer A
#SPEED_CIA_1A = 60

;*****************************************************************************
; Prototypes SID
;*****************************************************************************
PrototypeC SidConfig_SetDefaultC64Model(c_defaultC64Model.l) : Global SidConfig_SetDefaultC64Model.SidConfig_SetDefaultC64Model
PrototypeC SidConfig_SetForceC64Model(forceC64Model.b) : Global SidConfig_SetForceC64Model.SidConfig_SetForceC64Model
PrototypeC SidConfig_SetDefaultSidModel(c_defaultSidModel.l) : Global SidConfig_SetDefaultSidModel.SidConfig_SetDefaultSidModel
PrototypeC SidConfig_SetForceSidModel(forceSidModel.b) : Global SidConfig_SetForceSidModel.SidConfig_SetForceSidModel
PrototypeC SidConfig_SetDigiBoost(digiBoost.b) : Global SidConfig_SetDigiBoost.SidConfig_SetDigiBoost
PrototypeC SidConfig_SetCIAModel(ciaModel.l) : Global SidConfig_SetCIAModel.SidConfig_SetCIAModel
PrototypeC SidConfig_SetPlayBack(playback.l) : Global SidConfig_SetPlayBack.SidConfig_SetPlayBack
PrototypeC SidConfig_SetFrequency(frequency.l) : Global SidConfig_SetFrequency.SidConfig_SetFrequency
PrototypeC SidConfig_SetSecondSidAddress(secondSidAddress.l) : Global SidConfig_SetSecondSidAddress.SidConfig_SetSecondSidAddress
PrototypeC SidConfig_SetThirdSidAddress(thirdSidAddress.l) : Global SidConfig_SetThirdSidAddress.SidConfig_SetThirdSidAddress
PrototypeC SidConfig_SetSidEmulation(sidEmulation.l) : Global SidConfig_SetSidEmulation.SidConfig_SetSidEmulation
PrototypeC SidConfig_SetLeftVolume(leftVolume.l) : Global SidConfig_SetLeftVolume.SidConfig_SetLeftVolume
PrototypeC SidConfig_SetRightVolume(rightVolume.l) : Global SidConfig_SetRightVolume.SidConfig_SetRightVolume
PrototypeC SidConfig_SetPowerOnDelay(delay.l) : Global SidConfig_SetPowerOnDelay.SidConfig_SetPowerOnDelay
PrototypeC SidConfig_SetSamplingMethod(samplingMethod.l) : Global SidConfig_SetSamplingMethod.SidConfig_SetSamplingMethod
PrototypeC SidConfig_SetFastSampling(fastSampling.b) : Global SidConfig_SetFastSampling.SidConfig_SetFastSampling
PrototypeC.l SidInfo_LibraryName() : Global SidInfo_LibraryName.SidInfo_LibraryName
PrototypeC.l SidInfo_Version() : Global SidInfo_Version.SidInfo_Version
PrototypeC.i SidInfo_NumberOfCredits() : Global SidInfo_NumberOfCredits.SidInfo_NumberOfCredits
PrototypeC.l SidInfo_Credits(i.l) : Global SidInfo_Credits.SidInfo_Credits
PrototypeC.i SidInfo_MaxSIDS() : Global SidInfo_MaxSIDS.SidInfo_MaxSIDS
PrototypeC.i SidInfo_Channels() : Global SidInfo_Channels.SidInfo_Channels
PrototypeC.i SidInfo_DriverAddr() : Global SidInfo_DriverAddr.SidInfo_DriverAddr
PrototypeC.i SidInfo_DriverLength() : Global SidInfo_DriverLength.SidInfo_DriverLength
PrototypeC.i SidInfo_PownOnDelay() : Global SidInfo_PownOnDelay.SidInfo_PownOnDelay
PrototypeC.l SidInfo_SpeedString() : Global SidInfo_SpeedString.SidInfo_SpeedString
PrototypeC.l SidInfo_KernalDesc() : Global SidInfo_KernalDesc.SidInfo_KernalDesc
PrototypeC.l SidInfo_BasicDesc() : Global SidInfo_BasicDesc.SidInfo_BasicDesc
PrototypeC.l SidInfo_ChargenDesc() : Global SidInfo_ChargenDesc.SidInfo_ChargenDesc
PrototypeC.l SidPlayFP_GetConfig() : Global SidPlayFP_GetConfig.SidPlayFP_GetConfig
PrototypeC.l SidPlayFP_Information() : Global SidPlayFP_Information.SidPlayFP_Information
PrototypeC.b SidPlayFP_SetConfig(*SidConfig) : Global SidPlayFP_SetConfig.SidPlayFP_SetConfig
PrototypeC.l SidPlayFP_Error() : Global SidPlayFP_Error.SidPlayFP_Error
PrototypeC.b SidPlayFP_FastForward(percent.l) : Global SidPlayFP_FastForward.SidPlayFP_FastForward
PrototypeC.b SidPlayFP_Load(*tune) : Global SidPlayFP_Load.SidPlayFP_Load
PrototypeC.i SidPlayFP_Play(*buffer,count.l) : Global SidPlayFP_Play.SidPlayFP_Play
PrototypeC.b SidPlayFP_isPlayering() : Global SidPlayFP_isPlayering.SidPlayFP_isPlayering
PrototypeC SidPlayFP_Stop() : Global SidPlayFP_Stop.SidPlayFP_Stop
PrototypeC SidPlayFP_Debug(enable.b,*out) : Global SidPlayFP_Debug.SidPlayFP_Debug
PrototypeC SidPlayFP_Mute(sidNum.l,voice.l,enable.b) : Global SidPlayFP_Mute.SidPlayFP_Mute
PrototypeC.i SidPlayFP_Time() : Global SidPlayFP_Time.SidPlayFP_Time
PrototypeC.i SidPlayFP_TimeMs() : Global SidPlayFP_TimeMs.SidPlayFP_TimeMs
PrototypeC SidPlayFP_SetRoms(kernal.l,*basic,*character = 0) : Global SidPlayFP_SetRoms.SidPlayFP_SetRoms
PrototypeC SidPlayFP_SetKernal(*rom) : Global SidPlayFP_SetKernal.SidPlayFP_SetKernal
PrototypeC SidPlayFP_SetBasic(*rom) : Global SidPlayFP_SetBasic.SidPlayFP_SetBasic
PrototypeC SidPlayFP_SetChargen(*rom) : Global SidPlayFP_SetChargen.SidPlayFP_SetChargen
PrototypeC.i SidPlayFP_GetCia1TimerA() : Global SidPlayFP_GetCia1TimerA.SidPlayFP_GetCia1TimerA
PrototypeC.b SidPlayFP_GetSidStatus(sidNum.l,*regs) : Global SidPlayFP_GetSidStatus.SidPlayFP_GetSidStatus
PrototypeC SidTune_LoadFromFile(fileName.s,fileNameExt.l= 0,separatorIsSlash = #False) : Global SidTune_LoadFromFile.SidTune_LoadFromFile
PrototypeC SidTune_LoadFromCallBack(loader.l,fileName.s,fileNameExt.l=0,separatorIsSlash = #False) : Global SidTune_LoadFromCallBack.SidTune_LoadFromCallBack
PrototypeC SidTune_LoadFromMemory(*oneFileFormatSidtune,sidtuneLength.l) : Global SidTune_LoadFromMemory.SidTune_LoadFromMemory
PrototypeC SidTune_LoadObject(fileName.s,separatorIsSlash.b) : Global SidTune_LoadObject.SidTune_LoadObject
PrototypeC SidTune_LoadObjectCallBack(*loader,fileName.s,separatorIsSlash.b) : Global SidTune_LoadObjectCallBack.SidTune_LoadObjectCallBack 
PrototypeC SidTune_Read(*sourceBuffer,bufferLen.l) : Global SidTune_Read.SidTune_Read
PrototypeC SidTune_SelectSong(songNum.l) : Global SidTune_SelectSong.SidTune_SelectSong
PrototypeC.l SidTune_GetInfo() : Global SidTune_GetInfo.SidTune_GetInfo
PrototypeC.l SidTune_GetInfoSubSong(songNum) : Global SidTune_GetInfoSubSong.SidTune_GetInfoSubSong
PrototypeC.b SidTune_GetStatus() : Global SidTune_GetStatus.SidTune_GetStatus
PrototypeC.s SidTune_StatusString() : Global SidTune_StatusString.SidTune_StatusString
PrototypeC.b SidTune_PlaceSidTuneInC64mem(*mem) : Global SidTune_PlaceSidTuneInC64mem.SidTune_PlaceSidTuneInC64mem
PrototypeC.s SidTune_CreateMD5(*md5) : Global SidTune_CreateMD5.SidTune_CreateMD5
PrototypeC.s SidTune_CreateMD5New(*md5) : Global SidTune_CreateMD5New.SidTune_CreateMD5New
PrototypeC.i SidTuneInfo_LoadAddr() : Global SidTuneInfo_LoadAddr.SidTuneInfo_LoadAddr
PrototypeC.i SidTuneInfo_InitAddr() : Global SidTuneInfo_InitAddr.SidTuneInfo_InitAddr
PrototypeC.i SidTuneInfo_PlayAddr() : Global SidTuneInfo_PlayAddr.SidTuneInfo_PlayAddr
PrototypeC.i SidTuneInfo_Songs() : Global SidTuneInfo_Songs.SidTuneInfo_Songs
PrototypeC.i SidTuneInfo_StartSong() : Global SidTuneInfo_StartSong.SidTuneInfo_StartSong
PrototypeC.i SidTuneInfo_CurrentSong() : Global SidTuneInfo_CurrentSong.SidTuneInfo_CurrentSong 
PrototypeC.i SidTuneInfo_SidChipBase(i.i) : Global SidTuneInfo_SidChipBase.SidTuneInfo_SidChipBase 
PrototypeC.i SidTuneInfo_SidChips() : Global SidTuneInfo_SidChips.SidTuneInfo_SidChips
PrototypeC.i SidTuneInfo_SongSpeed() : Global SidTuneInfo_SongSpeed.SidTuneInfo_SongSpeed
PrototypeC.i SidTuneInfo_RelocStartPage() : Global SidTuneInfo_RelocStartPage.SidTuneInfo_RelocStartPage
PrototypeC.i SidTuneInfo_RelocPages() : Global SidTuneInfo_RelocPages.SidTuneInfo_RelocPages
PrototypeC.i SidTuneInfo_SidModel(i.i) : Global SidTuneInfo_SidModel.SidTuneInfo_SidModel
PrototypeC.i SidTuneInfo_Compatibility() : Global SidTuneInfo_Compatibility.SidTuneInfo_Compatibility 
PrototypeC.i SidTuneInfo_NumberOfInfoStrings() : Global SidTuneInfo_NumberOfInfoStrings.SidTuneInfo_NumberOfInfoStrings
PrototypeC.s SidTuneInfo_InfoString(i.i) : Global SidTuneInfo_InfoString.SidTuneInfo_InfoString
PrototypeC.i SidTuneInfo_NumberOfCommentStrings() : Global SidTuneInfo_NumberOfCommentStrings.SidTuneInfo_NumberOfCommentStrings
PrototypeC.s SidTuneInfo_CommentString(i.i) : Global SidTuneInfo_CommentString.SidTuneInfo_CommentString
PrototypeC.s SidTuneInfo_MusString() : Global SidTuneInfo_MusString.SidTuneInfo_MusString
PrototypeC.i SidTuneInfo_DataFileLen() : Global SidTuneInfo_DataFileLen.SidTuneInfo_DataFileLen
PrototypeC.i SidTuneInfo_C64dataLen() : Global SidTuneInfo_C64dataLen.SidTuneInfo_C64dataLen
PrototypeC.i SidTuneInfo_ClockSpeed() : Global SidTuneInfo_ClockSpeed.SidTuneInfo_ClockSpeed
PrototypeC.s SidTuneInfo_FormatString() : Global SidTuneInfo_FormatString.SidTuneInfo_FormatString
PrototypeC.b SidTuneInfo_FixLoad() : Global SidTuneInfo_FixLoad.SidTuneInfo_FixLoad
PrototypeC.s SidTuneInfo_Path() : Global SidTuneInfo_Path.SidTuneInfo_Path
PrototypeC.s SidTuneInfo_DataFileName() : Global SidTuneInfo_DataFileName.SidTuneInfo_DataFileName
PrototypeC.s SidTuneInfo_InfoFileName() : Global SidTuneInfo_InfoFileName.SidTuneInfo_InfoFileName

XIncludeFile "SoundServer.pbi"

;*****************************************************************************
; Initalize SID
;*****************************************************************************

;/****** SID_Plugin.pbi/RML_SID_OpenLibrary **********************************
;* 
;*   NAME	
;* 	     RML_SID_OpenLibrary -- Opens SID dll.
;*
;*   SYNOPSIS
;*	     long library = RML_SID_OpenLibrary(library.s=#SNDH_PLUGIN)
;*
;*   FUNCTION
;*       Prototype the DLL functions.
;*
;*   INPUTS
;* 	     string library - can be ignored if the dll is in the location
;*       held in #SID_PLUGIN, else you can pass your own path.
;*	
;*   RESULT
;*       library pointer - value passed back from OpenLibrary()
;* 	     error - #False
;* 
;*****************************************************************************
Procedure RML_SID_OpenLibrary(library.s=#SID_PLUGIN)  
  dll_plugin = OpenLibrary(#PB_Any,library)
  If dll_plugin
    ;-SidConfig
    SidConfig_SetDefaultC64Model = GetFunction(dll_plugin,"SidConfig_SetDefaultC64Model")
    SidConfig_SetForceC64Model = GetFunction(dll_plugin,"SidConfig_SetForceC64Model")
    SidConfig_SetDefaultSidModel = GetFunction(dll_plugin,"SidConfig_SetDefaultSidModel")
    SidConfig_SetForceSidModel = GetFunction(dll_plugin,"SidConfig_SetForceSidModel")
    SidConfig_SetDigiBoost = GetFunction(dll_plugin,"SidConfig_SetDigiBoost")
    SidConfig_SetCIAModel = GetFunction(dll_plugin,"SidConfig_SetCIAModel")
    SidConfig_SetPlayBack = GetFunction(dll_plugin,"SidConfig_SetPlayBack")
    SidConfig_SetFrequency = GetFunction(dll_plugin,"SidConfig_SetFrequency")
    SidConfig_SetSecondSidAddress = GetFunction(dll_plugin,"SidConfig_SetSecondSidAddress")
    SidConfig_SetThirdSidAddress = GetFunction(dll_plugin,"SidConfig_SetThirdSidAddress")
    SidConfig_SetSidEmulation = GetFunction(dll_plugin,"SidConfig_SetSidEmulation")
    SidConfig_SetLeftVolume = GetFunction(dll_plugin,"SidConfig_SetLeftVolume")
    SidConfig_SetRightVolume = GetFunction(dll_plugin,"SidConfig_SetRightVolume")
    SidConfig_SetPowerOnDelay = GetFunction(dll_plugin,"SidConfig_SetPowerOnDelay")
    SidConfig_SetSamplingMethod = GetFunction(dll_plugin,"SidConfig_SetSamplingMethod")
    SidConfig_SetFastSampling = GetFunction(dll_plugin,"SidConfig_SetFastSampling")
    ;-SidInfo
    SidInfo_LibraryName = GetFunction(dll_plugin,"SidInfo_LibraryName")
    SidInfo_Version = GetFunction(dll_plugin,"SidInfo_Version")
    SidInfo_NumberOfCredits = GetFunction(dll_plugin,"SidInfo_NumberOfCredits")
    SidInfo_Credits = GetFunction(dll_plugin,"SidInfo_Credits")
    SidInfo_MaxSIDS = GetFunction(dll_plugin,"SidInfo_MaxSIDS")
    SidInfo_Channels = GetFunction(dll_plugin,"SidInfo_Channels")
    SidInfo_DriverAddr = GetFunction(dll_plugin,"SidInfo_DriverAddr")
    SidInfo_DriverLength = GetFunction(dll_plugin,"SidInfo_DriverLength")
    SidInfo_PownOnDelay = GetFunction(dll_plugin,"SidInfo_PownOnDelay")
    SidInfo_SpeedString = GetFunction(dll_plugin,"SidInfo_SpeedString")
    SidInfo_KernalDesc = GetFunction(dll_plugin,"SidInfo_KernalDesc")
    SidInfo_BasicDesc = GetFunction(dll_plugin,"SidInfo_BasicDesc")
    SidInfo_ChargenDesc = GetFunction(dll_plugin,"SidInfo_ChargenDesc")
    ;-SidPlayFP
    SidPlayFP_GetConfig = GetFunction(dll_plugin,"SidPlayFP_GetConfig")
    SidPlayFP_Information = GetFunction(dll_plugin,"SidPlayFP_Information")
    SidPlayFP_SetConfig = GetFunction(dll_plugin,"SidPlayFP_SetConfig")
    SidPlayFP_Error = GetFunction(dll_plugin,"SidPlayFP_Error")
    SidPlayFP_FastForward = GetFunction(dll_plugin,"SidPlayFP_FastForward")
    SidPlayFP_Load = GetFunction(dll_plugin,"SidPlayFP_Load")
    SidPlayFP_Play = GetFunction(dll_plugin,"SidPlayFP_Play")
    SidPlayFP_isPlayering = GetFunction(dll_plugin,"SidPlayFP_isPlayering")
    SidPlayFP_Stop = GetFunction(dll_plugin,"SidPlayFP_Stop")
    SidPlayFP_Debug = GetFunction(dll_plugin,"SidPlayFP_Debug")
    SidPlayFP_Mute = GetFunction(dll_plugin,"SidPlayFP_Mute")
    SidPlayFP_Time = GetFunction(dll_plugin,"SidPlayFP_Time")
    SidPlayFP_TimeMs = GetFunction(dll_plugin,"SidPlayFP_TimeMs")
    SidPlayFP_SetRoms = GetFunction(dll_plugin,"SidPlayFP_SetRoms")
    SidPlayFP_SetKernal = GetFunction(dll_plugin,"SidPlayFP_SetKernal")
    SidPlayFP_SetBasic = GetFunction(dll_plugin,"SidPlayFP_SetBasic")
    SidPlayFP_SetChargen = GetFunction(dll_plugin,"SidPlayFP_SetChargen")
    SidPlayFP_GetCia1TimerA = GetFunction(dll_plugin,"SidPlayFP_GetCia1TimerA")
    SidPlayFP_GetSidStatus = GetFunction(dll_plugin,"SidPlayFP_GetSidStatus")
    ;-SidTune
    SidTune_LoadFromFile = GetFunction(dll_plugin,"SidTune_LoadFromFile")
    SidTune_LoadFromCallBack = GetFunction(dll_plugin,"SidTune_LoadFromCallBack")    
    SidTune_LoadFromMemory = GetFunction(dll_plugin,"SidTune_LoadFromMemory")    
    SidTune_LoadObject = GetFunction(dll_plugin,"SidTune_LoadObject")
    SidTune_LoadObjectCallBack = GetFunction(dll_plugin,"SidTune_LoadObjectCallBack")
    SidTune_Read = GetFunction(dll_plugin,"SidTune_Read")
    SidTune_SelectSong = GetFunction(dll_plugin,"SidTune_SelectSong")
    SidTune_GetInfo = GetFunction(dll_plugin,"SidTune_GetInfo")
    SidTune_GetInfoSubSong = GetFunction(dll_plugin,"SidTune_GetInfoSubSong")
    SidTune_GetStatus = GetFunction(dll_plugin,"SidTune_GetStatus")
    SidTune_StatusString = GetFunction(dll_plugin,"SidTune_StatusString")
    SidTune_PlaceSidTuneInC64mem = GetFunction(dll_plugin,"SidTune_PlaceSidTuneInC64mem")
    SidTune_CreateMD5 = GetFunction(dll_plugin,"SidTune_CreateMD5")
    SidTune_CreateMD5New = GetFunction(dll_plugin,"SidTune_CreateMD5New")
    ;-SidTuneInfo
    SidTuneInfo_LoadAddr = GetFunction(dll_plugin,"SidTuneInfo_LoadAddr")
    SidTuneInfo_InitAddr = GetFunction(dll_plugin,"SidTuneInfo_InitAddr")
    SidTuneInfo_PlayAddr = GetFunction(dll_plugin,"SidTuneInfo_PlayAddr")
    SidTuneInfo_Songs = GetFunction(dll_plugin,"SidTuneInfo_Songs")
    SidTuneInfo_StartSong = GetFunction(dll_plugin,"SidTuneInfo_StartSong")   
    SidTuneInfo_CurrentSong = GetFunction(dll_plugin,"SidTuneInfo_CurrentSong")
    SidTuneInfo_SidChipBase = GetFunction(dll_plugin,"SidTuneInfo_SidChipBase")
    SidTuneInfo_SidChips = GetFunction(dll_plugin,"SidTuneInfo_SidChips")
    SidTuneInfo_SongSpeed = GetFunction(dll_plugin,"SidTuneInfo_SongSpeed")
    SidTuneInfo_RelocStartPage = GetFunction(dll_plugin,"SidTuneInfo_RelocStartPage")
    SidTuneInfo_SidModel = GetFunction(dll_plugin,"SidTuneInfo_SidModel")
    SidTuneInfo_Compatibility = GetFunction(dll_plugin,"SidTuneInfo_Compatibility")
    SidTuneInfo_NumberOfInfoStrings = GetFunction(dll_plugin,"SidTuneInfo_NumberOfInfoStrings")
    SidTuneInfo_InfoString = GetFunction(dll_plugin,"SidTuneInfo_InfoString")
    SidTuneInfo_NumberOfCommentStrings = GetFunction(dll_plugin,"SidTuneInfo_NumberOfCommentStrings")
    SidTuneInfo_DataFileLen = GetFunction(dll_plugin,"SidTuneInfo_DataFileLen")
    SidTuneInfo_C64dataLen = GetFunction(dll_plugin,"SidTuneInfo_C64dataLen")
    SidTuneInfo_ClockSpeed = GetFunction(dll_plugin,"SidTuneInfo_ClockSpeed")
    SidTuneInfo_FormatString = GetFunction(dll_plugin,"SidTuneInfo_FormatString")
    SidTuneInfo_FixLoad = GetFunction(dll_plugin,"SidTuneInfo_FixLoad")
    SidTuneInfo_Path = GetFunction(dll_plugin,"SidTuneInfo_Path")
    SidTuneInfo_DataFileName = GetFunction(dll_plugin,"SidTuneInfo_DataFileName")
    SidTuneInfo_InfoFileName = GetFunction(dll_plugin,"SidTuneInfo_InfoFileName")
       
    ExamineLibraryFunctions(dll_plugin)
  
    While NextLibraryFunction()
      Debug LibraryFunctionName()+" "+LibraryFunctionAddress()
    Wend
    
    SoundServer::p\library = dll_plugin
  Else 
    ProcedureReturn #False    
  EndIf
  ProcedureReturn dll_plugin
EndProcedure

;/****** SID_Plugin.pbi/RML_SID_Close ****************************************
;* 
;*   NAME	
;* 	     RML_SID_Close -- Shut down SNDH dll
;*
;*   FUNCTION
;*       Closes the server library currently open. While it might seem still
;*       ridiculous to wrapper such a function as CloseLibrary() in this way
;*       it's future proofing, in the event that futre additions might require
;*       more deinitializing than just simply closing the library.
;* 
;*****************************************************************************
Procedure RML_SID_Close()
  CloseLibrary(SoundServer::p\library)
EndProcedure

;*****************************************************************************
; Sound Server Procedures
;*****************************************************************************

;/****** SID_Plugin.pbi/RML_SID_Render ***************************************
;* 
;*   NAME	
;* 	     RML_SID_Render -- calls SNDH render
;*
;*   SYNOPSIS
;*	     None  RML_SID_Render(pMusic,*pBuffer,size.i)
;*
;*   FUNCTION
;*       Calls SID.dll to render the tune to PCM for play back, this 
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
Procedure RML_SID_Render(pMusic,*pBuffer,size.i)
  If (pMusic)
    SidPlayFP_Play(*pBuffer,size)
    ShowMemoryViewer(*pBuffer,size)
  EndIf 
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
Procedure RML_SID_Initialize_SoundServer()
  SoundServer::p\Render=@RML_SID_Render()
EndProcedure

;*****************************************************************************
; Helpper Procedures
;*****************************************************************************

;/****** SID_Plugin.pbi/RML_SID_LoadMusic ************************************
;* 
;*   NAME	
;* 	     RML_SID_LoadMusic -- 
;*
;*   SYNOPSIS
;*	     long  = RML_SID_LoadMusic(file.s)
;*
;*   FUNCTION
;*       Loads a tune into the DLL for play back.
;*
;*   INPUTS
;* 	     string file - file path to a sndh tune.
;*	
;*   RESULT
;* 	     long handle - the result of calling SidPlayFP_Load()
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
Procedure.l RML_SID_LoadMusic(file.s) 
  fn = OpenFile(#PB_Any,file)
  If fn
    filesize = FileSize(file) 
    sid_mem = AllocateMemory(filesize)
    If sid_mem
      ReadData(fn,sid_mem,filesize)       
      result = SidTune_LoadFromMemory(sid_mem,filesize)
      FreeMemory(sid_mem)
    EndIf      
    CloseFile(fn)
  EndIf  
  ProcedureReturn result
EndProcedure

;*****************************************************************************
;                 !!ONLY!! -- Testing Purposes -- !!ONLY!!
;*****************************************************************************
CompilerIf #SID_DEBUG_PLUGIN = #True
  RML_SID_Initialize_SoundServer()
  Debug RML_SID_OpenLibrary()   
  Debug RML_SID_LoadMusic("Music/Wiklund_-_Six_hours.sid")  
;  SidTune_SelectSong(1)
  
;  Debug SidTuneInfo_StartSong()  
  
  SoundServer::Play()
  
  Delay(5000)
  
  RML_SID_Close()
CompilerEndIf

End

; IDE Options = PureBasic 6.03 LTS (Windows - x86)
; CursorPosition = 146
; FirstLine = 104
; Folding = --
; EnableXP
; DPIAware