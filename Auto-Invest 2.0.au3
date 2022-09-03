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
#include <Math.au3>
#include <GuiRichEdit.au3>
#include <GuiStatusBar.au3>
#include "GraphGDIPlus.au3"
Opt("SendKeyDelay",10)
Opt("SendKeyDownDelay",10)
Opt("TrayAutoPause",0)
Opt("SendCapslockMode", 0)
Opt("GUIOnEventMode", 1)

;----- API Keys -----


;Global $sAPI_Key_Access = ""
;Global $sAPI_Key_Secret = ""
Global $sAPI_Secret_Tapi = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJjbHVlIjoiNjMwY2Y1NWJmYzVhOGFkZmVjNzYwMmY0IiwiaWF0IjoxNjYxNzkzNzQ1LCJleHAiOjMzMTY2MjU3NzQ1fQ.a7n2uwIsTiSKDAqgTtHkpeSFQ_oRyCUZDqyHNuDRccs"
;----- Prepare DLL -----
Global $hDll_WinHTTP = DllOpen("winhttp.dll")
Global $State = False
Global $Candle_period = "30m"


HotKeySet("{F3}","Out")
HotKeySet("{F2}","Test")
Func Out ()
	Exit
 EndFunc
$count = 2




#Region ### START Koda GUI section ### Form=
$Form1 = GUICreate("Auto Invest 2.0", 1030, 350, 186, 331)
$StatusBar = _GUICtrlStatusBar_Create($Form1)
_GUICtrlStatusBar_SetParts($StatusBar,4,293)
$Console_LB = GUICtrlCreateLabel("CONSOLE", 620, 135, 380, 18)
GUICtrlSetFont(-1, 8, $FW_BOLD)
$Console = _GUICtrlRichEdit_Create($Form1,"", 620, 150, 400, 160,$ES_READONLY+$ES_MULTILINE +$WS_VSCROLL)
$Group1 = GUICtrlCreateGroup("INFO MARKET", 10, 10, 600, 300)
GUICtrlSetFont(-1, 10, $FW_BOLD)
$BTC_PRICE_GUI = GUICtrlCreateLabel("PRICE BTC = -----------------------------", 20, 30, 550, 25)
GUICtrlSetFont(-1, 10, $FW_BOLD)
$ETH_PRICE_GUI = GUICtrlCreateLabel("PRICE ETH = -----------------------------", 20, 60, 550, 25)
GUICtrlSetFont(-1, 10, $FW_BOLD)
$BNB_PRICE_GUI = GUICtrlCreateLabel("PRICE BNB = -----------------------------", 20, 90, 550, 25)
GUICtrlSetFont(-1, 10, $FW_BOLD)

$USDT_WALLET_GUI = GUICtrlCreateLabel("WALLET_USDT = -----------------------------", 20, 120, 550, 25)
GUICtrlSetFont(-1, 10, $FW_BOLD)
$BTC_WALLET_GUI = GUICtrlCreateLabel("WALLET_BTC = -----------------------------", 20, 150, 550, 25)
GUICtrlSetFont(-1, 10, $FW_BOLD)
$ETH_WALLET_GUI = GUICtrlCreateLabel("WALLET_ETH = -----------------------------", 20, 180, 550, 25)
GUICtrlSetFont(-1, 10, $FW_BOLD)
$BNB_WALLET_GUI = GUICtrlCreateLabel("WALLET_BNB = -----------------------------", 20, 210, 550, 25)
GUICtrlSetFont(-1, 10, $FW_BOLD)
$TOTAL_WALLET_GUI = GUICtrlCreateLabel("WALLET_TOTAL (USD) = -----------------------------", 20, 240, 550, 25)
GUICtrlSetFont(-1, 10, $FW_BOLD)
GUICtrlCreateGroup("", -99, -99, 1, 1)

