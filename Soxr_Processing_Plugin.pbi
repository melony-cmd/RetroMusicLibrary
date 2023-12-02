;*****************************************************************************
; Author T.J.Roughton
; Windows x86/x64 
; Requires "SOXR.dll"
;
; The SoX Resampler
;   https://sourceforge.net/projects/soxr/
;   The SoX Resampler library `libsoxr' performs one-dimensional sample-rate 
;   conversion—it may be used, for example, to resample PCM-encoded audio.
;
;   It aims to give fast and high quality results for any constant 
;   (rational Or irrational) resampling ratio. Phase-response, preserved bandwidth,
;   aliasing, and rejection level parameters are all configurable; alternatively,
;   simple `preset' configurations may be selected. An experimental,
;   variable-rate resampling mode of operation is also included.
;
; Author Notes:
; 
;   I've no idea what this does, it was found in rePlayer under the replay
;   folder Quartet along with zingzong which is the actual renderer for
;   quartet I assumed/presumed it would be required for Quartet since it was
;   located where it was.
;
;   Since then it was discovered that this Soxr.dll whatever it is, is a 
;   project written that is seporate from Quartet entirely and is intended
;   for a more general purpose.
;
;   The only knowolage I've been able to understand about Soxr is it's some
;   sort of sound processor of sorts.
;
;   I'm unable to test this to see if it works, thus some errors may exist
;   in prototype/structs/etc. as part of being able to make something works
;   is understanding what it is supposed to be or do, thus the massive amount
;   of code documentation.
;
;*****************************************************************************
#SOXR_DEBUG_PLUGIN = #False

CompilerIf #PB_Compiler_Processor = #PB_Processor_x86
  #SOXR_PLUGIN = "x86_Plugins/soxr.dll"
CompilerElseIf #PB_Compiler_Processor = #PB_Processor_x64
  #SOXR_PLUGIN = "x64_Plugins/soxr.dll"
CompilerEndIf

;*****************************************************************************
; Enumeration SOXR
;*****************************************************************************
Enumeration soxr_datatype_t ;/* Datatypes supported For I/O To/from the resampler: */
  ;/* Internal; do not use: */
  #SOXR_FLOAT32
  #SOXR_FLOAT64
  #SOXR_INT32
  #SOXR_INT16
  #SOXR_SPLIT = 4

  ;/* Use For interleaved channels: */
  #SOXR_FLOAT32_I = #SOXR_FLOAT32
  #SOXR_FLOAT64_I
  #SOXR_INT32_I
  #SOXR_INT16_I

  ;/* Use For split channels: */
  #SOXR_FLOAT32_S = #SOXR_SPLIT  
  #SOXR_FLOAT64_S
  #SOXR_INT32_S
  #SOXR_INT16_S
EndEnumeration

;*****************************************************************************
; Constants SOXR
;*****************************************************************************

#SOXR_TPDF =               0     ;/* Applicable only If otype is INT16. */
#SOXR_NO_DITHER =          8     ;/* Disable the above. */

#SOXR_ROLLOFF_SMALL =      0     ;/* <= 0.01 dB */
#SOXR_ROLLOFF_MEDIUM =     1     ;/* <= 0.35 dB */
#SOXR_ROLLOFF_NONE =       2     ;/* For Chebyshev bandwidth. */

#SOXR_HI_PREC_CLOCK =      8     ;/* Increase `irrational' ratio accuracy. */
#SOXR_DOUBLE_PRECISION =   16    ;/* Use D.P. calcs even If precision <= 20. */
#SOXR_VR =                 32    ;/* Variable-rate resampling. */

                                 ;/* For `irrational' ratios only: */
#SOXR_COEF_INTERP_AUTO =   0     ;/* Auto Select coef. interpolation. */
#SOXR_COEF_INTERP_LOW =    2     ;/* Man. Select: less CPU, more memory. */
#SOXR_COEF_INTERP_HIGH =   3     ;/* Man. Select: more CPU, less memory. */

#SOXR_QQ =                 0     ;/* 'Quick' cubic interpolation. */
#SOXR_LQ =                 1     ;/* 'Low' 16-bit With larger rolloff. */
#SOXR_MQ =                 2     ;/* 'Medium' 16-bit With medium rolloff. */
#SOXR_HQ =                 4     ;#SOXR_20_BITQ /* 'High quality'. */
#SOXR_VHQ =                6     ;#SOXR_28_BITQ /* 'Very high quality'. */

