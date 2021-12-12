#Include, ../Lib/JSON.ahk

; data:={"username":"demo","password":"test123"} ; key-val data to be posted
endpoint := "http://localhost:4000/api/v1/authenticate"

try{ ; only way to properly protect from an error here

	request := ComObjCreate("WinHttp.WinHttpRequest.5.1") ; create WinHttp object
    request.SetTimeouts(0, 30000, 30000, 120000)
    
	
    request.Open("POST", endpoint, true) ; open a post event to the specified endpoint
	request.setRequestHeader("Content-Type", "application/json") ; set content header

    body := JSON.Dump({"username": "ahkuser", "password": "ahkpwd"})
    
    request.Send(body) ; send request with data
    
    request.WaitForResponse()    
    

    result := JSON.Load(request.ResponseText)
    json := JSON.Dump(result,, 2)
    MsgBox, % json

}catch e{    
    MsgBox, % e.message
}
