Btn_Bind_0:
{
    waitingKey := true
    GuiControl, Text, Btn_Binding_0, % "Press a key..."
    GuiControl, Disable, Btn_Binding_0

    while (waitingKey) {
        MouseGetPos, mPosx, mPosy
        
        keyPressed := AnyKeyPressed()
        if(keyPressed != 0) {
            waitingKey := false

            GuiControl, Text, Btn_Binding_0, % "" . keyPressed . ""
            GuiControl, Enable, Btn_Binding_0
            
            KeyList[0] := keyPressed
        }
    }
    ToolTip, 
    return
}


Btn_Bind_1:
{
    waitingKey := true
    GuiControl, Text, Btn_Binding_1, % "Press a key..."
    GuiControl, Disable, Btn_Binding_1

    while (waitingKey) {
        MouseGetPos, mPosx, mPosy
        
        keyPressed := AnyKeyPressed()
        if(keyPressed != 0) {
            waitingKey := false

            GuiControl, Text, Btn_Binding_1, % "" . keyPressed . ""
            GuiControl, Enable, Btn_Binding_1
            
            KeyList[0] := keyPressed
        }
    }
    ToolTip, 
    return
}

Btn_Bind_2:
{
    waitingKey := true
    GuiControl, Text, Btn_Binding_2, % "Press a key..."
    GuiControl, Disable, Btn_Binding_2

    while (waitingKey) {
        MouseGetPos, mPosx, mPosy
        
        keyPressed := AnyKeyPressed()
        if(keyPressed != 0) {
            waitingKey := false

            GuiControl, Text, Btn_Binding_2, % "" . keyPressed . ""
            GuiControl, Enable, Btn_Binding_2
            
            KeyList[0] := keyPressed
        }
    }
    ToolTip, 
    return
}

Btn_Bind_3:
{
    waitingKey := true
    GuiControl, Text, Btn_Binding_3, % "Press a key..."
    GuiControl, Disable, Btn_Binding_3

    while (waitingKey) {
        MouseGetPos, mPosx, mPosy
        
        keyPressed := AnyKeyPressed()
        if(keyPressed != 0) {
            waitingKey := false

            GuiControl, Text, Btn_Binding_3, % "" . keyPressed . ""
            GuiControl, Enable, Btn_Binding_3
            
            KeyList[0] := keyPressed
        }
    }
    ToolTip, 
    return
}

Btn_Bind_4:
{
    waitingKey := true
    GuiControl, Text, Btn_Binding_4, % "Press a key..."
    GuiControl, Disable, Btn_Binding_4

    while (waitingKey) {
        MouseGetPos, mPosx, mPosy
        
        keyPressed := AnyKeyPressed()
        if(keyPressed != 0) {
            waitingKey := false

            GuiControl, Text, Btn_Binding_4, % "" . keyPressed . ""
            GuiControl, Enable, Btn_Binding_4
            
            KeyList[0] := keyPressed
        }
    }
    ToolTip, 
    return
}

AnyKeyPressed() {
    Loop, 256 {                
        If (GetKeyState(Format("vk{:x}", A_Index - 1), "P")) {
            return GetKeyName(Format("vk{:x}", A_Index-1))
        }
        
    }
    return 0
}