#SOXR_16_BITQ =            3
#SOXR_20_BITQ =            4
#SOXR_24_BITQ =            5
#SOXR_28_BITQ =            6
#SOXR_32_BITQ =            7
                           ;/* Reserved For internal use (To be removed): */
#SOXR_LSR0Q =              8     ;/* 'Best sinc'. */
#SOXR_LSR1Q =              9     ;/* 'Medium sinc'. */
#SOXR_LSR2Q =              10    ;/* 'Fast sinc'. */

#SOXR_LINEAR_PHASE =       0
#SOXR_INTERMEDIATE_PHASE = 16
#SOXR_MINIMUM_PHASE =      48
#SOXR_STEEP_FILTER =       64

;*****************************************************************************
; Structure SOXR
;*****************************************************************************
Structure struct_soxr_io_spec                                                 ;                                      /* Typically */
  itype.l                                                                     ;soxr_datatype_t /* Input datatype.  SOXR_FLOAT32_I */
  otype.l                                                                     ;soxr_datatype_t /* Output datatype. SOXR_FLOAT32_I */
  scale.d                                                                     ;/* Linear gain to apply during resampling.  1      */
  *e                                                                          ;/* Reserved for internal use                0      */
  flags.l                                                                     ;/* Per the following #defines.              0      */
EndStructure

Structure struct_soxr_quality_spec                                            ;                                     /* Typically */
   precision.d                                                                ;/* Conversion precision (in bits).           20   */
   phase_response.d                                                           ;/* 0=minimum, ... 50=linear, ... 100=maximum 50   */
   passband_end.d                                                             ;/* 0dB pt. bandwidth to preserve; nyquist=1  0.913*/
   stopband_begin.d                                                           ;/* Aliasing/imaging control; > passband_end   1   */
   *e                                                                         ;/* Reserved for internal use.                 0   */
   flags.l                                                                    ;/* Per the following #defines.                0   */
EndStructure

Structure struct_soxr_runtime_spec                                            ;                                 /* Typically */
   log2_min_dft_size.i                                                        ;/* For DFT efficiency. [8,15]           10    */
   log2_large_dft_size.i                                                      ;/* For DFT efficiency. [8,20]           17    */
   coef_size_kbytes.i                                                         ;/* For SOXR_COEF_INTERP_AUTO (below).   400   */
   num_threads.i                                                              ;/* 0: per OMP_NUM_THREADS; 1: 1 thread.  1    */
   *e                                                                         ;/* Reserved for internal use.            0    */
   flags.l                                                                    ;/* Per the following #defines.           0    */
EndStructure

;*****************************************************************************
; Prototypes SOXR
;*****************************************************************************

;/* --------------------------- API main functions --------------------------- */
PrototypeC SOXR_Version() : Global SOXR_Version.SOXR_Version

; /* Create a stream resampler: */
PrototypeC SOXR_Create(input_rate.d,                                          ;/* Input sample-rate. */
                       output_rate.d,                                         ;/* Output sample-rate. */
                       num_channels.i,                                        ;/* Number of channels To be used. */
                                                                              ;/* All following arguments are optional (may be set To NULL). */
                       *soxr_error_t,                                         ;/* To report any error during creation. */
                       *soxr_io_spec_t,                                       ;/* To specify non-Default I/O formats. */
                       *soxr_quality_spec_t,                                  ;/* To specify non-Default resampling quality.*/
                       *soxr_runtime_spec_t)                                  ;/* To specify non-default runtime resources. */
                       Global SOXR_Create.SOXR_Create

;Default io_spec      is per soxr_io_spec(SOXR_FLOAT32_I, SOXR_FLOAT32_I)
;Default quality_spec is per soxr_quality_spec(SOXR_HQ, 0)
;Default runtime_spec is per soxr_runtime_spec(1)                       
                       
