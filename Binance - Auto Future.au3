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
Global $State = False,$Snipe_count = 0,$NUM_TRADE =0,$level = 25, $Percent_Order = 0.13


HotKeySet("{F3}","Out")
Func Out ()
	Exit
 EndFunc


#Region ### START Koda GUI section ### Form=D:\Dropbox\w-Funny Programming\Miner\FUTURE.kxf
$Form1 = GUICreate("APP", 1560, 617, 165, 176)
$Group1 = GUICtrlCreateGroup("", 25, 0, 730, 250)
$Group2 = GUICtrlCreateGroup("", 780, 0, 738, 250)
$STATUS1123123 = GUICtrlCreateLabel("STATUS ORDER", 25, 260, 730, 30)
GUICtrlSetFont(-1, 12, $FW_BOLD)
$STATUS = GUICtrlCreateLabel("STATUS ORDER", 160, 260, 730, 30)
GUICtrlSetFont(-1, 12, $FW_BOLD)

$BOT_ACT1111 = GUICtrlCreateLabel("BOT ACTIVITIES", 25, 290, 1600, 30)
GUICtrlSetFont(-1, 12,  $FW_BOLD)

$BOT_ACT = GUICtrlCreateLabel("", 25, 320, 1510, 260)
GUICtrlSetFont(-1, 12,  $FW_BOLD)

$Label1 = GUICtrlCreateLabel("MARKED PRICE", 35, 10, 85, 17)
GUICtrlSetColor($Label1,0xFF00FF)
$VL_MARKED_PRICE = GUICtrlCreateLabel("MARKED PRICE", 160, 10, 85, 17)

$Label123121 = GUICtrlCreateLabel("AMOUNT BUY:", 250, 10, 100, 17)
GUICtrlSetFont($Label123121,10 , $FW_BOLD)
GUICtrlSetColor($Label123121,0x0000FF)

$VL_TOTALBUY = GUICtrlCreateLabel("TOTAL BUY", 345, 10, 150, 17)
GUICtrlSetFont($VL_TOTALBUY,10 , $FW_BOLD)
GUICtrlSetColor($VL_TOTALBUY,0x0000FF)

$Labeaaal123121 = GUICtrlCreateLabel("AMOUNT SELL:", 430, 10, 100, 17)
GUICtrlSetFont($Labeaaal123121,10 , $FW_BOLD)
GUICtrlSetColor($Labeaaal123121,0xFF00FF)

$VL_TOTALSELL = GUICtrlCreateLabel("TOTAL SELL", 535, 10, 150, 17)
GUICtrlSetFont($VL_TOTALSELL,10 , $FW_BOLD)
GUICtrlSetColor($VL_TOTALSELL,0xFF00FF)

$Labeaaaal123121 = GUICtrlCreateLabel("DIFF:", 625, 10, 85, 17)
GUICtrlSetFont($Labeaaaal123121,10 , $FW_BOLD)
GUICtrlSetColor($Labeaaaal123121,0xFF00FF)

$VL_TOTALDIFF = GUICtrlCreateLabel("TOTAL SELL", 660, 10, 85, 17)
GUICtrlSetFont($VL_TOTALDIFF,10 , $FW_BOLD)
GUICtrlSetColor($VL_TOTALDIFF,0xFF00FF)


$Label3 = GUICtrlCreateLabel("LIVE PRICE MARKET", 35, 40, 110, 17)
GUICtrlSetColor($Label3,0x0000FF)
$VL_LIVE_PRICE = GUICtrlCreateLabel("LIVE PRICE MARKET", 160, 40, 110, 17)
$Label5 = GUICtrlCreateLabel("STRATEGY", 35, 70, 63, 17)
$VL_STATEGY = GUICtrlCreateLabel("LONG", 160, 70, 100, 17)

$Label51 = GUICtrlCreateLabel("RSI=", 250, 70, 100, 17)
$VL_RSI = GUICtrlCreateLabel("LONG", 280, 70, 63, 17)

