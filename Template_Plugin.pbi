;*****************************************************************************
;Author <name>
;Windows x86 
;Requires "<>.dll"
;URL
;*****************************************************************************
#<format>_DEBUG_PLUGIN = #False

CompilerIf #PB_Compiler_Processor = #PB_Processor_x86
  #SNDH_PLUGIN = "x86_Plugins/<format>.dll"
CompilerElseIf #PB_Compiler_Processor = #PB_Processor_x64
  #SNDH_PLUGIN = "x64_Plugins/<format>.dll"
CompilerEndIf
;*****************************************************************************
; Enumeration <format>
;*****************************************************************************

;*****************************************************************************
; Structure <format>
;*****************************************************************************

;*****************************************************************************
; Constants <format>
;*****************************************************************************

;*****************************************************************************
; Prototypes <format>
;*****************************************************************************

XIncludeFile "SoundServer.pbi"
;*****************************************************************************
; Initalize <format>
;*****************************************************************************

;/****** <format>_Plugin.pbi/RML_<format>_OpenLibrary ********************************
;* 
;*   NAME	
;* 	     RML_<format>_OpenLibrary -- Opens SNDH dll.
;*
;*   SYNOPSIS
;*	     long library = RML_<format>_OpenLibrary(library.s=#<format>_PLUGIN)
;*
;*   FUNCTION
;*       Prototype the DLL functions.
;*
;*   INPUTS
;* 	     string library - can be ignored if the dll is in the location
;*       held in #<format>_PLUGIN, else you can pass your own path.
;*	
;*   RESULT
;*       library pointer - value passed back from OpenLibrary()
;* 	     error - #False
;* 
;*****************************************************************************
Procedure RML_<format>_OpenLibrary(library.s=#<format>_PLUGIN)  
  dll_plugin = OpenLibrary(#PB_Any,library)
  If dll_plugin
    <format>_ = GetFunction(dll_plugin, "<function>")    
    SoundServer::p\library = dll_plugin
  Else 
    ProcedureReturn #False    
  EndIf
  ProcedureReturn dll_plugin
EndProcedure

;/****** <format>_Plugin.pbi/RML_<format>_Close **************************************
;* 
;*   NAME	
;* 	     RML_<format>_Close -- Shut down SNDH dll
;*
;*   FUNCTION
;*       Closes the server library currently open. While it might seem still
;*       ridiculous to wrapper such a function as CloseLibrary() in this way
;*       it's future proofing, in the event that futre additions might require
;*       more deinitializing than just simply closing the library.
;* 
;*****************************************************************************
Procedure RML_<format>_Close()
  CloseLibrary(SoundServer::p\library)
EndProcedure

;*****************************************************************************
; Sound Server Procedures
;*****************************************************************************

;*****************************************************************************
; Helpper Procedures
;*****************************************************************************

;*****************************************************************************
;                 !!ONLY!! -- Testing Purposes -- !!ONLY!!
;*****************************************************************************
; IDE Options = PureBasic 6.03 LTS (Windows - x86)
; CursorPosition = 22
; Folding = -
; EnableXP
; DPIAware