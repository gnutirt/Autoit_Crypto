#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <ProgressConstants.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <File.au3>
#include <FileConstants.au3>
#include <MsgBoxConstants.au3>
#include <WinAPIFiles.au3>
#include <Date.au3>
#include "WinHttp.au3"
#include <Array.au3>
#include <FontConstants.au3>
#include <EditConstants.au3>
#include <Excel.au3>
#include <WinAPIFiles.au3>
#include <Date.au3>

Opt("GUIOnEventMode", 1)


;----- API Keys -----
Global $sAPI_Key_Access = "Your API Access Key"
Global $sAPI_Key_Secret = "Your API Secrect Key"

;----- Prepare DLL -----
Global $hDll_WinHTTP = DllOpen("winhttp.dll")

Global $Symbol = "BTCUSDT";"BTCUSDT",
Global $State = False,$Snipe_count = 0

HotKeySet("{F3}","Out")
Func Out ()
	Exit
 EndFunc
While 1
ToolTip("RUNNING",0,0)
All_write_excel ()
Sleep (0)
   WEnd
;--------------Test Area----------------------------


Global  $sReturned = _BINANCE_API_Call("api/v3/ticker/price", "symbol=BTCUSDT")
Global  $Price = StringTrimRight(StringTrimLeft($sReturned,66),2)

Global  $Deeps = _BINANCE_API_Call("/api/v3/depth", "symbol=BTCUSDT&limit=1")
;Global  $Trades = _BINANCE_API_Call("/api/v3/trades", "symbol=BTCUSDT&limit=1")
Global  $Candle = _BINANCE_API_Call("/api/v3/klines", "symbol=BTCUSDT&interval=1m&limit=1")
Global  $AVGPrice = _BINANCE_API_Call("/api/v3/avgPrice", "symbol=BTCUSDT")
Global  $bookTicker = _BINANCE_API_Call("/api/v3/ticker/bookTicker", "symbol=BTCUSDT")




;--------------Record Area----------------------------

Func All_write_excel ()

   Readbase ()
   ReadCandle ()
   TRADE_BINANCE()
   API_GET_LIVE_PRICE ()

   EndFunc

Func Excel_Focus ();$Range can be exactly Sheet Or A Range; Exactly $Range= A2; If $Range = "A1:A5"


   Global $oExcel = _Excel_Open()
   Global $oBook = _Excel_BookAttach("Binance_database.xlsx", "FileName", $oExcel)

   If @error Then Return MsgBox($MB_ICONERROR, "Excel Failed", "Failed to attach to Excel")


   ;_Excel_Close($oExcel)

   _Excel_RangeRead($oBook,"CNAME","A2")

EndFunc




Func Readbase ()

   Excel_Focus ()
   Global  $bookTicker = _BINANCE_API_Call("/api/v3/ticker/bookTicker", "symbol=BTCUSDT")
   Global  $AVGPrice = _BINANCE_API_Call("/api/v3/avgPrice", "symbol=BTCUSDT")

   $AVGPrice = StringTrimRight($AVGPrice,2)
   $AVGPrice_count = StringInStr($AVGPrice,"price")
   $AVGPrice = StringMid ($AVGPrice,$AVGPrice_count,20)
   $AVGPrice = StringReplace($AVGPrice,'price":"',"")
   _Excel_RangeWrite($oBook, "CNAME",$AVGPrice,"B2")


   $bookTicker_count = StringInStr($bookTicker,'"}{"')
   $bookTicker = StringMid ($bookTicker,$bookTicker_count,180)
   $bookTicker = StringReplace($bookTicker,'"}',"")
   $bookTicker = StringReplace($bookTicker,'{"',"")
   $bookTicker_1D = StringSplit($bookTicker,",")
	$bookTicker_1D[2] = StringTrimLeft(StringTrimRight($bookTicker_1D[2],2),12)
	$bookTicker_1D[3] = StringTrimLeft(StringTrimRight($bookTicker_1D[3],2),10)
	$bookTicker_1D[4] = StringTrimLeft(StringTrimRight($bookTicker_1D[4],2),12)
	$bookTicker_1D[5] = StringTrimLeft(StringTrimRight($bookTicker_1D[5],2),10)

   _Excel_RangeWrite($oBook, "CNAME",$bookTicker_1D[2],"B3")
   _Excel_RangeWrite($oBook, "CNAME",$bookTicker_1D[3],"B4")
   _Excel_RangeWrite($oBook, "CNAME",$bookTicker_1D[4],"B5")
   _Excel_RangeWrite($oBook, "CNAME",$bookTicker_1D[5],"B6")



   EndFunc