$Labe5l51 = GUICtrlCreateLabel("GREEN CANDLE =", 320, 70, 100, 17)
GUICtrlSetColor($Labe5l51,0x0000FF)
$VL_GREEN_CANDLE = GUICtrlCreateLabel("LONG", 415, 70, 63, 17)
GUICtrlSetColor($VL_GREEN_CANDLE,0x0000FF)

$Labe5l51nbnbmb = GUICtrlCreateLabel("RED CANDLE=", 460, 70, 100, 17)
GUICtrlSetColor($Labe5l51nbnbmb,0xFF0000)
$VL_RED_CANDLE = GUICtrlCreateLabel("LONG", 540, 70, 63, 17)
GUICtrlSetColor($VL_RED_CANDLE,0xFF0000)


$Label241111 = GUICtrlCreateLabel("BUY-SELL =", 600, 70, 70, 17)
$VL_BUY_SELL = GUICtrlCreateLabel("LONG", 660, 70, 100, 17)

$Label7 = GUICtrlCreateLabel("PROFIT-%", 35, 100, 60, 17)
$VL_PROFIT = GUICtrlCreateInput("0.015", 160, 95, 65, 21)
$VL_PROFIT_USD = GUICtrlCreateLabel("=??? USD", 250, 100, 54, 17)
$Label9 = GUICtrlCreateLabel("FUND TO PLAY", 35, 130, 82, 17)
$VL_FUND = GUICtrlCreateInput("50", 160, 125, 65, 21)

$Label91 = GUICtrlCreateLabel("ORDER", 35, 160, 120, 17)
$STATUS_ORDER= GUICtrlCreateLabel("ĐANG CHỜ", 160, 160, 200, 21)


$Start = GUICtrlCreateButton("START", 35, 200, 175, 40)
GUICtrlSetOnEvent (-1,"start")
$EXIT = GUICtrlCreateButton("EXIT", 220, 200, 175, 40)
GUICtrlSetOnEvent (-1,"Out")

$Test = GUICtrlCreateButton("TEST", 420, 200, 175, 40)
GUICtrlSetOnEvent (-1,"TRADE_BINANCE")



$Label11 = GUICtrlCreateLabel("ENTRY PRICE", 790, 10, 85, 17)
GUICtrlSetColor($Label11,0x00FF00)
$VL_ENTRY = GUICtrlCreateLabel("XXXXXXX", 900, 10, 85, 17)
GUICtrlSetColor($VL_ENTRY,0x00FF00)
$Label111 = GUICtrlCreateLabel("LIQUID PRICE", 790, 40, 85, 17)
GUICtrlSetColor($Label111,0xFF0000)
$VL_LIQUID = GUICtrlCreateLabel("XXXXXXX", 900, 40, 85, 17)
GUICtrlSetColor($VL_LIQUID,0xFF0000)
$Label1111 = GUICtrlCreateLabel("UN_PROFIT", 790, 70, 85, 17)
GUICtrlSetColor($Label1111,0x0000FF)
$UN_PROFIT = GUICtrlCreateLabel("XXXXXXX", 900, 70, 85, 17)
GUICtrlSetColor($UN_PROFIT,0x0000FF)
$Label11111 = GUICtrlCreateLabel("AMOUNT TRADE", 790, 100, 125, 17)
GUICtrlSetColor($Label11111,0x0000FF)
$AMOUNT_TRADE = GUICtrlCreateLabel("XXXXXXX", 900, 100, 85, 17)
GUICtrlSetColor($AMOUNT_TRADE,0x0000FF)





GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###
 Func start ()

	$State = Not $State

	if $State = true then GUICtrlSetData($Start,"RUNNING")
EndFunc

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit

	EndSwitch

	API_GET_LIVE_PRICE ()
	Swap ()
    ReadCandle ()
	TRADE_BINANCE()
    PTKT ()

	If $State = true then
	Set_Data_Status ()
	  MainBot ()
	EndIf

 WEnd

 ;--------------------BOT SESSION------------------

