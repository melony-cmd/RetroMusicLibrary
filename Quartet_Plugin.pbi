;*****************************************************************************
;Author <name>
;Windows x86 
;Requires "<>.dll"
;URL
;*****************************************************************************
#QUARTET_DEBUG_PLUGIN = #False

CompilerIf #PB_Compiler_Processor = #PB_Processor_x86
  #QUARTET_PLUGIN = "x86_Plugins/Quartet.dll"
CompilerElseIf #PB_Compiler_Processor = #PB_Processor_x64
  #QUARTET_PLUGIN = "x64_Plugins/Quartet.dll"
CompilerEndIf
;*****************************************************************************
; Enumeration Quartet
;*****************************************************************************

;/**
; * Zingzong error codes.
; */
Enumeration
  #ZZ_OK		     ;/**< (0) No error.                       */
  #ZZ_ERR	       ;/**< (1) Unspecified error.              */
  #ZZ_EARG 	     ;/**< (2) Argument error.                 */
  #ZZ_ESYS		   ;/**< (3) System error (I/O, memory ...). */
  #ZZ_EINP		   ;/**< (4) Problem With input.             */
  #ZZ_EOUT		   ;/**< (5) Problem With output.            */
  #ZZ_ESNG		   ;/**< (6) Song error.                     */
  #ZZ_ESET		   ;/**< (7) Voice set error                 */
  #ZZ_EPLA		   ;/**< (8) Player error.                   */
  #ZZ_EMIX		   ;/**< (9) Mixer error.                    */
  #ZZ_666 = 66	 ;/**< Internal error.                     */
EndEnumeration

;/**
; * Known (but Not always supported) Quartet file format.
; */
Enumeration zz_format_e
  #ZZ_FORMAT_UNKNOWN 	     ;/**< Not yet determined (must be 0)  */
  #ZZ_FORMAT_4V		         ;/**< Original Atari ST song.         */
  #ZZ_FORMAT_BUNDLE = 64   ;/**< Next formats are bundles.       */
  #ZZ_FORMAT_4Q 		       ;/**< Single song bundle (MUG UK ?).  */
  #ZZ_FORMAT_QUAR 	       ;/**< Multi song bundle (SC68).       */
EndEnumeration

;/**
; * Mixer identifiers.
; */
Enumeration
  #ZZ_MIXER_XTN = 254 	        ;/**< External mixer.                 */
  #ZZ_MIXER_DEF = 255 	        ;/**< Default mixer id.               */
  #ZZ_MIXER_ERR = #ZZ_MIXER_DEF ;/**< Error (alias For ZZ_MIXER_DEF). */
EndEnumeration

;/**
; * Stereo channel mapping.
; */
Enumeration
  #ZZ_MAP_ABCD			       ;/**< (0) Left:A+B Right:C+D. */
  #ZZ_MAP_ACBD			       ;/**< (1) Left:A+C Right:B+D. */
  #ZZ_MAP_ADBC			       ;/**< (2) Left:A+D Right:B+C. */
EndEnumeration

;/**
; * Sampler quality.
; */
Enumeration zz_quality_e
  #ZZ_FQ				    ;/**< (1) Fastest quality. */
  #ZZ_LQ				    ;/**< (2) Low quality.     */
  #ZZ_MQ				    ;/**< (3) Medium quality.  */
  #ZZ_HQ					  ;/**< (4) High quality.    */
EndEnumeration

;/**
; * Log level (first parameter of zz_log_t function).
; */
Enumeration
  #ZZ_LOG_ERR				;/**< Log error.   */
  #ZZ_LOG_WRN				;/**< Log warning. */
  #ZZ_LOG_INF				;/**< Log info.    */
  #ZZ_LOG_DBG				;/**< Log Debug.   */
EndEnumeration

Enumeration
  #ZZ_SEEK_SET
  #ZZ_SEEK_CUR
  #ZZ_SEEK_END
EndEnumeration

;*****************************************************************************
; Structure Quartet
;*****************************************************************************
Structure q_fmt
;  zz_u8_t	 num            ;/**< format (@see zz_format_e). */
;  const char * str        ;/**< format string.             */
EndStructure			        ;/**< format info.               */

Structure q_len
;  zz_u16_t	 rate         ;/**< player tick rate (200hz).  */
;  zz_u32_t	 ms           ;/**< song duration in ms.       */
EndStructure              ;/**< replay info.               */

;/** mixer info. */
Structure q_mix
;  zz_u32_t	 spr          ;/**< sampling rate.                  */
;  zz_u8_t	 num            ;/**< mixer identifier.               */
;  zz_u8_t	 Map            ;/**< channel mapping (ZZ_MAP_*).     */
;  zz_u16_t	 lr8          ;/**< 0:normal 128:center 256:invert. */

;  const char * name       ;/**< mixer name or "".               */
;  const char * desc       ;/**< mixer description or "".        */
EndStructure              ;/**< mixer related info.             */

