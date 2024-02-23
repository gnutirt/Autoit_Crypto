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
Global $sAPI_Key_Access = ""
Global $sAPI_Key_Secret = ""

;----- Prepare DLL -----
Global $hDll_WinHTTP = DllOpen("winhttp.dll")

Global $Symbol = "BTCUSDT";"BTCUSDT",
Global $State = False,$Snipe_count = 0

DATA_WALET ()
HotKeySet("{F3}","Exit_app")
Func Out ()
	Exit
 EndFunc


#Region ### START Koda GUI section ### Form=D:\Dropbox\w-Funny Programming\Miner\APP.kxf
$APP = GUICreate("AUTO_INVEST", 1010, 440, 450, 400)
GUISetFont(12, 400, 0, "MS Sans Serif")
$Market_Summary = GUICtrlCreateGroup("", 10, 4, 990, 66)
$Group1 = GUICtrlCreateGroup("Bot Stat", 650, 77, 350, 350)
$Group2 = GUICtrlCreateGroup("", 10, 58, 260, 370)


$Console = GUICtrlCreateEdit("Action Bot" & @CRLF, 270, 68, 380, 180, $ES_READONLY+$ES_AUTOVSCROLL+$ES_NOHIDESEL+$ES_MULTILINE )
$Result_Binance = GUICtrlCreateEdit("HTTP_RESPONSE" & @CRLF, 270, 250, 380, 175,$ES_READONLY+$ES_AUTOVSCROLL+$ES_NOHIDESEL+$ES_MULTILINE )


$LB_Live_Price = GUICtrlCreateLabel("BTC LIVE PRICE =", 20, 25, 150, 36)
$VL_Live_Price = GUICtrlCreateLabel("XXXXX0", 160, 25, 180, 28)



$LB_AV_Price = GUICtrlCreateLabel("BTC AVG PRICE =", 280, 25, 152, 36)
$VL_AV_Price = GUICtrlCreateLabel("XXXXX0", 420, 25, 200, 36)

$LB_DIFF_PRICE = GUICtrlCreateLabel("AVG-LIVE =", 560, 25, 96, 36)
$VL_DIFF_PRICE = GUICtrlCreateLabel("", 650, 25, 136, 36)


$LB_DIFF_AM = GUICtrlCreateLabel("DIFF BUY-SELL", 760, 25, 144, 36)
$VL_DIFF_AM = GUICtrlCreateLabel("0 BTC", 890, 25, 200, 36)


$LB_Profit = GUICtrlCreateLabel("% Price", 20,80, 118, 30)
$VL_Profit_Epx = GUICtrlCreateInput("0.01", 110, 75, 80, 32)
$LB_MAX_FUND_BTC = GUICtrlCreateLabel("Fund_BTC", 20, 120, 120, 36)
$VL_MAX_FUND_BTC = GUICtrlCreateInput("0.001", 110, 115, 80, 32)
$LB_MAX_FUND_USD = GUICtrlCreateLabel("Fund_USD", 20, 160, 120, 36)
$VL_MAX_FUND_USD = GUICtrlCreateLabel("100", 110, 160, 80, 32)
$Start = GUICtrlCreateButton("START", 20, 200, 175, 40)
GUICtrlSetOnEvent (-1,"start")
$EXIT = GUICtrlCreateButton("EXIT", 20, 350, 175, 40)
GUICtrlSetOnEvent (-1,"Exit_app")


$LB_WALLET_BTC = GUICtrlCreateLabel("WALLET_BTC", 20, 250, 180, 36)
$VL_WALLET_BTC = GUICtrlCreateLabel("xxx", 150, 250, 98, 36)

$LB_WALLET_USD = GUICtrlCreateLabel("WALLET_USD", 20, 290, 184, 36)
$VL_WALLET_USD = GUICtrlCreateLabel("xxx", 150, 290, 98, 36)



$LB_STATUS = GUICtrlCreateLabel("STATUS TRADING:", 670, 120, 170, 36)
$VL_STATUS = GUICtrlCreateLabel("STOP", 670, 150, 300, 36)

$LB_Snipe = GUICtrlCreateLabel("Snipe:", 670, 180, 62, 36)
$VL_Snipe = GUICtrlCreateLabel("XXX", 850, 180, 100, 40)


