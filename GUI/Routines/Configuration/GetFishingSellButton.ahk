BtnGetFishingSellButton()
{
    While(!GetKeyState("LButton"))
    {
        mPos := MouseGetPos()
        ToolTip, Click at the position where the button to turn in resides, mPos[0], mPos[1]

    }

    fishSellButton.x := mPos[0]
    fishSellButton.y := mPos[1]

    ClearTooltip()
}