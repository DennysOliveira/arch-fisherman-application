

GetServerSideVersion()
{
    endpoint := "http://localhost:4000/api/v1/version/current"

    try { 
        ; Create WinHTTPRequest Object
        request := ComObjCreate("WinHttp.WinHttpRequest.5.1") 

        request.SetTimeouts(0, 30000, 30000, 120000)

        request.Open("GET", endpoint, true)

        request.Send() 

        request.WaitForResponse() 

        result := JSON.Load(request.ResponseText)
        json := JSON.Dump(result,, 2)

        if(!result.success) {
            MsgBox, % result.message
        }

        return result

    }catch e{ 
        MsgBox, % e.message
        MsgBox, % "Could not connect to the server. Verify your internet connection."
        ExitApp
    }
}