Func MainBot ()
;Check state
Global $Currentstate,$trend,$OrderSTT
Position ()
PTKT ()
St_Order ()
Switch $Currentstate
Case "LONG"
	  GUICtrlSetData($VL_STATEGY,"ĐANG LONG")
	  GUICtrlSetData ($STATUS,"Đã Long: "&$Position_1D[2]&" voi gia: "&$Position_1D[3]&" va profit dang la: "&$Position_1D[5])
	  Switch $trend
	  Case "SHOULD LONG"
	  Close_Long ()
	  Case "SHOULD SHORT"
	  Close_Long ()
	  EndSwitch
   Case "SHORT"
	  GUICtrlSetData($VL_STATEGY,"ĐANG SHORT")
	  GUICtrlSetData ($STATUS,"Đã Short: "&$Position_1D[2]&" voi gia: "&$Position_1D[3]&" va profit dang la: "&$Position_1D[5])
	  Switch $trend
	  Case "SHOULD LONG"
	  Close_Short()
	  Case "SHOULD SHORT"
	  Close_Short ()
	  EndSwitch
   Case "NONE"
	  If $OrderSTT <> "" then
		 CHECK_ORDER ()
	  EndIf
	  GUICtrlSetData ($STATUS,"Chưa có mua bán")
	  Switch $trend
		 Case "SHOULD LONG"
			GUICtrlSetData($VL_STATEGY,"SHOULD LONG")
			Trade_Long ()
		 Case "SHOULD SHORT"
			Trade_Short ()
			GUICtrlSetData($VL_STATEGY,"SHOULD SHORT")
	  EndSwitch
EndSwitch

EndFunc
Func CHECK_ORDER ()
   Global $Currentstate,$trend,$Order_Price,$Order_Side,$Action,$Cancel,$Marked_Price
   Position ()
   API_GET_LIVE_PRICE ()
   Position ()
   ReadCandle ()
   PTKT ()
If $trend = "SHOULD SHORT" And $Order_Side='"side":"BUY"' then $Action = "Quayxe"
If $trend = "SHOULD LONG" And $Order_Side='"side":"SELL"' then $Action = "Quayxe"
If $Order_Price*(100 + 4*$Percent_Order)/100 < $Marked_Price And $Order_Side='"side":"BUY"' then $Action = "Quayxe"
If $Order_Price > $Marked_Price*(100 + 4*$Percent_Order)/100 And $Order_Side='"side":"SELL"' then $Action = "Quayxe"

   If $Action = "Quayxe" Then
	  $Cancel = _BINANCE_API_Call("fapi/v1/allOpenOrders","symbol=BTCUSDT")
	  GUICtrlSetData ($BOT_ACT,$Cancel)
	  $Action = "Chodoi"
   EndIf

EndFunc
Func St_Order ()
Global $OrderSTT,$OrderSTT_1D,$Order_Price,$Order_Side,$OrderSTT_1D[30]
Position ()
$OrderSTT = _BINANCE_API_Call("fapi/v1/openOrders","symbol=BTCUSDT")
;StringInStr($sRet,"Order does not exis")
;If not @error then  GUICtrlSetData ($STATUS,@CRLF&$sRet& @CRLF,1)
$OrderSTT=StringReplace($OrderSTT,'{"HTTPCode":"200 OK","APIWeight":"ache-Control: no-cache, no-store, must-revalidate"}',"")
$OrderSTT=StringReplace($OrderSTT,'[',"")
$OrderSTT=StringReplace($OrderSTT,']',"")
$OrderSTT_1D = StringSplit($OrderSTT,",")
;_ArrayDisplay($OrderSTT_1D)
;If  $Position_1D[2] = 0 then
If   UBound($OrderSTT_1D) > 2  then
;$OrderSTT = StringTrimLeft(StringTrimRight($OrderSTT,30),50)

