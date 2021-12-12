
SaveRoutine:
{
    return
}

ExitRoutine:
{
    return
}

DebugRoutine:
{
    return
}

AboutRoutine:
{
    return
}

BroadcasterCharacterUpdated:
{
    Gui, MainGUI:Submit, NoHide
    ; TrayTip, Changed, New name: %GuiControl_Edit_BroadcasterCharacter%
    BroadcasterCharacter := GuiControl_Edit_BroadcasterCharacter
    return
}