$API_key1_LB = GUICtrlCreateLabel("API key Access", 20, 265, 100, 15)
GUICtrlSetFont(-1, 8, $FW_BOLD)
$API_access = GUICtrlCreateInput("",120, 260, 350, 20)
$API_key2_LB = GUICtrlCreateLabel("API key Secret", 20, 290, 100, 15)
GUICtrlSetFont(-1, 8, $FW_BOLD)
$API_Secret = GUICtrlCreateInput("",120, 285, 350, 20)


$Group2 = GUICtrlCreateGroup("AUTO-INVEST", 620, 10, 400, 120)
GUICtrlSetFont(-1, 10, $FW_BOLD)
$STRATEGY_ADVISE = GUICtrlCreateLabel("ANALYZING", 630, 30, 380, 18)
$Start = GUICtrlCreateButton("START-BOT", 630, 50, 75, 25)
GUICtrlSetOnEvent (-1,"start")

$Diff_LB = GUICtrlCreateLabel("Diff - %", 730, 55, 75, 25)
GUICtrlSetFont(-1, 10, $FW_BOLD)
$Diff_VL = GUICtrlCreateInput("1.0",780, 50, 40, 25)
GUICtrlSetFont(-1, 10, $FW_BOLD)
$Button2 = GUICtrlCreateButton("SWAP-USDT", 630, 90, 75, 25)
GUICtrlSetOnEvent (-1,"SWAP_USDT")
$Button3 = GUICtrlCreateButton("SWAP-BTC", 730, 90, 75, 25)
GUICtrlSetOnEvent (-1,"SWAP_BTC")
$Button4 = GUICtrlCreateButton("SWAP-ETH", 830, 90, 75, 25)
GUICtrlSetOnEvent (-1,"SWAP_ETH")
$Button5 = GUICtrlCreateButton("SWAP-BNB", 930, 90, 75, 25)
GUICtrlSetOnEvent (-1,"SWAP_BNb")
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###
 Func start ()
	$State = Not $State
	if $State = true then 
		GUICtrlSetData($Start,"RUNNING")		
		
		EndIf
EndFunc
Global $Starttime = _NowCalc()
Func SWAP_USDT ()
	$symbol =  "USDT"
	 DATA_WALET_Info ()
	 DATA_WALET ($symbol)
    PT ()    	
	If  $Balance_BTC_USD > 2 then Trade("BTC","SELL")
	If  $Balance_ETH_USD > 2 then Trade("ETH","SELL")
	If  $Balance_BNB_USD > 2 then Trade("BNB","SELL")
EndFunc
Func SWAP_BTC ()
	if $Balance_BTC_USD < 2 Then
	If  $Balance_USDT > 2 then Trade("BTC","BUY")
	If  $Balance_ETH_USD > 2 then 
		Trade("ETH","SELL")
		Trade("BTC","BUY")
		EndIf
	If  $Balance_BNB_USD > 2 then 
		Trade("BNB","SELL")
		Trade("BTC","BUY")
		EndIf
    EndIf
EndFunc
Func SWAP_ETH ()
	if $Balance_ETH_USD < 2 Then
	If  $Balance_USDT > 2 then Trade("ETH","BUY")
	If  $Balance_BTC_USD > 2 then 
		Trade("BTC","SELL")
		Trade("ETH","BUY")
		EndIf
	If  $Balance_BNB_USD > 2 then 
		Trade("BNB","SELL")
		Trade("ETH","BUY")
		EndIf
    EndIf
EndFunc
Func SWAP_BNB ()
	if $Balance_BNB_USD < 2 Then
	If  $Balance_USDT > 2 then Trade("BNB","BUY")
	If  $Balance_BTC_USD > 2 then 
		Trade("BTC","SELL")
		Trade("BNB","BUY")
		EndIf
	If  $Balance_ETH_USD > 2 then 
		Trade("ETH","SELL")
		Trade("BNB","BUY")
		EndIf
    EndIf
