//+------------------------------------------------------------------+
//|                                                      TMMA v1.mq4 |
//|                        Copyright 2022, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"

extern int TakeProfit = 10;
extern int StopLoss = 10;
extern double Lots = 0.01;
extern int ma_period1 = 100;
extern int ma_period2 = 200;
extern int MagicNumber = 293847;
extern string EAComment = "TMMA v1";
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

   double qnMA1 = iMA(Symbol(),Period(),ma_period1,0,MODE_EMA,PRICE_CLOSE,0);
   double qnMA2 = iMA(Symbol(),Period(),ma_period2,0,MODE_EMA,PRICE_CLOSE,0);
   double qnMAs1 = iMA(Symbol(),Period(),ma_period1,0,MODE_EMA,PRICE_CLOSE,5);
   double qnMAs2 = iMA(Symbol(),Period(),ma_period2,0,MODE_EMA,PRICE_CLOSE,5);

   int ticket;
   if(OrdersTotal()==0)
     {
      if((qnMAs1 > qnMAs2)&&(qnMA1 < qnMA2))
        {
         ticket = OrderSend(Symbol(),OP_BUY,Lots,Ask,3,Ask-StopLoss*Point*10,Ask+TakeProfit*Point*10,EAComment,MagicNumber,0,Blue);
        }
      if((qnMAs1 < qnMAs2)&&(qnMA1 > qnMA2))
        {
         ticket = OrderSend(Symbol(),OP_SELL,Lots,Bid,3,Bid+StopLoss*Point*10,Bid-TakeProfit*Point*10,EAComment,MagicNumber,0,Blue);
        }
     }


  }
//+------------------------------------------------------------------+