$LB_GAIN = GUICtrlCreateLabel("TOTAL GAINS", 670, 210, 132, 36)
$VL_GAIN = GUICtrlCreateLabel("XXXXX", 850, 210, 120, 36)

$LB_TRADE = GUICtrlCreateLabel("AMOUNT TRADE", 670, 240, 158, 36)
$VL_TRADE = GUICtrlCreateLabel("0", 850, 240, 18, 36)

$LB_REAL_LOST = GUICtrlCreateLabel("Real Lost", 670, 270, 88, 36)
$VL_REAL_LOST = GUICtrlCreateLabel("xxxxxxx", 850, 270, 98, 36)
$LB_REAL_WIN = GUICtrlCreateLabel("Real Win", 670, 300, 84, 36)
$VL_REAL_WIN = GUICtrlCreateLabel("xxxxxxxx", 850, 300, 98, 36)




$LB_NUM_BUY = GUICtrlCreateLabel("BUY", 670, 330, 48, 36)
$VL_NUM_BUY = GUICtrlCreateLabel("0", 850, 330, 18, 36)
$LB_NUM_SELL = GUICtrlCreateLabel("SELL", 670, 360, 52, 36)
$VL_NUM_SELL = GUICtrlCreateLabel("0", 850, 360, 18, 36)

GUICtrlSetColor(-1, 0xFF0000)



GUICtrlCreateGroup("", -99, -99, 1, 1)

GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

 Func start ()

	$State = Not $State

	if $State = true then GUICtrlSetData($Start,"RUNNING")
EndFunc
Func Exit_app ()
   Local $oExcel = _Excel_Open()
    Local $oBook = _Excel_BookAttach("Log.xlsx", "FileName", $oExcel)
    Local $sSheet = "Trades"

   _Excel_RangeWrite($oBook, "Logs","","A2")
   _Excel_RangeWrite($oBook, "Logs","","B2")

   _Excel_RangeWrite($oBook, "Logs","","C2")
   _Excel_RangeWrite($oBook, "Logs","","D2")
   _Excel_RangeWrite($oBook, "Logs","","D2")
   _Excel_RangeWrite($oBook, "Logs","","E2")
   Exit

   EndFunc

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit

	 EndSwitch
   SET_DATA ()
  If $state = true then Trades ()
Swap ()
WEnd
Func SET_DATA ()
   API_GET ()
   API_GET_AVG_PRICE_BINANCE()
   set_data_Bid_ask ()
   DATA_WALET ()
   GUICtrlSetData ($VL_DIFF_PRICE,round($Price - $Price_AVG_BINANCE,4) & " USD")
   GUICtrlSetData ($VL_DIFF_AM,round($CAL_SUM_BTC_BID - $CAL_SUM_BTC_ASK,4) & " BTC")

   IF $Price - $Price_AVG_BINANCE > 0 THEN GUICtrlSetColor($VL_DIFF_PRICE,0x00ff00)
   IF $Price - $Price_AVG_BINANCE < 0 THEN GUICtrlSetColor($VL_DIFF_PRICE,0xff0000)

   IF $CAL_SUM_BTC_BID - $CAL_SUM_BTC_ASK > 0 THEN GUICtrlSetColor($VL_DIFF_AM,0x00ff00)
   IF $CAL_SUM_BTC_BID - $CAL_SUM_BTC_ASK < 0 THEN GUICtrlSetColor($VL_DIFF_AM,0xff0000)

   GUICtrlSetData ($VL_WALLET_BTC,$Balance_BTC)
   GUICtrlSetData ($VL_WALLET_USD,$Balance_USD)

   ;doc Trade
   Local $oExcel = _Excel_Open()
    Local $oBook = _Excel_BookAttach("Log.xlsx", "FileName", $oExcel)
    Local $sSheet = "Logs"
    If @error Then Return MsgBox($MB_ICONERROR, "Excel Failed", "Failed to attach to Excel")
   _Excel_RangeWrite($oBook, "Trades",$Total_Balance_USD,"L7")
   GUICtrlSetData($VL_GAIN,_Excel_RangeRead($oBook,"Trades", "L3"))
   GUICtrlSetData($VL_NUM_BUY,_Excel_RangeRead($oBook,"Trades", "L1"))
   GUICtrlSetData($VL_NUM_SELL,_Excel_RangeRead($oBook,"Trades", "L2"))



