//+------------------------------------------------------------------+
//|                                                EUROPIAN RUSH.mq4 |
//|                           Copyright 2022, NEXT TRADING EVOLUTION |
//|                                        YourSmartTradingEvolution |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, NEXT TRADING EVOLUTION"
#property link      "YourSmartTradingEvolution"
#property version   "1.00"

extern int TakeProfit = 30;
extern int StopLoss = 30;
extern double Lots = 0.01;
extern int TrailingStop=30;
extern int MagicNumber = 30290;
string EAComment = "EA AUTOMA Z+";
extern string info1 = "==============Marti Setting==============";
extern double   Lot_exponent      = 1;
extern int      PipStep           = 100;
extern int      MaxAveraging      = 15;
extern string info2 = "==============Day Setting==============";
extern bool Sunday = true;
extern bool Monday = true;
extern bool Tuesday = true;
extern bool Wednesday = true;
extern bool Thursday = true;
extern bool Friday = false;
extern bool NFP_Friday = true;
extern bool NFP_ThursdayBefore = true;
extern bool ChristmasHolidays = true;
extern double XMAS_DayBeginBreak = 15;
extern bool NewYearsHolidays = true;
extern double NewYears_DayEndBreak = 3;
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
   int CandleOnChart = WindowFirstVisibleBar();

   double MyPoint=Point;
   if(Digits==3 || Digits==5)
      MyPoint=Point*10;

   double qneq = AccountEquity();
   double qnbllnc = AccountBalance();
   double prft = qneq-qnbllnc;

   int x_resistance = iHighest(_Symbol,_Period,MODE_HIGH,200,0);
   int x_support = iHighest(_Symbol,_Period,MODE_LOW,200,0);
   double var_high = High[x_resistance];
   double var_close = MathMax(Close[x_resistance], Open[x_resistance]);
   double var_low = Low[x_resistance];
   double var_closes = MathMax(Close[x_resistance], Open[x_resistance]);
   static string crt="none";

   if(Bid>var_close&&Bid<var_high)
     {
      crt="BUY";
     }
   if(Bid<var_closes&&Bid>var_low)
     {
      crt="SELL";
     }

   ObjectCreate(0,"High"+Time[x_resistance],OBJ_TREND,Time[x_resistance],High[x_resistance],Time[0],High[x_resistance]);
   ObjectCreate(0,"Close"+Time[x_support],OBJ_TREND,Time[x_support],Low[x_support],Time[0],Low[x_supportx]);
   ObjectSetInteger(0,"High"+Time[x_resistance],OBJPROP_COLOR,Red);
   ObjectSetInteger(0,"High"+Time[x_resistance],OBJPROP_STYLE,STYLE_SOLID);
   ObjectSetInteger(0,"High"+Time[x_resistance],OBJPROP_WIDTH,1);
   ObjectSetInteger(0,"High"+Time[x_resistance],OBJPROP_RAY,false);

   ObjectSetInteger(0,"Close"+Time[x_support],OBJPROP_COLOR,Red);
   ObjectSetInteger(0,"Close"+Time[x_support],OBJPROP_STYLE,STYLE_SOLID);
   ObjectSetInteger(0,"Close"+Time[x_support],OBJPROP_WIDTH,1);
   ObjectSetInteger(0,"Close"+Time[x_support],OBJPROP_RAY,false);
   
   /*
      if(OrdersTotal()==0)
        {
         if(crt=="BUY")
           {
            CloseSell();
            OrderSend(Symbol(),OP_BUY,Lots,Ask,3,Ask-StopLoss*Point*10,0,EAComment,MagicNumber);
           }
         else
            if(crt=="SELL")
              {
               CloseBuy();
               OrderSend(Symbol(),OP_SELL,Lots,Bid,3,Bid+StopLoss*Point*10,0,EAComment,MagicNumber);
              }
        }*/

   if(OrdersTotal()>0)
     {
      crt="none";
     }

   Comment("/nSignal : ", crt);

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
int CloseBuy()
  {
   for(int i=OrdersTotal()-1; i>=0; i--)
     {
      if(!OrderSelect(i,SELECT_BY_POS,MODE_TRADES)
         || (OrderMagicNumber()!=MagicNumber)
         || (OrderSymbol()!=Symbol())
         || (OrderType()>2))
         continue;

      if(OrderType()==OP_BUY)
        {
         OrderClose(i,OrderLots(),OrderClosePrice(),3);
        }
     }
  }
//+------------------------------------------------------------------+
int CloseSell()
  {
   for(int i=OrdersTotal()-1; i>=0; i--)
     {
      if(!OrderSelect(i,SELECT_BY_POS,MODE_TRADES)
         || (OrderMagicNumber()!=MagicNumber)
         || (OrderSymbol()!=Symbol())
         || (OrderType()>2))
         continue;

      if(OrderType()==OP_SELL)
        {
         OrderClose(i,OrderLots(),OrderClosePrice(),3);
        }
     }
  }
//+------------------------------------------------------------------+
