//+------------------------------------------------------------------+
//|                                            JADC-MULTITEST-v0.mq4 |
//|                                                 JDC-ANewGrid-V.0 |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "JDC-MULTITEST-v0"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

//+------------------------------------------------------------------+
//| Includes and object initialization                               |
//+------------------------------------------------------------------+
enum TrueFalse
  {
   YES = 1, //YES
   NO = 0 //NO
  };

enum MAFactor
  {
   A =0,  //MA - FACTOR 0
   B =1,  //MA - FACTOR 1
   C =2,  //MA - FACTOR 2
   D =3,  //MA - FACTOR 3
   E =4,  //MA - FACTOR 4
   F =5,  //MA - FACTOR 5
   G =6,  //MA - FACTOR 6
   H =7,  //MA - FACTOR 7
   I =8,  //MA - FACTOR 8
   J =9   //MA - FACTOR 9
  };


enum EA_Setting
  {
   SPECIALONE1       =0,  //Special 1
   SPECIALONE2       =20, //Special 2
   RSI               =1,  //RSI 14/30-70
   RSI2              =2,  //RSI  8/20-80
   ADX               =3,  //ADX
   MACD              =4,  //MACD + 200SMA
   Stochastic        =5,  //Stochastic 5/3/3 (80-20)
   Sar               =6,  //Parabolic SAR
   BBand2            =7,  //Bolinger Bands 2dv
   BBand3            =8,  //Bolinger Bands 3dv
   BullBearP1        =9,  //Bull Bear Power 1
   BullBearP2        =10, //Bull Bear Power 2
   AO1               =11, //Awesome Oscillator 1
   AO2               =12, //Awesome Oscillator 2
   RVIMFI1           =13, //RVI+MFI 1
   RVIMFI2           =14, //RVI+MFI 2
   WPRMFI1           =15, //WPR+MFI 1
   WPRMFI2           =16, //WPR+MFI 2
   ADXBREAKOUT       =17, //ADX BREAKOUT
   MACONTRARIAN      =18, //MA AGAINST TREND
   PERCENTILEADX     =19, //PERCENT RANK
   ReturnExtreme1    =21, // Mean Reversion 1
   ReturnExtreme2    =22, // Mean Reversion 2
   ReturnExtreme3    =23, // Mean Reversion 3
   MOMENTUM          =24  // Momentum
  };

enum CLOSE_PENDING_TYPE
  {
   CLOSE_BUY_LIMIT,
   CLOSE_SELL_LIMIT,
   CLOSE_BUY_STOP,
   CLOSE_SELL_STOP,
   CLOSE_ALL_PENDING
  };

enum EA_Direction
  {
   Buy=0, // Buy Only
   Sell=1, // Sell Only
   Buy_Sell=2 // Buy and Sell
  };

enum Trade_Volume
  {
   Fixed_Lot   =0, //FIXED LOT
   Fixed_P     =1, // % OF RISK
   Half_Kelly  =2, //Half-Kelly
   Full_Kelly  =3, //Full Kelly
   Optimal_F   =4, //Optimal F
   RvRoulet    =5  //Reinversed
  };
enum Type_Loss
  {
   Fixed_PiP   =0, //FIXED PIPs
   ATR_PERIOD  =1, //ATR
   STD_PERIOD  =2  //SD (Standard deviation)
  };


enum KickTrailing
  {
   KickUp05    = 5,  //5 Pips
   KickUp10    = 10, //10 Pips
   KickUp20    = 20, //20 Pips
   KickUp30    = 30, //30 Pips
   KickUp40    = 40, //40 Pips
   KickUp50    = 50, //50 Pips
   KickUp60    = 60, //60 Pips
   KickUp70    = 70, //70 Pips
   KickUp80    = 80, //80 Pips
   KickUp90    = 90, //90 Pips
   KickUp100   = 100 //100 Pips
  };

enum PeriodVolat
  {
   PeriodVolat05    = 5,  //5 Bars
   PeriodVolat10    = 10, //10 Bars
   PeriodVolat15    = 15, //15 Bars
   PeriodVolat20    = 20, //20 Bars
   PeriodVolat25    = 25, //25 Bars
   PeriodVolat30    = 30, //30 Bars
   PeriodVolat35    = 35, //35 Bars
   PeriodVolat40    = 40, //40 Bars
   PeriodVolat45    = 45, //45 Bars
   PeriodVolat50    = 50, //50 Bars
   PeriodVolat55    = 55, //55 Bars
   PeriodVolat60    = 60, //60 Bars
   PeriodVolat65    = 65, //65 Bars
   PeriodVolat70    = 70, //70 Bars
   PeriodVolat75    = 75, //75 Bars
   PeriodVolat80    = 80, //80 Bars
   PeriodVolat85    = 85, //85 Bars
   PeriodVolat90    = 90, //90 Bars
   PeriodVolat95    = 95, //95 Bars
   PeriodVolat100   = 100 //100 Bars
  };

enum UtilitySelectPips
  {
   Zone5       =  5, //5 Pips
   Zone10      =  10, //10 Pips
   Zone15      =  15, //15 Pips
   Zone20      =  20, //20 Pips
   Zone25      =  25, //25 Pips
   Zone30      =  30, //30 Pips
   Zone35      =  35, //35 Pips
   Zone40      =  40, //40 Pips
   Zone45      =  45, //45 Pips
   Zone50      =  50, //50 Pips
   Zone55      =  55, //55 Pips
   Zone60      =  60, //60 Pips
   Zone65      =  65, //65 Pips
   Zone70      =  70, //70 Pips
   Zone75      =  75, //75 Pips
   Zone80      =  80, //80 Pips
   Zone85      =  85, //85 Pips
   Zone90      =  90, //90 Pips
   Zone95      =  95, //95 Pips
   Zone100     =  100, //100 Pips
   Zone110     =  110, //110 Pips
   Zone120     =  120, //120 Pips
   Zone130     =  130, //130 Pips
   Zone140     =  140, //140 Pips
   Zone150     =  150, //150 Pips
   Zone160     =  160, //160 Pips
   Zone170     =  170, //170 Pips
   Zone180     =  180, //180 Pips
   Zone190     =  190, //190 Pips
   Zone200     =  200, //200 Pips
   Zone250     =  250, //250 Pips
   Zone300     =  300, //300 Pips
   Zone350     =  350, //350 Pips
   Zone400     =  400, //400 Pips
   Zone450     =  450, //450 Pips
   Zone500     =  500  //500 Pips
  };

enum MaxNumTrades
  {
   Unlimited     =  0, //Unlimited
   Trades2       =  2, //2 Trades
   Trades3       =  3, //3 Trades
   Trades4       =  4, //4 Trades
   Trades5       =  5, //5 Trades
   Trades6       =  6, //6 Trades
   Trades7       =  7, //7 Trades
   Trades8       =  8, //8 Trades
   Trades9       =  9, //9 Trades
   Trades10      =  10, //10 Trades
   Trades11      =  11, //11 Trades
   Trades12      =  12, //12 Trades
   Trades13      =  13, //13 Trades
   Trades14      =  14, //14 Trades
   Trades15      =  15, //15 Trades
   Trades16      =  16, //16 Trades
   Trades17      =  17, //17 Trades
   Trades18      =  18, //18 Trades
   Trades19      =  19, //19 Trades
   Trades20      =  20, //20 Trades
   Trades25      =  25, //25 Trades
   Trades30      =  30, //30 Trades
   Trades35      =  35, //35 Trades
   Trades40      =  40, //40 Trades
   Trades45      =  45, //45 Trades
   Trades50      =  50  //50 Trades
  };

enum LotsMultiplic
  {
   Increment1,  //1.0 increment
   Increment15, //1.5 increment
   Increment20, //2.0 Normal
   Increment25, //2.5 increment
   Increment30, //3.0 increment
   Increment35, //3.5 increment
   Increment40, //4.0 increment
   Increment45, //4.5 increment
   Increment50  //5.0 increment
  };

//+------------------------------------------------------------------+
//| Input variables                                                  |
//+------------------------------------------------------------------+
extern string Input_DataOrders                        = "======= ORDER MANAGEMENT ======= ";
input Trade_Volume SelectTrade                        = Fixed_Lot; // Select Type of Trade
input double InitialLotSize                           = 0.01; // Initial Lot Size (Only for "FIXED LOT" selected)
input double RiskPercent                              = 2.00; //  % Risk Account - Lot Size (Only for "% OF RISK" selected)
input int MagicNumber                                 = 19710818; // Magic Number
input int Slippage                                    = 100; // Slippage Max (Points).

extern string Input_Strategy                          = "======= SELECT TRADING STRATEGY ======= ";
input EA_Direction DirectionTrade                     = Buy_Sell; // Select Direction of Orders
input EA_Setting EA_Mode                              = SPECIALONE1; //Select Trading System
input MAFactor MovFactor                              = A; //Select the factor (Works only in Moving Average Systems - MA)
extern TrueFalse BreakEven                            = YES; // Use Break Even
extern TrueFalse TraillingStop                        = YES; // Use Break Even + Trailling Stop
extern UtilitySelectPips  KickToBreak                 = Zone15; // Pips to Start Break Even
extern UtilitySelectPips  KickToTrailStop             = Zone15; // Pips to Start Trailling

extern string Input_TakeProfit                        = "======= ZONE PROFIT SETTINGS ======= ";
extern UtilitySelectPips TakeProfit                   = Zone20; // Take Profit
extern Type_Loss SelectTypeLoss                       = Fixed_PiP; // Select Kind of Loss
extern UtilitySelectPips StpLoss                      = Zone20; // Only for "FIXED PIPs"
extern PeriodVolat VolPeriods                         = PeriodVolat20; // Only for "ATR" of "SD"

extern string Input_ZoneRecover                       = "======= AVERAGING RECOVERY SETTINGS ======= ";
extern TrueFalse UseAveraging                         = YES; // Use Averaging Strategy
extern TrueFalse FactorIcrement                       = NO; // Use Factor to Increment Recovery Zone Size
input UtilitySelectPips RecoveryTakeProfit            = Zone10; // Recovery Take Profit.
extern UtilitySelectPips RecoveryZoneSize             = Zone50; // Recovery Zone Size(+ Stop Loss)
input LotsMultiplic LotMultiplier                     = Increment20; // Multiplier for Lots
input MaxNumTrades MaxTrades                          = Trades10; // Max Number of Trades (Unlimited Is a High Risk Option)
input TrueFalse SetMaxLoss                            = NO; // Max Loss after Max Trades reached?
input double MaxLoss                                  = 0; // Max Loss after Max Trades (0 for unlimted) in deposit currency.

extern string Input_Time                              = "======= SELECT TIME OPTIONS ======= ";
extern TrueFalse TradeADay                            = NO; // Trade Once A Day?
input TrueFalse UseLocalTime                          = NO; // Use Local Time?
input TrueFalse UseTimer                              = NO; // Use a Trade Timer?
input int StartHour                                   = 0; // Start Hour - Trade Timer
input int StartMinute                                 = 0; // Start Minute - Trade Timer
input int EndHour                                     = 0; // End Hour - Trade Timer
input int EndMinute                                   = 0; // End Minute - Trade Timer

extern string Input_Visual                            = "======= SELECT VISUAL OPTIONS ======= ";
input color profitLineColor                           = clrBlueViolet; // Profit
input color breakEventLineColor                       = clrBrown; // Break Even

extern string Input_General                           = "======= SELECT EA GENERAL OPTIONS ======= ";
input TrueFalse TradeOnBarOpen                        = NO;  // Trade on New Bar?
input TrueFalse BackTest                              = YES; // Simulate Costs in Back Test?
input double TestCommission                           = 3.5; // Commission Back Test US$ Per 1 Lot
input double TestSwap                                 = 1.5; // Swap Back Test US$ Per 1 Lot

//+------------------------------------------------------------------+
//| Global variable and indicators                                   |
//+------------------------------------------------------------------+

#define PROFIT_LINE "Profit Line"
#define PROFIT_BREAK_EVEN_LINE "Break Even Line"
#define EA_NAME "MULTITEST v1.5.0" //usar
#define CLOSE_ALL_BUTTON "Close All Button" //usar


double gBuyOpenPrice, gSellOpenPrice;
double gNewBuyOpenPrice, gNewSellOpenPrice;
double gLotSize;
double gInitialLotSize;
bool gRecoveryInitiated;
double gCurrentDirection;
double UsePip;
int CalcDig;
double UseSlippage;
datetime gLastTime;
int gBuyStopTicket = 0;
int gSellStopTicket = 0;
int gBuyTicket = 0;
int gSellTicket = 0;
int NumbOrder = 0;
double ATRStopRange, SDStopRange;
string gTradingPanelObjects[100];
color cl1=clrChartreuse;//Color 1
color cl2=clrLightSkyBlue;//Color 2
color cl3=clrRed;//Color 3
color cl_back=clrBlack;//Back color
int text_size=9;//Text size
bool BEActive = false;
double PriceAverage, TargetProfit, CostTrade, ProfitCurrent;
int barsTotal, counted_bars, limit, MaxBar;
double LotSelectec;
double InitialBalance;


//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   barsTotal = iBars(_Symbol,0);
   CreateTradePanel();
   DeleteTradePanel();
   UpdateTradePanel();
   InitialBalance = AccountBalance();