;/* If not using an app-supplied input function, after creating a stream
; * resampler, repeatedly call: */
PrototypeC SOXR_Process(soxr,                                                 ;/* As returned by soxr_create. */
                                                                              ;/* Input (To be resampled): */
                        in,                                                   ;/* Input buffer(s); may be NULL (see below). */
                        ilen,                                                 ;/* Input buf. length (samples per channel). */
                        *idone,                                               ;/* To Return actual # samples used (<= ilen). */
                                                                              ;/* Output (resampled): */
                        out,                                                  ;/* Output buffer(s).*/
                        olen,                                                 ;/* Output buf. length (samples per channel). */
                        *odone)                                               ;/* To return actual # samples out (<= olen).
                        Global SOXR_Process.SOXR_Process 
 
;Note that no special meaning is associated With ilen Or olen equal To
;zero.  End-of-Input (i.e. no Data is available nor shall be available)
;may be indicated by seting `in' to NULL.                        
                        
;/* If using an app-supplied input function, it must look And behave like this:*/

;typedef size_t /* data_len */
;  (* soxr_input_fn_t)(         /* Supply data to be resampled. */
;    void * input_fn_state,     /* As given to soxr_set_input_fn (below). */
;    soxr_in_t * data,          /* Returned data; see below. N.B. ptr to ptr(s)*/
;    size_t requested_len);     /* Samples per channel, >= returned data_len.

;   data_len  *data     Indicates    Meaning
;   ------- -------   ------------  -------------------------
;     !=0     !=0       Success     *data contains data to be
;                                   input to the resampler.
;      0    !=0 (or   End-of-input  No data is available nor
;           not set)                shall be available.
;      0       0        Failure     An error occurred whilst trying to
;                                   source data to be input to the resampler.  */
                        
;/* and be registered with a previously created stream resampler using: */
                                                    ;/* Set (or reset) an input function.*/                        
PrototypeC SOXR_Input_fn(resampler,                 ;/* As returned by soxr_create. */                                                    
                         soxr_input_fn_t,           ;/* Function to supply data to be resampled.*/
                         *input_fn_state,           ;/* If needed by the input function. */
                         max_ilen.i)                ;/* Maximum value for input fn. requested_len.*/
                         Global SOXR_Input_fn.SOXR_Input_fn 
                         
;/* then repeatedly call: */
                                                    ;/* Resample And output a block of Data.*/                 
PrototypeC SOXR_Output(resampler,                   ;/* As returned by soxr_create. */                                                    
                       odata,                       ;/* App-supplied buffer(s) For resampled Data.*/
                       olen)                        ;/* Amount of data to output; >= odone. */
                       Global SOXR_Output.SOXR_Output 

;/* Common stream resampler operations: */
                       
PrototypeC SOXR_Error(soxr_t) : Global SOXR_Error.SOXR_Error 
PrototypeC SOXR_Num_Clips(soxr_t) : Global SOXR_Num_Clips.SOXR_Num_Clips  
PrototypeC SOXR_Delay(soxr_t) : Global SOXR_Delay.SOXR_Delay 
PrototypeC SOXR_Engine(soxr_t) : Global SOXR_Engine.SOXR_Engine 
PrototypeC SOXR_Clear(soxr_t) : Global SOXR_Clear.SOXR_Clear
PrototypeC SOXR_Delete(soxr_t) : Global SOXR_Delete.SOXR_Delete 

; /* `Short-cut', single call to resample a (probably short) signal held entirely
;  * in memory.  See soxr_create And soxr_process above For parameter details.
;  * Note that unlike soxr_create however, the Default quality spec. For
;  * soxr_oneshot is per soxr_quality_spec(SOXR_LQ, 0). */

PrototypeC SOXR_OneShot(input_rate.d,
                        output_rate.d,
                        num_channels.i,
                        in , ilen, *idone,
                        out, olen, *odone,
                        *soxr_io_spec_t,
                        *soxr_quality_spec_t,
                        *soxr_runtime_spec_t)
                        Global SOXR_OneShot.SOXR_OneShot 

; /* For variable-rate resampling. See example # 5 For how To create a
;  * variable-rate resampler And how To use this function. */
                        
PrototypeC SOXR_Set_IO_Ratio(soxr_t,io_ratio.d,size.i) : Global SOXR_Set_IO_Ratio.SOXR_Set_IO_Ratio 

;/* -------------------------- API type constructors ------------------------- */

;/* These functions allow setting of the most commonly-used structure
; * parameters, with other parameters being given default values.  The default
; * values may then be overridden, directly in the structure, if needed.  */

PrototypeC SOXR_Quality_Spec(recipe.i,flags.i) : Global SOXR_Quality_Spec.SOXR_Quality_Spec

