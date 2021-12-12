SetKeyDelay, 15, 25
CoordMode, ToolTip, Screen
CoordMode, Pixel, Screen
CoordMode, Mouse, Screen

#InstallKeybdHook
; [x] Function to add a new game client to the game handle list
; [x] Function to emit key events to game client windows
; [x] Create a GUI for users to authenticate
; [ ] Enable user to save its data
; [ ] Enable user to load saved data, manually
; [ ] Enable user to change Keybinds for hotkeys

; Import libraries
#Include, Lib/Utilities.ahk
#Include, Lib/JSON.ahk

; Global Variables
Global state := { PAUSED: 0, ACTIVE: 1 }
Global CurrentState := state.PAUSED
Global GameClients := []
Global BroadcasterHandle

; Script Config
Global ConfigDir := A_AppData "\Bardsnight\AA Kyrios Fisherman\"
Global ConfigFullPath := ConfigDir "user.preferences"
Global GuiVisible := false
Global ApplicationVersion := "1.0.0"

; User Config
Global KeyList := ["y", "u", "i", "h", "j"]

Global AverageLatency := 200

Global SpellTimer := [A_TickCount, A_TickCount, A_TickCount, A_TickCount, A_TickCount]

Global BroadcasterCharacter := "Rubinite"

; User pointer config
Global targetBar := { x: 0, y: 0, c: 0 }
Global fishingBar := [{ x: 0, y: 0, c: 0 }
,{ x: 0, y: 0, c: 0 }
,{ x: 0, y: 0, c: 0 }
,{ x: 0, y: 0, c: 0 }
,{ x: 0, y: 0, c: 0 }]

Global currentFishingBarColor := []

#Include, Routines/ValidateVersion.ahk

result := GetServerSideVersion()

if(result.version.number != ApplicationVersion) {
    MsgBox, % "Application version outdated. Download a new version on the website."
    ExitApp, 0
}

#Include, GUI/Authentication.ahk

While (!authenticated) {

}

Initialize()

; Main Loop
Loop {
    ; If app enabled
    if (CurrentState = state.ACTIVE){
        ; Get current pixel color based on earlier x,y set positions
        ; Target Bar pixel
        currentTargetBarColor := PixelGetColor(targetBar.x, targetBar.y)

        ; Validate Target Existance using Pixel Color Checks
        if (currentTargetBarColor = targetBar.c) {
            for index, element in fishingBar {
                ; Get current color
                currentColor := PixelGetColor(element.x, element.y)

                ; Verify current spell timer
                if(TimerDiff(SpellTimer[index]) > (5000 - AverageLatency)) {
                    ; Verify if current color is diff   
                    if (currentColor != element.c){

                        MsgBox, % "Index Verification - SpellTimer: " SpellTimer[index] " - Key: " KeyList[index]

                        ; Broadcast keys through all connected clients for the current skill
                        Broadcast(KeyList[index])
                        SpellTimer[index] := TimerInit()
                        ClearTooltip()
                    }
                }
            }
        } 
    }
}

Broadcast(key) {
    ; decVK := GetKeyVK(key)
    ; hexVK := Format("{vk{:x}}", decVK)
    ; MsgBox, % key " -> " GetKeyVK(key) " -> " hexVK
    ControlSend,, %key%, ahk_id %BroadcasterHandle%

    For index, client in GameClients {
        ControlSend,, %key%, ahk_id %client%
    }

    Sleep, 100
}

ToggleScript() {
    if (CurrentState = state.ACTIVE) {
        CurrentState := state.PAUSED
        TrayTip, Disabled, App deactivated
    } else {
        CurrentState := state.ACTIVE
        TrayTip, Enabled, App activated
    } 
}

GetBroadcasterTarget() {
    For index, client in GameClients {
        ControlSend,, {F5}, ahk_id %client%
    }
}

Initialize() {

    ; Create the GUI inside the broadcaster client
    Global GuiHandle := InstantiateGUI()

    ; Show GUI Manually centered as first position
    Gui, MainGUI:Show, Center
    GuiVisible := true

}