$Order_Price = $OrderSTT_1D[5]
$Order_Price = StringTrimLeft(StringTrimRight($Order_Price,1),9)
$Order_Side = $OrderSTT_1D[14]
GUICtrlSetData ($STATUS_ORDER,"ĐANG ORDER VỚI GIÁ:"&$Order_Price)

;GUICtrlSetData ($STATUS,@CRLF&$OrderSTT_1D [14]& @CRLF,1)
;MsgBox ($MB_SYSTEMMODAL,"test",$Order_Price&" ----   "&$Order_Side,0);De Test
;GUICtrlSetData ($BOT_ACT,@CRLF&$OrderSTT& @CRLF,1)
EndIf
EndFunc

Func Position ()
   API_GET_LIVE_PRICE ()
   $sRet = _BINANCE_API_Call("fapi/v2/positionRisk","symbol=BTCUSDT")
   $sRet=StringReplace($sRet,'{"HTTPCode":"200 OK","APIWeight":"ache-Control: no-cache, no-store, must-revalidate"}',"")
   $sRet=StringReplace($sRet,'[{',"")
   $sRet=StringReplace($sRet,'}]',"")
   Global $Position_1D = StringSplit($sRet,","),$Currentstate
   ;_ArrayDisplay($Position_1D)
   $Position_1D[2] = StringTrimLeft(StringTrimRight($Position_1D[2],1),15)
   $Position_1D[3] = StringTrimLeft(StringTrimRight($Position_1D[3],1),14);
   $Position_1D[5] = StringTrimLeft(StringTrimRight($Position_1D[5],1),20);Profit
   $Position_1D[6] = StringTrimLeft(StringTrimRight($Position_1D[6],1),20); Liquid Price


   GUICtrlSetData ($AMOUNT_TRADE,$Position_1D[2])
   GUICtrlSetData ($VL_ENTRY,$Position_1D[3])
   GUICtrlSetData ($UN_PROFIT,$Position_1D[5])
   GUICtrlSetData ($VL_LIQUID,$Position_1D[6])
   If $Position_1D[6] <> 0 then
   If $Position_1D[6] < $Marked_Price then $Currentstate = "LONG"
   If $Position_1D[6] > $Marked_Price then $Currentstate = "SHORT"
   Else
   $Currentstate = "NONE"
EndIf
   EndFunc

Func Trade_Long ()
   API_GET_LIVE_PRICE ()
   Position ()
   ReadCandle ()
   Global $Qty,$Price_Order,$FUND,$Marked_Price
   $FUND = GUICtrlRead($VL_FUND)

   $Qty = ($FUND/$Marked_Price)*$level
   $Qty = round ($Qty,3)
   ;ConsoleWrite($Qty & @CRLF & @CRLF)

   $Price_Order = $Marked_Price*(100 - $Percent_Order)/100
   ;$Price_Order = ($Min_High + $Max_Low)/2
   $Price_Order = round ($Price_Order,2)
   ;ConsoleWrite($Price_Order & @CRLF & @CRLF)
   If $OrderSTT = "" Then
	  If $Position_1D[3] = 0 then
		 $sRet = _BINANCE_API_Call("fapi/v1/order","symbol=BTCUSDT&side=BUY&type=LIMIT&timeInForce=GTC&quantity="&$Qty&"&price="&$Price_Order&"&closePosition=false") ;
		 GUICtrlSetData ($BOT_ACT,$sRet)
	  EndIf
   EndIf

EndFunc

Func Close_Long ()
   API_GET_LIVE_PRICE ()
   St_Order ()
   Position ()