EndFunc






   Func Readexcel ()

   Local $oExcel = _Excel_Open()
    Local $oBook = _Excel_BookAttach("Log.xlsx", "FileName", $oExcel)
    Local $sSheet = "Logs"
    If @error Then Return MsgBox($MB_ICONERROR, "Excel Failed", "Failed to attach to Excel")

    Local $iNum

   ; Global $log = _Excel_RangeRead($oBook, $sSheet, "A2:D100")
  ; _Excel_Close($oExcel)
   ;_ArrayDisplay($log)


EndFunc
Func Excel_trades ()
    DATA_WALET ()
    Local $oExcel = _Excel_Open()
    Local $oBook = _Excel_BookAttach("Log.xlsx", "FileName", $oExcel)
    Local $sSheet = "Trades"
    If @error Then Return MsgBox($MB_ICONERROR, "Excel Failed", "Failed to attach to Excel")

    Local $iNum

    Global $trade ,$F_trade

	 $trade = _Excel_RangeRead($oBook, "Logs","A2")


  ; _Excel_Close($oExcel)
   ;_ArrayDisplay($log)
   _Excel_RangeWrite($oBook, "Logs",1,"A2")
   _Excel_RangeWrite($oBook, "Logs",_DateAdd('n', 0, _NowCalcDate()),"B2")

   _Excel_RangeWrite($oBook, "Logs",$Balance_BTC,"C2")
   _Excel_RangeWrite($oBook, "Logs",$Balance_USD,"D2")
   _Excel_RangeWrite($oBook, "Logs",$Balance_USD,"D2")

if $trade = "1" & _Excel_RangeRead($oBook, "Logs","E3") = "" then
   $F_trade = True
    _Excel_RangeWrite($oBook, "Logs","TRUE","E2")
Else
   $F_trade = False

   EndIf


