;----- API Keys -----
Global $sAPI_Key_Access = "Your API Access Key"
Global $sAPI_Key_Secret = "Your API Secrect Key"

;----- Prepare DLL -----
Global $hDll_WinHTTP = DllOpen("winhttp.dll")


;########## EXAMPLE API CALLS ##########

;----- Ping Binance -----
Global $sRet = _BINANCE_API_Call("api/v3/ping")
;ConsoleWrite($sRet & @CRLF & @CRLF)

;----- Get Binance's Server Time -----
$sRet = _BINANCE_API_Call("api/v3/time")
;ConsoleWrite($sRet & @CRLF & @CRLF)

;----- Get BTC/USDT Average Price -----
$sRet = _BINANCE_API_Call("api/v3/avgPrice","symbol=BTCUSDT")
;ConsoleWrite($sRet & @CRLF & @CRLF)

;----- Get ETH/BTC Live Ticker Price -----
For $i = 1 To 5
  ;  Sleep(100)
   ; $sRet = _BINANCE_API_Call("api/v3/ticker/price", "symbol=ETHBTC")
 ;   ConsoleWrite($sRet & @CRLF)
Next
;ConsoleWrite(@CRLF)

;----- Get Last 10 ETH/BTC Trades -----
$sRet = _BINANCE_API_Call("api/v3/trades", "symbol=ETHBTC&limit=10")
;ConsoleWrite($sRet & @CRLF & @CRLF)

;----- Get Your Account Data -----
;$sRet = _BINANCE_API_Call("api/v3/account")
;ConsoleWrite($sRet & @CRLF & @CRLF)
;$sRet_test = _BINANCE_API_Call("api/v3/myTrades","symbol=BTCUSDT")
;ConsoleWrite($sRet_test & @CRLF & @CRLF)
Global $extra = round(0.0013123,5)
;ConsoleWrite($extra & @CRLF & @CRLF)
;$sRet = _BINANCE_API_Call("api/v3/order","symbol=BTCUSDT&side=SELL&type=MARKET&quantity="&$extra)
;ConsoleWrite($sRet & @CRLF & @CRLF)

;$sRet = _BINANCE_API_Call("fapi/v2/balance")
;$sRet = _BINANCE_API_Call("fapi/v1/premiumIndex","symbol=BTCUSDT") ; Mark Price
$sRet = _BINANCE_API_Call("fapi/v1/openOrders","symbol=BTCUSDT") ; Check Order
;$sRet = _BINANCE_API_Call("fapi/v2/positionRisk","symbol=BTCUSDT") ; Check Position
;$sRet = _BINANCE_API_Call("fapi/v1/order","symbol=BTCUSDT&side=BUY&type=LIMIT&timeInForce=GTC&quantity=0.01&price=40000&closePosition=false") ; Order

;$sRet = _BINANCE_API_Call("fapi/v1/order","symbol=BTCUSDT&side=BUY&type=TAKE_PROFIT_MARKET&timeInForce=GTC&quantity=0.01&stopPrice=48000") ; Check Order
;$sRet = _BINANCE_API_Call("fapi/v1/allOpenOrders","symbol=BTCUSDT") ; Cancel Order


;$sRet = _BINANCE_API_Call("api/v3/account")
;$sRet = _BINANCE_API_Call("api/v3/order","symbol=BTCUSDT&side=BUY&type=MARKET&quantity="&$extra)
ConsoleWrite($sRet & @CRLF & @CRLF)