//---
   gRecoveryInitiated = false;
   gCurrentDirection = 0;
   UsePip = PipPoint(Symbol());
   CalcDig = GetPoints(Digits());
   UseSlippage = GetSlippage(Symbol(), Slippage);
   gLastTime = 0;
   Print("Recovery EA Initiated SUCCESFULLLY!!!,  RecoveryZone Initiate : ", gRecoveryInitiated, " -  Current Direction: ", gCurrentDirection, " - Magic No: ", MagicNumber, " - Slippage: ", Slippage);

   if(OrdersTotal() > 0)
     {
      FindOpenOrders();
     }

   switch(Period()) // Calculating coefficient for..
     {
      // .. different timeframes
      case     1:
         HideTestIndicators(true);
         ATRStopRange = NormalizeDouble(iATR(Symbol(), PERIOD_M15, VolPeriods, 1),CalcDig);
         SDStopRange = NormalizeDouble(iStdDev(NULL,PERIOD_M15,VolPeriods,0,MODE_EMA,PRICE_MEDIAN,0),CalcDig);
         HideTestIndicators(false);
         break;// Timeframe M1
      case     5:
         HideTestIndicators(true);
         ATRStopRange = NormalizeDouble(iATR(Symbol(), PERIOD_M30, VolPeriods, 1),CalcDig);
         SDStopRange = NormalizeDouble(iStdDev(NULL,PERIOD_M30,VolPeriods,0,MODE_EMA,PRICE_MEDIAN,0),CalcDig);
         HideTestIndicators(false);
         break;// Timeframe M5
      case    15:
         HideTestIndicators(true);
         ATRStopRange = NormalizeDouble(iATR(Symbol(), PERIOD_H1, VolPeriods, 1),CalcDig);
         SDStopRange = NormalizeDouble(iStdDev(NULL,PERIOD_H1,VolPeriods,0,MODE_EMA,PRICE_MEDIAN,0),CalcDig);
         HideTestIndicators(false);
         break;// Timeframe M15
      case    30:
         HideTestIndicators(true);
         ATRStopRange = NormalizeDouble(iATR(Symbol(), PERIOD_H4, VolPeriods, 1),CalcDig);
         SDStopRange = NormalizeDouble(iStdDev(NULL,PERIOD_H4,VolPeriods,0,MODE_EMA,PRICE_MEDIAN,0),CalcDig);
         HideTestIndicators(false);
         break;// Timeframe M30
      case    60:
         HideTestIndicators(true);
         ATRStopRange = NormalizeDouble(iATR(Symbol(), PERIOD_D1, VolPeriods, 1),CalcDig);
         SDStopRange = NormalizeDouble(iStdDev(NULL,PERIOD_D1,VolPeriods,0,MODE_EMA,PRICE_MEDIAN,0),CalcDig);
         HideTestIndicators(false);
         break;// Timeframe H1
      case   240:
         HideTestIndicators(true);
         ATRStopRange = NormalizeDouble(iATR(Symbol(), PERIOD_W1, VolPeriods, 1),CalcDig);
         SDStopRange = NormalizeDouble(iStdDev(NULL,PERIOD_W1,VolPeriods,0,MODE_EMA,PRICE_MEDIAN,0),CalcDig);
         HideTestIndicators(false);
         break;// Timeframe H4
      case  1440:
         HideTestIndicators(true);
         ATRStopRange = NormalizeDouble(iATR(Symbol(), PERIOD_MN1, VolPeriods, 1),CalcDig);
         SDStopRange = NormalizeDouble(iStdDev(NULL,PERIOD_MN1,VolPeriods,0,MODE_EMA,PRICE_MEDIAN,0),CalcDig);
         HideTestIndicators(false);
         break;// Timeframe D1
      case  10080:
         HideTestIndicators(true);
         ATRStopRange = NormalizeDouble(iATR(Symbol(), PERIOD_MN1, VolPeriods, 1),CalcDig);
         SDStopRange = NormalizeDouble(iStdDev(NULL,PERIOD_MN1,VolPeriods,0,MODE_EMA,PRICE_MEDIAN,0),CalcDig);
         HideTestIndicators(false);
         break;// Timeframe W1
      case  43200:
         HideTestIndicators(true);
         ATRStopRange = NormalizeDouble(iATR(Symbol(), PERIOD_MN1, VolPeriods, 1),CalcDig);
         SDStopRange = NormalizeDouble(iStdDev(NULL,PERIOD_MN1,VolPeriods,0,MODE_EMA,PRICE_MEDIAN,0),CalcDig);
         HideTestIndicators(false);
         break;// Timeframe MN1

     }

//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
///////////
   for(int i=ObjectsTotal(); i>=0; i--)
     {
      string name=ObjectName(i);
      if(StringSubstr(name,0,4)=="data")
        {
         ObjectDelete(0,name);
        }
     }
   DeleteTradePanel();
///////////
   switch(reason)
     {
      case 0:
        {
         Print("EA De-Initialised, removed by EA");
         break;
        }
      case 1:
        {
         Print("EA De-Initialised, removed by user");
         break;
        }
      case 2:
        {
         Print("EA De-Initialised, EA recompiled");
         break;
        }
      case 3:
        {
         Print("EA De-Initialised, Symbol changed");
         break;
        }
      case 4:
        {
         Print("EA De-Initialised, chart closed by user.");
         break;
        }
      case 5:
        {
         Print("EA De-Initialised, input parameters changed.");
         break;
        }
      case 6:
        {
         Print("EA De-Initialised, account changed");
         break;
        }
      case 7:
        {
         Print("EA De-Initialised, A new template has been applied.");
         break;
        }
      case 8:
        {
         Print("EA De-Initialised, EA failed to initialize.");
         break;
        }
      case 9:
        {
         Print("EA De-Initialised, Terminal closed by user.");
         break;
        }
     }
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
   BEActive = false;
   UpdateTradePanel();
// Check timer
   bool tradeEnabled = true;
   if(UseTimer == YES)
     {
      tradeEnabled = CheckDailyTimer();
     }


// Check for bar open
   bool newBar = true;
   int barShift = 0;

// check if a new bar has been opened
   if(TradeOnBarOpen == YES)
     {
      newBar = false;
      datetime time[];
      bool firstRun = false;

      CopyTime(_Symbol,PERIOD_CURRENT,0,2,time);

      if(gLastTime == 0)
        {
         firstRun = true;
        }

      if(time[0] > gLastTime)
        {
         if(firstRun == false)
           {
            newBar = true;
           }
         gLastTime = time[0];
        }
      barShift = 1;
     }

   ControlPosition();

// Money management
   switch(SelectTrade)
     {
      case Fixed_Lot :
         if(InitialLotSize <= 0)
           {
            double minVolumeInformed = SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MIN);
            string MessageLot = "The Volume Informed Is Smaller Than The Minimum For This Symbol, Please Increase Volume: ";
            Alert(MessageLot, _Symbol, ", EA Will Use Minimum Lot: ", minVolumeInformed);
           }
         // set lot size to initial lot size for doubling later
         gInitialLotSize = CheckVolume(_Symbol, InitialLotSize); // check the input value for lot initial lot size and set to initial
         break;
      case Fixed_P :
         if(RiskPercent != 0)
           {
            int StopLoss = TakeProfit;
            gInitialLotSize = GetTradeSize(_Symbol,InitialLotSize,RiskPercent,StopLoss);
           }
         else
           {
            double minVolumeUsing = SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MIN);
            string MessageLot = "% of Risk Informed Is Incompatible, Please Adjust Your % Of Risk For This Symbol: ";
            Alert(MessageLot, _Symbol, ", EA Will Use Fixed Minimum Lot: ", minVolumeUsing);
            gInitialLotSize = CheckVolume(_Symbol, InitialLotSize); // check the input value for lot initial lot size and set to initial
           }
         break;
      case Half_Kelly:
         gInitialLotSize = LotCriterium(Half_Kelly);
         break;
      case Full_Kelly:
         gInitialLotSize = LotCriterium(Full_Kelly);
         break;
      case Optimal_F:
         gInitialLotSize = LotCriterium(Optimal_F);
         break;
      case RvRoulet:
         gInitialLotSize = LotCriterium(RvRoulet);
         break;
     }

// Check entries on new bar
   if(newBar == true && tradeEnabled == true && TradeOnceDay()) // check for new bar and whether timer allows to open
     {
      int direction = TradingSystem(barShift + 1,EA_Mode,DirectionTrade);
      int nowFalse = TradingSystem(barShift,EA_Mode,DirectionTrade);
      if(direction == 1 && nowFalse == 0)
        {
         Print("Buy signal generated.");
         if(gCurrentDirection == 0)
           {
            TakeTrade(direction);
            Print("Buy signal generated.");
           }
         else
           {
            Print("Buy signal not used as EA in trade on ", _Symbol);
           }
        }
      else
         if(direction == -1 && nowFalse == 0)
           {
            if(gCurrentDirection == 0)
              {
               TakeTrade(direction);
               Print("Sell signal generated.");
              }
            else
              {
               Print("Sell signal not used as EA in trade on ", _Symbol);
              }
           }
     }
   if(gCurrentDirection != 0)
     {
      //////////
      // on every tick work out the average price
      // count the number of buy and sell orders
      int positions = 0;
      double averagePrice = 0;
      double currentProfit = 0;
      double positionSize = 0;
      double netLotSize = 0;
      double totalCommision = 0;
      double totalSwap = 0;
      double totalSpreadCosts = 0;
      double oldorderopenprice=0;
      int oldticketnumber=0;
      double unused = 0;
      int ticketnumber = 0;
      int IncrementFactor = 0;
      double point_value = _Point*MarketInfo(_Symbol, MODE_TICKVALUE)/MarketInfo(_Symbol, MODE_TICKSIZE);
      //////////
      for(int counter = 0; counter <= OrdersTotal() - 1; counter++)
        {
         if(OrderSelect(counter, SELECT_BY_POS))
           {
            if(OrderMagicNumber() == MagicNumber && OrderSymbol() == Symbol())
              {
               positions += 1;
               currentProfit += OrderProfit();

               if(OrderType() == OP_BUY)
                 {
                  positionSize += (OrderOpenPrice()*OrderLots());
                  netLotSize += OrderLots();
                  totalSpreadCosts += (OrderLots()*MarketInfo(_Symbol, MODE_SPREAD)*point_value);
                  totalCommision += OrderCommission();
                  totalSwap += OrderSwap();
                 }
               else
                  if(OrderType() == OP_SELL)
                    {
                     positionSize -= (OrderOpenPrice()*OrderLots());
                     netLotSize -= OrderLots();
                     totalSpreadCosts += (OrderLots()*MarketInfo(_Symbol, MODE_SPREAD)*point_value);
                     totalCommision += OrderCommission();
                     totalSwap += OrderSwap();
                    }
              }
           }
        }

      // if the current profits are greater than the desired recovery profit and costs close the trades
      double volume;
      volume = gInitialLotSize;

      double profitTarget = (RecoveryTakeProfit*10)*point_value*volume; //Multiply 10 because utilitypips was divided by 10

      // simulate commission for backtesting
      double tradeCosts = 0;
      if(IsTesting())
        {
         tradeCosts = totalSpreadCosts+(MathAbs(netLotSize)*TestCommission)+(MathAbs(netLotSize)*TestSwap);
        }
      else
        {
         tradeCosts = totalSpreadCosts+totalCommision+totalSwap; // spread + commision + swap
        }

      double tp = RecoveryTakeProfit*10; //Multiply 10 because utilitypips was divided by 10


      if((currentProfit >= (profitTarget + tradeCosts)))
        {
         bool isOrderOpen=false;
         for(int i=OrdersTotal()-1; i>=0; i--)
           {
            if(OrderSelect(i,SELECT_BY_POS))
              {
               if(OrderMagicNumber()==MagicNumber && OrderSymbol()==Symbol())
                 {
                  if(OrderStopLoss() > OrderOpenPrice())
                    {
                     isOrderOpen=true;
                    }
                 }
              }
           }
         if(!isOrderOpen)
           {
            CloseOrdersAndReset();
            Print("Orders closed, profit target of: ", DoubleToStr(profitTarget, 2), "$ exceeded at: ", DoubleToStr(currentProfit, 2), "$, Costs(", DoubleToStr(tradeCosts, 2), "$)");
           }
        }
      //////////////////
      if(netLotSize != 0)
        {
         averagePrice    = NormalizeDouble(positionSize/netLotSize, _Digits);
         Comment(StringConcatenate("Average Price: ", DoubleToStr(averagePrice, _Digits), ", Profit Target: $", DoubleToStr(profitTarget, 2), " + Trade Costs: $", DoubleToStr(tradeCosts, 2), ", Running Profit:  $", DoubleToStr(currentProfit, 2), "\n"));
         PriceAverage    = averagePrice;
         TargetProfit    = profitTarget;
         CostTrade       = tradeCosts;
         ProfitCurrent   = currentProfit;
        }
      //Print("NetLotSize ", netLotSize);
      ///////////////
      /*if(positions >= MaxTrades && MaxTrades != 0 && currentProfit < -MaxLoss && SetMaxLoss == YES)
        {
         CloseOrdersAndReset();
         Print("Orders closed, max trades reached and max loss of: -$", MaxLoss, " by $", currentProfit);
        }*/
      if(SetMaxLoss == YES)
        {
         if((positions == MaxTrades && MaxTrades != 0 && currentProfit < -MaxLoss) || currentProfit < -MaxLoss)
           {
            CloseOrdersAndReset();
            Print("Orders closed, max trades reached and max loss of: -$", MaxLoss, " by $", currentProfit);
           }
        }

      // set the take profit line price
      if(gCurrentDirection == 1 && netLotSize != 0)
        {
         tp = (profitTarget + tradeCosts - currentProfit)*_Point/(point_value*netLotSize);
         double   profitPrice = NormalizeDouble(Bid + tp, _Digits);
         if(!ObjectSetDouble(0, PROFIT_LINE, OBJPROP_PRICE, profitPrice))
           {
            Print("Could not set line");
           }
        }
      else
         if(gCurrentDirection == -1 && netLotSize != 0)
           {
            tp = (profitTarget + tradeCosts - currentProfit)*_Point/(point_value*netLotSize);
            double   profitPrice = NormalizeDouble(Ask + tp, _Digits);
            if(!ObjectSetDouble(0, PROFIT_LINE, OBJPROP_PRICE, profitPrice))
              {
               Print("Could not set line");
              }
           }

      // check if the current direction is buy and the bid price (sell stop has opened) is below the recovery line
      if(gCurrentDirection == 1)
        {
         double SpecialIncrement = 0;
         //double price = MarketInfo(Symbol(), MODE_BID);
         for(int cnt = OrdersTotal() - 1; cnt >= 0; cnt--)
           {
            if(OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES))
              {
               if(OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber && OrderType() == OP_BUY)
                 {
                  oldticketnumber = OrderTicket();
                  if(oldticketnumber > ticketnumber)
                    {
                     oldorderopenprice = OrderOpenPrice();
                     unused = oldorderopenprice;
                     ticketnumber = oldticketnumber;
                    }
                 }
              }
           }
         if(FactorIcrement == YES)
           {
            SpecialIncrement = SDStopRange * positions;
           }
         else
           {
            SpecialIncrement = 0;
           }

         if(Ask <  oldorderopenprice - (RecoveryZoneSize*UsePip + SpecialIncrement))
           {
            Print("Recovery Buy Stop has been opene, initiating recovery...");
            // increase the lot size
            gLotSize = GetTradeVolume();
            if(MaxTrades == 0 || positions < MaxTrades) // check we've not exceeded the max trades
              {
               // open a buy stop order at double the running lot size
               gBuyOpenPrice = Ask;
               gBuyStopTicket = OpenPendingOrder(Symbol(), OP_BUY, gLotSize, gBuyOpenPrice, 0, 0, StringConcatenate("Recovery Buy Stop opened."), 0, clrTurquoise); // create an opposite buy stop
               gRecoveryInitiated = true; // signal that we are in recovery mode
              }
            // Waning the current direction to Buy
            gCurrentDirection = 1;
           }
        }
      // check if the current direction is sell and the ask price (sell stop has opened) is below the recovery line
      if(gCurrentDirection == -1)
        {
         double SpecialIncrement = 0;
         //double price = MarketInfo(Symbol(), MODE_ASK);
         for(int cnt = OrdersTotal() - 1; cnt >= 0; cnt--)
           {
            if(OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES))
              {
               if(OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber && OrderType() == OP_SELL)
                 {
                  oldticketnumber = OrderTicket();
                  if(oldticketnumber > ticketnumber)
                    {
                     oldorderopenprice = OrderOpenPrice();
                     unused = oldorderopenprice;
                     ticketnumber = oldticketnumber;
                    }
                 }
              }
           }
         if(FactorIcrement == YES)
           {
            SpecialIncrement = SDStopRange * positions;
           }
         else
           {
            SpecialIncrement = 0;
           }
         if(Bid > oldorderopenprice + (RecoveryZoneSize*UsePip + SpecialIncrement))
           {
            Print("Recovery Sell Stop has been opened, initiating recovery...");
            // increase the lot size
            gLotSize = GetTradeVolume();
            if(MaxTrades == 0 || positions < MaxTrades) // check we've not exceeded the max trades
              {
               // open a sell stop order at double the running lot size
               gSellOpenPrice = Bid;
               gSellStopTicket = OpenPendingOrder(Symbol(), OP_SELL, gLotSize, gSellOpenPrice, 0, 0, StringConcatenate("Recovery Sell Stop opened."), 0, clrPink); // create an opposite sell stop
               gRecoveryInitiated = true; // signal we're in recovery mode
              }
            // Warning the current direction to sell
            gCurrentDirection = -1;
           }
        }
     }
   else
     {
      Comment("No Zone Recovery Active", "\n");
      for(int cnt = OrdersTotal() - 1; cnt >= 0; cnt--)
        {
         if(OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES))
           {
            if(OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber)
              {
               ProfitCurrent = OrderProfit();
              }
           }
        }
     }

  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|     ======= CONTROL SEND ORDERS =======                          |
