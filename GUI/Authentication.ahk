

; Variables
Global GuiName := "AuthenticationGUI"
Global GuiHandle := 0x0
Global BaseURL := "http://localhost:4000"

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
Gui, Add, Edit, x90 y40 r1 w140 -WantReturn vEdit_Username gCredentialsUpdated

Gui, Add, Text, x10 y75 w200, Password
Gui, Add, Edit, x90 y70 r1 w140 -WantReturn +Password vEdit_Password gCredentialsUpdated

Gui, Add, Button, x60 y100 w120 h30 gButtonAuthenticate, Log in

Gui, %GuiName%:Show, w240 h160 Center

_GuiHandle := GuiHandle
_GuiName := GuiName

CredentialsUpdated() 
{
    Gui, AuthenticationGUI:Submit, NoHide

    inputUsername := Edit_Username
    inputPassword := Edit_Password
}

AuthenticationGUIGuiClose()
{
    ExitApp
}

ButtonAuthenticate()
{
    Gui, AuthenticationGUI:Submit, NoHide
    result := AuthenticateUserRequest(Edit_Username, Edit_Password)
    ; MsgBox, % result
    Global authenticated := result
    if(authenticated) {
        Gui, AuthenticationGUI:Destroy
    }
    return
}

AuthenticateUserRequest(username, password)
{
    endpoint := "http://localhost:4000/api/v1/user/authenticate"

    try { 
        ; Create WinHTTPRequest Object
        request := ComObjCreate("WinHttp.WinHttpRequest.5.1") 

        request.SetTimeouts(0, 30000, 30000, 120000)

        ; 
        request.Open("POST", endpoint, true)

        ; 
        request.setRequestHeader("Content-Type", "application/json")

        ; Dump object into a JSON string
        body := JSON.Dump({"username": username, "password": password})

        request.Send(body) 

        request.WaitForResponse() 

        result := JSON.Load(request.ResponseText)
        json := JSON.Dump(result,, 2)

        if(!result.success) {
            MsgBox, % result.message
        }

        return result.success

    }catch e{ 
        MsgBox, % e.message
    }
}