EndFunc

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit

	EndSwitch
	Global $sAPI_Key_Access = GUICtrlRead($API_access)
	Global $sAPI_Key_Secret = GUICtrlRead($API_Secret)
	Global $CheckDiff = GUICtrlRead($Diff_VL)
	
	_GUICtrlStatusBar_SetText($StatusBar,"Run: "&_DateDiff ('s',$Starttime,_NowCalc())&" secs" ,3, $SBT_RTLREADING)
	;If _DateDiff ('s',$Starttime,_NowCalc()) < 3600 then _GUICtrlStatusBar_SetText($StatusBar,"Run: "&_DateDiff ('s',$Starttime,_NowCalc())&" secs" ,3, $SBT_RTLREADING)
	;If _DateDiff ('s',$Starttime,_NowCalc()) > 3600 then _GUICtrlStatusBar_SetText($StatusBar,"Run: "&_DateDiff ('m',$Starttime,_NowCalc())&" minutes" ,3, $SBT_RTLREADING)
		If _DateDiff ('s',$Starttime,_NowCalc())= 0 Then
		GUICtrlSetState($Start,$GUI_DISABLE)
		GUICtrlSetState($Button2,$GUI_DISABLE)
		GUICtrlSetState($Button3,$GUI_DISABLE)
		GUICtrlSetState($Button4,$GUI_DISABLE)
		GUICtrlSetState($Button5,$GUI_DISABLE)
		$State =  False
	EndIf
	
	Update_Info ()
	PT ()	
	
	if $State =  False then 
		_GUICtrlStatusBar_SetText($StatusBar,"IDLE - BOT",2, $SBT_RTLREADING)
		GUICtrlSetState($Start,$GUI_ENABLE )
		GUICtrlSetState($Button2,$GUI_ENABLE )
		GUICtrlSetState($Button3,$GUI_ENABLE )
		GUICtrlSetState($Button4,$GUI_ENABLE )
		GUICtrlSetState($Button5,$GUI_ENABLE )
		EndIf
	if 	$State =  True then 
		Bot_Main ()
		_GUICtrlStatusBar_SetText($StatusBar,"RUNNING - BOT",2, $SBT_RTLREADING)
		GUICtrlSetState($Button2,$GUI_DISABLE)
		GUICtrlSetState($Button3,$GUI_DISABLE)
		GUICtrlSetState($Button4,$GUI_DISABLE)
		GUICtrlSetState($Button5,$GUI_DISABLE)
	EndIf
WEnd


Func Update_Info ()
	_GUICtrlStatusBar_SetText($StatusBar,"In Updating Info - Progress",0)
	 API_GET_LIVE_PRICE ("BTCUSDT")
	TRADE_BINANCE("BTCUSDT")
	ReadCandle_Time ($Candle_period,19,"BTCUSDT")
	GUICtrlSetData ($BTC_PRICE_GUI,"Price BTC= "&Round($Price,2)&" - BUY= "&$TOTAL_BUY&" - SELL= "&$TOTAL_SELL&" - BUY-SELL= "&Round($TOTAL_BUY-$TOTAL_SELL,0)&" ("&round(100*($Price-$pricenen)/$pricenen,3)&" %)")
	API_GET_LIVE_PRICE ("ETHUSDT")
	TRADE_BINANCE("ETHUSDT")
	ReadCandle_Time ($Candle_period,19,"ETHUSDT")
	GUICtrlSetData ($ETH_PRICE_GUI,"Price ETH= "&Round($Price,2)&" - BUY= "&$TOTAL_BUY&" - SELL= "&$TOTAL_SELL&" - BUY-SELL= "&Round($TOTAL_BUY-$TOTAL_SELL,0)&" ("&round(100*($Price-$pricenen)/$pricenen,3)&" %)")	 
	API_GET_LIVE_PRICE ("BNBUSDT")
	TRADE_BINANCE("BNBUSDT")
	ReadCandle_Time ($Candle_period,19,"BNBUSDT")
	GUICtrlSetData ($BNB_PRICE_GUI,"Price BNB= "&Round($Price,2)&" - BUY= "&$TOTAL_BUY&" - SELL= "&$TOTAL_SELL&" - BUY-SELL= "&Round($TOTAL_BUY-$TOTAL_SELL,0)&" ("&round(100*($Price-$pricenen)/$pricenen,3)&" %)")	 
	DATA_WALET_Info ()	 
	DATA_WALET ("USDT")
	GUICtrlSetData ($USDT_WALLET_GUI,"WALLET_USDT = "&$Balance)
	Global $Balance_USDT = $Balance	
	DATA_WALET ("BTC")
	API_GET_LIVE_PRICE ("BTCUSDT")
	GUICtrlSetData ($BTC_WALLET_GUI,"WALLET_BTC = "&$Balance)
	Global $Balance_BTC = $Balance*$Price	
	DATA_WALET ("ETH")
	API_GET_LIVE_PRICE ("ETHUSDT")
	GUICtrlSetData ($ETH_WALLET_GUI,"WALLET_ETH = "&$Balance)
	Global $Balance_ETH =  $Balance*$Price	
	DATA_WALET ("BNB")
	API_GET_LIVE_PRICE ("BNBUSDT")
	Global $Balance_BNB = $Balance*$Price
	GUICtrlSetData ($BNB_WALLET_GUI,"WALLET_BNB = "&$Balance)	
	Global $Balance_Total = $Balance_BNB + $Balance_ETH +$Balance_BTC + $Balance_USDT
	GUICtrlSetData ($TOTAL_WALLET_GUI,"WALLET_TOTAL (USD) = "&$Balance_Total)
	_GUICtrlStatusBar_SetText($StatusBar,"Done Updating Info",0)
	EndFunc
	
	
