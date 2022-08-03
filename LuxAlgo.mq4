//+------------------------------------------------------------------+
//|                                                      Indomie.mq4 |
//|                           Copyright 2022, NEXT TRADING EVOLUTION |
//|                                        YourSmartTradingEvolution |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, NEXT TRADING EVOLUTION"
#property link      "YourSmartTradingEvolution"
#property version   "1.00"

extern int TakeProfit = 30;
extern int StopLoss = 70;
extern int QnPeriod = 10;
extern double Lots = 0.01;
extern int MagicNumber = 30290;
extern int Slippage = 3;
string EAComment = "EA";

int Range = 500;
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

   ChartSetInteger(0,CHART_SHOW_GRID,false); // false to remove grid
   ChartSetInteger(0,CHART_MODE,CHART_CANDLES);

   if(OrdersTotal()==0)
     {
      if((stoch(10,6,6,2) > 80 && stoch(10,6,6,1) < 80) && (Close[2] > tema(34,1) && Close[1] < tema(34,1)))
        {
         order(0);
        }
     }
  }
//+------------------------------------------------------------------+
string CheckCandle(int shift = 1)
  {
   string result;
   if(Open[shift] < Close[shift])
      result="Bullish";
   if(Open[shift] > Close[shift])
      result="Bearish";
   return(result);
  }
//+------------------------------------------------------------------+
double stoch(int kperiod, int dperiod, int slowperiod, int shift)
  {
   return(iStochastic(Symbol(),Period(),kperiod,dperiod,slowperiod,MODE_SMA,1,MODE_MAIN,shift));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double tema(int period, int shift)
  {
   return(iCustom(Symbol(),Period(),"TEMA",period,0,shift));
  }
//+------------------------------------------------------------------+
bool BulEngulfing()
  {
   bool result=false;
   if((High[2] < High[1])&&(Low[2] > Low[1])&&(CheckCandle(2)=="Bearish")&&((CheckCandle()=="Bullish")))
      result=true;
   return(result);
  }
//+------------------------------------------------------------------+
bool BerEngulfing()
  {
   bool result=false;
   if((High[2] < High[1])&&(Low[2] > Low[1])&&(CheckCandle(2)=="Bullish")&&((CheckCandle()=="Bearish")))
      result=true;
   return(result);
  }
//+------------------------------------------------------------------+
void order(int cmd)
  {
   double Price;
   double stoploss = 0;
   double takeprofit = 0;
   int ticket;
   if(cmd == OP_BUY)
     {
      Price = Ask;
      if(StopLoss>0)
        {
         stoploss = Price-StopLoss*Point*10;
        }
      if(TakeProfit>0)
        {
         takeprofit = Price+TakeProfit*Point*10;
        }
     }
   if(cmd == OP_SELL)
     {
      Price = Bid;
      if(StopLoss>0)
        {
         stoploss = Price+StopLoss*Point*10;
        }
      if(TakeProfit>0)
        {
         takeprofit = Price-TakeProfit*Point*10;
        }
     }

   if(cmd == OP_BUYSTOP)
     {
      Price = Open[0]+Range*Point*10;
      if(StopLoss>0)
        {
         stoploss = Price-StopLoss*Point*10;
        }
      if(TakeProfit>0)
        {
         takeprofit = Price+TakeProfit*Point*10;
        }
     }

   if(cmd == OP_SELLSTOP)
     {
      Price = Open[0]-Range*Point*10;
      if(StopLoss>0)
        {
         stoploss = Price+StopLoss*Point*10;
        }
      if(TakeProfit>0)
        {
         takeprofit = Price-TakeProfit*Point*10;
        }
     }

   ticket = OrderSend(Symbol(),cmd,Lots,Price,Slippage,stoploss,takeprofit,EAComment,MagicNumber);

  }
//+------------------------------------------------------------------+