InstantiateGUI(){
    ; Declare global GUI variables so they doesn't lead to an exception.
    Global TabManager

    ; Create a GUI
    ; Gui, MainGUI:New, +HwndGuiHandle +AlwaysOnTop +Parent%BroadcasterHandle% -Caption +LastFound
    Gui, MainGUI:New, +HwndGuiHandle +LastFound
    Gui, Add, Tab3, x5 y30 w290 h230 vTabManager , Status|Preferences|Configuration

    ; -> Define Gui1 Styles
    WinSet, Trans, 225
    WinSet, Style, -0x40000000 ; Removes WS_CHILD    
    WinSet, Style, +0x0 ; Adds WS_OVERLAPPED  
    WinSet, Style, -0x10000 ; Removes WS_MAXIMIZE 
    WinSet, Style, -0x20000000 ; Removez WS_MINIMIZE 
    WinSet, Style, +0x800000 ; 
    ; Gui,    Color,  Gray        ; Set Main BG Color to Dark Blue

    ; Non-tab specific Controls
    Gui, Tab ; When declaring this line, every control created below will NOT be TAB specific
    Gui, Add, Text, x150 y15 cBlack, Press [Shift + F3] to attach the main client. ; Header Text
    Gui, Add, Button, w100 h20 x190 y270 gSaveRoutine, Save ; Save Config Button

    ; ################
    ; Tab: Status
    Gui, Tab, Status ; Set tab to add controls
    ; Variables:
    Global GuiControl_BroadcasterStatus
    Global GuiControl_AttachedClients

    ; Status tab controls
    Gui, Add, Text, x10 y60 , Application Status

    Gui, Add, Text, x10 y80 w1000 vGuiControl_BroadcasterStatus
    GuiControl, Text, GuiControl_BroadcasterStatus, % "Broadcaster Status: OK - [" . BroadcasterHandle . "]"

    Gui, Add, Text, x10 y110 w1000 vGuiControl_AttachedClients
    GuiControl, Text, GuiControl_AttachedClients, % "Attached Clients: [0]"

    ; ################
    ; Tab: Configuration
    Gui, Tab, Configuration ; Set tab to add controls
    ; Variables:
    Global GuiControl_StatusTargetBarPosition
    Global GuiControl_StatusTargetBarColor
    Global GuiControl_StatusFishingBarPosition
    Global GuiControl_StatusFishingBarColor

    ; Configuration Tab Controls
    Gui, Add, Text, x10 y60 , Get Target Health Bar Information
    Gui, Add, Button, w100 h20 x10 y80 gBtnGetTargetBarPosition, Get Position
    Gui, Add, Button, w100 h20 x120 y80 gBtnGetTargetBarColor, Get Colors

    Gui, Add, Text, x10 y100 w500 vGuiControl_StatusTargetBarPosition, Position: Not set
    Gui, Add, Text, x140 y100 w500 vGuiControl_StatusTargetBarColor, Color: Not set

    Gui, Add, Text, x10 y140 , Get Fishing Bar Information
    Gui, Add, Button, w100 h20 x10 y160 gBtnGetFishingBarPosition, Get Position
    Gui, Add, Button, w100 h20 x120 y160 gBtnGetFishingBarColor, Get Color

    Gui, Add, Text, x10 y180 vGuiControl_StatusFishingBarPosition, Position: Not set
    Gui, Add, Text, x140 y180 vGuiControl_StatusFishingBarColor, Color: Not set

    ; Tab: Preferences
    Gui, Tab, Preferences
    ; Variables:
    Global GuiControl_Edit_BroadcasterCharacter
    Global Btn_Binding_0
    Global Btn_Binding_1
    Global Btn_Binding_2
    Global Btn_Binding_3
    Global Btn_Binding_4

    ; Preferences Tab Controls
    Gui, Add, Text, x10 y60, Main Character Name
    Gui, Add, Edit, x10 y80 r1 w120 -WantReturn vGuiControl_Edit_BroadcasterCharacter gBroadcasterCharacterUpdated, %BroadcasterCharacter%

    Gui, Add, Text, x10 y120, Keybindings
    Gui, Add, Text, x10 y140, "1: "
    Gui, Add, Button, w100 h20 x120 y140 gBtn_Bind_0 vBtn_Binding_0, % KeyList[1]

    Gui, Add, Text, x10 y160, "2: "
    Gui, Add, Button, w100 h20 x120 y160 gBtn_Bind_1 vBtn_Binding_1, % KeyList[2]

    Gui, Add, Text, x10 y180, "3: "
    Gui, Add, Button, w100 h20 x120 y180 gBtn_Bind_2 vBtn_Binding_2, % KeyList[3]

    Gui, Add, Text, x10 y200, "4: "
    Gui, Add, Button, w100 h20 x120 y200 gBtn_Bind_3 vBtn_Binding_3, % KeyList[4]

    Gui, Add, Text, x10 y220, "5: "
    Gui, Add, Button, w100 h20 x120 y220 gBtn_Bind_4 vBtn_Binding_4, % KeyList[5]

    ; Clear tab 
    Gui, Tab

    ; Declares SubMenus and their Options
    Menu, File_Submenu, Add, &Save, SaveRoutine
    Menu, File_Submenu, Add, &Exit, ExitRoutine
    Menu, Tools_Submenu, Add, &Debug, DebugRoutine
    Menu, Help_Submenu, Add, &About, AboutRoutine

    ; Adds Submenus to MenuBar
    Menu, MenuBar, Add, &File, :File_Submenu
    Menu, MenuBar, Add, &Tools, :Tools_Submenu
    Menu, MenuBar, Add, &Help, :Help_Submenu

    ; Define MenuBar Styles
    Menu, MenuBar, Color, White

    ; Append menu "MenuBar" to LastFound Gui
    Gui, Menu, MenuBar

    Global IsGuiVisible := true
    Gui, MainGUI:Show, x0 y0 

    return %GuiHandle%
}