; Binance_Function--------------------------------------------------------

Func DATA_WALET_Info () ; Chay 1 lan thoi
Global $h,$i,$Balance_BTC, $Balance_USD,$Balance_USD_convert,$Total_Balance_USD,$Balance,$Balance_Arr_tmp
;Global $sRet = _BINANCE_API_Call("api/v3/time")
;ConsoleWrite ($sRet&" "&_TimeStamp()&@CRLF)
Global $sRet = _BINANCE_API_Call("api/v3/account")



;$sRet = StringTrimRight(StringTrimLeft($sRet,234),26)
$sRet = StringReplace($sRet,'"balances":[','"balances":[,') 
$sRet = StringReplace($sRet,'","',"---") 

;_ArrayDisplay($Balance_1D)
Global $Balance_1D = StringSplit($sRet,",")
;_ArrayDisplay($Balance_1D)
;ConsoleWrite (UBound($Balance_1D)&@CRLF)
If UBound($Balance_1D) > 10 then 
	if $Balance_1D [12] = '{"asset":"LTC---free":"0.00000000---locked":"0.00000000"}' then _ArrayDelete($Balance_1D,"0;1;2;3;4;5;6;7;8;9;10")	
	if $Balance_1D [11] = '{"asset":"LTC---free":"0.00000000---locked":"0.00000000"}' then _ArrayDelete($Balance_1D,"0;1;2;3;4;5;6;7;8;9")
	$UBOUND = UBound($Balance_1D)
	_ArrayDelete($Balance_1D,$UBOUND-1)
	Global $Balance_2D[UBound($Balance_1D)][4]
	For $i = 0 to UBound($Balance_1D)-1 Step 1
	$Balance_1D[$i] = StringReplace($Balance_1D[$i],'---',",") 
	$Balance_1D[$i] = StringReplace($Balance_1D[$i],'{"asset":"',"") 
	$Balance_1D[$i] = StringReplace($Balance_1D[$i],'"}',"") 
	$Balance_1D[$i] = StringReplace($Balance_1D[$i],'free":"',"") 
	$Balance_1D[$i] = StringReplace($Balance_1D[$i],'locked":"',"")
	$Balance_Arr_tmp=  StringSplit($Balance_1D[$i],",")

		For $h = 1 to 3
			$Balance_2D[$i][$h]=$Balance_Arr_tmp[$h]
		Next
		;_ArrayDelete($Balance_Arr_tmp,2)	
	Next