//+------------------------------------------------------------------+
void TakeTrade(int direction)
  {
   double rz = 0;
   double tp = 0;
   tp = TakeProfit*UsePip; // tp as price units
   rz = RecoveryZoneSize*UsePip; // rz as price

   gLotSize = gInitialLotSize;

   double price = 0;

// Buy Trade
   if(direction == 1)
     {
      gBuyTicket = OpenMarketOrder(Symbol(), OP_BUY, gLotSize, "Initial Buy Order", clrGreen);
      gCurrentDirection = direction;
      /*if(UseAveraging == YES)
        {
         if(OrderSelect(gBuyTicket, SELECT_BY_TICKET))
           {
            gBuyOpenPrice = OrderOpenPrice();
            gNewBuyOpenPrice = NormalizeDouble((gBuyOpenPrice - rz), _Digits);
            //open a recovery stop order in the opposite direction
            gLotSize = GetTradeVolume();
            gSellStopTicket = OpenPendingOrder(Symbol(), OP_BUYLIMIT, gLotSize, gNewBuyOpenPrice, 0, 0, "Initial Recovery Sell Stop)", 0, clrPink);
            gCurrentDirection = direction;
            price = gNewBuyOpenPrice;
           }
        }*/
     }
// Sell Trade
   else
      if(direction == -1)
        {
         gSellTicket = OpenMarketOrder(Symbol(), OP_SELL, gLotSize, "Initial Sell Order", clrRed);
         gCurrentDirection = direction;
         /*if(UseAveraging == YES)
           {
            if(OrderSelect(gSellTicket, SELECT_BY_TICKET))
              {
               gSellOpenPrice = OrderOpenPrice();
               gNewSellOpenPrice = NormalizeDouble((gSellOpenPrice + rz), _Digits);
               //open a recovery stop order in the opposite direction
               gLotSize = GetTradeVolume();
               gBuyStopTicket = OpenPendingOrder(Symbol(), OP_SELLLIMIT, gLotSize, gNewSellOpenPrice, 0, 0, "Initial Recovery Buy Stop)", 0, clrTurquoise);
               gCurrentDirection = direction;
               price = gNewSellOpenPrice;
              }
           }*/
        }
   CreateProfitLine(direction, price, tp);

  }
//+------------------------------------------------------------------+
//|      ======= USEFUL FUNCTIONS =======                            |
//+------------------------------------------------------------------+
double PipPoint(string Currency)
  {
   double CalcPoint = 0;
   double CalcDigits = MarketInfo(Currency,MODE_DIGITS);
   if(CalcDigits == 2 || CalcDigits == 3)
     {
      CalcPoint = 0.01;
     }
   else
      if(CalcDigits == 4 || CalcDigits == 5)
        {
         CalcPoint = 0.0001;
        }
      else
         if(CalcDigits == 0)
           {
            CalcPoint = 0;
           }
         else
            if(CalcDigits == 1)
              {
               CalcPoint = 0.1;
              }
   return(CalcPoint);
  }
//+------------------------------------------------------------------+
double GetSlippage(string Currency, int SlippagePips)
  {
   double CalcSlippage = SlippagePips;
   int CalcDigits = (int)MarketInfo(Currency,MODE_DIGITS);
   if(CalcDigits == 0 || CalcDigits == 1 || CalcDigits == 2 || CalcDigits == 4)
     {
      CalcSlippage = SlippagePips;
     }
   else
      if(CalcDigits == 3 || CalcDigits == 5)
        {
         CalcSlippage = SlippagePips;
        }
   return(CalcSlippage);
  }

//+------------------------------------------------------------------+
int GetPoints(int Dig)
  {
   int CalcPoint = Dig;
   double CalcDigits = MarketInfo(Symbol(),MODE_DIGITS);
   if(CalcPoint >= 4)
     {
      CalcPoint = 4;
     }
   else
      if(_Digits <= 3)
        {
         CalcPoint = 2;
        }
   return(CalcPoint);
  }
//+------------------------------------------------------------------+
// END USEFUL FUNCTIONS

//+------------------------------------------------------------------+
//|          ======= SELECT TIME OPTIONS =======                     |
//+------------------------------------------------------------------+
datetime CreateDateTime(int pHour = 0, int pMinute = 0)
  {
   MqlDateTime timeStruct;
   TimeToStruct(TimeCurrent(),timeStruct);

   timeStruct.hour = pHour;
   timeStruct.min = pMinute;

   datetime useTime = StructToTime(timeStruct);

   return(useTime);
  }
//+------------------------------------------------------------------+
bool CheckDailyTimer()
  {
   datetime TimeStart = CreateDateTime(StartHour, StartMinute);
   datetime TimeEnd = CreateDateTime(EndHour, EndMinute);

   datetime currentTime;
   if(UseLocalTime == YES)
     {
      currentTime = TimeLocal();
     }
   else
     {
      currentTime = TimeCurrent();
     }

// check if the timer goes over midnight
   if(TimeEnd <= TimeStart)
     {
      TimeStart -= 86400;

      if(currentTime > TimeEnd)
        {
         TimeStart += 86400;
         TimeEnd += 86400;
        }
     }

   bool timerOn = false;
   if(currentTime >= TimeStart && currentTime < TimeEnd)
     {
      timerOn = true;
     }

   return(timerOn);
  }
//+------------------------------------------------------------------+
bool TradeOnceDay()
  {
   if(TradeADay == YES)
     {
      datetime today = iTime(NULL,PERIOD_D1,0);
      for(int i=OrdersHistoryTotal()-1; i>=0; i--)
        {
         if(!OrderSelect(i,SELECT_BY_POS,MODE_HISTORY))
           {
            continue;
           }
         if(OrderSymbol() != _Symbol)
           {
            continue;
           }
         if(OrderMagicNumber()!= MagicNumber)
           {
            continue;
           }
         if(OrderOpenTime() >= today)
           {
            return(false);
           }
        }

      for(int i=OrdersTotal()-1; i>=0; i--)
        {
         if(!OrderSelect(i,SELECT_BY_POS))
           {
            continue;
           }
         if(OrderSymbol() != _Symbol)
           {
            continue;
           }
         if(OrderMagicNumber()!= MagicNumber)
           {
            continue;
           }
         if(OrderOpenTime() >= today)
           {
            return(false);
           }
        }
      return(true);
     }
   else
     {
      return(true);
     }
  }