If $Position_1D[3] > 0 then
   If $OrderSTT = "" then
   If $Position_1D[5] > $Marked_Price*GuiCtrlread($VL_PROFIT)/100 then
	  $sRet = _BINANCE_API_Call("fapi/v1/order","symbol=BTCUSDT&side=SELL&type=LIMIT&timeInForce=GTC&quantity="&$Position_1D[2]&"&price="&round($Marked_Price,2)&"&closePosition=false") ;
	  GUICtrlSetData ($BOT_ACT,$sRet)
   Sleep(5000)
   EndIf
   EndIf

EndIf

EndFunc

Func Trade_Short ()
   API_GET_LIVE_PRICE ()
   Position ()
   ReadCandle ()
   Global $Qty,$Price_Order,$FUND,$Marked_Price
   $FUND = GUICtrlRead($VL_FUND)

   $Qty = ($FUND/$Marked_Price)*$level
   $Qty = round ($Qty,3)
   ;ConsoleWrite($Qty & @CRLF & @CRLF)

   $Price_Order = $Marked_Price*(100 + $Percent_Order)/100
   ;$Price_Order = ($Max_High + $Marked_Price+$Max_Low)/3
   $Price_Order = round ($Price_Order,2)
   ;ConsoleWrite($Price_Order & @CRLF & @CRLF)
   If $OrderSTT = "" Then
	  If $Position_1D[3] = 0 then
		 $sRet = _BINANCE_API_Call("fapi/v1/order","symbol=BTCUSDT&side=SELL&type=LIMIT&timeInForce=GTC&quantity="&$Qty&"&price="&$Price_Order&"&closePosition=false") ;
		 GUICtrlSetData ($BOT_ACT,$sRet)
	  EndIf
   EndIf

EndFunc

Func Close_Short ()
   API_GET_LIVE_PRICE ()
   St_Order ()
   Position ()

If $Position_1D[3] > 0 then
   If $OrderSTT = "" then
   If $Position_1D[5] > $Marked_Price*GuiCtrlread($VL_PROFIT)/100 then
	  $sRet = _BINANCE_API_Call("fapi/v1/order","symbol=BTCUSDT&side=BUY&type=LIMIT&timeInForce=GTC&quantity="&$Position_1D[2]&"&price="&round($Marked_Price,2)&"&closePosition=false") ;
	  GUICtrlSetData ($BOT_ACT,$sRet)
	  Sleep(5000)
   EndIf
   EndIf

EndIf

EndFunc




Func Set_Data_Status ()
   API_GET_LIVE_PRICE ()
   Position ()
   St_Order ()
   If $OrderSTT = "" then
	  ;GUICtrlSetData ($STATUS,@CRLF&"Da mua: "&$Position_1D[2]&" voi gia: "&$Position_1D[3]&" va profit dang la: "&$Position_1D[5]& @CRLF,1)
   EndIf
   If $Position_1D[5] > 0 then GUICtrlSetColor($STATUS,0x00FF00)
   If $Position_1D[5] < 0 then GUICtrlSetColor($STATUS,0xFF0000)

EndFunc


Func ReadCandle ()

Global $Total_sell_candle=0,$Total_buy_candle=0,$Total_high =0,$Total_low =0,$Max_High,$Min_High,$Max_Low,$Min_Low,$trend,$Value_Candle =0,$AvgU = 0, $AvgD = 0,$RSI

   Global  $Candle = _BINANCE_API_Call("/api/v3/klines", "symbol=BTCUSDT&interval=1m&limit=720")
   $Candle = StringTrimRight(StringTrimLeft($Candle,38),0)
   $Candle = StringReplace($Candle,']',"")
   $Candle = StringReplace($Candle,'[',"")
   $Candle = StringReplace($Candle,'"',"")
   Global $Candle_1D = StringSplit($Candle,","),$Candle_2D[720][9]
  ;_ArrayDisplay($Candle_1D)
   $j = 0