EndFunc
Func Trades ()
   Global $F_QTy = GUICtrlRead($VL_MAX_FUND_BTC)
    Local $oExcel = _Excel_Open()
    Local $oBook = _Excel_BookAttach("Log.xlsx", "FileName", $oExcel)
    Local $sSheet = "Trades"
    If @error Then Return MsgBox($MB_ICONERROR, "Excel Failed", "Failed to attach to Excel")
   Global $trade = _Excel_RangeRead($oBook, $sSheet, "A2:E100"),$F_trade

   API_GET ()
   API_GET_AVG_PRICE_BINANCE()
   DATA_WALET ()
   SET_DATA ()
   Excel_trades ()
   set_data_Bid_ask ()
   Global  $TREND,$Snipe_count,$AMOUNT_BULL = 0,$AMOUNT_BEAR=0,$BuyBTC,$SellBTC,$Countrade,$Balance_USD_convert

   IF $CAL_SUM_BTC_BID - $CAL_SUM_BTC_ASK > 0 THEN $TREND ="BULL"
   IF $CAL_SUM_BTC_BID - $CAL_SUM_BTC_ASK < 0 THEN $TREND ="BEAR"

   ;IF $TREND = "BULL" then GUICtrlSetData($VL_STATUS,"SELLING BTC")
   ;IF $TREND = "BEAR" then GUICtrlSetData($VL_STATUS,"BUYING BTC")
   If $F_trade = true then
   For $Snipe_count = 1 to 10
   API_GET ()
   API_GET_AVG_PRICE_BINANCE()
   set_data_Bid_ask ()

	  IF $CAL_SUM_BTC_BID - $CAL_SUM_BTC_ASK > 0 THEN
		 $AMOUNT_BULL = abs($CAL_SUM_BTC_BID - $CAL_SUM_BTC_ASK) + $AMOUNT_BULL
	  EndIf

	  IF $CAL_SUM_BTC_BID - $CAL_SUM_BTC_ASK < 0 THEN
		  $AMOUNT_BEAR = abs($CAL_SUM_BTC_BID - $CAL_SUM_BTC_ASK) + $AMOUNT_BEAR
		  EndIf
	  IF $AMOUNT_BULL > $AMOUNT_BEAR then ; Mua> Ban
		 GUICtrlSetData($VL_STATUS,"SELL BTC") ;=> Ban BTC, cho gia thap mua vao BTC
		 $TREND ="BULL"
	  Else
		 GUICtrlSetData($VL_STATUS,"BUYING BTC") ; Mua BTC, cho gia cao ban BTC
		 $TREND ="BEAR"
	  EndIf
	  GUICtrlSetData($VL_Snipe,$Snipe_count)
   Next

 EndIf

   If $F_trade = true then

   _Excel_RangeWrite($oBook, "Trades",1,"A2")
   _Excel_RangeWrite($oBook, "Trades",_DateAdd('n', 0, _NowCalcDate()),"C2")
   _Excel_RangeWrite($oBook, "Trades",round($Price,4),"B2")

		 IF $trend = "BEAR" then ; thi truong giam mua vao BTC
			DATA_WALET ()

		 $BuyBTC = _BINANCE_API_Call("api/v3/order","symbol=BTCUSDT&side=BUY&type=MARKET&quantity="&$Balance_USD_convert)

		  GUICtrlSetData ($Console,"Thi truong Bear - Swap het qua BTC - Đợi giá tốt bán"& @CRLF,1)
		 _Excel_RangeWrite($oBook, "Trades",$Balance_USD,"F2")
		 _Excel_RangeWrite($oBook, "Trades","BUY","D2")
		 _Excel_RangeWrite($oBook, "Trades",round($Price,4),"B2")
		; ConsoleWrite($BuyBTC & @CRLF & @CRLF)
		; ConsoleWrite($Balance_USD_convert & @CRLF & @CRLF)
		 GUICtrlSetData($Result_Binance,$BuyBTC)


		 Else
			DATA_WALET ()
		 $SellBTC = _BINANCE_API_Call("api/v3/order","symbol=BTCUSDT&side=SELL&type=MARKET&quantity="&$Balance_BTC)
		  GUICtrlSetData ($Console,"Thi truong BULL -  Swap het qua USD- Đợi giá tốt mua"& @CRLF,1)
		 _Excel_RangeWrite($oBook, "Trades",$Balance_BTC,"E2")
		 _Excel_RangeWrite($oBook, "Trades","SELL","D2")
		 _Excel_RangeWrite($oBook, "Trades",round($Price,4),"B2")
		 GUICtrlSetData($Result_Binance,$SellBTC)
		 ;ConsoleWrite($SellBTC & @CRLF & @CRLF)
		 ;ConsoleWrite($Balance_BTC & @CRLF & @CRLF)

	  EndIf
	  $F_trade = False
	  $Countrade = 2
	  ;_ArrayDisplay($trade)
      Else