PrototypeC SOXR_RunTime_Spec(num_threads.i) : Global SOXR_RunTime_Spec.SOXR_RunTime_Spec 
PrototypeC SOXR_IO_Spec(itype.i,otype.i) : Global SOXR_IO_Spec.SOXR_IO_Spec

;/* --------------------------- Advanced use only ---------------------------- */

;/* For new designs, the following functions/usage will probably not be needed.
; * They might be useful when adding soxr into an existing design where values
; * for the resampling-rate and/or number-of-channels parameters to soxr_create
; * are not available when that function will be called.  In such cases, the
; * relevant soxr_create parameter(s) can be given as 0, then one or both of the
; * following (as appropriate) later invoked (but prior to calling soxr_process
; * or soxr_output):
; *
; * soxr_set_error(soxr, soxr_set_io_ratio(soxr, io_ratio, 0));
; * soxr_set_error(soxr, soxr_set_num_channels(soxr, num_channels));
; */

PrototypeC SOXR_Set_Error(soxr_t,soxr_error.i) : Global SOXR_Set_Error.SOXR_Set_Error 
PrototypeC SOXR_Set_Num_Channels(soxr_t,num_channels.i) : Global SOXR_Set_Num_Channels.SOXR_Set_Num_Channels 

XIncludeFile "SoundServer.pbi"

;*****************************************************************************
; Initalize SOXR
;*****************************************************************************

;/****** SOXR_Plugin.pbi/RML_SOXR_OpenLibrary ********************************
;* 
;*   NAME	
;* 	     RML_SOXR_OpenLibrary -- Opens SNDH dll.
;*
;*   SYNOPSIS
;*	     long library = RML_SOXR_OpenLibrary(library.s=#SOXR_PLUGIN)
;*
;*   FUNCTION
;*       Prototype the DLL functions.
;*
;*   INPUTS
;* 	     string library - can be ignored if the dll is in the location
;*       held in #SOXR_PLUGIN, else you can pass your own path.
;*	
;*   RESULT
;*       library pointer - value passed back from OpenLibrary()
;* 	     error - #False
;* 
;*****************************************************************************
Procedure RML_SOXR_OpenLibrary(library.s=#SOXR_PLUGIN)  
  dll_plugin = OpenLibrary(#PB_Any,library)
  If dll_plugin
    SOXR_Clear = GetFunction(dll_plugin, "soxr_clear")
    SOXR_Create = GetFunction(dll_plugin, "soxr_create")
    SOXR_Delay = GetFunction(dll_plugin, "soxr_delay")
    SOXR_Delete = GetFunction(dll_plugin, "soxr_delete")
    SOXR_Engine = GetFunction(dll_plugin, "soxr_engine")
    SOXR_Error = GetFunction(dll_plugin, "soxr_error")
    SOXR_IO_Spec = GetFunction(dll_plugin, "soxr_io_spec")
    SOXR_Num_Clips = GetFunction(dll_plugin, "soxr_num_clips")
    SOXR_OneShot = GetFunction(dll_plugin, "soxr_oneshot")
    SOXR_Output = GetFunction(dll_plugin, "soxr_output")
    SOXR_Process = GetFunction(dll_plugin, "soxr_process")
    SOXR_Quality_Spec = GetFunction(dll_plugin, "soxr_quality_spec")
    SOXR_RunTime_Spec = GetFunction(dll_plugin, "soxr_runtime_spec")
    SOXR_Set_Error = GetFunction(dll_plugin, "soxr_set_error")
    SOXR_Input_fn = GetFunction(dll_plugin, "soxr_set_input_fn")
    SOXR_Set_IO_Ratio = GetFunction(dll_plugin, "soxr_set_io_ratio")
    SOXR_Set_Num_Channels = GetFunction(dll_plugin, "soxr_set_num_channels")
    SOXR_Version = GetFunction(dll_plugin, "soxr_version")
    SoundServer::Add_Audio_Processor(#SOXR_PLUGIN,dll_plugin)
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
Procedure RML_SOXR_Close()
  SoundServer::Remove_Audio_Processor(#SOXR_PLUGIN)
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

RML_SOXR_OpenLibrary()
Debug PeekS(SOXR_Version(),-1,#PB_Ascii)

ShowMemoryViewer(SOXR_Version(),16)
RML_SOXR_Close()
; IDE Options = PureBasic 6.03 LTS (Windows - x86)
; CursorPosition = 33
; Folding = -
; EnableXP
; DPIAware