AttachGameClient() {
    newClienthandle := WinActive("ahk_class ArcheAge") 
    WinGetTitle, gameTitle, ahk_id %newClienthandle% 

    if (!newClientHandle) {
        TrayTip, Failure, Game client not detected,,3
    }

    clientExists := false
    for index, clientHandle in GameClients { 
        if(newClienthandle = clientHandle) { 
            Sleep, 222
            clientExists := true
            TrayTip, Fail, This game is already attached to the list.,,3

        }
    }

    if (clientExists = false) { 
        GameClients.Push(newClientHandle) 
        TrayTip, Success, Game client %newClienthandle% attached successfully.,,1
        GuiControl, MainGUI:Text, GuiControl_AttachedClients, % "Attached Clients: [" . GameClients.MaxIndex() . "]"
    } 
}

AttachBroadcaster() { 

    newClienthandle := WinActive("ahk_class ArcheAge") 
    WinGetTitle, gameTitle, ahk_id %newClienthandle% 

    ; Verify if broadcaster already exists
    if (BroadcasterHandle) {
        MsgBox, A client is already set as broadcaster: %BroadcasterHandle%
        return false
    } else if (BroadcasterHandle = newClienthandle) {
        MsgBox, This client is already set as the broadcaster.
        return false
    }

    if (newClientHandle) {
        BroadcasterHandle := newClienthandle
        TrayTip, Success, Broadcaster game client attached to %newClienthandle%,,1 
        return true
    } else {
        TrayTip, Fail, Couldn't find a game to attach to.,,3
        return false
    }

}

TestAttach() {
}

ToggleGUI(){
    Gui, MainGUI:Show

    if (GuiVisible) {
        Gui, MainGUI:Hide
        GuiVisible := false
    } else {
        Gui, MainGUI:Show
        GuiVisible := true
    }
}