;;;;;;;;;;;;;;;;;;;;;KT lai cai nay;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	   Select
	   Case _Excel_RangeRead($oBook, "Trades", "D"&$Countrade) ='BUY'
		     GUICtrlSetData ($Console,"Đang canh giá bán, giá trước mua: "&_Excel_RangeRead($oBook, "Trades", "B"&$Countrade)&". Giá hiện hữu: "& round($Price,4)& @CRLF,1)
			 DATA_WALET ()
			GUICtrlSetData($VL_STATUS,"TRADE - SNIP PRICE TO SELL")
			If  _Excel_RangeRead($oBook, "Trades", "B"&$Countrade)*(1+ GUICtrlRead($VL_Profit_Epx)/100)< round($Price,4) Then ; CHECK GIA
			$SellBTC = _BINANCE_API_Call("api/v3/order","symbol=BTCUSDT&side=SELL&type=MARKET&quantity="&$Balance_BTC)
             GUICtrlSetData($Result_Binance,$SellBTC)
			DATA_WALET ()
			_Excel_RangeWrite($oBook, "Trades","SELL","D"&$Countrade+1)
			_Excel_RangeWrite($oBook, "Trades",round($Price,4),"B"&$Countrade+1)
			_Excel_RangeWrite($oBook, "Trades",$Balance_BTC,"E"&$Countrade+1)
			_Excel_RangeWrite($oBook, "Trades",_DateAdd('n', 0, _NowCalcDate()),"C"&$Countrade+1)

            $Countrade = $Countrade + 1
			GUICtrlSetData ($Console,"Giá êm - Bán với giá "& round($Price,4)& @CRLF,1)

			;ConsoleWrite($Balance_BTC & @CRLF & @CRLF)
			;ConsoleWrite($SellBTC & @CRLF & @CRLF)
		 EndIf


	  Case _Excel_RangeRead($oBook, "Trades", "D"&$Countrade) ='SELL'
		   DATA_WALET ()
		   GUICtrlSetData($VL_STATUS,"TRADE - SNIP PRICE TO BUY")
		  GUICtrlSetData ($Console,"Đang canh giá mua, giá trước bán "&_Excel_RangeRead($oBook, "Trades", "B"&$Countrade)&" Giá hiện hữu "& round($Price,4)& @CRLF,1)
			If _Excel_RangeRead($oBook, "Trades", "B"&$Countrade) > round($Price,4)*(1+ 3*GUICtrlRead($VL_Profit_Epx)/100) Then ; CHECK GIA

			   $BUYBTC = _BINANCE_API_Call("api/v3/order","symbol=BTCUSDT&side=BUY&type=MARKET&quantity="&$Balance_USD_convert)
			     DATA_WALET ()
			   _Excel_RangeWrite($oBook, "Trades",$Balance_USD,"F"&$Countrade+1)
			   _Excel_RangeWrite($oBook, "Trades","BUY","D"&$Countrade+1)
			   _Excel_RangeWrite($oBook, "Trades",round($Price,4),"B"&$Countrade+1)
			   GUICtrlSetData ($Console,"Giá Êm - Mua với giá " &round($Price,4)& @CRLF,1)
			   _Excel_RangeWrite($oBook, "Trades",_DateAdd('n', 0, _NowCalcDate()),"C"&$Countrade+1)
			   $Countrade = $Countrade + 1
			   GUICtrlSetData($Result_Binance,$BuyBTC)
			   ;ConsoleWrite($Balance_USD_convert & @CRLF & @CRLF)
			 ; ConsoleWrite($BuyBTC & @CRLF & @CRLF)
			EndIf



		 EndSelect




	  EndIf





; $BuyBTC = _BINANCE_API_Call("api/v3/order","symbol=BTCUSDT&side=BUY&type=MARKET&quantity="&Qty)
 ;$SellBTC = _BINANCE_API_Call("api/v3/order","symbol=BTCUSDT&side=BUY&type=MARKET&quantity="&Qty)


   EndFunc
Func FIRSTRUN ()
   Readexcel ()
   DATA_WALET ()
   Local $oExcel = _Excel_Open()
    Local $oBook = _Excel_BookAttach("Log.xlsx", "FileName", $oExcel)
    Local $sSheet = "Logs"
    If @error Then Return MsgBox($MB_ICONERROR, "Excel Failed", "Failed to attach to Excel")

    Local $iNum
   If $log[0][0] = 0 then
   _Excel_RangeWrite($oBook, "Logs",1,"A2")
   _Excel_RangeWrite($oBook, "Logs",_DateAdd('n', 0, _NowCalcDate()),"B2")

   _Excel_RangeWrite($oBook, "Logs",$Balance_BTC,"C2")
   _Excel_RangeWrite($oBook, "Logs",$Balance_USD,"D2")


   _Excel_BookSave($oBook)
   _Excel_Close($oExcel)

   EndIf
   EndFunc
Func set_data_Bid_ask ()
;API_GET_ORDER_BID()
API_GET_TRADE_BINANCE()
Global $CAL_SUM_BTC_BID =0 ,$CAL_SUM_BTC_ASK = 0,$CAL_SUM_USD_BID=0 ,$CAL_SUM_USD_ASK=0,$AMOUNT_PENDING_BUY_BTC_CAL=0,$AMOUNT_PENDING_SELL_BTC_CAL

$CAL_SUM_BTC_BID =0
$CAL_SUM_BTC_ASK = 0
$CAL_SUM_USD_BID=0
$CAL_SUM_USD_ASK=0
$AMOUNT_PENDING_BUY_BTC_CAL = 0
$AMOUNT_PENDING_SELL_BTC_CAL = 0