//+------------------------------------------------------------------+
void FindOpenOrders()
  {
   double largest_lots = 0;
   int ticket = -1;
   int open_orders = 0;
   int stopTicket = 0;
   for(int Counter = 0; Counter <= OrdersTotal()-1; Counter++)
     {
      if(OrderSelect(Counter,SELECT_BY_POS))
        {
         if(OrderMagicNumber() == MagicNumber && OrderSymbol() == _Symbol && (OrderType() == OP_BUY || OrderType() == OP_SELL))
           {
            open_orders++;
            if(OrderLots() > largest_lots)
              {
               ticket = OrderTicket();
               largest_lots = OrderLots();
              }
           }
         if(OrderMagicNumber() == MagicNumber && OrderSymbol() == _Symbol && OrderType() == OP_BUYSTOP)
           {
            gBuyStopTicket = OrderTicket();
            stopTicket = gBuyStopTicket;
           }
         else
            if(OrderMagicNumber() == MagicNumber && OrderSymbol() == _Symbol && OrderType() == OP_SELLSTOP)
              {
               gSellStopTicket = OrderTicket();
               stopTicket = gSellStopTicket;
              }
        }
     }

   if(ticket > 0)
     {
      if(OrderSelect(ticket, SELECT_BY_TICKET))
        {
         int type = OrderType();
         if(type == OP_BUY)
           {
            gCurrentDirection = 1;
            gBuyTicket = ticket;
           }
         else
            if(type == OP_SELL)
              {
               gCurrentDirection = -1;
               gSellTicket = ticket;
              }
         if(open_orders > 1)
            gRecoveryInitiated = true;
        }
      Print("Check for orders complete, resuming recovery direction of trade: ", ticket, " with recovery stop: ", stopTicket, " in place. ", open_orders, " orders already opened.");
     }
   else
     {
      Print("Check for orders complete, none currently open.");
     }
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
void CloseOrdersAndReset()
  {
   CloseAllMarketOrders();
   DeletePendingOrders(CLOSE_ALL_PENDING);
   gLotSize = gInitialLotSize;
   gCurrentDirection = 0;
   gBuyStopTicket = 0;
   gSellStopTicket = 0;
   gBuyTicket = 0;
   gSellTicket = 0;
   gRecoveryInitiated = false;
   DeleteProfitLine();
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
void CloseOrdersAndResetTrading()
  {
   DeletePendingOrders(CLOSE_ALL_PENDING);
   gLotSize = gInitialLotSize;
   gCurrentDirection = 0;
   gBuyStopTicket = 0;
   gSellStopTicket = 0;
   gBuyTicket = 0;
   gSellTicket = 0;
   gRecoveryInitiated = false;
   DeleteProfitLine();
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|=======  ORDER MANAGEMENT =======                                 |
//+------------------------------------------------------------------+
void CloseAllMarketOrders()
  {
   int retryCount = 0;

   for(int Counter = 0; Counter <= OrdersTotal()-1; Counter++)
     {
      if(OrderSelect(Counter,SELECT_BY_POS))
        {
         if(OrderMagicNumber() == MagicNumber && OrderSymbol() == _Symbol && (OrderType() == OP_BUY || OrderType() == OP_SELL))
           {
            // Close Order
            int CloseTicket = OrderTicket();
            double CloseLots = OrderLots();
            while(IsTradeContextBusy())
               Sleep(10);

            RefreshRates();
            double ClosePrice = MarketInfo(_Symbol,MODE_BID);
            if(OrderType() == OP_SELL)
              {
               ClosePrice = MarketInfo(_Symbol, MODE_ASK);
              }

            bool Closed = OrderClose(CloseTicket,CloseLots,ClosePrice,Slippage,Red);
            // Error Handling
            if(Closed == false)
              {
               int ErrorCode = GetLastError();
               string ErrAlert = StringConcatenate("Close All Market Orders - Error ",ErrorCode,".");
               Alert(ErrAlert);
               Print(ErrAlert);
              }
            else
               Counter--;
           }
        }
     }
  }

//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
bool DeletePendingOrders(CLOSE_PENDING_TYPE pDeleteType)
  {
   bool error = false;
   bool deleteOrder = false;

// Loop through open order pool from oldest to newest
   for(int order = 0; order <= OrdersTotal() - 1; order++)
     {
      // Select order
      bool result = OrderSelect(order,SELECT_BY_POS);

      int orderType = OrderType();
      int orderMagicNumber = OrderMagicNumber();
      int orderTicket = OrderTicket();
      double orderVolume = OrderLots();

      // Determine if order type matches pCloseType
      if((pDeleteType == CLOSE_ALL_PENDING && orderType != OP_BUY && orderType != OP_SELL)
         || (pDeleteType == CLOSE_BUY_LIMIT && orderType == OP_BUYLIMIT)
         || (pDeleteType == CLOSE_SELL_LIMIT && orderType == OP_SELLLIMIT)
         || (pDeleteType == CLOSE_BUY_STOP && orderType == OP_BUYSTOP)
         || (pDeleteType == CLOSE_SELL_STOP && orderType == OP_SELLSTOP))
        {
         deleteOrder = true;
        }
      else
        {
         deleteOrder = false;
        }

      // Close order if pCloseType and magic number match currently selected order
      if(deleteOrder == true && orderMagicNumber == MagicNumber)
        {
         result = OrderDelete(orderTicket);

         if(result == false)
           {
            Print("Delete multiple orders, failed to delete order: ", orderTicket);
            error = true;
           }
         else
           {
            order--;
           }
        }
     }

   return(error);
  }

//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|======= VOLUME ORDER MANAGEMENT =======                           |
//+------------------------------------------------------------------+
// Verify and adjust trade volume
double CheckVolume(string pSymbol,double pVolume)
  {
   double minVolume = SymbolInfoDouble(pSymbol,SYMBOL_VOLUME_MIN);
   double maxVolume = SymbolInfoDouble(pSymbol,SYMBOL_VOLUME_MAX);
   double stepVolume = SymbolInfoDouble(pSymbol,SYMBOL_VOLUME_STEP);

   double tradeSize;
   if(pVolume < minVolume)
     {
      Alert("Sent volume is smaller than the minimum volume for this symbol: ", _Symbol, ", min: ", minVolume, ", sent: ", pVolume);
      tradeSize = minVolume;
     }
   else
      if(pVolume > maxVolume)
        {
         Alert("Sent volume is larger than the maximum volume for this symbol: ", _Symbol, ", max: ", maxVolume, ", sent: ", pVolume);
         tradeSize = maxVolume;
        }
      else
        {
         tradeSize = MathRound(pVolume / stepVolume) * stepVolume;
        }

   if(stepVolume >= 0.1)
     {
      tradeSize = NormalizeDouble(tradeSize,1);
     }
   else
     {
      tradeSize = NormalizeDouble(tradeSize,2);
     }

   return(tradeSize);
  }

//+------------------------------------------------------------------+
double LotCriterium(int Switch)
  {
///////////////
   static double CurrentDrdw = 0, DrawDown = 0;
   static datetime y = 0, m = 0, d = 0;
   datetime OrderTimeClose=0, TimeCloseDD=0;
   double DrdwDwCalc=0;
   double CountNumberWins  = 0;
   double CountProfitMoney = 0;
   double CountLossMoney   = 0;
   double CountProfitLots  = 0;
   double CountLossLots    = 0;
   int EA_Executed_Trades  = 0;
   int HistoryOrders       = OrdersHistoryTotal();
   double MinLotDetect     = SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MIN);
   double MaxLotDetect     = SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MAX);
//double CalcLots;

   if(HistoryOrders == 0) // There was no trade done by this EA, use the manual input value
     {
      LotSelectec = MinLotDetect;
     }
   else
     {
      for(int index=0; index<HistoryOrders; index++)
        {
         if(OrderSelect(index,SELECT_BY_POS,MODE_HISTORY))
           {
            if(OrderSymbol()==Symbol() &&  OrderCloseTime()>0)
              {
               EA_Executed_Trades++;
               if(OrderProfit()>0)
                 {
                  CountNumberWins++;
                 }
               if(OrderType()<2)
                 {
                  if(OrderProfit()>0)
                    {
                     CountProfitMoney += OrderProfit()+(OrderSwap()+OrderCommission());
                     CountProfitLots += OrderLots();
                     DrdwDwCalc = ((OrderProfit()+OrderSwap()+OrderCommission())- AccountMargin()) / AccountBalance() * 100;
                     OrderTimeClose =  OrderCloseTime();
                    }
                  if(OrderProfit()<0)
                    {
                     CountLossMoney += OrderProfit()+(OrderSwap()+OrderCommission());
                     CountLossLots += OrderLots();
                     DrdwDwCalc = ((OrderProfit()+OrderSwap()+OrderCommission())- AccountMargin()) / AccountBalance() * 100;
                     OrderTimeClose =  OrderCloseTime();
                    }
                 }
              }
           }
        }
     }
//Maximum drawdown data
   if(DrdwDwCalc < CurrentDrdw) //Maximum drawdown data
     {
      CurrentDrdw = DrdwDwCalc;
      DrawDown    = NormalizeDouble(DrdwDwCalc *AccountBalance() / 100,2);
      y = TimeYear(TimeCurrent());
      m = TimeMonth(TimeCurrent());
      d = TimeDay(TimeCurrent());
      TimeCloseDD = OrderTimeClose;
      Print("DrawDown: ", DrawDown, " TimeCloseDD: ", TimeCloseDD);
     }

   if(CountNumberWins > 0 && CountProfitMoney > 0 && CountLossMoney /*>0*/!=0)
     {
      double WinNumberRate    = (CountNumberWins/EA_Executed_Trades);
      double LossNumberRate   = 1 - WinNumberRate;
      double WinMoneyRate     = (CountProfitMoney/EA_Executed_Trades);
      double LossMoneyRate    = (CountLossMoney/EA_Executed_Trades);

      if(Switch==Half_Kelly)//Half-Kelly
        {
         double Kelly2 = (WinNumberRate - ((LossNumberRate /(WinMoneyRate/LossMoneyRate))))/2;
         if(Kelly2 > MaxLotDetect)
           {
            LotSelectec = MaxLotDetect;
           }
         if(Kelly2 < MinLotDetect)
           {
            LotSelectec = MinLotDetect;
           }

         //double Lots=MathCeil((AccountFreeMargin()*AccountLeverage()*Kelly2*UsePip)/(Ask*MarketInfo(Symbol(),MODE_LOTSIZE)*MarketInfo(Symbol(),MODE_MINLOT)))/**MarketInfo(Symbol(),MODE_MINLOT)*/;

         LotSelectec = Kelly2;
        }
      if(Switch==Full_Kelly)//Full Kelly
        {
         double Kelly = WinNumberRate - ((LossNumberRate /(WinMoneyRate/LossMoneyRate)));
         if(Kelly > MaxLotDetect)
           {
            LotSelectec = MaxLotDetect;
           }
         if(Kelly < MinLotDetect)
           {
            LotSelectec = MinLotDetect;
           }
         //double Lots=MathCeil((AccountFreeMargin()*AccountLeverage()*Kelly*UsePip)/(Ask*MarketInfo(Symbol(),MODE_LOTSIZE)*MarketInfo(Symbol(),MODE_MINLOT)))*MarketInfo(Symbol(),MODE_MINLOT);
         LotSelectec = Kelly;
        }
      if(Switch==Optimal_F)//Optimal F
        {
         double Optimal_f=(((WinMoneyRate/LossMoneyRate) + 1)*WinNumberRate-1)/(WinMoneyRate/LossMoneyRate);
         if(Optimal_f > MaxLotDetect)
           {
            LotSelectec = MaxLotDetect;
           }
         if(Optimal_f < MinLotDetect)
           {
            LotSelectec = MinLotDetect;
           }
         //double Lots=MathCeil((AccountFreeMargin()*AccountLeverage()*Optimal_f*UsePip)/(Ask*MarketInfo(Symbol(),MODE_LOTSIZE)*MarketInfo(Symbol(),MODE_MINLOT)))*MarketInfo(Symbol(),MODE_MINLOT);
         LotSelectec = Optimal_f;
        }
      if(Switch==RvRoulet)//Reinversed
        {
         double RvRoulette=(0.47/WinNumberRate)*0.1;
         if(RvRoulette > MaxLotDetect)
           {
            LotSelectec = MaxLotDetect;
           }
         if(RvRoulette < MinLotDetect)
           {
            LotSelectec = MinLotDetect;
           }
         //double Lots=MathCeil((AccountFreeMargin()*AccountLeverage()*RvRoulette*UsePip)/(Ask*MarketInfo(Symbol(),MODE_LOTSIZE)*MarketInfo(Symbol(),MODE_MINLOT)))*MarketInfo(Symbol(),MODE_MINLOT);
         LotSelectec = RvRoulet;
        }
     }
   else
     {
      Print("Real Time WinRate not Available ", "EA_Executed_Trades: ",EA_Executed_Trades, " CountNumberWins: ", CountNumberWins, " CountProfitMoney: ",CountProfitMoney, " CountLossMoney: ", CountLossMoney, " CountProfitLots: ", CountProfitLots, " CountLossLots: ",CountLossLots);
      LotSelectec = MinLotDetect; // this will return 0.
     }
//////////////
   return LotSelectec;
  }
//+------------------------------------------------------------------+
// Return trade size based on risk per trade of stop loss in points
double GetTradeSize(string pSymbol, double pFixedVol, double pPercent, int pStopPoints)
  {
   double tradeSize;

   if(pPercent > 0 && pStopPoints > 0)
     {
      if(pPercent > 10)
        {
         pPercent = 10;
        }

      //double margin = AccountInfoDouble(ACCOUNT_BALANCE) * (pPercent / 100);
      //double tickSize = SymbolInfoDouble(pSymbol,SYMBOL_TRADE_TICK_VALUE);

      double Lots=MathCeil((AccountFreeMargin()*AccountLeverage()*(pPercent / 1000))/(Ask*MarketInfo(pSymbol,MODE_LOTSIZE)*MarketInfo(pSymbol,MODE_MINLOT)))*MarketInfo(pSymbol,MODE_MINLOT);
      if(Lots < MarketInfo(pSymbol,MODE_MINLOT))
        {
         Lots = MarketInfo(pSymbol,MODE_MINLOT);
        }
      if(Lots > MarketInfo(pSymbol,MODE_MAXLOT))
        {
         Lots = MarketInfo(pSymbol,MODE_MAXLOT)*0.25;
        }
      //tradeSize = (margin / pStopPoints) / tickSize;
      //tradeSize = CheckVolume(pSymbol,tradeSize);
      tradeSize = Lots;

      return(tradeSize);
     }
   else
     {
      //tradeSize = pFixedVol;
      tradeSize = CheckVolume(pSymbol,pFixedVol);

      return(tradeSize);
     }
  }
//+------------------------------------------------------------------+
void MoveToBreakEven()
  {
   double stopcrnt;
   double point_value = _Point*MarketInfo(_Symbol, MODE_TICKVALUE)/MarketInfo(_Symbol, MODE_TICKSIZE);

   for(int i=0; i < OrdersTotal() ; i++)
     {
      if(OrderSelect(i,SELECT_BY_POS, MODE_TRADES)== true)
        {
         if(OrderSymbol() == _Symbol && OrderMagicNumber() == MagicNumber)
           {
            if(OrderType() ==  OP_BUY)
              {
               stopcrnt = OrderStopLoss();
               if(stopcrnt==0 && (Ask > OrderOpenPrice() + KickToBreak * UsePip))
                 {
                  double BuyBreakEven = OrderOpenPrice() +((KickToBreak * UsePip)/5);

                  bool OrderBreakEven = OrderModify(OrderTicket(),OrderOpenPrice(),BuyBreakEven,OrderTakeProfit(),0,clrGreen);

                  if(OrderBreakEven)
                    {
                     CloseOrdersAndResetTrading();
                     BEActive = true;
                    }

                  if(!OrderBreakEven)
                     Print("Error in OrderModify. Error code=",GetLastError());
                 }
              }
            if(OrderType() ==  OP_SELL)
              {
               stopcrnt = OrderStopLoss();
               if(stopcrnt==0 && (Bid < OrderOpenPrice() - KickToBreak * UsePip))
                 {
                  double SellBreakEven = OrderOpenPrice() - ((KickToBreak * UsePip)/5);

                  bool OrderBreakEven = OrderModify(OrderTicket(),OrderOpenPrice(),SellBreakEven,OrderTakeProfit(),0,clrGreen);

                  if(OrderBreakEven)
                    {
                     CloseOrdersAndResetTrading();
                     BEActive = true;
                    }

                  if(!OrderBreakEven)
                     Print("Error in OrderModify. Error code=",GetLastError());
                 }
              }
           }
        }
     }
  }
//+------------------------------------------------------------------+
void MoveToTrailingStop()
  {
   for(int i=0; i < OrdersTotal(); i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if(OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber)
           {
            if(OrderType() ==  OP_BUY)
              {
               if(OrderStopLoss() > OrderOpenPrice())
                 {
                  if(OrderStopLoss() < Ask - KickToTrailStop*UsePip)
                    {
                     double BuyTrailing = Ask - KickToTrailStop*UsePip;
                     bool OrderToTrailingStop = OrderModify(OrderTicket(),OrderOpenPrice(),BuyTrailing, OrderTakeProfit(),0,clrYellow);
                     BEActive = true;
                     if(!OrderToTrailingStop)
                       {
                        Print("Error in OrderModify. Error code=",GetLastError());
                       }
                    }
                 }
              }
            if(OrderType() ==  OP_SELL)
              {
               if(OrderStopLoss() < OrderOpenPrice())
                 {
                  if(OrderStopLoss() > Bid + KickToTrailStop*UsePip)
                    {
                     double SellTrailing = Bid + KickToTrailStop*UsePip;
                     bool OrderToTrailingStop = OrderModify(OrderTicket(),OrderOpenPrice(),SellTrailing, OrderTakeProfit(),0,clrYellow);
                     BEActive = true;
                     if(!OrderToTrailingStop)
                       {
                        Print("Error in OrderModify. Error code=",GetLastError());
                       }
                    }
                 }
              }
           }
        }
     }
  }

