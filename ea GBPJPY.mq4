//+------------------------------------------------------------------+
//|                                                    MACD joss.mq4 |
//|                           Copyright 2022, NEXT TRADING EVOLUTION |
//|                                        YourSmartTradingEvolution |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, NEXT TRADING EVOLUTION"
#property link      "YourSmartTradingEvolution"
#property version   "1.00"

extern int TakeProfit = 20;
extern int StopLoss = 30;
extern bool auto_compound = false;
extern double Lots = 0.1;
extern int Gap = 20;
extern int Slippage = 3;
extern int MagicNumber = 30290;
//extern int timedelay = 6;
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

   double JGatr1 = iATR(NULL,PERIOD_D1,12,1);
   double JGatr2 = iATR(NULL,PERIOD_D1,12,2);
   double JGtrend1 = iOpen(NULL,PERIOD_D1,1);
   double JGtrend2 = iClose(NULL,PERIOD_D1,1);
   static string signalatr = " ";
   static string signaltrend = " ";

   if(auto_compound)
     {
      if((AccountBalance()>=3000)&&(AccountBalance()<=5000))
        {
         Lots = 0.1;
        }
      else
         if((AccountBalance()>=5000)&&(AccountBalance()<=10000))
           {
            Lots = 0.5;
           }
         else
            if((AccountBalance()>=10000)&&(AccountBalance()<=15000))
              {
               Lots = 1.0;
              }
            else
               if((AccountBalance()>=15000)&&(AccountBalance()<=20000))
                 {
                  Lots = 2.0;
                 }
               else
                  if((AccountBalance()>=20000)&&(AccountBalance()<=25000))
                    {
                     Lots = 3.0;
                    }
                  else
                     if((AccountBalance()>=25000)&&(AccountBalance()<=30000))
                       {
                        Lots = 4.0;
                       }
     }

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
      if(JGtrend2 > JGtrend1)
        {
         signaltrend="Bullish";
        }

      if(JGtrend2 < JGtrend1)
        {
         signaltrend="Bearish";
        }
     }

   string WRSignal = signalatr+" "+signaltrend;
//string TRSignal = signalatr+" "+signaltrend;

   int chigh = iHighest(NULL,0,MODE_HIGH,9,1);
   int clows = iLowest(NULL,0,MODE_LOW,9,1);
   double highprice = High[chigh]+Gap*MyPoint;
   double lowsprice = Low[clows]-Gap*MyPoint;

   double persen_modal = (AccountBalance()*1)/100;
   double aturan_lots = persen_modal/StopLoss/10;

   int ticket;
   if(OrdersTotal()==0)
     {
      if(Hour()==9 && Minute()==0 && Seconds()==0)
        {
         if((WRSignal == "Strong Bearish")||(WRSignal == "Weak Bullish"))
           {
            ticket = OrderSend(Symbol(),OP_BUYSTOP,Lots,highprice,3,highprice-StopLoss*MyPoint,highprice+TakeProfit*MyPoint,EAComment,MagicNumber);
           }
         if((WRSignal == "Strong Bullish")||(WRSignal == "Weak Bearish"))
           {
            ticket = OrderSend(Symbol(),OP_SELLSTOP,Lots,lowsprice,3,lowsprice+StopLoss*MyPoint,lowsprice-TakeProfit*MyPoint,EAComment,MagicNumber);
           }
        }
     }

   if(Hour()==0 && Minute()==0 && Seconds()==0)
     {
      DeletePendingOrders();
     }
   /*
   if(IsNewBar())
   {
    if((AccountEquity() > AccountBalance()))
      {
       CloseAll();
      }
   }*/

   CheckMarketDeletePending();
   Comment("\nSignal : ", WRSignal);

  }
//+------------------------------------------------------------------+
int CloseAll()
  {
   int total = OrdersTotal();
   for(int i=total-1; i>=0; i--)
     {
      int hg=OrderSelect(i, SELECT_BY_POS);
      int type   = OrderType();

      bool result = false;

      switch(type)
        {
         //Close opened long positions
         case OP_BUY       :
            result = OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_BID), 5, Red);
            break;

         //Close opened short positions
         case OP_SELL      :
            result = OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_ASK), 5, Red);

        }

      if(result == false)
        {
         Alert("Order ", OrderTicket(), " failed to close. Error:", GetLastError());
         Sleep(3000);
        }
     }

   return(0);
  }
//+------------------------------------------------------------------+
void CheckMarketDeletePending()
  {
   for(int i = OrdersTotal() - 1; i >= 0; i--)
     {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
        {
         if((OrderMagicNumber() == MagicNumber) && (OrderSymbol() == _Symbol))
           {
            if((OrderType() == OP_BUY) || (OrderType() == OP_SELL))
              {
               DeletePendingOrders();
               break;
              }
           }
        }
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void DeletePendingOrders()
  {
   for(int i = OrdersTotal() - 1; i >= 0; i--)
     {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
        {
         if((OrderMagicNumber() == MagicNumber) && (OrderSymbol() == _Symbol))
           {
            if((OrderType() != OP_BUY) && (OrderType() != OP_SELL))
              {
               if(!OrderDelete(OrderTicket()))
                 {
                  // Delete failed (need to deal with situation)
                  // Check Error Codes
                 }
              }
           }
        }
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CloseMarketOrders()
  {
   for(int i = OrdersTotal() - 1; i >= 0; i--)
     {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
        {
         if((OrderMagicNumber() == MagicNumber) && (OrderSymbol() == _Symbol))
           {
            if((OrderType() == OP_BUY) || (OrderType() == OP_SELL))
              {
               if(!OrderClose(OrderTicket(), OrderLots(), OrderClosePrice(), Slippage))
                 {
                  // Close failed (need to deal with situation)
                  // Check Error Codes
                 }
              }
           }
        }
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CloseDeleteAllOrders()
  {
   for(int i = OrdersTotal() - 1; i >= 0; i--)
     {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
        {
         if((OrderMagicNumber() == MagicNumber) && (OrderSymbol() == _Symbol))
           {
            if((OrderType() == OP_BUY) || (OrderType() == OP_SELL))
              {
               if(!OrderClose(OrderTicket(), OrderLots(), OrderClosePrice(), Slippage))
                 {
                  // Close failed (need to deal with situation)
                  // Check Error Codes
                 }
              }
            else
              {
               if(!OrderDelete(OrderTicket()))
                 {
                  // Delete failed (need to deal with situation)
                  // Check Error Codes
                 }
              }
           }
        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool IsNewBar()
  {
   static   datetime lastBar;
   datetime currBar  =  iTime(Symbol(), Period(), 0);

   if(lastBar != currBar)
     {
      lastBar  =  currBar;
      return (true);
     }
   else
     {
      return(false);
     }
  }
//+------------------------------------------------------------------+