For $i = 0 to 499
   $CAL_SUM_BTC_BID = $CAL_SUM_BTC_BID + $Price_Bids_2D[$i][1]
Next
For $i = 0 to 499
   $CAL_SUM_BTC_ASK = $CAL_SUM_BTC_ASK + $Price_asks_2D[$i][1]
Next

For $i = 0 to 499
   $CAL_SUM_USD_BID = $CAL_SUM_USD_BID + ($Price_Bids_2D[$i][1]*$Price_Bids_2D[$i][0])
Next
For $i = 0 to 499
   $CAL_SUM_USD_ASK = $CAL_SUM_USD_ASK + ($Price_asks_2D[$i][1]*$Price_asks_2D[$i][0])
Next

For $i = 0 to 499
   $AMOUNT_PENDING_BUY_BTC_CAL = $AMOUNT_PENDING_BUY_BTC_CAL + ($Price_Bids_2D[$i][1]*$Price_Bids_2D[$i][0])
Next
For $i = 0 to 499
   $AMOUNT_PENDING_SELL_BTC_CAL = $AMOUNT_PENDING_SELL_BTC_CAL + ($Price_asks_2D[$i][1]*$Price_asks_2D[$i][0])
Next






   EndFunc
Func API_GET ()
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


GUICtrlSetData ($VL_Live_Price,round($Price,4) & " USD")
;GUICtrlSetData ($Console,round($Price,4) & " USD" & @CRLF,1)
EndFunc

Func API_GET_AVG_PRICE_BINANCE()

Global $sDomain = "api1.binance.com"
Global $sPage = "/api/v3/avgPrice?symbol="&$Symbol
;Set_data ()
   ; Initialize and get session handle
 Global $hOpen = _WinHttpOpen()

; Get connection handle
 Global $hConnect = _WinHttpConnect($hOpen, $sDomain)

; Make a SimpleSSL request
Global $hRequestSSL = _WinHttpSimpleSendSSLRequest($hConnect, Default, $sPage)

; Read...
Global $sReturned = _WinHttpSimpleReadData($hRequestSSL)
Global $Price_AVG_BINANCE = StringTrimRight(StringTrimLeft($sReturned,19),2)

GUICtrlSetData ($VL_AV_Price,round($Price_AVG_BINANCE,4) & " USD")
_WinHttpCloseHandle($hRequestSSL)
_WinHttpCloseHandle($hConnect)
_WinHttpCloseHandle($hOpen)

EndFunc

Func API_GET_TRADE_BINANCE()

Global $sDomain = "api1.binance.com"
Global $sPage = "/api/v3/trades?symbol="&$Symbol
Global $hOpen = _WinHttpOpen()
Global $hConnect = _WinHttpConnect($hOpen, $sDomain)
Global $hRequestSSL = _WinHttpSimpleSendSSLRequest($hConnect, Default, $sPage)
Global $sReturned = _WinHttpSimpleReadData($hRequestSSL)
Global $Price_TRADE_BINANCE = $sReturned
Global $a = "]", $b = "[", $c='00"',$d = '"'
Global $Price_TRADE_BINANCE_2D[500][4], $h=0,$i=1

$Price_TRADE_BINANCE = StringReplace($Price_TRADE_BINANCE,',"isBestMatch":true',"")
$Price_TRADE_BINANCE_1D = StringSplit($Price_TRADE_BINANCE,",")
While $i < 2996

   $Price_TRADE_BINANCE_2D[$h][0] = $Price_TRADE_BINANCE_1D[$i+1];Price
   $Price_TRADE_BINANCE_2D[$h][1] = $Price_TRADE_BINANCE_1D[$i+2];Q'ty
   $Price_TRADE_BINANCE_2D[$h][2] = $Price_TRADE_BINANCE_1D[$i+3];Quote Q'ty

   if $Price_TRADE_BINANCE_1D[$i+5] = '"isBuyerMaker":true}' then
   $Price_TRADE_BINANCE_2D[$h][3] = "SELL"; isBuyerMaker = true
   Else
   $Price_TRADE_BINANCE_2D[$h][3] ="BUY"; isBuyerMaker = false
   EndIf
  $h=$h+1
  $i = $i + 6
