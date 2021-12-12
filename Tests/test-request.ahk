#Include, createFormData.ahk


; data:={"username":"demo","password":"test123"} ; key-val data to be posted
endpoint := "http://localhost:3000/api/v1/authenticate"

try{ ; only way to properly protect from an error here
	; createFormData(rData, rHeader, data) ; formats the data, stores in rData, header info in rHeader
	request := ComObjCreate("WinHttp.WinHttpRequest.5.1") ; create WinHttp object
    request.SetTimeouts(0, 30000, 30000, 120000)
	; hObject.setRequestHeader("Content-Type",rHeader) ; set content header
	request.Open("GET", endpoint, true) ; open a post event to the specified endpoint
	request.Send() ; send request with data
    request.WaitForResponse()
    MsgBox, % hObject.ResponseText

}catch e{    
    MsgBox, % e.message
}