Func _BINANCE_API_Call($sEndPoint, $sParameters = "")
    ;**************************************************
    ; Performs Binance API Call Via Native WinHTTP dll
    ;**************************************************

    ;----- Vars -----
    ; Presume GET, assign POST if needed in switch
    Local $sGETorPOST = "GET"
	Local $API_URL = "api.binance.com"

    ;----- Check Endpoint Required -----
    ; Some endpoints require signing, other endpoints can be
    ; added as new cases.
    Switch $sEndPoint
        Case "api/v3/account"
            $sParameters &= "&timestamp=" & _TimeStamp()
            $sParameters &= "&signature=" & _HMAC($sParameters, $sAPI_Key_Secret)
			$API_URL = "api.binance.com"
	    Case "fapi/v2/balance"
            $sParameters &= "&timestamp=" & _TimeStamp()
            $sParameters &= "&signature=" & _HMAC($sParameters, $sAPI_Key_Secret)
			$API_URL = "fapi.binance.com"
		 Case "fapi/v1/premiumIndex"
            $sParameters &= "&timestamp=" & _TimeStamp()
            $sParameters &= "&signature=" & _HMAC($sParameters, $sAPI_Key_Secret)
			$API_URL = "fapi.binance.com"
		  Case "fapi/v1/openOrders"
            $sParameters &= "&timestamp=" & _TimeStamp()
            $sParameters &= "&signature=" & _HMAC($sParameters, $sAPI_Key_Secret)
			$API_URL = "fapi.binance.com"
		  Case "fapi/v1/allOpenOrders"
            $sParameters &= "&timestamp=" & _TimeStamp()
            $sParameters &= "&signature=" & _HMAC($sParameters, $sAPI_Key_Secret)
			$API_URL = "fapi.binance.com"
			$sGETorPOST = "DELETE"
		  Case "fapi/v2/positionRisk"
			$sParameters &= "&timestamp=" & _TimeStamp()
			$sParameters &= "&signature=" & _HMAC($sParameters, $sAPI_Key_Secret)
			$API_URL = "fapi.binance.com"
        Case "api/v3/order"
            $sGETorPOST = "POST"
            $sParameters &= "&timestamp=" & _TimeStamp()
            $sParameters &= "&signature=" & _HMAC($sParameters, $sAPI_Key_Secret)
			$API_URL = "api.binance.com"
	     Case "fapi/v1/order"
            $sGETorPOST = "POST"
            $sParameters &= "&timestamp=" & _TimeStamp()
            $sParameters &= "&signature=" & _HMAC($sParameters, $sAPI_Key_Secret)
			$API_URL = "fapi.binance.com"
        Case "api/v3/myTrades"
            $sParameters &= "&timestamp=" & _TimeStamp()
            $sParameters &= "&signature=" & _HMAC($sParameters, $sAPI_Key_Secret)
			$API_URL = "api.binance.com"
    EndSwitch

    ;----- Start Session -----
    Local $hHTTP_Session = DllCall($hDll_WinHTTP, "handle", "WinHttpOpen", "wstr", "Mozilla/4.0", "dword", 0, "wstr", "", "wstr", "", "dword", 0)[0]
    ;----- Connect To Binance Server -----
    Local $hHTTP_Connection = DllCall($hDll_WinHTTP, "handle", "WinHttpConnect", "handle", $hHTTP_Session, "wstr",$API_URL, "dword", 443, "dword", 0)[0]
    ;----- Prepare Request Data -----
    If $sParameters <> "" Then $sParameters = "?" & $sParameters
    Local $hHTTP_Request = DllCall($hDll_WinHTTP, "handle", "WinHttpOpenRequest", "handle", $hHTTP_Connection, "wstr", $sGETorPOST, "wstr", $sEndPoint & $sParameters, "wstr", "HTTP/1.1", "wstr", "", "ptr", 0, "dword", 0x00800000)[0]
    ;----- Add Request Header -----
    ; Adds API key to header even if not specifically needed, inconsequential
    DllCall($hDll_WinHTTP, "bool", "WinHttpAddRequestHeaders", "handle", $hHTTP_Request, "wstr", "X-MBX-APIKEY: " & $sAPI_Key_Access, "dword", -1, "dword", 0x10000000)
    ;----- Send Request To Server -----
    DllCall($hDll_WinHTTP, "bool", "WinHttpSendRequest", "handle", $hHTTP_Request, "wstr", "", "dword", 0, "ptr", 0, "dword", 0, "dword", 0, "dword_ptr", 0)
    ;----- Recieve Response -----
    DllCall($hDll_WinHTTP, "bool", "WinHttpReceiveResponse", "handle", $hHTTP_Request, "ptr", 0)
    ;----- Recieve Headers -----
    ; Extract HTTP return code and API weight
    Local $sHeaders = DllCall($hDll_WinHTTP, "bool", "WinHttpQueryHeaders", "handle", $hHTTP_Request, "dword", 22, "wstr", "", "wstr", "", "dword*", 65536, "dword*", 0)[4]
    Local $sHTTP_ReturnCode = StringMid($sHeaders, StringInStr($sHeaders, "HTTP/1.1 ") + 9, StringInStr($sHeaders, @CR, 0, 1, StringInStr($sHeaders, "HTTP/1.1 ") + 9) - (StringInStr($sHeaders, "HTTP/1.1 ") + 9))
    Local $sAPI_Weight = StringMid($sHeaders, StringInStr($sHeaders, "x-mbx-used-weight: ") + 19, StringInStr($sHeaders, @CR, 0, 1, StringInStr($sHeaders, "x-mbx-used-weight: ") + 19) - (StringInStr($sHeaders, "x-mbx-used-weight: ") + 19))
    Local $sAPI_IPBan_RetryAfter_Sec = StringInStr($sHeaders, "Retry-After: ") = 0 ? "" : StringMid($sHeaders, StringInStr($sHeaders, "Retry-After: ") + 13, StringInStr($sHeaders, @CR, 0, 1, StringInStr($sHeaders, "Retry-After: ") + 13) - (StringInStr($sHeaders, "Retry-After: ") + 13))
    ;----- Get Data -----
    Local $sData = ""
    Local $iBytesToRead, $hBuffer_Data
    While 1
        ;- Get Bytes To Read In This Loop -
        $iBytesToRead = DllCall($hDll_WinHTTP, "bool", "WinHttpQueryDataAvailable", "handle", $hHTTP_Request, "dword*", 0)[2]
        ;- Check If No More Data To Read -
        If $iBytesToRead <= 0 Then ExitLoop
        ;- Prep Data Buffer -
        $hBuffer_Data = DllStructCreate("char[" & $iBytesToRead & "]")
        ;- Read Data To Buffer -
        DllCall($hDll_WinHTTP, "bool", "WinHttpReadData", "handle", $hHTTP_Request, "struct*", $hBuffer_Data, "dword", $iBytesToRead, "dword*", 0)
        ;- Get Data From Buffer -
        $sData &= DllStructGetData($hBuffer_Data, 1)
        ;- Release -
        $hBuffer_Data = ""
    WEnd
    ;----- Close Handles -----
    DllCall($hDll_WinHTTP, "bool", "WinHttpCloseHandle", "handle", $hHTTP_Request)
    DllCall($hDll_WinHTTP, "bool", "WinHttpCloseHandle", "handle", $hHTTP_Connection)
    DllCall($hDll_WinHTTP, "bool", "WinHttpCloseHandle", "handle", $hHTTP_Session)

    ;----- Return Data -----
    ; Include HTTP Code and API Weight to check for overuse, and retry period if banned
    ; HTTP CODES : 429=over request limit, 418=IP banned due to overuse
    ; API WEIGHT : over 1200 will lead to ban
    Return '{"HTTPCode":"' & $sHTTP_ReturnCode & '","APIWeight":"' & $sAPI_Weight & ($sAPI_IPBan_RetryAfter_Sec = "" ? "" : '","Retry-After":"' & $sAPI_IPBan_RetryAfter_Sec) & '"}' & $sData

EndFunc   ;==>_BINANCE_API_Call

Func _HMAC($bData, $bKey)
    ;**************************************************
    ; Create HMAC SHA256 Signature
    ;**************************************************
    Local $oHMAC = ObjCreate("System.Security.Cryptography.HMAC" & "SHA256")
    $oHMAC.key = Binary($bKey)
    Local $bHash = $oHMAC.ComputeHash_2(Binary($bData))
    Return StringLower(StringMid($bHash, 3))
EndFunc   ;==>_HMAC

Func _TimeStamp()
    ;**************************************************
    ; Create UNIX-style TimeStamp
    ;**************************************************
    ; This is 'unix time', aka UTC time in milliseconds
    Local $aTimeStamp = DllCall("msvcrt.dll", "int:cdecl", "time", "int", 0)
    Return ($aTimeStamp[0] * 1000) + @MSEC ;convert to miliseconds
EndFunc   ;==>_TimeStamp