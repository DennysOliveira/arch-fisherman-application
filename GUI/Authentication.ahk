
; Variables
Global GuiName := "AuthenticationGUI"
Global GuiHandle := 0x0

; ----------------------
; Create a GUI

Gui, %GuiName%:New, +Hwnd%GuiHandle% +LastFound

; -> Define Gui1 Styles
WinSet, Trans, 245
WinSet, Style, -0x40000000 ; Removes WS_CHILD    
WinSet, Style, +0x0 ; Adds WS_OVERLAPPED  
WinSet, Style, -0x10000 ; Removes WS_MAXIMIZE 
WinSet, Style, -0x20000000 ; Removez WS_MINIMIZE 
WinSet, Style, +0x800000 ;     

; ----------------------
; Declare Global Control Variables
Global Edit_Username
Global Edit_Password

; ----------------------
; Declare controls
Global inputUsername
Global inputPassword

Gui, Add, Text, x10 y45 w200, Username
Gui, Add, Edit, x90 y40 r1 w140 -WantReturn vEdit_Username

Gui, Add, Text, x10 y75 w200, Password
Gui, Add, Edit, x90 y70 r1 w140 -WantReturn vEdit_Password

Gui, Add, Button, x60 y100 w120 h30 gButtonAuthenticate, Log in

Gui, %GuiName%:Show, w240 h160 Center

AuthenticationGUIGuiClose()
{
    ExitApp
}

ButtonAuthenticate()
{
    Gui, %GuiName%:Submit, NoHide
    MsgBox, % "L: " Edit_Username " P: " Edit_Password
    return
}