//+------------------------------------------------------------------+
int ControlPosition()
  {
   int ControlCount=0;
   for(int Counter = 0; Counter <= OrdersTotal()-1; Counter++)
     {
      if(OrderSelect(Counter,SELECT_BY_POS))
        {
         if(OrderMagicNumber() == MagicNumber && OrderSymbol() == _Symbol && (OrderType() == OP_BUY || OrderType() == OP_SELL))
           {
            ControlCount++;
           }
        }
     }
   if(ControlCount < 2)
     {
      if(TraillingStop == YES && BreakEven == YES)
        {
         MoveToBreakEven();
         MoveToTrailingStop();
        }
      if(TraillingStop == NO && BreakEven == YES)
        {
         MoveToBreakEven();
        }
     }
   return(0);
  }
//+------------------------------------------------------------------+
void CreateProfitLine(double pDirection, double pPrice, double pPoints)
  {
   double profitLine = 0;
   double breakEvenLine = 0;
   if(pDirection == 1)
     {
      profitLine = NormalizeDouble(pPrice + pPoints, _Digits);
      breakEvenLine = NormalizeDouble(pPrice, _Digits);
     }
   else
      if(pDirection == -1)
        {
         profitLine = NormalizeDouble(pPrice - pPoints, _Digits);
         breakEvenLine = NormalizeDouble(pPrice, _Digits);
        }
   ObjectCreate(0, PROFIT_LINE, OBJ_HLINE, 0,0,profitLine);
   ObjectSetInteger(0, PROFIT_LINE, OBJPROP_COLOR, profitLineColor);
   ObjectSetInteger(0, PROFIT_LINE, OBJPROP_STYLE, STYLE_SOLID);
//ObjectCreate(1,PROFIT_BREAK_EVEN_LINE , OBJ_HLINE, 0,0,breakEvenLine);
//ObjectSetInteger(1, PROFIT_BREAK_EVEN_LINE, OBJPROP_COLOR, breakEventLineColor);
//ObjectSetInteger(1, PROFIT_BREAK_EVEN_LINE, OBJPROP_STYLE, STYLE_SOLID);
  }