Else
	_GUICtrlRichEdit_AppendText ($Console,"At "&_NowTime()&" - WRONG API "&@CRLF)
	EndIf
	
EndFunc

Func DATA_WALET ($symbol)
	
	;_GUICtrlStatusBar_SetText($StatusBar," Getting Wallet Info "&$symbol ,0, $SBT_POPOUT)
	;_GUICtrlStatusBar_SetIcon($StatusBar, 0, _WinAPI_LoadShell32Icon(156))
	For $i = 0 to UBound($Balance_1D)-1 Step 1
	If $Balance_2D [$i][1] = $symbol then 
	Dim	$Balance = $Balance_2D [$i][2] 
	EndIf
Next
	EndFunc
Func Test ()
;Tapi_API ()
	EndFunc
Func  Trade($symbol,$action)
	If $symbol = "BTC" then $round = 5
	If $symbol = "ETH" then $round = 4
	If $symbol = "BNB" then $round = 3		
	If $action = "BUY" then 
	DATA_WALET_Info () 
	DATA_WALET ("USDT")	
	API_GET_LIVE_PRICE ($symbol&"USDT")
	Dim $Invest = round(0.98*$Balance/$Price,$round)
	;ConsoleWrite($Invest)
	$Action_Trade = _BINANCE_API_Call("api/v3/order","symbol="&$symbol&"USDT"&"&side="&$action&"&type=MARKET&quantity="&$Invest)
	;ConsoleWrite($Action_Trade)
	EndIf
	
	If $action = "SELL" then 
	DATA_WALET_Info () 
	DATA_WALET ($symbol)	
	API_GET_LIVE_PRICE ($symbol&"USDT")
	Dim $Invest = round(0.99*$Balance,$round)
	;ConsoleWrite($Invest)
	$Action_Trade = _BINANCE_API_Call("api/v3/order","symbol="&$symbol&"USDT"&"&side="&$action&"&type=MARKET&quantity="&$Invest)
	;ConsoleWrite($Action_Trade)
	EndIf
		
	_GUICtrlRichEdit_AppendText ($Console,"At "&_NowTime()&" COIN "&$symbol&" "&$action&" "&$Action_Trade&@CRLF)

EndFunc
Func PT ()
	_GUICtrlStatusBar_SetText($StatusBar,"ANALYZING STARTING",1)
	Global  $trend,$destination
	
	Global $From, $To
     
	 API_GET_LIVE_PRICE ("BTCUSDT")
	TRADE_BINANCE("BTCUSDT")
	ReadCandle_Time ($Candle_period,19,"BTCUSDT")
	Global $Diff_BTC=round(100*($Price-$pricenen)/$pricenen,3)

	API_GET_LIVE_PRICE ("ETHUSDT")
	TRADE_BINANCE("ETHUSDT")
	ReadCandle_Time ($Candle_period,19,"ETHUSDT")
	Global $Diff_ETH=round(100*($Price-$pricenen)/$pricenen,3)	 
	
	API_GET_LIVE_PRICE ("BNBUSDT")
	TRADE_BINANCE("BNBUSDT")
	ReadCandle_Time ($Candle_period,19,"BNBUSDT")
	Global $Diff_BNB=round(100*($Price-$pricenen)/$pricenen,3)	 
	
	Global $Diff_Max = _Max(_Max($Diff_BTC,$Diff_ETH),$Diff_BNB)
	Global $Diff_Min = _Min(_Min($Diff_BTC,$Diff_ETH),$Diff_BNB)
	
	If $Diff_Max =  $Diff_BTC then $From="BTC"
	If $Diff_Max =  $Diff_ETH then $From="ETH"
	If $Diff_Max =  $Diff_BNB then $From="BNB"
		
	If $Diff_Min =  $Diff_BTC then $To="BTC"
	If $Diff_Min =  $Diff_ETH then $To="ETH"
	If $Diff_Min =  $Diff_BNB then $To="BNB"
	
	GUICtrlSetData($STRATEGY_ADVISE,"SHOULD CONVERT "&$From&" With Diff="&$Diff_Max&" TO "&$To&" With Diff="&$Diff_Min)
	
	
	DATA_WALET ("USDT")
	Global $Balance_USDT = $Balance	
	DATA_WALET ("BTC")
	Global $Balance_BTC = $Balance
	DATA_WALET ("ETH")
	Global $Balance_ETH = $Balance
	DATA_WALET ("BNB")
	Global $Balance_BNB = $Balance	
	API_GET_LIVE_PRICE("BTCUSDT")
    Global    $Balance_BTC_USD = $Price * $Balance_BTC
	Global     $Price_BTC = $Price
	API_GET_LIVE_PRICE("ETHUSDT")
	Global $Balance_ETH_USD = $Price * $Balance_ETH
	Global     $Price_ETH= $Price
	API_GET_LIVE_PRICE("BNBUSDT")
	Global $Balance_BNB_USD = $Price * $Balance_BNB
	Global     $Price_BNB= $Price
  ;  Logs_Info ()
	$trend=$From&$To	
	$destination = $To

	_GUICtrlStatusBar_SetText($StatusBar,"Done Ana- Max="&$Diff_Max&" -Min="&$Diff_Min&" -Change="&$Diff_Max-$Diff_Min,1)
	