WEnd

For $i = 0 to 499

   $Price_TRADE_BINANCE_2D[$i][0] = StringReplace($Price_TRADE_BINANCE_2D[$i][0],'"price":"',"")
   $Price_TRADE_BINANCE_2D[$i][0] = StringReplace($Price_TRADE_BINANCE_2D[$i][0],'"',"")


   $Price_TRADE_BINANCE_2D[$i][1] = StringReplace($Price_TRADE_BINANCE_2D[$i][1],'"qty":"',"")
   $Price_TRADE_BINANCE_2D[$i][1] = StringReplace($Price_TRADE_BINANCE_2D[$i][1],'"',"")

   $Price_TRADE_BINANCE_2D[$i][2] = StringReplace($Price_TRADE_BINANCE_2D[$i][2],'"quoteQty":"',"")
   $Price_TRADE_BINANCE_2D[$i][2] = StringReplace($Price_TRADE_BINANCE_2D[$i][2],'"',"")

   Next
Global $Price_Bids_2D[500][3] ;  BUY
Global $Price_Asks_2D[500][3] ; SELL
For $i = 0 to 499

    if $Price_TRADE_BINANCE_2D[$i][3] ="BUY" then
	  $Price_Bids_2D[$i][0]=$Price_TRADE_BINANCE_2D[$i][0]
	  $Price_Bids_2D[$i][1]=$Price_TRADE_BINANCE_2D[$i][1]
	  $Price_Bids_2D[$i][2]=$Price_TRADE_BINANCE_2D[$i][2]


   Else
	  $Price_Asks_2D[$i][0]=$Price_TRADE_BINANCE_2D[$i][0]
	  $Price_Asks_2D[$i][1]=$Price_TRADE_BINANCE_2D[$i][1]
	  $Price_Asks_2D[$i][2]=$Price_TRADE_BINANCE_2D[$i][2]

	  EndIf

   Next
Global $j = 0
_ArraySort($Price_Bids_2D,1)
_ArraySort($Price_asks_2D,1)

_WinHttpCloseHandle($hRequestSSL)
_WinHttpCloseHandle($hConnect)
_WinHttpCloseHandle($hOpen)

EndFunc

Func DATA_WALET ()
API_GET ()
Global $h=0,$i=1,$Balance_BTC, $Balance_USD,$Balance_USD_convert,$Total_Balance_USD
Global $sRet = _BINANCE_API_Call("api/v3/account")
$sRet = StringTrimRight(StringTrimLeft($sRet,234),24)
$sRet = StringReplace($sRet,"[","")
$sRet = StringReplace($sRet,'{"asset":',"")
$sRet = StringReplace($sRet,'"free":',"")
Global $Balance_1D = StringSplit($sRet,",")
Global $Balance_2D[492][2]
While $i < 1477

  $Balance_2D[$h][0] = $Balance_1D[$i];NANME
  $Balance_2D[$h][1] = $Balance_1D[$i+1];Q'ty


  if $Balance_1D[$i] = '"BTC"' then 	$Balance_BTC =	round(StringReplace($Balance_1D[$i+1],'"',""),5)
  if $Balance_1D[$i] = '"USDT"' then 	$Balance_USD = 	round(StringReplace($Balance_1D[$i+1],'"',""),5)



  $h=$h+1
  $i = $i + 3
WEnd
;_ArrayDisplay($Balance_2D)
$Balance_USD_convert = $Balance_USD/$Price
  ;ConsoleWrite($Balance_USD_convert & @CRLF & @CRLF)
  $Balance_USD_convert = round($Balance_USD_convert,5)
   ;ConsoleWrite($Balance_USD_convert & @CRLF & @CRLF)
   $Balance_BTC = round($Balance_BTC,5)
$Total_Balance_USD=$Balance_BTC*$Price + $Balance_USD
ConsoleWrite($Balance_BTC & @CRLF)
ConsoleWrite($Balance_USD_convert & @CRLF)

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

 Func Swap ()
 API_GET ()

;GUICtrlSetData($VL_MAX_FUND_USD,GUICtrlRead($VL_MAX_FUND_BTC)*round($Price,4))


	EndFunc