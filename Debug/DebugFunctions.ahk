DebugGetActiveWindow()
{
    newClienthandle := WinActive("ahk_class ArcheAge") 
    WinGetTitle, Game_Title, ahk_id %newClienthandle% 

    Global testClientHandle := newClienthandle

    MsgBox, % "WinTitle: " Game_Title
    MsgBox, % "WinHand: " newClienthandle

}

DebugSendActiveWindow() {
    testNewClient := WinActive("ahk_class ArcheAge") 
    ControlSend,, "b", ahk_id %testNewClient%
    MsgBox, % "Tried sending key to -> " testNewClient
}


DebugShowClientList() {
    for key, value in GameClients {
        MsgBox, % "Index: " key ", value: " value
    }
}

DebugEmulateDetection() {
    keystring := ""
    for index, value in KeyList {
        keystring := keystring " " value
        Broadcast(value)
    }
    MsgBox, % "Keys launched: " keystring
}