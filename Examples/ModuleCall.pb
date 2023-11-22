
DeclareModule Apples
  
  Structure basketlist
    slot1.l
    slot2.l
  EndStructure
  Global b.basketlist
  
  Declare GetApples()
  
EndDeclareModule

Module Apples
  Procedure GetApples()
    CallFunctionFast(b\slot1)
  EndProcedure  
EndModule

Procedure BuyTheApples()
  Debug "YAY YOU'RE AN APPLE!"
EndProcedure

Apples::b\slot1 = @BuyTheApples()

Apples::GetApples()

  
; IDE Options = PureBasic 6.03 LTS (Windows - x86)
; CursorPosition = 11
; Folding = -
; EnableXP
; DPIAware