Structure q_set           ;/**< voice set info.            */
;  const char * uri        ;/**< URI or path.               */
;  zz_u32_t	 khz          ;/**< sampling rate reported.    */
EndStructure

Structure q_sng           ;/**< song info.                 */
;  const char * uri        ;/**< URI or path.               */
;  zz_u32_t	 khz          ;/**< sampling rate reported.    */
EndStructure

Structure q_tag
  *album       ;/**< album or "".               */
  *title       ;/**< title or "".               */
  *artist      ;/**< artist or "".              */
  *ripper      ;/**< ripper or "".              */
EndStructure   ;/**< meta tags.                 */

;*****************************************************************************
; Constants Quartet
;*****************************************************************************

; typedef signed char        int8_t;
; typedef short              int16_t;
; typedef int                int32_t;
; typedef long long          int64_t;
; typedef unsigned char      uint8_t;
; typedef unsigned short     uint16_t;
; typedef unsigned int       uint32_t;
; typedef unsigned long long uint64_t;
; 
; typedef signed char        int_least8_t;
; typedef short              int_least16_t;
; typedef int                int_least32_t;
; typedef long long          int_least64_t;
; typedef unsigned char      uint_least8_t;
; typedef unsigned short     uint_least16_t;
; typedef unsigned int       uint_least32_t;
; typedef unsigned long long uint_least64_t;
; 
; typedef signed char        int_fast8_t;
; typedef int                int_fast16_t;
; typedef int                int_fast32_t;
; typedef long long          int_fast64_t;
; typedef unsigned char      uint_fast8_t;
; typedef unsigned int       uint_fast16_t;
; typedef unsigned int       uint_fast32_t;
; typedef unsigned long long uint_fast64_t;
; 
; typedef long long          intmax_t;
; typedef unsigned long long uintmax_t;

;*****************************************************************************
; Prototypes Quartet
;*****************************************************************************
PrototypeC Quartet_Core_Version()                     : Global  Quartet_Core_Version.Quartet_Core_Version
PrototypeC Quartet_Core_Mute(K.i,clr.a,set.a)         : Global Quartet_Core_Mute.Quartet_Core_Mute

PrototypeC Quartet_Core_Init(core.i,mixer.l, spr.l)   : Global Quartet_Core_Init.Quartet_Core_Init

PrototypeC Quartet_Core_Kill(core.i)                  : Global Quartet_Core_Kill.Quartet_Core_Kill
PrototypeC Quartet_Core_Tick(core.i)                  : Global Quartet_Core_Tick.Quartet_Core_Tick
PrototypeC Quartet_Core_Play(core.i,*pcm, n.l)        : Global Quartet_Core_Play.Quartet_Core_Play
PrototypeC Quartet_Core_Blend(core.i,bmap.l, lr8.l)   : Global Quartet_Core_Blend.Quartet_Core_Blend

PrototypeC Quartet_Log_Bit(clr,set)                   : Global Quartet_Log_Bit.Quartet_Log_Bit
PrototypeC Quartet_Log_Fun(func,*user)                : Global Quartet_Log_Fun.Quartet_Log_Fun
PrototypeC Quartet_Mem(newf,delf)                     : Global Quartet_Mem.Quartet_Mem
PrototypeC Quartet_New(*pplay)                        : Global Quartet_New.Quartet_New
PrototypeC Quartet_Del(*pplay)                        : Global Quartet_Del.Quartet_Del 

PrototypeC.b Quartet_Load(play, song.p-Ascii, *vset, *pfmt)   : Global Quartet_Load.Quartet_Load
PrototypeC Quartet_Close(play)                        : Global Quartet_Close.Quartet_Close 
PrototypeC Quartet_Info(play, *pinfo)                 : Global Quartet_Info.Quartet_Info

PrototypeC Quartet_Init(play,rate,ms)                 : Global Quartet_Init.Quartet_Init

PrototypeC Quartet_Setup(play,mixer,spr)              : Global Quartet_Setup.Quartet_Setup
PrototypeC Quartet_Tick(play)                         : Global Quartet_Tick.Quartet_Tick
PrototypeC Quartet_Play(play,*pcm,n)                  : Global Quartet_Play.Quartet_Play 
PrototypeC Quartet_Position(play)                     : Global Quartet_Position.Quartet_Position
PrototypeC Quartet_Mixer_Info(id,*pname,*pdesc)       : Global Quartet_Mixer_Info.Quartet_Mixer_Info

XIncludeFile "SoundServer.pbi"
;*****************************************************************************
; Initalize Quartet
;*****************************************************************************