EndFunc
Func Calculate ($Balance_A,$Balance_B)


	
	EndFunc
Func Bot_Main ()	
;PT ()
    If $Balance_USDT > 5 Then
			Trade($To,"BUY")
		
		EndIf
	If $Balance_BTC_USD > 5 Then
			$Diff_change = $Diff_BTC - $Diff_Min
			If $Diff_change > $CheckDiff  then 
				Trade("BTC","SELL")
				Sleep(2000)
				Trade($To,"BUY")
				EndIf
			EndIf
				If $Balance_ETH_USD > 5 Then
			$Diff_change = $Diff_ETH - $Diff_Min
			If $Diff_change > $CheckDiff then 
				Trade("ETH","SELL")
				Sleep(2000)
				Trade($To,"BUY")
				EndIf
			EndIf
				If $Balance_BNB_USD > 5 Then
			$Diff_change = $Diff_BNB - $Diff_Min
			If $Diff_change > $CheckDiff then 
				Trade("BNB","SELL")
				Sleep(2000)
				Trade($To,"BUY")
				EndIf
	EndIf
	
	EndFunc


Func ReadCandle_Time ($typecan,$limit,$Symbol)
Sleep(500)
Global $Total_sell_candle=0,$Total_buy_candle=0,$Total_high =0,$Total_low =0,$Max_High,$Min_High,$Max_Low,$Min_Low,$trend,$Value_Candle =0,$AvgU, $AvgD,$RSI,$rautren,$rauduoi,$pricenen
Dim $Candle_2D
Dim  $Candle = _BINANCE_API_Call("/api/v3/klines", "symbol="&$Symbol&"&interval="&$typecan&"&limit="&$limit)
   ;ConsoleWrite ($Candle&@CRLF)
   ;
   $Candle = StringTrimRight(StringTrimLeft($Candle,38),0)
   
   $Candle = StringReplace($Candle,']',"")
   $Candle = StringReplace($Candle,'[',"")
   $Candle = StringReplace($Candle,'"',"")
   Dim $Candle_1D = StringSplit($Candle,",") 
   Dim $Candle_2D[$limit][11]
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
   $Candle_2D[$j][5] = abs($Candle_2D[$j][6]- $Candle_2D[$j][7]);Body of Candle
  If  $Candle_2D[$j][6] -  $Candle_2D[$j][7] > 0 then $Candle_2D[$j][8] = 0 ;RED
  If  $Candle_2D[$j][6] -  $Candle_2D[$j][7] < 0 then $Candle_2D[$j][8] = 1 ;GREEN


  ;If  $Candle_2D[$j][6] -  $Candle_2D[$j][7] < 0 then $AvgU =   $Candle_2D[$j][4]*($Candle_2D[$j][0] +   $Candle_2D[$j][1])/2+ $AvgU ;GREEN

 ; If  $Candle_2D[$j][6] -  $Candle_2D[$j][7] > 0 then $AvgD =   $Candle_2D[$j][4]*($Candle_2D[$j][0] +   $Candle_2D[$j][1])/2+ $AvgD ;RED

   If  $Candle_2D[$j][0]  -  $Candle_2D[$j][6] > 0 then  
	   $Candle_2D[$j][9] =  $Candle_2D[$j][0]  -  $Candle_2D[$j][6]  ; Rau tren
	   $rautren = $rautren +round($Candle_2D[$j][9],0)
	   EndIf
   If  $Candle_2D[$j][7]  -  $Candle_2D[$j][1] > 0 then  
	   $Candle_2D[$j][10] =  $Candle_2D[$j][7]  -  $Candle_2D[$j][1] ; Rau duoi
	   $rauduoi = $rauduoi + round($Candle_2D[$j][10],0)
	   EndIf

   $Value_Candle = $Value_Candle + $Candle_2D[$j][8]
   $Total_sell_candle =Round( $Total_sell_candle + $Candle_2D[$j][3],0)
   $Total_buy_candle =Round( $Total_buy_candle + $Candle_2D[$j][2],0)

   $j = $j+1
   Next
