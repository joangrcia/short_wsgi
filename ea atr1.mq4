//+------------------------------------------------------------------+
//|                                                      ea atr1.mq4 |
//|                           Copyright 2022, NEXT TRADING EVOLUTION |
//|                                        YourSmartTradingEvolution |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, NEXT TRADING EVOLUTION"
#property link      "YourSmartTradingEvolution"
#property version   "1.00"

extern int TakeProfit = 20;
extern int StopLoss = 30;
extern double Lots = 0.01;
extern int MagicNumber = 30290;
extern int Exit_Loss = 50;
extern bool auto_compound = false;
string EAComment = "EA AUTOMA Z+";
extern int std = 30;
extern int std2 = 55;
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

   double JGatr1 = iATR(NULL,PERIOD_H1,12,0);
   double JGatr2 = iATR(NULL,PERIOD_H1,12,24);
   double JGtrend1 = iOpen(NULL,PERIOD_H1,0);
   double JGtrend2 = iOpen(NULL,PERIOD_H1,24);
   double JGmacd_main = iMACD(NULL,PERIOD_H1,12,26,9,PRICE_CLOSE,MODE_MAIN,1);
   double JGmacd_signal = iMACD(NULL,PERIOD_M5,12,26,9,PRICE_CLOSE,MODE_SIGNAL,1);
   double JGsar1 = iSAR(NULL,PERIOD_M5,0.01,0.2,1);
   double JGsar2 = iSAR(NULL,PERIOD_M5,0.01,0.2,2);
   static string signalatr = " ";
   static string signaltrend = " ";

//==================================== Signal ====================================
   if(TimeHour(iTime(NULL,PERIOD_H1,1))==0||TimeHour(iTime(NULL,PERIOD_H1,1))==1)
     {
      if(JGatr2 < JGatr1)
        {
         signalatr="Strong";
        }

      if(JGatr2 > JGatr1)
        {
         signalatr="Weak";
        }
     }

   if(TimeHour(iTime(NULL,PERIOD_H1,1))==0||TimeHour(iTime(NULL,PERIOD_H1,1))==1)
     {
      if(JGtrend2 < JGtrend1)
        {
         signaltrend="Bullish";
        }

      if(JGtrend2 > JGtrend1)
        {
         signaltrend="Bearish";
        }
     }

   string WRSignal = signalatr+" "+signaltrend;
//string TRSignal = signalatr+" "+signaltrend;
//==================================== Trigger ====================================

   int ticket;
   if(OrdersTotal()==0)
     {
      if((WRSignal == "Strong Bullish")||(WRSignal == "Weak Bearish"))
        {
         if((JGmacd_signal > JGmacd_main) && (JGsar2 > High[2] && JGsar1 < Low[1]))
           {
            ticket = OrderSend(Symbol(),OP_BUY,Lots,Ask,3,Ask-StopLoss*MyPoint,Ask+TakeProfit*MyPoint,EAComment,MagicNumber);
           }
        }
      if((WRSignal == "Strong Bearish")||(WRSignal == "Weak Bullish"))
        {
         if((JGmacd_signal < JGmacd_main) && (JGsar2 < Low[2] && JGsar1 > High[1]))
           {
            ticket = OrderSend(Symbol(),OP_SELL,Lots,Bid,3,Bid+StopLoss*MyPoint,Bid-TakeProfit*MyPoint,EAComment,MagicNumber);
           }
        }
     }
     
   Comment("\nSignal : ", WRSignal);

  }
//+------------------------------------------------------------------+