Func ReadCandle ()
   Excel_Focus ()


   Global  $Candle = _BINANCE_API_Call("/api/v3/klines", "symbol=BTCUSDT&interval=1m&limit=10")
   $Candle = StringTrimRight(StringTrimLeft($Candle,38),0)
   $Candle = StringReplace($Candle,']',"")
   $Candle = StringReplace($Candle,'[',"")
   $Candle = StringReplace($Candle,'"',"")
   Global $Candle_1D = StringSplit($Candle,",")
  ;_ArrayDisplay($Candle_1D)
   $j = 2


    _Excel_RangeWrite($oBook,"CNAME","","H2:F100")


   For $i = 1 to UBound($Candle_1D)-1 Step 12
   _Excel_RangeWrite($oBook, "CNAME",_DateAdd("s", Int($Candle_1D [$i]/ 1000), "1970/01/01 7:00:00"),"H"&$j) ; Opentime
   _Excel_RangeWrite($oBook, "CNAME",$Candle_1D [$i+1],"J"&$j) ; Open
   _Excel_RangeWrite($oBook, "CNAME",$Candle_1D [$i+2],"K"&$j) ; High
   _Excel_RangeWrite($oBook, "CNAME",$Candle_1D [$i+3],"L"&$j) ; Low
   _Excel_RangeWrite($oBook, "CNAME",$Candle_1D [$i+4],"M"&$j) ; Close
   _Excel_RangeWrite($oBook, "CNAME",$Candle_1D [$i+5],"N"&$j) ; TotalVolum
   ;_Excel_RangeWrite($oBook, "CNAME",_DateAdd("s", Int($Candle_1D [$i+6]/ 1000), "1970/01/01 7:00:00"),"I"&$j); Closetime
   _Excel_RangeWrite($oBook, "CNAME",$Candle_1D [$i+8],"O"&$j) ; Total Trade
   _Excel_RangeWrite($oBook, "CNAME",$Candle_1D [$i+9],"P"&$j) ; Total Buy

   $j = $j+1

   Next


   EndFunc


Func TRADE_BINANCE()
Excel_Focus ()
Global $Price_TRADE_BINANCE = _BINANCE_API_Call("/api/v3/trades", "symbol=BTCUSDT&limit=10")
Global $j = 2, $h = 2

;$Price_TRADE_BINANCE = StringReplace($Price_TRADE_BINANCE,',"isBestMatch":true',"")
Global $Price_TRADE_BINANCE_1D
Global $Price_TRADE_BINANCE_1D = StringSplit($Price_TRADE_BINANCE,",")
_Excel_RangeWrite($oBook,"CNAME","","C2:F300")