;_ArrayDisplay($Candle_2D)
;$AvgU =  $AvgU/$limit
;$AvgD =  $AvgD/$limit
;$RSI = round(100 - (100/(1+ ($AvgU/$AvgD))),2)

$Max_High =round(_ArrayMax($Candle_2D,1,0,-1,0),4)
$Min_High = round(_ArrayMin($Candle_2D,1,0,-1,0),4)
$Max_Low =round( _ArrayMax($Candle_2D,1,0,-1,1),4)
$Min_Low = round(_ArrayMin($Candle_2D,1,0,-1,1),4)

;ConsoleWrite("Max High="&$Max_High*1 &" Min High=" &$Min_High&" AvgU="&$AvgU/$AvgD&"  AvgD="& $AvgD& @CRLF & @CRLF)

$pricenen =   $Candle_2D[17][7]
_ArrayDelete($Candle_1D,"0-228")
_ArrayDelete($Candle_2D,"0-18")
;_ArrayDisplay($Candle_2D)


EndFunc

Func TRADE_BINANCE($Symbol)

Global $Price_TRADE_BINANCE = _BINANCE_API_Call("/api/v3/historicalTrades", "symbol="&$Symbol&"&limit=1000")
Global $j = 2, $h = 2,$TOTAL_SELL=0,$TOTAL_BUY=0


