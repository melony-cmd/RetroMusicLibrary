

Procedure TEST(value)
  Debug "Hello!"
  Debug value
EndProcedure

procadd=@TEST()

Debug procadd

CallFunctionFast(procadd,100)

; IDE Options = PureBasic 6.03 LTS (Windows - x86)
; CursorPosition = 2
; Folding = -
; EnableXP
; DPIAware