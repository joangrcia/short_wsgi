//+------------------------------------------------------------------+
//|                                                     EA VENOM.mq4 |
//|                           Copyright 2022, NEXT TRADING EVOLUTION |
//|                                        YourSmartTradingEvolution |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, NEXT TRADING EVOLUTION"
#property link      "YourSmartTradingEvolution"
#property version   "1.00"

extern int TakeProfit = 30;
extern int StopLoss = 30;
extern double Lots = 0.01;
extern int Slippage = 3;
extern int Range = 20;
extern int MagicNumber = 30290;
extern string Signal21 = "FXVEN1";
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

   /*
   int shift = 1;
   double val1 = iCustom(NULL,0,"FXVEN2",0,0,0,2,shift);
   double val2 = iCustom(NULL,0,"FXVEN2",0,0,0,3,shift);
   */

   if(OrdersTotal()==0)
     {
      if(Val1()>0)
        {
         order(0);
        }
      if(Val2()>0)
        {
         order(1);
        }
     }

   closebuy();
   closesell();

   Comment("\nGET : ", Val2(),
           "\nGET2 : ", Val1());

  }
//+------------------------------------------------------------------+
bool IsNewBar()
  {
   static   datetime lastBar;
   datetime currBar  =  iTime(Symbol(), PERIOD_D1, 0);

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
//|                                                                  |
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

   if(cmd == OP_BUYLIMIT)
     {
      Price = Ask-Range*Point*10;
      if(StopLoss>0)
        {
         stoploss = Price-StopLoss*Point*10;
        }
      if(TakeProfit>0)
        {
         takeprofit = Price+TakeProfit*Point*10;
        }
     }

   if(cmd == OP_SELLLIMIT)
     {
      Price = Bid+Range*Point*10;
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
void closebuy()
  {
   for(int i = OrdersTotal() - 1; i >= 0; i--)
     {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
        {
         if((OrderMagicNumber() == MagicNumber) && (OrderSymbol() == _Symbol))
           {
            if(Val2()>0)
              {
               if(!OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(), MODE_BID), 5, Red))
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
void closesell()
  {
   for(int i = OrdersTotal() - 1; i >= 0; i--)
     {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
        {
         if((OrderMagicNumber() == MagicNumber) && (OrderSymbol() == _Symbol))
           {
            if(Val1()>0)
              {
               if(!OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(), MODE_ASK), 5, Red))
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
double LastOrderClosedProfit()
  {
   int      ticket      =-1;
   datetime last_time   = 0;
   for(int i=OrdersHistoryTotal()-1; i>=0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)&&OrderSymbol()==_Symbol&&OrderCloseTime()>last_time)
        {
         last_time = OrderCloseTime();
         ticket = OrderTicket();
        }
     }
   if(!OrderSelect(ticket,SELECT_BY_TICKET))
     {
      Print("OrderSelectError: ",GetLastError());
      return 0.0;
     }
   return OrderProfit();
  }
//+------------------------------------------------------------------+
double LastOrderLots()
  {
   int      ticket      =-1;
   datetime last_time   = 0;
   for(int i=OrdersHistoryTotal()-1; i>=0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)&&OrderSymbol()==_Symbol&&OrderCloseTime()>last_time)
        {
         last_time = OrderCloseTime();
         ticket = OrderTicket();
        }
     }
   if(!OrderSelect(ticket,SELECT_BY_TICKET))
     {
      Print("OrderSelectError: ",GetLastError());
      return 0.0;
     }
   return OrderLots();
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double LastOrderPriceClosed()
  {
   int      ticket      =-1;
   datetime last_time   = 0;
   for(int i=OrdersHistoryTotal()-1; i>=0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)&&OrderSymbol()==_Symbol&&OrderCloseTime()>last_time)
        {
         last_time = OrderCloseTime();
         ticket = OrderTicket();
        }
     }
   if(!OrderSelect(ticket,SELECT_BY_TICKET))
     {
      Print("OrderSelectError: ",GetLastError());
      return 0.0;
     }
   return OrderClosePrice();
  }
//+------------------------------------------------------------------+
double Jarak_loss()
  {
   double konf_sw = 0;
   double qcloser = MathMax(LastOrderPriceClosed(),OrderOpenPrice());
   double qcloser2 = MathMin(LastOrderPriceClosed(),OrderOpenPrice());
   konf_sw = MathRound((qcloser - qcloser2)*10);
   return(konf_sw);
  }
//+------------------------------------------------------------------+
int TodayClosed()
  {
   int history = 0;
   for(int order = 0; order <= OrdersHistoryTotal() - 1; order++)
     {
      bool select = OrderSelect(order,SELECT_BY_POS,MODE_HISTORY);
      if(TimeDay(OrderCloseTime())==Day() && OrderType()<2 && OrderSymbol()==_Symbol && OrderMagicNumber()==MagicNumber)
         history++;
     }

   return history;
  }
//+------------------------------------------------------------------+
double Val1()
  {
   int shift = 1;
   double val1 = iCustom(NULL,0,Signal21,0,0,0,2,shift);
//double val2 = iCustom(NULL,0,"FXVEN2",0,0,0,3,shift);
   return(val1);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double Val2()
  {
   int shift = 1;
//double val1 = iCustom(NULL,0,"FXVEN2",0,0,0,2,shift);
   double val2 = iCustom(NULL,0,Signal21,0,0,0,3,shift);
   return(val2);
  }
//+------------------------------------------------------------------+