Global $Price_TRADE_BINANCE_1D
Global $Price_TRADE_BINANCE_1D = StringSplit($Price_TRADE_BINANCE,",")
_ArrayDelete($Price_TRADE_BINANCE_1D,0)
_ArrayDelete($Price_TRADE_BINANCE_1D,0)
_ArrayDelete($Price_TRADE_BINANCE_1D,0)
;_ArrayDisplay($Price_TRADE_BINANCE_1D)
For $i = 1 to UBound($Price_TRADE_BINANCE_1D)-1
      If $Price_TRADE_BINANCE_1D[$i] = '"isBuyerMaker":true' then ; Sell
     $Price_TRADE_BINANCE_1D [$i-4]= StringTrimRight(StringTrimLeft($Price_TRADE_BINANCE_1D [$i-4],9),1) ; L?c giá
     $Price_TRADE_BINANCE_1D [$i-3]= StringTrimRight(StringTrimLeft($Price_TRADE_BINANCE_1D [$i-3],7),1) ; L?c Kh?i Lu?ng
     $TOTAL_SELL =Round($TOTAL_SELL+ ($Price_TRADE_BINANCE_1D [$i-3]*$Price_TRADE_BINANCE_1D [$i-4]),2)
	 EndIf
    If $Price_TRADE_BINANCE_1D[$i] = '"isBuyerMaker":false' then ; BUY
     $Price_TRADE_BINANCE_1D [$i-4]= StringTrimRight(StringTrimLeft($Price_TRADE_BINANCE_1D [$i-4],9),1) ; L?c giá
     $Price_TRADE_BINANCE_1D [$i-3]= StringTrimRight(StringTrimLeft($Price_TRADE_BINANCE_1D [$i-3],7),1) ; L?c Kh?i Lu?ng
     $TOTAL_BUY =Round($TOTAL_BUY+ ($Price_TRADE_BINANCE_1D [$i-3]*$Price_TRADE_BINANCE_1D [$i-4]),2)
	 EndIf
 Next
 EndFunc

 Func API_GET_LIVE_PRICE ($Symbol)

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
EndFunc

 Func _BINANCE_API_Call($sEndPoint, $sParameters = "")
     ;**************************************************
    ; Performs Binance API Call Via Native WinHTTP dll
    ;**************************************************

    ;----- Vars -----
    ; Presume GET, assign POST if needed in switch
    Local $sGETorPOST = "GET"
    Local $sDELETEorPOST = "DELETE"
    Local $API_URL = "api.binance.com"

    ;----- Check Endpoint Required -----
    ; Some endpoints require signing, other endpoints can be
    ; added as new cases.
    Switch $sEndPoint
		   Case "api/v3/time"
            $sParameters &= ""
			$API_URL = "api.binance.com"
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
    Return ($aTimeStamp[0] * 1000) + @MSEC-500 ;convert to miliseconds
 EndFunc   ;==>_TimeStamp
Func Logs_Info ()
    Local $oExcel = _Excel_Open()
    Local $oBook = _Excel_BookAttach("Log.xlsx", "FileName", $oExcel)
    Local $sSheet = "Record"
    If @error Then Return MsgBox($MB_ICONERROR, "Excel Failed", "Failed to attach to Excel")

    Local $iNum
	$count = $count + 1
	
   	_Excel_RangeWrite($oBook, "Record",_DateAdd('n', 0, _NowCalcDate()),"A"&$count)
	_Excel_RangeWrite($oBook, "Record",_NowTime(),"B"&$count)
	_Excel_RangeWrite($oBook, "Record",$Price_BTC,"C"&$count)
	_Excel_RangeWrite($oBook, "Record",$Price_ETH,"D"&$count)
	_Excel_RangeWrite($oBook, "Record",$Price_BNB,"E"&$count)
	_Excel_RangeWrite($oBook, "Record",$Balance_BTC,"F"&$count)
	_Excel_RangeWrite($oBook, "Record",$Balance_ETH,"G"&$count)
	_Excel_RangeWrite($oBook, "Record",$Balance_BNB,"H"&$count)
	_Excel_RangeWrite($oBook, "Record",$Balance_USDT,"I"&$count)
	If $count > 7000 then $count = 2
EndFunc
Func Tapi_API ()
	
Global $sDomain = "api.taapi.io"
Global $sPage = "/rsi?secret="&$sAPI_Secret_Tapi&"&exchange=binance&symbol=BTC/USDT&interval=1h&backtracks=24&period=19"

   ; Initialize and get session handle
 Global $hOpen = _WinHttpOpen()

; Get connection handle
 Global $hConnect = _WinHttpConnect($hOpen, $sDomain)

; Make a SimpleSSL request
 Global $hRequestSSL = _WinHttpSimpleSendSSLRequest($hConnect, Default, $sPage)

; Read...
Global $sReturned = _WinHttpSimpleReadData($hRequestSSL)
ConsoleWrite($sReturned)



; Close handles
_WinHttpCloseHandle($hRequestSSL)
_WinHttpCloseHandle($hConnect)
_WinHttpCloseHandle($hOpen)
	EndFunc