For $i = 1 to UBound($Candle_1D)-1 Step 12

   $Candle_2D[$j][0] = $Candle_1D[$i+2];High
   $Total_high = $Total_high + $Candle_2D[$j][0]
   $Candle_2D[$j][1] = $Candle_1D[$i+3];low
   $Total_low = $Total_low + $Candle_2D[$j][1]
   $Candle_2D[$j][2] = $Candle_1D[$i+9];Totalbuy
   $Candle_2D[$j][3] = $Candle_1D[$i+5]-$Candle_1D[$i+9];Total Sell
   $Candle_2D[$j][4] = $Candle_1D[$i+5];Total Trade

   $Candle_2D[$j][6] =  $Candle_1D[$i+1]; Open
   $Candle_2D[$j][7] = $Candle_1D[$i+4]; Close
   $Candle_2D[$j][5] = ($Candle_2D[$j][6]- $Candle_2D[$j][7]);Body of Candle
  If  $Candle_2D[$j][6] -  $Candle_2D[$j][7] > 0 then $Candle_2D[$j][8] = 0 ;RED
  If  $Candle_2D[$j][6] -  $Candle_2D[$j][7] < 0 then $Candle_2D[$j][8] = 1 ;GREEN
  If  $Candle_2D[$j][6] -  $Candle_2D[$j][7] < 0 then $AvgU =  abs($Candle_2D[$j][5]) + $AvgU ;GREEN
  If  $Candle_2D[$j][6] -  $Candle_2D[$j][7] > 0 then $AvgD =  abs($Candle_2D[$j][5]) + $AvgU ;RED


   $Value_Candle = $Value_Candle + $Candle_2D[$j][8]
   $Total_sell_candle = $Total_sell_candle + $Candle_2D[$j][3]
   $Total_buy_candle = $Total_buy_candle + $Candle_2D[$j][2]

   $j = $j+1
   Next
;_ArrayDisplay($Candle_2D)
$AvgU =  $AvgU/720
$AvgD =  $AvgD/720
$RSI = round(100 - 100/(1+ ($AvgU/$AvgD)),2)

$Max_High =round(_ArrayMax($Candle_2D,1,0,59,0),4)
$Min_High = round(_ArrayMin($Candle_2D,1,0,59,0),4)
$Max_Low =round( _ArrayMax($Candle_2D,1,0,59,1),4)
$Min_Low = round(_ArrayMin($Candle_2D,1,0,59,1),4)

GUICtrlSetData($VL_RSI,$RSI)
GUICtrlSetData($VL_GREEN_CANDLE,$Value_Candle)
GUICtrlSetData($VL_RED_CANDLE,500-$Value_Candle)
GUICtrlSetData($VL_BUY_SELL ,round(($Total_buy_candle-$Total_sell_candle)*($Max_High+$Min_Low)/2,2))

If $Total_buy_candle-$Total_sell_candle > 0 then GUICtrlSetColor($VL_BUY_SELL,0x00FF00)
If $Total_buy_candle-$Total_sell_candle < 0 then GUICtrlSetColor($VL_BUY_SELL,0xFF0000)
If $RSI > 50 Then
   GUICtrlSetColor($VL_RSI,0x00FF00)

   Else
   GUICtrlSetColor($VL_RSI,0xFF0000)

EndIf




   EndFunc

   Func PTKT ()
	  ReadCandle ()
	  TRADE_BINANCE()
	  Global $TOTAL_BUY,$TOTAL_SELL,$Total_sell_candle,$Total_buy,$Total_high ,$Total_low ,$Max_High,$Min_High,$Max_Low,$Min_Low,$trend,$Value_Candle,$RSI

   If $RSI > 45 then
	  $trend = "SHOULD LONG"
   EndIf
   If $RSI < 30 then
	  $trend = "SHOULD SHORT"
   EndIf

   If 45 > $RSI > 30  then
	  If $TOTAL_BUY > $TOTAL_SELL then   $trend = "SHOULD LONG"
	  If $TOTAL_BUY < $TOTAL_SELL then   $trend = "SHOULD SHORT"
   EndIf




	  EndFunc

Func TRADE_BINANCE()