;/****** Quartet_Plugin.pbi/RML_Quartet_OpenLibrary ********************************
;* 
;*   NAME	
;* 	     RML_Quartet_OpenLibrary -- Opens SNDH dll.
;*
;*   SYNOPSIS
;*	     long library = RML_Quartet_OpenLibrary(library.s=#Quartet_PLUGIN)
;*
;*   FUNCTION
;*       Prototype the DLL functions.
;*
;*   INPUTS
;* 	     string library - can be ignored if the dll is in the location
;*       held in #Quartet_PLUGIN, else you can pass your own path.
;*	
;*   RESULT
;*       library pointer - value passed back from OpenLibrary()
;* 	     error - #False
;* 
;*****************************************************************************
Procedure RML_Quartet_OpenLibrary(library.s=#QUARTET_PLUGIN)  
  dll_plugin = OpenLibrary(#PB_Any,library)
  If dll_plugin
    Quartet_Core_Version = GetFunction(dll_plugin,"quartet_core_version")
    Quartet_Core_Mute = GetFunction(dll_plugin, "quartet_core_mute")
    Quartet_Core_Init = GetFunction(dll_plugin, "quartet_core_init")
    Quartet_Core_Kill = GetFunction(dll_plugin, "quartet_core_kill")
    Quartet_Core_Tick = GetFunction(dll_plugin, "quartet_core_tick")
    Quartet_Core_Play = GetFunction(dll_plugin, "quartet_core_play")
    Quartet_Core_Blend = GetFunction(dll_plugin, "quartet_core_blend")
    Quartet_Log_Bit = GetFunction(dll_plugin, "quartet_log_bit")
    Quartet_Log_Fun = GetFunction(dll_plugin, "quartet_log_fun")
    Quartet_Mem = GetFunction(dll_plugin, "quartet_mem")
    Quartet_New = GetFunction(dll_plugin, "quartet_new")
    Quartet_Del = GetFunction(dll_plugin, "quartet_del")
    Quartet_Load = GetFunction(dll_plugin, "quartet_load")
    Quartet_Close = GetFunction(dll_plugin, "quartet_close")
    Quartet_Info = GetFunction(dll_plugin, "quartet_info")
    Quartet_Init = GetFunction(dll_plugin, "quartet_init")
    Quartet_Setup = GetFunction(dll_plugin, "quartet_setup")
    Quartet_Tick = GetFunction(dll_plugin, "quartet_tick")
    Quartet_Play = GetFunction(dll_plugin, "quartet_play")
    Quartet_Position = GetFunction(dll_plugin, "quartet_position")
    Quartet_Mixer_Info = GetFunction(dll_plugin, "quartet_mixer_info")    
    SoundServer::p\library = dll_plugin
  Else 
    ProcedureReturn #False    
  EndIf
  ProcedureReturn dll_plugin
EndProcedure

;/****** Quartet_Plugin.pbi/RML_Quartet_Close **************************************
;* 
;*   NAME	
;* 	     RML_Quartet_Close -- Shut down SNDH dll
;*
;*   FUNCTION
;*       Closes the server library currently open. While it might seem still
;*       ridiculous to wrapper such a function as CloseLibrary() in this way
;*       it's future proofing, in the event that futre additions might require
;*       more deinitializing than just simply closing the library.
;* 
;*****************************************************************************
Procedure RML_Quartet_Close()
  CloseLibrary(SoundServer::p\library)
EndProcedure

;*****************************************************************************
; Sound Server Procedures
;*****************************************************************************

;*****************************************************************************
; Helpper Procedures
;*****************************************************************************
Procedure Quartet_Error(err.b)
  Select err
    Case #ZZ_OK		     : Debug(";/**< (0) No error.                       */")
    Case #ZZ_ERR	     : Debug(";/**< (1) Unspecified error.              */")
    Case #ZZ_EARG 	   : Debug(";/**< (2) Argument error.                 */")
    Case #ZZ_ESYS		   : Debug(";/**< (3) System error (I/O, memory ...). */")
    Case #ZZ_EINP		   : Debug(";/**< (4) Problem With input.             */")
    Case #ZZ_EOUT		   : Debug(";/**< (5) Problem With output.            */")
    Case #ZZ_ESNG		   : Debug(";/**< (6) Song error.                     */")
    Case #ZZ_ESET		   : Debug(";/**< (7) Voice set error                 */")
    Case #ZZ_EPLA		   : Debug(";/**< (8) Player error.                   */")
    Case #ZZ_EMIX		   : Debug(";/**< (9) Mixer error.                    */")
    Default
      Debug("???")
  EndSelect  
EndProcedure

Procedure.l RML_Quartet_LoadMusic(file.s)
EndProcedure

;*****************************************************************************
;                 !!ONLY!! -- Testing Purposes -- !!ONLY!!
;*****************************************************************************
;Source Data -- "Music/H_RACE_5.4Q"

; IDE Options = PureBasic 6.03 LTS (Windows - x86)
; CursorPosition = 297
; FirstLine = 256
; Folding = -
; EnableXP
; DPIAware