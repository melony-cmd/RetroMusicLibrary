
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
    Select Random(1)
      Case 0
        CallFunctionFast(b\slot1)
      Case 1
        CallFunctionFast(b\slot2)
    EndSelect        
  EndProcedure  
EndModule

Procedure BuyTheApples()
  Debug "YAY YOU'RE AN APPLE!"
EndProcedure

Procedure SellTheApples()
  Debug "YAY YOU'RE NOT APPLE!"
EndProcedure

Repeat
Apples::b\slot1 = @BuyTheApples()
Apples::b\slot2 = @SellTheApples()

Apples::GetApples()
ForEver
  
; IDE Options = PureBasic 6.03 LTS (Windows - x86)
; CursorPosition = 38
; Folding = -
; EnableXP
; DPIAware