Global $Price_TRADE_BINANCE = _BINANCE_API_Call("/api/v3/trades", "symbol=BTCUSDT&limit=500")
Global $j = 2, $h = 2,$TOTAL_SELL=0,$TOTAL_BUY = 0

;$Price_TRADE_BINANCE = StringReplace($Price_TRADE_BINANCE,',"isBestMatch":true',"")
Global $Price_TRADE_BINANCE_1D
Global $Price_TRADE_BINANCE_1D = StringSplit($Price_TRADE_BINANCE,",")
_ArrayDelete($Price_TRADE_BINANCE_1D,0)
_ArrayDelete($Price_TRADE_BINANCE_1D,0)
_ArrayDelete($Price_TRADE_BINANCE_1D,0)
;_ArrayDisplay($Price_TRADE_BINANCE_1D)
For $i = 1 to UBound($Price_TRADE_BINANCE_1D)-1
      If $Price_TRADE_BINANCE_1D[$i] = '"isBuyerMaker":true' then ; Sell
     $Price_TRADE_BINANCE_1D [$i-4]= StringTrimRight(StringTrimLeft($Price_TRADE_BINANCE_1D [$i-4],9),1) ; Lọc giá
     $Price_TRADE_BINANCE_1D [$i-3]= StringTrimRight(StringTrimLeft($Price_TRADE_BINANCE_1D [$i-3],7),1) ; Lọc Khối Lượng
     $TOTAL_SELL =Round($TOTAL_SELL+ ($Price_TRADE_BINANCE_1D [$i-3]*$Price_TRADE_BINANCE_1D [$i-4]),2)
	 EndIf
    If $Price_TRADE_BINANCE_1D[$i] = '"isBuyerMaker":false' then ; BUY
     $Price_TRADE_BINANCE_1D [$i-4]= StringTrimRight(StringTrimLeft($Price_TRADE_BINANCE_1D [$i-4],9),1) ; Lọc giá
     $Price_TRADE_BINANCE_1D [$i-3]= StringTrimRight(StringTrimLeft($Price_TRADE_BINANCE_1D [$i-3],7),1) ; Lọc Khối Lượng
     $TOTAL_BUY =Round($TOTAL_BUY+ ($Price_TRADE_BINANCE_1D [$i-3]*$Price_TRADE_BINANCE_1D [$i-4]),2)
	 EndIf
  Next

  GUICtrlSetData($VL_TOTALBUY,$TOTAL_BUY)
  GUICtrlSetData($VL_TOTALSELL,$TOTAL_SELL)
  GUICtrlSetData($VL_TOTALDIFF,$TOTAL_BUY-$TOTAL_SELL)
  IF $TOTAL_SELL > $TOTAL_BUY then GUICtrlSetColor($VL_TOTALDIFF,0xFF0000)
  IF $TOTAL_SELL < $TOTAL_BUY then GUICtrlSetColor($VL_TOTALDIFF,0x00FF00)

EndFunc
;--------------------API---------------------------------


 Func API_GET_LIVE_PRICE ()

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

GUICtrlSetData($VL_LIVE_PRICE,$Price)
GUICtrlSetColor($VL_LIVE_PRICE,0x0000FF)

Global $Marked_Price = _BINANCE_API_Call("fapi/v1/premiumIndex","symbol=BTCUSDT")
Local $pos = StringInStr($Marked_Price,'"markPrice":')
$Marked_Price = StringTrimLeft($Marked_Price,$pos+12)
$Marked_Price = StringTrimRight($Marked_Price,$pos+78)

GUICtrlSetData($VL_MARKED_PRICE,$Marked_Price)
GUICtrlSetColor($VL_MARKED_PRICE,0xFF00FF)


EndFunc





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

 Func Swap ()

   API_GET_LIVE_PRICE ()
   GUICtrlSetData($VL_PROFIT_USD,$Price*GuiCtrlread($VL_PROFIT)/100)

	EndFunc