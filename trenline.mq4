//+------------------------------------------------------------------+
//|                                                     trenline.mq4 |
//|                           Copyright 2022, NEXT TRADING EVOLUTION |
//|                                        YourSmartTradingEvolution |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, NEXT TRADING EVOLUTION"
#property link      "YourSmartTradingEvolution"
#property version   "1.00"

extern int TakeProfit = 250;
extern int StopLoss = 250;
extern double Lots = 0.01;
extern int TrailingStop=70;
extern int sr_range = 50;
extern int slow_range = 35;
extern int fast_range = 70;
extern int MagicNumber = 30290;
string EAComment = "EA AUTOMA Z+";
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---

//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---

  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---

   double MyPoint=Point;
   if(Digits==3 || Digits==5)
      MyPoint=Point*10;

   int CandleOnChart = WindowFirstVisibleBar();

   int LowestCandle = iLowest(_Symbol,_Period,MODE_LOW,sr_range,30);
   int HighCandle = iHighest(_Symbol,_Period,MODE_HIGH,sr_range,30);
   double Qnma200 = iMA(NULL,0,slow_range,0,MODE_SMA,PRICE_CLOSE,5);
   double Qnma100 = iMA(NULL,0,fast_range,0,MODE_SMA,PRICE_CLOSE,5);

   ObjectDelete("lowTrend");
   ObjectDelete("highTrend");
   ObjectDelete("lowTrendclose");
   ObjectDelete("highTrendclose");

   int ticket;
   if(OrdersTotal()==0 && NewBar())
     {
      if(
         //(Qnma100>Qnma200)
         (Bid<MathMin(Close[LowestCandle],Open[LowestCandle])))
        {
         ticket = OrderSend(Symbol(),OP_BUY,Lots,Ask,3,Ask-StopLoss*MyPoint,Ask+TakeProfit*MyPoint,EAComment,MagicNumber);
        }
      if(
         ///(Qnma100<Qnma200)
         (Bid>MathMax(Close[HighCandle],Open[HighCandle])))
        {
         ticket = OrderSend(Symbol(),OP_SELL,Lots,Bid,3,Bid+StopLoss*MyPoint,Bid-TakeProfit*MyPoint,EAComment,MagicNumber);
        }
     }


//====================================================================
//draw trendline
//====================================================================

   ObjectCreate(
      0,
      "lowTrend",
      OBJ_TREND,
      0,
      iTime(_Symbol,PERIOD_H4,LowestCandle),
      iLow(_Symbol,PERIOD_H4,LowestCandle),
      iTime(_Symbol,PERIOD_H4,0),
      iLow(_Symbol,PERIOD_H4,LowestCandle)
   );

   ObjectCreate(
      0,
      "lowTrendclose",
      OBJ_TREND,
      0,
      iTime(_Symbol,PERIOD_H4,LowestCandle),
      MathMin(iOpen(_Symbol,PERIOD_H4,LowestCandle),iClose(_Symbol,PERIOD_H4,LowestCandle)),
      iTime(_Symbol,PERIOD_H4,0),
      MathMin(iOpen(_Symbol,PERIOD_H4,LowestCandle),iClose(_Symbol,PERIOD_H4,LowestCandle))
   );

   ObjectCreate(
      0,
      "highTrend",
      OBJ_TREND,
      0,
      iTime(_Symbol,PERIOD_H4,HighCandle),
      iHigh(_Symbol,PERIOD_H4,HighCandle),
      iTime(_Symbol,PERIOD_H4,0),
      iHigh(_Symbol,PERIOD_H4,HighCandle)
   );
   ObjectCreate(
      0,
      "highTrendclose",
      OBJ_TREND,
      0,
      iTime(_Symbol,PERIOD_H4,HighCandle),
      MathMax(iOpen(_Symbol,PERIOD_H4,HighCandle),iClose(_Symbol,PERIOD_H4,HighCandle)),
      iTime(_Symbol,PERIOD_H4,0),
      MathMax(iOpen(_Symbol,PERIOD_H4,HighCandle),iClose(_Symbol,PERIOD_H4,HighCandle))
   );

   ObjectSetInteger(0,"lowTrend", OBJPROP_COLOR,Red);
   ObjectSetInteger(0,"lowTrend", OBJPROP_STYLE,STYLE_SOLID);
   ObjectSetInteger(0,"lowTrend", OBJPROP_WIDTH,1);
   ObjectSetInteger(0,"lowTrend", OBJPROP_RAY,false);

   ObjectSetInteger(0,"lowTrendclose", OBJPROP_COLOR,Red);
   ObjectSetInteger(0,"lowTrendclose", OBJPROP_STYLE,STYLE_SOLID);
   ObjectSetInteger(0,"lowTrendclose", OBJPROP_WIDTH,1);
   ObjectSetInteger(0,"lowTrendclose", OBJPROP_RAY,false);

   ObjectSetInteger(0,"highTrend", OBJPROP_COLOR,Red);
   ObjectSetInteger(0,"highTrend", OBJPROP_STYLE,STYLE_SOLID);
   ObjectSetInteger(0,"highTrend", OBJPROP_WIDTH,1);
   ObjectSetInteger(0,"highTrend", OBJPROP_RAY,false);

   ObjectSetInteger(0,"highTrendclose", OBJPROP_COLOR,Red);
   ObjectSetInteger(0,"highTrendclose", OBJPROP_STYLE,STYLE_SOLID);
   ObjectSetInteger(0,"highTrendclose", OBJPROP_WIDTH,1);
   ObjectSetInteger(0,"highTrendclose", OBJPROP_RAY,false);
//====================================================================
//Trailing Stop
//====================================================================

   for(int cnt=0; cnt<OrdersTotal(); cnt++)
     {
      OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      if(OrderType()<=OP_SELL &&
         OrderSymbol()==Symbol() &&
         OrderMagicNumber()==MagicNumber
        )
        {
         if(OrderType()==OP_BUY)
           {
            if(TrailingStop>0)
              {
               if(Bid-OrderOpenPrice()>MyPoint*TrailingStop)
                 {
                  if(OrderStopLoss()<Bid-MyPoint*TrailingStop)
                    {
                     OrderModify(OrderTicket(),OrderOpenPrice(),Bid-TrailingStop*MyPoint,OrderTakeProfit(),0,Green);
                     return(0);
                    }
                 }
              }
           }
         else
           {
            if(TrailingStop>0)
              {
               if((OrderOpenPrice()-Ask)>(MyPoint*TrailingStop))
                 {
                  if((OrderStopLoss()>(Ask+MyPoint*TrailingStop)) || (OrderStopLoss()==0))
                    {
                     OrderModify(OrderTicket(),OrderOpenPrice(),Ask+MyPoint*TrailingStop,OrderTakeProfit(),0,Red);
                     return(0);
                    }
                 }
              }
           }
        }
     }
  }
//+------------------------------------------------------------------+
bool NewBar()
  {
   static datetime lastbar;
   datetime curbar = Time[0];
   if(lastbar!=curbar)
     {
      lastbar=curbar;
      return (true);
     }
   else
     {
      return(false);
     }
  }
//+------------------------------------------------------------------+