For $i = 1 to UBound($Price_TRADE_BINANCE_1D)-1
   If $Price_TRADE_BINANCE_1D[$i] = '"isBuyerMaker":true' then ; Sell
     $Price_TRADE_BINANCE_1D [$i-4]= StringTrimRight(StringTrimLeft($Price_TRADE_BINANCE_1D [$i-4],9),1) ; Lọc giá
     $Price_TRADE_BINANCE_1D [$i-3]= StringTrimRight(StringTrimLeft($Price_TRADE_BINANCE_1D [$i-3],7),1) ; Lọc Khối Lượng
     _Excel_RangeWrite($oBook, "CNAME",$Price_TRADE_BINANCE_1D [$i-4],"D"&$j) ; Ghi vào giá bán
	  _Excel_RangeWrite($oBook, "CNAME",$Price_TRADE_BINANCE_1D [$i-3],"C"&$j) ; Ghi vao KL Bán
	  $j=$j+1
	 EndIf
    If $Price_TRADE_BINANCE_1D[$i] = '"isBuyerMaker":false' then ; BUY
     $Price_TRADE_BINANCE_1D [$i-4]= StringTrimRight(StringTrimLeft($Price_TRADE_BINANCE_1D [$i-4],9),1) ; Lọc giá
     $Price_TRADE_BINANCE_1D [$i-3]= StringTrimRight(StringTrimLeft($Price_TRADE_BINANCE_1D [$i-3],7),1) ; Lọc Khối Lượng
      _Excel_RangeWrite($oBook, "CNAME",$Price_TRADE_BINANCE_1D [$i-4],"F"&$h) ; Ghi vào giá bán
	  _Excel_RangeWrite($oBook, "CNAME",$Price_TRADE_BINANCE_1D [$i-3],"E"&$h) ; Ghi vao KL Bán
	  $h=$h+1
	 EndIf
   Next


EndFunc


;-------------API Area------------------------------

 Func API_GET_LIVE_PRICE ()
Excel_Focus ()
Global $Price,$VL_Live_Price
Global $sDomain = "api1.binance.com"
Global $sPage = "/api/v3/ticker/price?symbol="&$Symbol

   ; Initialize and get session handle
 Global $hOpen = _WinHttpOpen()

; Get connection handle
 Global $hConnect = _WinHttpConnect($hOpen, $sDomain)

; Make a SimpleSSL request
 Global $hRequestSSL = _WinHttpSimpleSendSSLRequest($hConnect, Default, $sPage)

; Read...
Global $sReturned = _WinHttpSimpleReadData($hRequestSSL)
Global $Price = StringTrimRight(StringTrimLeft($sReturned,29),2)



; Close handles
_WinHttpCloseHandle($hRequestSSL)
_WinHttpCloseHandle($hConnect)
_WinHttpCloseHandle($hOpen)

_Excel_RangeWrite($oBook, "CNAME",$Price,"B1")

EndFunc


  Func _BINANCE_API_Call($sEndPoint, $sParameters = "")
    ;**************************************************
    ; Performs Binance API Call Via Native WinHTTP dll
    ;**************************************************

    ;----- Vars -----
    ; Presume GET, assign POST if needed in switch
    Local $sGETorPOST = "GET"

    ;----- Check Endpoint Required -----
    ; Some endpoints require signing, other endpoints can be
    ; added as new cases.
    Switch $sEndPoint
        Case "api/v3/account"
            $sParameters &= "&timestamp=" & _TimeStamp()
            $sParameters &= "&signature=" & _HMAC($sParameters, $sAPI_Key_Secret)
        Case "api/v3/order"
            $sGETorPOST = "POST"
            $sParameters &= "&timestamp=" & _TimeStamp()
            $sParameters &= "&signature=" & _HMAC($sParameters, $sAPI_Key_Secret)
        Case "api/v3/myTrades"
            $sParameters &= "&timestamp=" & _TimeStamp()
            $sParameters &= "&signature=" & _HMAC($sParameters, $sAPI_Key_Secret)
    EndSwitch

    ;----- Start Session -----
    Local $hHTTP_Session = DllCall($hDll_WinHTTP, "handle", "WinHttpOpen", "wstr", "Mozilla/4.0", "dword", 0, "wstr", "", "wstr", "", "dword", 0)[0]
    ;----- Connect To Binance Server -----
    Local $hHTTP_Connection = DllCall($hDll_WinHTTP, "handle", "WinHttpConnect", "handle", $hHTTP_Session, "wstr", "api.binance.com", "dword", 443, "dword", 0)[0]
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
Func _RevertTime ()
   Local $atime
   _DateAdd("s", Int($atime / 1000), "1970/01/01 00:00:00")
   EndFunc