//+------------------------------------------------------------------+
void DeleteProfitLine()
  {
   ObjectDelete(0, PROFIT_LINE);
  }
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//|          ======= SELECT ORDER OPEN =======                       |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
double GetTradeVolume()
  {
   double lots = 0;
   double volume = 0;
   double Multiplies;

   switch(LotMultiplier)
     {
      case  Increment1:
         Multiplies = 1.0;
      case  Increment15:
         Multiplies = 1.5;
      case  Increment20:
         Multiplies = 2.0;
      case  Increment25:
         Multiplies = 2.5;
      case  Increment30:
         Multiplies = 3.0;
      case  Increment35:
         Multiplies = 3.5;
      case  Increment40:
         Multiplies = 4.0;
      case  Increment45:
         Multiplies = 4.5;
      case  Increment50:
         Multiplies = 5.0;
      default:
         Multiplies = 2;
     }
   lots = (gLotSize*Multiplies); //increase the lot size
   volume = CheckVolume(_Symbol, lots);
   return volume;
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
int OpenPendingOrder(string pSymbol,int pType,double pVolume,double pPrice,double pStop,double pProfit,string pComment,datetime pExpiration,color pArrow)
  {
   int retryCount = 0;
   int ticket = 0;
   int errorCode = 0;
   int max_attempts = 5;

   string orderType;
   string errDesc;

// Order retry loop
   while(retryCount <= max_attempts)
     {
      while(IsTradeContextBusy())
        {
         Sleep(10);
        }
      ticket = OrderSend(pSymbol, pType, pVolume, pPrice, Slippage, pStop, pProfit, pComment, MagicNumber, pExpiration, pArrow);

      // Error handling
      if(ticket == -1)
        {
         errorCode = GetLastError();
         bool checkError = RetryOnError(errorCode);

         // Unrecoverable error
         if(checkError == false)
           {
            Alert("Open ",orderType," order: Error ",errorCode,".");
            Print("Symbol: ",pSymbol,", Volume: ",pVolume,", Price: ",pPrice,", SL: ",pStop,", TP: ",pProfit,", Expiration: ",pExpiration);
            break;
           }

         // Retry on error
         else
           {
            Print("Server error detected, retrying...");
            Sleep(3000);
            retryCount++;
           }
        }

      // Order successful
      else
        {
         Comment(orderType," order #",ticket," opened on ",_Symbol, "\n");
         Print(orderType," order #",ticket," opened on ",_Symbol);
         break;
        }
     }

// Failed after retry
   if(retryCount > max_attempts)
     {
      Alert("Open ",orderType," order: Max retries exceeded. Error ",errorCode," - ",errDesc);
      Print("Symbol: ",pSymbol,", Volume: ",pVolume,", Price: ",pPrice,", SL: ",pStop,", TP: ",pProfit,", Expiration: ",pExpiration);
     }

   return(ticket);
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
bool RetryOnError(int pErrorCode)
  {
// Retry on these error codes
   switch(pErrorCode)
     {
      case ERR_BROKER_BUSY:
      case ERR_COMMON_ERROR:
      case ERR_NO_ERROR:
      case ERR_NO_CONNECTION:
      case ERR_NO_RESULT:
      case ERR_SERVER_BUSY:
      case ERR_NOT_ENOUGH_RIGHTS:
      case ERR_MALFUNCTIONAL_TRADE:
      case ERR_TRADE_CONTEXT_BUSY:
      case ERR_TRADE_TIMEOUT:
      case ERR_REQUOTE:
      case ERR_TOO_MANY_REQUESTS:
      case ERR_OFF_QUOTES:
      case ERR_PRICE_CHANGED:
      case ERR_TOO_FREQUENT_REQUESTS:

         return(true);
     }

   return(false);
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
int OpenMarketOrder(string pSymbol, int pType, double pVolume, string pComment, color pArrow)
  {
   int retryCount = 0;
   int ticket = 0;
   int errorCode = 0;
   int max_attempts = 5;
   int wait_time = 3000;
   double StopOrderEnter = 0;
   double orderPrice = 0;
   double ProfitOrderEnter = TakeProfit*UsePip;

   string orderType;
   string errDesc;

// Order retry loop
   while(retryCount <= max_attempts)
     {
      while(IsTradeContextBusy())
        {
         Sleep(10);
        }

      // Place market order
      if(UseAveraging == NO)
        {
         if(pType == OP_BUY)
           {
            orderPrice = MarketInfo(pSymbol,MODE_ASK);
            ProfitOrderEnter = orderPrice + ProfitOrderEnter;
            switch(SelectTypeLoss)
              {
               case  0: //FIXED PIPs
                  StopOrderEnter = orderPrice - (StpLoss * UsePip);
                  ticket = OrderSend(pSymbol,pType,pVolume,orderPrice,Slippage,StopOrderEnter,ProfitOrderEnter,pComment,MagicNumber,0,pArrow);
                  break;
               case  1: //ATR
                  StopOrderEnter = orderPrice - ATRStopRange;
                  ticket = OrderSend(pSymbol,pType,pVolume,orderPrice,Slippage,StopOrderEnter,ProfitOrderEnter,pComment,MagicNumber,0,pArrow);
                  break;
               case  2: //SD (Standard deviation)
                  StopOrderEnter = orderPrice - SDStopRange;
                  ticket = OrderSend(pSymbol,pType,pVolume,orderPrice,Slippage,StopOrderEnter,ProfitOrderEnter,pComment,MagicNumber,0,pArrow);
                  break;
              }
           }
         else
            if(pType == OP_SELL)
              {
               orderPrice = MarketInfo(pSymbol,MODE_BID);
               ProfitOrderEnter = orderPrice - ProfitOrderEnter;
               switch(SelectTypeLoss)
                 {
                  case  0: //FIXED PIPs
                     StopOrderEnter = orderPrice + (StpLoss * UsePip);
                     ticket = OrderSend(pSymbol,pType,pVolume,orderPrice,Slippage,StopOrderEnter,ProfitOrderEnter,pComment,MagicNumber,0,pArrow);
                     break;
                  case  1: //ATR
                     StopOrderEnter = orderPrice + ATRStopRange;
                     ticket = OrderSend(pSymbol,pType,pVolume,orderPrice,Slippage,StopOrderEnter,ProfitOrderEnter,pComment,MagicNumber,0,pArrow);
                     break;
                  case  2: //SD (Standard deviation)R
                     StopOrderEnter = orderPrice + SDStopRange;
                     ticket = OrderSend(pSymbol,pType,pVolume,orderPrice,Slippage,StopOrderEnter,ProfitOrderEnter,pComment,MagicNumber,0,pArrow);
                     break;
                 }
              }
        }
      else
        {
         // Get current bid/ask price
         if(pType == OP_BUY)
           {
            orderPrice = MarketInfo(pSymbol,MODE_ASK);
            //ProfitOrderEnter = orderPrice + ProfitOrderEnter;
           }
         else
            if(pType == OP_SELL)
              {
               orderPrice = MarketInfo(pSymbol,MODE_BID);
               //ProfitOrderEnter = orderPrice - ProfitOrderEnter;
              }
         ticket = OrderSend(pSymbol,pType,pVolume,orderPrice,Slippage,0,0,pComment,MagicNumber,0,pArrow);
        }

      // Error handling
      if(ticket == -1)
        {
         errorCode = GetLastError();
         bool checkError = RetryOnError(errorCode);

         // Unrecoverable error
         if(checkError == false)
           {
            Alert("Open ",orderType," order: Error ",errorCode,".");
            Print("Symbol: ",pSymbol,", Volume: ",pVolume,", Price: ",orderPrice);
            break;
           }

         // Retry on error
         else
           {
            Print("Server error detected, retrying...");
            Sleep(wait_time);
            retryCount++;
           }
        }

      // Order successful
      else
        {
         Comment(orderType," order #",ticket," opened on ",pSymbol, "\n");
         Print(orderType," order #",ticket," opened on ",pSymbol);
         break;
        }
     }

// Failed after retry
   if(retryCount > max_attempts)
     {
      Alert("Open ",orderType," order: Max retries exceeded. Error ",errorCode," - ",errDesc);
      Print("Symbol: ",pSymbol,", Volume: ",pVolume,", Price: ",orderPrice);
     }

   return(ticket);
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|Check if Bar Closed                                               |
//+------------------------------------------------------------------+
bool IsBarClosed(int timeframeBar,bool reset)
  {
   static datetime lastbartime;
   if(timeframeBar==-1)
     {
      if(reset)
         lastbartime=0;
      else
         lastbartime=iTime(NULL,timeframeBar,0);
      return(true);
     }
   if(iTime(NULL,0,0)==lastbartime) // wait for new bar
      return(false);
   if(reset)
      lastbartime=iTime(NULL,timeframeBar,0);
   return(true);
  }

//+------------------------------------------------------------------+
//| Info creating  Panel                                             |
//+------------------------------------------------------------------+
void CreateTradePanel()
  {
   int Step = 28;
   if(DayOfWeek()==0 || DayOfWeek()==6)
     {
      info_set("m1",5,36,"ººº MUILTITRADE ººº",cl1,470);
      info_set("m2",5,64,"DAY NOT ALLOW TO OPEN TRADES",cl3,470);
     }
   else
     {
      info_set("m1",5,36,"ººº MUILTITRADE ººº",cl1,470);
      info_set("m2",5,64," ",cl3,470);
      info_set("m3",5,92," ",cl2,470);
      info_set("m4",5,120," ",cl2,470);
      info_set("m5",5,148," ",cl2,470);
      info_set("m6",5,176," ",cl2,470);
     }
  }
//+-------------------------------------------------------------------+
void UpdateTradePanel()
  {
   /*Comment("mGrid_mod_002\n",
           "FX Acc Server:",AccountServer(),"\n",
           "\n",
           "Date: ",Month(),"-",Day(),"-",Year()," Server Time: ",Hour(),":",Minute(),":",Seconds(),"\n",
           "\n",
           "Minimum Lot Sizing: ",MarketInfo(Symbol(),MODE_MINLOT),"\n",
           "\n",
           "Account Balance:  $",AccountBalance(),"\n",
           "\n",
           "Account Equity:  $",AccountEquity(),"\n",
           "\n",
           "Account Profit:  $",AccountProfit(),"\n",
           "\n",
           "Symbol: ", Symbol(),"\n",
           "\n",
           "Price:  ",NormalizeDouble(Bid,4),"\n",
           "\n",
           "Pip Spread:  ",MarketInfo("EURUSD",MODE_SPREAD),"\n",
           "\n",
           "Increment=" + Ask,"\n",
           "\n",
           "Lots:  ",Bid,"\n");*/

   ENUM_ACCOUNT_TRADE_MODE account_type=(ENUM_ACCOUNT_TRADE_MODE)AccountInfoInteger(ACCOUNT_TRADE_MODE);
   string Mode;
   switch(account_type)
     {
      case  ACCOUNT_TRADE_MODE_DEMO:
         Mode = "Demo Account";
         break;
      case  ACCOUNT_TRADE_MODE_CONTEST:
         Mode = "Contest Account";
         break;
      case  ACCOUNT_TRADE_MODE_REAL:
         Mode = "Real Accountt";
         break;
     }
//--- Stop Out is set in percentage or money
   ENUM_ACCOUNT_STOPOUT_MODE stop_out_mode=(ENUM_ACCOUNT_STOPOUT_MODE)AccountInfoInteger(ACCOUNT_MARGIN_SO_MODE);
//--- Get the value of the levels when Margin Call and Stop Out occur
   double margin_call=AccountInfoDouble(ACCOUNT_MARGIN_SO_CALL);
   double stop_out=AccountInfoDouble(ACCOUNT_MARGIN_SO_SO);

   if(DayOfWeek()==0 || DayOfWeek()==6)
     {
      ObjectSetText("data_m2","DAY NOT ALLOW OPEN",text_size,"Verdana",cl3);
     }
   else
     {
      ObjectSetText("data_m2","Client: "+AccountInfoString(ACCOUNT_NAME)+" | "+"Mode: "+Mode,text_size,"Verdana",cl3);
      ObjectSetText("data_m3"," Equity: "+DoubleToString(AccountEquity(),2)+" "+AccountCurrency()+" | "+"Balance: "+DoubleToString(AccountBalance(),2)+" "+AccountCurrency(),text_size,"Verdana",cl2);
      ObjectSetText("data_m4",Symbol()+" | "+"Spread: "+DoubleToString(MarketInfo(Symbol(),MODE_SPREAD),1)+" | "+"Bid: "+DoubleToString(Bid,Digits)+" | "+"Ask: "+DoubleToString(Ask,Digits),text_size,"Verdana",cl2);
      ObjectSetText("data_m5","Margin: "+DoubleToString(AccountMargin(),2)+" "+AccountCurrency()+" | "+"Free Margin: "+DoubleToString(AccountFreeMargin(),2)+" "+AccountCurrency(),text_size,"Verdana",cl2);
      ObjectSetText("data_m6","Gross Profit: "+DoubleToString(ProfitCurrent,2)+" "+AccountCurrency()+" | "+"Trading Cost: "+DoubleToString(CostTrade,2)+" "+AccountCurrency(),text_size,"Verdana",cl2);
     }
  }
//+------------------------------------------------------------------+
void info_set(string nam,int x_distv,int y_distv,string textsd,color font_color,int longs=150,int wind=30)
  {
   string namef="data_"+nam;
   ObjectDelete(0,namef);
   ObjectCreate(0,namef,OBJ_BUTTON,0,0,0);
   ObjectSetString(0,namef,OBJPROP_TEXT,textsd);
   ObjectSetInteger(0,namef,OBJPROP_FONTSIZE,text_size);
   ObjectSetInteger(0,namef,OBJPROP_XDISTANCE,x_distv);
   ObjectSetInteger(0,namef,OBJPROP_YDISTANCE,y_distv);
   ObjectSetInteger(0,namef,OBJPROP_XSIZE,longs);
   ObjectSetInteger(0,namef,OBJPROP_YSIZE,wind);
   ObjectSetInteger(0,namef,OBJPROP_CORNER,0);
   ObjectSetInteger(0,namef,OBJPROP_COLOR,font_color);
   ObjectSetInteger(0,namef,OBJPROP_BGCOLOR,cl_back);
   ObjectSetInteger(0,namef,OBJPROP_BORDER_COLOR,cl_back);
   ObjectSetInteger(0,namef,OBJPROP_HIDDEN,true);
  }
//+------------------------------------------------------------------+
void DeleteTradePanel()
  {
   ObjectsDeleteAll(0,OBJ_RECTANGLE);
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|       "======= TRADING SYSTEM STRATEGY ======= "                 |
//+------------------------------------------------------------------+
int TradingSystem(int shift, int System, int TradeDirection)
  {
   int direction = 0;
   /*switch(MaFactor)
     {
      case  A:
         MAShort   = 5;
         MALong    = 25;
         break;
      case  B:
         MAShort   = 10;
         MALong    = 50;
         break;
      case  C:
         MAShort   = 15;
         MALong    = 75;
         break;
      case  D:
         MAShort   = 20;
         MALong    = 100;
         break;
      case  E:
         MAShort   = 25;
         MALong    = 125;
         break;
      case  F:
         MAShort   = 50;
         MALong    = 250;
         break;
      case  F:
         MAShort   = 75;
         MALong    = 375;
         break;
      case  H:
         MAShort   = 100;
         MALong    = 500;
         break;
      case  I:
         MAShort   = 100;
         MALong    = 175;
         break;
      case  J:
         MAShort   = 100;
         MALong    = 175;
         break;
      default:
         MAShort   = 15;
         MALong    = 75;
         break;
     }*/

   bool isOrderOpen=false;
   for(int i=OrdersTotal()-1; i>=0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS))
        {
         if(OrderMagicNumber()==MagicNumber && OrderSymbol()==Symbol())
           {
            isOrderOpen=true;
           }
        }
     }
   if(!isOrderOpen)
     {
      switch(System)
        {
         case  0:
            direction = SpecialOne(shift, System, TradeDirection);
            break;
         case  1:
            direction = RSI(shift, System, TradeDirection);
            break;
         case  2:
            direction = RSI(shift, System, TradeDirection);
            break;
         case  3:
            direction = ADX(shift, TradeDirection);
            break;
         case  4:
            direction = MACD(shift, TradeDirection);
            break;
         case  5:
            direction = Stochastic(shift, TradeDirection);
            break;
         case  6:
            direction = Sar(shift, TradeDirection);
            break;
         case  7:
            direction = BBand(shift, System, TradeDirection);
            break;
         case  8:
            direction = BBand(shift, System, TradeDirection);
            break;
         case  9:
            direction = BullBear(shift, System, TradeDirection);
            break;
         case  10:
            direction = BullBear(shift, System, TradeDirection);
            break;
         case  11:
            direction = AO(shift, System, TradeDirection);
            break;
         case  12:
            direction = AO(shift, System, TradeDirection);
            break;
         case  13:
            direction = RVIMFI(shift, System, TradeDirection);
            break;
         case  14:
            direction = RVIMFI(shift, System, TradeDirection);
            break;
         case  15:
            direction = WPRMFI(shift, System, TradeDirection);
            break;
         case  16:
            direction = WPRMFI(shift, System, TradeDirection);
            break;
         case  17:
            direction = ADXBREAKOUT(shift, TradeDirection);
            break;
         case  18:
            direction = MACONTRARIAN(shift, TradeDirection);
            break;
         case  19:
            direction = PERCENTILEADX(shift, TradeDirection);
            break;
         case  20:
            direction = SpecialOne(shift, System, TradeDirection);
            break;
         case  21:
            direction = ReturnExtreme(shift, System, TradeDirection);
            break;
         case  22:
            direction = ReturnExtreme(shift, System, TradeDirection);
            break;
         case  23:
            direction = ReturnExtreme(shift, System, TradeDirection);
            break;
         case  24:
            direction = MOMENTUM(shift, TradeDirection);
            break;
        }
     }
   return direction;

  }
//+------------------------------------------------------------------+
int SpecialOne(int shift, int Special, int direction)
  {
   int Condition     = 0;
   int OverBought    = 70;
   int OverSold      = 30;
   int RsiPeriod     = 14;
   int BandPeriod    = 20;
   int BandDV3       = 3;
   int UpMode        = 1;
   int DwMode        = 2;
   HideTestIndicators(true);
   double rsi0    = iRSI(_Symbol, 0, RsiPeriod, PRICE_CLOSE, shift);
   double rsi1    = iRSI(_Symbol, 0, RsiPeriod, PRICE_CLOSE, shift+1);
   double UpBand0 = iBands(_Symbol,0,BandPeriod,BandDV3,0,0,UpMode,shift);
   double DwBand0 = iBands(_Symbol,0,BandPeriod,BandDV3,0,0,DwMode,shift);
   double UpBand1 = iBands(_Symbol,0,BandPeriod,BandDV3,0,0,UpMode,shift+1);
   double DwBand1 = iBands(_Symbol,0,BandPeriod,BandDV3,0,0,DwMode,shift+1);
   double Close0  = iClose(_Symbol,0,shift);
   double Open0   = iOpen(_Symbol,0,shift);
   double High0   = iHigh(_Symbol,0,shift);
   double Low0    = iLow(_Symbol,0,shift);
   double Close1  = iClose(_Symbol,0,shift+1);
   double Open1   = iOpen(_Symbol,0,shift+1);
   double High1   = iHigh(_Symbol,0,shift+1);
   double Low1    = iLow(_Symbol,0,shift+1);
   HideTestIndicators(false);

   if(Special == 0)
     {
      if((rsi0 <= OverSold) &&  Low1 < DwBand1 && Close0 > DwBand0 && (direction==0 || direction==2))
        {
         Condition = 1;
        }
      else
         if((rsi0 >= OverBought) &&  High1 > UpBand1 && Close0 < UpBand0 && (direction==1 || direction==2))
           {
            Condition = -1;
           }
     }
   if(Special == 20)
     {
      if((rsi0 <= OverSold) && Close1  < DwBand1 && Close0 > DwBand0 && (direction==0 || direction==2))
        {
         Condition = 1;
        }
      else
         if((rsi0 >= OverBought) && Close1  > UpBand1 && Close0 < UpBand0 && (direction==1 || direction==2))
           {
            Condition = -1;
           }
     }

   return Condition;
  }
//+------------------------------------------------------------------+
int RSI(int shift, int Special,int direction)
  {
   int Condition = 0;
   if(Special == 1)
     {
      HideTestIndicators(true);
      double rsi0 = iRSI(_Symbol, 0, 14, PRICE_CLOSE, shift);
      double rsi1 = iRSI(_Symbol, 0, 14, PRICE_CLOSE, shift+1);
      HideTestIndicators(false);

      int OverBought = 70;
      int OverSold   = 30;

      if(rsi0 < rsi1 && (rsi0 < OverSold && rsi1 > OverSold) && (direction==0 || direction==2))
        {
         Condition = 1;
         return Condition;
        }
      else
         if(rsi0 > rsi1 && (rsi0 > OverBought && rsi1 < OverBought) && (direction==1 || direction==2))
           {
            Condition = -1;
            return Condition;
           }
     }
   if(Special == 2)
     {
      HideTestIndicators(true);
      double rsi0 = iRSI(_Symbol, 0, 8, PRICE_CLOSE, shift);
      double rsi1 = iRSI(_Symbol, 0, 8, PRICE_CLOSE, shift+1);
      HideTestIndicators(false);

      int OverBought = 80;
      int OverSold   = 20;

      if(rsi0 < rsi1 && (rsi0 < OverSold && rsi1 > OverSold) && (direction==0 || direction==2))
        {
         Condition = 1;
        }
      else
         if(rsi0 > rsi1 && (rsi0 > OverBought && rsi1 < OverBought) && (direction==1 || direction==2))
           {
            Condition = -1;
           }
     }

   return Condition;
  }
//+------------------------------------------------------------------+
int ADX(int shift,int direction)
  {
   int Condition = 0;
   HideTestIndicators(true);
   double ADX0 = iADX(Symbol(),PERIOD_CURRENT,14,0,0,shift);
   double ADX1 = iADX(Symbol(),PERIOD_CURRENT,14,0,0,shift+1);
   double PlusDi0 = iADX(Symbol(),PERIOD_CURRENT,14,0,1,shift);
   double PlusDi1 = iADX(Symbol(),PERIOD_CURRENT,14,0,1,shift+1);
   double MinusDi0 = iADX(Symbol(),PERIOD_CURRENT,14,0,2,shift);
   double MinusDi1 = iADX(Symbol(),PERIOD_CURRENT,14,0,2,shift+1);
   HideTestIndicators(false);

   if((ADX0 > 25 && ADX1 < 25) && PlusDi0 > MinusDi0 && (direction==0 || direction==2))
     {
      Condition = 1;
     }
   if((ADX0 > 25 && ADX1 < 25) && MinusDi0 > PlusDi0 && (direction==1 || direction==2))
     {
      Condition = -1;
     }
   return Condition;
  }

//+------------------------------------------------------------------+
int MACD(int shift,int direction)
  {
   int Condition = 0;
   HideTestIndicators(true);
   double MacdCurrent         = iMACD(NULL,0,12,26,9,PRICE_CLOSE,MODE_MAIN,shift);
   double MacdPrevious        = iMACD(NULL,0,12,26,9,PRICE_CLOSE,MODE_MAIN,shift+1);
   double SignalCurrent       = iMACD(NULL,0,12,26,9,PRICE_CLOSE,MODE_SIGNAL,shift);
   double SignalPrevious      = iMACD(NULL,0,12,26,9,PRICE_CLOSE,MODE_SIGNAL,shift+1);
   double MaCurrent           = iMA(NULL,0,200,0,MODE_EMA,PRICE_CLOSE,shift);
   double MaPrevious          = iMA(NULL,0,200,0,MODE_EMA,PRICE_CLOSE,shift+1);
   double Open0               = iOpen(_Symbol,0,0);
   HideTestIndicators(false);

   if(MacdCurrent<0 && MacdCurrent>SignalCurrent && MacdPrevious<SignalPrevious &&
      MathAbs(MacdCurrent)>(3*Point) && (direction==0 || direction==2) && Open0 > MaCurrent && MaCurrent>MaPrevious)
     {
      Condition = 1;
     }

   if(MacdCurrent>0 && MacdCurrent<SignalCurrent && MacdPrevious>SignalPrevious &&
      MacdCurrent>(3*Point) && (direction==1 || direction==2) && Open0 < MaCurrent && MaCurrent<MaPrevious)
     {
      Condition = -1;
     }
   return Condition;

  }
//+------------------------------------------------------------------+
int Stochastic(int shift, int direction)
  {
   int Condition = 0;
   int OverBought = 80;
   int OverSold   = 20;
   HideTestIndicators(true);
   double Stoch0        = iStochastic(_Symbol,0,5,3,3,0,0,0,shift);
   double Stoch1        = iStochastic(_Symbol,0,5,3,3,0,0,0,shift+1);
   double StochSignal0  = iStochastic(_Symbol,0,5,3,3,0,0,1,shift);
   double StochSignal1  = iStochastic(_Symbol,0,5,3,3,0,0,1,shift+1);
   HideTestIndicators(false);
   if((Stoch0 > Stoch1 && Stoch0 > StochSignal0 && Stoch1 < StochSignal1) && (Stoch0 < OverSold) && (direction==0 || direction==2))
     {
      Condition = 1;
     }
   if((Stoch0 < Stoch1 && Stoch0 < StochSignal0 && Stoch1 > StochSignal1) && (Stoch0 > OverBought) && (direction==1 || direction==2))
     {
      Condition = -1;
     }

   return Condition;
  }
//+------------------------------------------------------------------+
int Sar(int shift, int direction)
  {
   int Condition = 0;

   double SAR_STEP = 0.02;
   double SAR_MAX = 0.2;
   HideTestIndicators(true);
   double Sar0    = iSAR(_Symbol,0,SAR_STEP,SAR_MAX,shift);
   double Sar1    = iSAR(_Symbol,0,SAR_STEP,SAR_MAX,shift+1);
   double Open1   = iOpen(_Symbol,0,shift);
   HideTestIndicators(false);

   if(Sar1 > Sar0 && Sar0 < Open1 && (direction==0 || direction==2))
     {
      Condition = 1;
     }
   if(Sar1 < Sar0 && Sar0 > Open1 && (direction==1 || direction==2))
     {
      Condition = -1;
     }
   return Condition;
  }
//+------------------------------------------------------------------+
int BBand(int shift, int Special,int direction)
  {
   int Condition     = 0;
   int BandPeriod    = 20;
   int BandDV2       = 2;
   int BandDV3       = 3;
   int UpMode        = 1;
   int DwMode        = 2;
   double Close0  = iClose(_Symbol,0,shift);
   double High0   = iHigh(_Symbol,0,shift);
   double Low0    = iLow(_Symbol,0,shift);
   double Close1  = iClose(_Symbol,0,shift+1);
   double High1   = iHigh(_Symbol,0,shift+1);
   double Low1    = iLow(_Symbol,0,shift+1);

   if(Special == 7)
     {
      HideTestIndicators(true);
      double UpBand0 = iBands(_Symbol,0,BandPeriod,BandDV2,0,0,UpMode,shift);
      double DwBand0 = iBands(_Symbol,0,BandPeriod,BandDV2,0,0,DwMode,shift);
      double UpBand1 = iBands(_Symbol,0,BandPeriod,BandDV2,0,0,UpMode,shift+1);
      double DwBand1 = iBands(_Symbol,0,BandPeriod,BandDV2,0,0,DwMode,shift+1);
      HideTestIndicators(false);

      if(Close1 < DwBand1 && Close0 < DwBand0 && (direction==0 || direction==2))
        {
         Condition = 1;
         return Condition;
        }
      else
         if(Close1 > UpBand1 && Close0 < UpBand0 && (direction==1 || direction==2))
           {
            Condition = -1;
            return Condition;
           }
     }
   if(Special == 8)
     {
      HideTestIndicators(true);
      double UpBand0 = iBands(_Symbol,0,BandPeriod,BandDV3,0,0,UpMode,shift);
      double DwBand0 = iBands(_Symbol,0,BandPeriod,BandDV3,0,0,DwMode,shift);
      double UpBand1 = iBands(_Symbol,0,BandPeriod,BandDV3,0,0,UpMode,shift+1);
      double DwBand1 = iBands(_Symbol,0,BandPeriod,BandDV3,0,0,DwMode,shift+1);
      HideTestIndicators(false);

      if(Close1 < DwBand1 && Close0 > DwBand0  && (direction==0 || direction==2))
        {
         Condition = 1;
        }
      else
         if(Close1 > UpBand1 && Close0 < UpBand0 && (direction==1 || direction==2))
           {
            Condition = -1;
           }
     }

   return Condition;
  }
//+------------------------------------------------------------------+
int BullBear(int shift, int Special, int direction)
  {
   int Condition = 0;
   double High0   = iHigh(_Symbol,0,shift);
   double Low0    = iLow(_Symbol,0,shift);
   double High1   = iHigh(_Symbol,0,shift+1);
   double Low1    = iLow(_Symbol,0,shift+1);
   double High2   = iHigh(_Symbol,0,shift+2);
   double Low2    = iLow(_Symbol,0,shift+2);
   double High3   = iHigh(_Symbol,0,shift+3);
   double Low3    = iLow(_Symbol,0,shift+3);

   HideTestIndicators(true);
   double Bull0    = iBullsPower(_Symbol,0,13,PRICE_CLOSE,shift);
   double Bull1    = iBullsPower(_Symbol,0,13,PRICE_CLOSE,shift+1);
   double Bull2    = iBullsPower(_Symbol,0,13,PRICE_CLOSE,shift+2);
   double Bull3    = iBullsPower(_Symbol,0,13,PRICE_CLOSE,shift+3);
   double Bear0    = iBearsPower(_Symbol,0,13,PRICE_CLOSE,shift);
   double Bear1    = iBearsPower(_Symbol,0,13,PRICE_CLOSE,shift+1);
   double Bear2    = iBearsPower(_Symbol,0,13,PRICE_CLOSE,shift+2);
   double Bear3    = iBearsPower(_Symbol,0,13,PRICE_CLOSE,shift+3);
   HideTestIndicators(false);

   if(Special == 9)
     {
      if(Bear0 > Bear1 && Bear1 > Bear2 && Bear2 < Bear3 && Bear0 < 0 && Bear1 < 0 && Bear2 < 0 && Bear3 < 0 && (direction==0 || direction==2))
        {
         Condition = 1;
        }
      if(Bull0 < Bull1 && Bull1 < Bull2 && Bull2 > Bull3 && Bull0 > 0 && Bull1 > 0 && Bull2 > 0 && Bull3 > 0 && (direction==1 || direction==2))
        {
         Condition = -1;
        }
     }
   if(Special == 10)
     {
      if(Bear0 > Bear1 && Bear1 > Bear2 && Bear2 < Bear3 && Bear0 < 0 && Bear1 < 0 && Bear2 < 0 && Bear3 < 0 && (direction==0 || direction==2))
        {
         if(Low1 < Low3 || Low2 < Low3)
           {
            Condition = 1;
           }
        }
      if(Bull0 < Bull1 && Bull1 < Bull2 && Bull2 > Bull3 && Bull0 > 0 && Bull1 > 0 && Bull2 > 0 && Bull3 > 0 && (direction==1 || direction==2))
        {
         if(High1 > High3 || High2 > High3)
           {
            Condition = -1;
           }
        }
     }
   return Condition;
  }
//+------------------------------------------------------------------+
int AO(int shift, int Special, int direction)
  {
   int Condition  = 0;
   double High0   = iHigh(_Symbol,0,shift);
   double Low0    = iLow(_Symbol,0,shift);
   double High1   = iHigh(_Symbol,0,shift+1);
   double Low1    = iLow(_Symbol,0,shift+1);
   double High2   = iHigh(_Symbol,0,shift+2);
   double Low2    = iLow(_Symbol,0,shift+2);
   double High3   = iHigh(_Symbol,0,shift+3);
   double Low3    = iLow(_Symbol,0,shift+3);
   double Close0  = iClose(_Symbol,0,shift);

   HideTestIndicators(true);
   double Ma200    = iMA(_Symbol,0,200,0,MODE_EMA,PRICE_CLOSE,shift);
   double AO0      = iAO(_Symbol,0,shift);
   double AO1      = iAO(_Symbol,0,shift+1);
   double AO2      = iAO(_Symbol,0,shift+2);
   double AO3      = iAO(_Symbol,0,shift+3);
   double AO4      = iAO(_Symbol,0,shift+4);
   double AO5      = iAO(_Symbol,0,shift+5);
   double AO6      = iAO(_Symbol,0,shift+6);
   HideTestIndicators(false);

   if(Special == 11)
     {
      if(AO0 > 0 && AO1 < 0 && Close0 > Ma200 && (direction==0 || direction==2))
        {
         Condition = 1;
        }
      if(AO0 < 0 && AO1 > 0 && Close0 < Ma200 && (direction==1 || direction==2))
        {
         Condition = -1;
        }
     }

   if(Special == 12)
     {
      if(AO0 < 0 && AO0 > AO1 && AO1 > AO2 && AO2 > AO3 && AO3 < AO4 && AO4 < AO5 && AO5 < AO6 && AO6 < 0 && Low3 > Low0 && (direction==0 || direction==2))
        {
         Condition = 1;
        }
      if(AO0 > 0 && AO0 < AO1 && AO1 < AO2 && AO2 < AO3 && AO3 > AO4 && AO4 > AO5 && AO5 > AO6 && AO6 > 0 && High3 < High0 && (direction==1 || direction==2))
        {
         Condition = -1;
        }
     }
   return Condition;
  }
//+------------------------------------------------------------------+
int RVIMFI(int shift, int Special, int direction)
  {
   int Condition  = 0;

   HideTestIndicators(true);
   double MFI0          = iMFI(_Symbol,0,14,shift);
   double MFI1          = iMFI(_Symbol,0,14,shift+1);
   double MFI2          = iMFI(_Symbol,0,14,shift+2);
   double MFI3          = iMFI(_Symbol,0,14,shift+3);
   double RVIMain0      = iRVI(_Symbol,0,10,0,shift);
   double RVIMain1      = iRVI(_Symbol,0,10,0,shift+1);
   double RVIMain2      = iRVI(_Symbol,0,10,0,shift+2);
   double RVIMain3      = iRVI(_Symbol,0,10,0,shift+3);
   double RVISignal0    = iRVI(_Symbol,0,10,1,shift);
   double RVISignal1    = iRVI(_Symbol,0,10,1,shift+1);
   double RVISignal2    = iRVI(_Symbol,0,10,1,shift+2);
   double RVISignal3    = iRVI(_Symbol,0,10,1,shift+3);
   HideTestIndicators(false);

   if(Special == 13)
     {
      if(((MFI0 < 20 && RVIMain0 < 50 && RVIMain0 > RVISignal0 && RVIMain1 < RVISignal1) || (MFI1 < 20 && RVIMain1 < 50 && RVIMain1 > RVISignal1 && RVIMain2 < RVISignal2))&& (direction==0 || direction==2))
        {
         Condition = 1;
        }

      if(((MFI0 > 80 && RVIMain0 > 50 && RVIMain0 < RVISignal0 && RVIMain1 > RVISignal1) || (MFI1 > 80 && RVIMain1 > 50 && RVIMain1 < RVISignal1 && RVIMain2 > RVISignal2))&& (direction==1 || direction==2))
        {
         Condition = -1;
        }
     }

   if(Special == 14)
     {
      if((direction==0 || direction==2))
        {
         if((MFI0 < 20 || MFI1 < 20 || MFI2 < 20 || MFI3 < 20) && (RVIMain0 < 50 || RVIMain1 < 50 || RVIMain2 < 50 || RVIMain3 < 50))
           {
            if((RVIMain0 > RVISignal0 || RVIMain1 > RVISignal1 || RVIMain2 > RVISignal2 || RVIMain3 > RVISignal3))
              {
               if((RVIMain1 < RVISignal1 || RVIMain2 < RVISignal2 || RVIMain3 < RVISignal3))
                 {
                  Condition = 1;
                 }
              }
           }
        }
      if((direction==1 || direction==2))
        {
         if((MFI0 > 80 || MFI1 > 80 || MFI2 > 80 || MFI3 > 80) && (RVIMain0 > 50 || RVIMain1 > 50 || RVIMain2 > 50 || RVIMain3 > 50))
           {
            if((RVIMain0 < RVISignal0 || RVIMain1 < RVISignal1 || RVIMain2 < RVISignal2 || RVIMain3 < RVISignal3))
              {
               if((RVIMain1 > RVISignal1 || RVIMain2 > RVISignal2 || RVIMain3 > RVISignal3))
                 {
                  Condition = -1;
                 }
              }
           }
        }
     }
   return Condition;
  }
//+------------------------------------------------------------------+
int WPRMFI(int shift, int Special, int direction)
  {
   int Condition  = 0;

   HideTestIndicators(true);
   double MFI0          = iMFI(_Symbol,0,14,shift);
   double MFI1          = iMFI(_Symbol,0,14,shift+1);
   double MFI2          = iMFI(_Symbol,0,14,shift+2);
   double MFI3          = iMFI(_Symbol,0,14,shift+3);
   double WPR0          = iWPR(_Symbol,0,14,shift);
   double WPR1          = iWPR(_Symbol,0,14,shift+1);
   double WPR2          = iWPR(_Symbol,0,14,shift+2);
   double WPR3          = iWPR(_Symbol,0,14,shift+3);
   HideTestIndicators(false);

   if(Special == 15)
     {
      if(((MFI0 < 20 && WPR0 < -80 && WPR0 > WPR1))&& (direction==0 || direction==2))
        {
         Condition = 1;
        }

      if(((MFI0 > 80 && WPR0 > -20 && WPR0 < WPR1))&& (direction==1 || direction==2))
        {
         Condition = -1;
        }
     }

   if(Special == 16)
     {
      if((direction==0 || direction==2))
        {
         if((MFI0 < 20 || MFI1 < 20 || MFI2 < 20 || MFI3 < 20) && (WPR0 < -80 || WPR1 < -80 || WPR2 < -80 || WPR3 < -80))
           {
            if(WPR0 > WPR1 || WPR1 > WPR2 || WPR2 > WPR3)
              {
               Condition = 1;
              }
           }
        }

      if((direction==1 || direction==2))
        {
         if((MFI0 > 80 || MFI1 > 80 || MFI2 > 80 || MFI3 > 80) && (WPR0 > -20 || WPR1 > -20 || WPR2 > -20 || WPR3 > -20))
           {
            if(WPR0 < WPR1 || WPR1 < WPR2 || WPR2 < WPR3)
              {
               Condition = -1;
              }
           }
        }
     }
   return Condition;
  }
//+------------------------------------------------------------------+
int ADXBREAKOUT(int shift, int direction) // TODO Antender PQ não dispara Ordem
  {
   int Condition  = 0;
   int LookBackPeriod = 20;
   double High0,Low0,ADX0,ADX1,PlusDi0,PlusDi1,MinusDi0, MinusDi1;
   int HighSelect,LowSelect;


   HideTestIndicators(true);
   HighSelect         = ArrayMaximum(High, LookBackPeriod, shift+1);//HighesBuffer[i];
   LowSelect          = ArrayMinimum(Low,LookBackPeriod, shift+1);//LowesBuffer[i];

   High0         = iHigh(_Symbol,0,shift);
   Low0          = iLow(_Symbol,0,shift);

   ADX0          = iADX(_Symbol,PERIOD_CURRENT,15,0,0,shift);
   ADX1          = iADX(_Symbol,PERIOD_CURRENT,15,0,0,shift+1);
   PlusDi0       = iADX(_Symbol,PERIOD_CURRENT,15,0,1,shift);
   PlusDi1       = iADX(_Symbol,PERIOD_CURRENT,15,0,1,shift+1);
   MinusDi0      = iADX(_Symbol,PERIOD_CURRENT,15,0,2,shift);
   MinusDi1      = iADX(_Symbol,PERIOD_CURRENT,15,0,2,shift+1);
   HideTestIndicators(false);

   if((ADX0 < 20 && ADX1 < 20) && High0 > High[HighSelect]  && (direction==0 || direction==2))
     {
      Condition = 1;
     }

   if((ADX0 < 20 && ADX1 < 20) && Low0 < Low[LowSelect] && (direction==1 || direction==2))
     {
      Condition = -1;
     }
   return Condition;
  }
//+------------------------------------------------------------------+
int MACONTRARIAN(int shift, int direction)
  {
   int Condition  = 0;
   int LongMA     = 180;//Implementar Factor
   int ShortMA    = 5;//Implementar Factor
   HideTestIndicators(true);
   double MAHIGHLong0        = iMA(_Symbol,0,LongMA,0,0,2,shift);
   double MAHIGHLong1        = iMA(_Symbol,0,LongMA,0,0,2,shift+1);
   double MALOWLong0         = iMA(_Symbol,0,LongMA,0,0,3,shift);
   double MALOWLong1         = iMA(_Symbol,0,LongMA,0,0,3,shift+1);

   double MAHIGHShort0       = iMA(_Symbol,0,ShortMA,0,0,2,shift);
   double MAHIGHShort1       = iMA(_Symbol,0,ShortMA,0,0,2,shift+1);
   double MALOWShort0        = iMA(_Symbol,0,ShortMA,0,0,3,shift);
   double MALOWShort1        = iMA(_Symbol,0,ShortMA,0,0,3,shift+1);

   double High0              = iHigh(_Symbol,0,shift);
   double Low0               = iLow(_Symbol,0,shift);
   HideTestIndicators(false);

   if(High0 <  MALOWShort0 && (MALOWShort1 > MALOWLong1 && MALOWShort0 <  MALOWLong0) &&(direction==0 || direction==2))
     {
      Condition = 1;
     }

   if(Low0 >  MAHIGHShort0 && (MAHIGHShort1 < MAHIGHLong1 && MAHIGHShort0 > MAHIGHLong0)&& (direction==1 || direction==2))
     {
      Condition = -1;
     }

   return Condition;
  }
//+------------------------------------------------------------------+
int PERCENTILEADX(int shift, int direction) //TODO Resolver problema do array manter o mesmo valor para 0.25 e 0.75
  {
   int bars = iBars(_Symbol,0);
   int Condition  = 0;
   if(bars > barsTotal)
     {
      barsTotal = bars;
      double ArrayClose[];
      double copy[];
      int size = 200;//Implementar Factor

      ArrayResize(copy,size);
      ArraySetAsSeries(ArrayClose,false);
      ArrayResize(ArrayClose,size);
      ArraySetAsSeries(ArrayClose,true);

      if(!IsBarClosed(0,true))
        {
         Condition = 0;
        }
      else
        {
         for(int i=0; i< size; i++)
           {
            ArrayClose[i] = Close[i];
           }

         ArrayCopy(copy,ArrayClose,0,0,WHOLE_ARRAY);
         ArraySort(copy,WHOLE_ARRAY,0,MODE_ASCEND);

         double Valu25 = (25/100)*size+0.5;
         double Valu75 = (75/100)*size+0.5;
         int Index25 = MathRound(Valu25);
         int Index75 = MathRound(Valu75);

         //double percentile25 = NormalizeDouble(copy[Index25-1],Digits);
         //double percentile75 = NormalizeDouble(copy[Index75-1],Digits);
         double percentile25 = NormalizeDouble(Close[Index25-1],Digits);
         double percentile75 = NormalizeDouble(Close[Index75-1],Digits);

         HideTestIndicators(true);
         double High0         = iHigh(_Symbol,0,shift);
         double Low0          = iLow(_Symbol,0,shift);
         double Close0        = iClose(_Symbol,0,shift);
         double ADX0          = iADX(Symbol(),PERIOD_CURRENT,15,0,0,shift);
         double ADX1          = iADX(Symbol(),PERIOD_CURRENT,15,0,0,shift+1);
         double PlusDi0       = iADX(Symbol(),PERIOD_CURRENT,15,0,1,shift);
         double PlusDi1       = iADX(Symbol(),PERIOD_CURRENT,15,0,1,shift+1);
         double MinusDi0      = iADX(Symbol(),PERIOD_CURRENT,15,0,2,shift);
         double MinusDi1      = iADX(Symbol(),PERIOD_CURRENT,15,0,2,shift+1);
         HideTestIndicators(false);

         if(ADX0 <  30 && ADX0 > 20 && ADX0 > ADX1 && Close0 > percentile75 && (direction==0 || direction==2))
           {
            Condition = 1;
            Print("Close0 ", Close0, " percentile75 ", percentile75, " percentile25 ", percentile25, " ADX0 ", ADX0);
           }

         if(ADX0 <  30 && ADX0 > 20 && ADX0 > ADX1 && Close0 < percentile25 && (direction==1 || direction==2))
           {
            Condition = -1;
            Print("Close0 ", Close0, " percentile25 ", percentile25, " ADX0 ", ADX0);
           }
        }
     }
   return Condition;
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
int ReturnExtreme(int shift, int Special, int direction)
  {
   int Condition     = 0;
   int OverBought    = 70;
   int OverSold      = 30;
   int RsiPeriod     = 14;
   int BandPeriod    = 20;
   int BandDV3       = 3;
   int AppHigh       = 2;
   int AppLow        = 3;
   int UpMode        = 1;
   int DwMode        = 2;
   int PeriodHL      = 20;
   HideTestIndicators(true);
   double rsi0    = iRSI(_Symbol, 0, RsiPeriod, PRICE_CLOSE, shift);
   double rsi1    = iRSI(_Symbol, 0, RsiPeriod, PRICE_CLOSE, shift+1);
   double UpBand0 = iBands(_Symbol,0,BandPeriod,BandDV3,0,AppHigh,UpMode,shift);
   double UpBand1 = iBands(_Symbol,0,BandPeriod,BandDV3,0,AppHigh,UpMode,shift+1);
   double DwBand0 = iBands(_Symbol,0,BandPeriod,BandDV3,0,AppLow,DwMode,shift);
   double DwBand1 = iBands(_Symbol,0,BandPeriod,BandDV3,0,AppLow,DwMode,shift+1);

   int HighRange        = iHighest(_Symbol,0,MODE_HIGH,PeriodHL,shift);
   double HighSelect    = iHigh(Symbol(),Period(),HighRange);

   int LowRange         = iLowest(_Symbol,0,MODE_LOW,PeriodHL,shift);
   double LowSelect     = iLow(Symbol(),Period(),LowRange);

   double Close0  = iClose(_Symbol,0,shift);
   double Open0   = iOpen(_Symbol,0,shift);
   double High0   = iHigh(_Symbol,0,shift);
   double Low0    = iLow(_Symbol,0,shift);
   double Close1  = iClose(_Symbol,0,shift+1);
   double Open1   = iOpen(_Symbol,0,shift+1);
   double High1   = iHigh(_Symbol,0,shift+1);
   double Low1    = iLow(_Symbol,0,shift+1);
   HideTestIndicators(false);

   if(Special == 21)
     {
      if((rsi0 <= OverSold) && Low1  < DwBand1 && LowSelect == Low1 && Close0 > DwBand0 && (direction==0 || direction==2))
        {
         Condition = 1;
        }
      else
         if((rsi0 >= OverBought) && High1  > UpBand1 && HighSelect == High1 && Close0 < UpBand0 && (direction==1 || direction==2))
           {
            Condition = -1;
           }
     }

   if(Special == 22)
     {
      if((rsi0 < OverSold) &&  Close1 < DwBand1 && Close0 > DwBand0 && LowSelect == Low1 && (direction==0 || direction==2))
        {
         Condition = 1;
        }
      else
         if((rsi0 > OverBought) &&  Close1 > UpBand1 && Close0 < UpBand0 && HighSelect == High1 && (direction==1 || direction==2))
           {
            Condition = -1;
           }
     }

   if(Special == 23)
     {
      if((rsi0 <= OverSold) && Low1  < DwBand1 && LowSelect <= Low0 && (LowSelect <= DwBand1 || LowSelect <= DwBand0) && Close0 >= DwBand0 && (direction==0 || direction==2))
        {
         Condition = 1;
        }
      else
         if((rsi0 >= OverBought) && High1  > UpBand1 && HighSelect >= High0 && (HighSelect >= UpBand1 || HighSelect >= UpBand0) && Close0 <= UpBand0 && (direction==1 || direction==2))
           {
            Condition = -1;
           }
     }

   return Condition;
  }
//+------------------------------------------------------------------+
int MOMENTUM(int shift, int direction)
  {
   int Condition     = 0;
   double LongLEVEL  = 100.505;//Implementar Factor
   double ShortLEVEL = 99.536;//Implementar Factor
   int MonPeriod     = 14;
   HideTestIndicators(true);
   double MOMENTO = iMomentum(_Symbol,0,MonPeriod,0,shift);
   HideTestIndicators(false);

   if(MOMENTO >  LongLEVEL  && (direction==0 || direction==2))
     {
      Condition = 1;
     }

   if(MOMENTO <  ShortLEVEL && (direction==1 || direction==2))
     {
      Condition = -1;
     }

   return Condition;
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int Prototipo(int shift, int Special, int direction, int ControlBar)
  {
   int Condition  = 0;
   int LookBackPeriod = 20;
   int bars = iBars(_Symbol,0);
   double HighesBuffer[], LowesBuffer[];

   static int IndCounted;
   if(bars < LookBackPeriod)
     {
      Condition  = 0;
     }

   if(ArraySize(HighesBuffer)< Bars)
     {
      ArraySetAsSeries(HighesBuffer,false);
      ArraySetAsSeries(LowesBuffer,false);

      ArrayResize(HighesBuffer,Bars);
      ArrayResize(LowesBuffer,Bars);

      ArraySetAsSeries(HighesBuffer,true);
      ArraySetAsSeries(LowesBuffer,true);
     }

   counted_bars = IndCounted;

   if(counted_bars < 0)
     {
      counted_bars=-1;
     }

   if(counted_bars > 0)
     {
      counted_bars--;
     }

   IndCounted = bars - 1;

   limit = bars  - counted_bars - 1;

   MaxBar = bars  - 1 - (ControlBar);

   if(limit > MaxBar)
     {
      limit = MaxBar;
      for(int bar = bars  - 1; bar >= 0; bar--)
        {
         HighesBuffer[bar]=0;
         LowesBuffer[bar]=0;
        }
     }

   for(int i=0; i<limit; i++)
     {
      HighesBuffer[i]    = iHigh(Symbol(),Period(),iHighest(Symbol(),Period(),MODE_HIGH,WHOLE_ARRAY,i));

      LowesBuffer[i]     = iLow(Symbol(),Period(),iLowest(Symbol(),Period(),MODE_LOW,WHOLE_ARRAY,i));
     }

   return Condition;

  }
//+------------------------------------------------------------------+