BtnGetTargetBarPosition:
    { 
        While(!GetKeyState("LButton"))
        {
            mPos := MouseGetPos()
            ToolTip, % "Clique no comeco da barra de mana do Target.", mPos[0] + 10, mPos[1] + 10
        }

        targetBar.x := mPos[0]
        targetBar.y := mPos[1] 

        GuiControl, MainGUI:Text, GuiControl_StatusTargetBarPosition, % "Position: [" . targetBar.x . ", " . targetBar.y . "]"
        GuiControl, MainGUI:Text, GuiControl_StatusTargetBarColor, % "Color: Not set"
        targetBar.c := 0

        TrayTip, Success, % "A posição da barra de mana do alvo foi carregada com sucesso."

        ClearTooltip()
        return
    }

BtnGetTargetBarColor:
    {
        if (targetBar.x = 0 || targetBar.y = 0) {
            TrayTip, Error, % "To get the color, you have to set a position"
            return
        }

        targetBar.c := PixelGetColor(targetBar.x, targetBar.y) 
        fontColor := targetBar.c
        Gui, Font, %fontColor%
        GuiControl, MainGUI:Text, GuiControl_StatusTargetBarColor, % "Color: [" . targetBar.c . "]"
        TrayTip, Success, % "As cores da barra de mana do alvo foram carregadas com sucesso."
        return
    }

BtnGetFishingBarPosition:
    {

        for index, value in fishingBar {
            While(!GetKeyState("LButton"))
            {
                mPos := MouseGetPos()
                ToolTip, % "X: " mPos[0] " Y: " mPos[1] " - Clique na " . index . "a habilidade de pesca.", mPos[0] + 10, mPos[1] + 10
            }

            mPos := MouseGetPos()
            fishingBar[index].x := mPos[0]
            fishingBar[index].y := mPos[1]

            While(!GetKeyState("x", "P")) {
                mPos := MouseGetPos()
                ; col := PixelGetColor()
                ToolTip, % "Press X to store the current skill color as the neutral state."
            }

            mPos := MouseGetPos()
            fishingBar[index].c := PixelGetColor(fishingBar[index].x, fishingBar[index].y)

            ClearTooltip()
            Sleep, 250
        } 

        TrayTip, Success, % "All skillbar positions were set successfully."
        GuiControl, MainGUI:Text, GuiControl_StatusFishingBarPosition, % "Position: Set"
        GuiControl, MainGUI:Text, GuiControl_StatusFishingBarColor, % "Color: Set"

        return
    }

BtnGetFishingBarColor:
    { 
        ; if (fishingBar[0].x = 0) {
        ;     TrayTip, Error, You have to set position before grabbing color.
        ;     return
        ; }

        ; for index, element in fishingBar {
        ;     if(element.x = 0 and element.y = 0) {
        ;         TrayTip, Error, You have to set position before grabbing color.
        ;         return
        ;     }

        ;     ; positionArray := [element.x, element.y]
        ;     fishingBar[index].c := PixelGetColor(element.x, element.y)
        ; }
        ; GuiControl, MainGUI:Text, GuiControl_StatusFishingBarColor, % "Color: Set"

        return
    }

    MainGUIGuiClose() {
        MsgBox, 0x4, Exit, Do you want to exit?
        IfMsgBox Yes
        ExitApp
        else 
            return

    }

    MouseGetPos(){
        array := []
        MouseGetPos, posX, posY
        array[0] := posX
        array[1] := posY
        return array
    }

    PixelGetColor(posX, posY){
        PixelGetColor, color, posX, posY, Alt
        ; MsgBox, % posX ", " posY " equals to " color
        return color
    }

    TimerDiff(timer){
        now := A_TickCount
        result := now - timer
        return result
    }

    TimerInit(){
        return A_TickCount
    }

    #Include, GUI/Routines/Interface/Interaction.ahk
    #Include, GUI/Routines/Preferences/Keybinding.ahk

    ; #Include, Debug/DebugFunctions.ahk

    ; Setup hotkeys
    +F3::AttachBroadcaster()

    ; Usage hotkeys
    +F1::ToggleScript()
    +F2::AttachGameClient()

    +F::GetBroadcasterTarget()