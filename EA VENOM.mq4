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

   /*
   int shift = 1;
   double val1 = iCustom(NULL,0,"FXVEN2",0,0,0,2,shift);
   double val2 = iCustom(NULL,0,"FXVEN2",0,0,0,3,shift);
   */

   if(OrdersTotal()==0)
     {
      if(Val1()>0)
        {
         int tikcet = OrderSend(Symbol(),OP_BUY,Lots,Ask,3,0,Ask+TakeProfit*Point*10, EAComment, MagicNumber,0);
        }
      if(Val2()>0)
        {
         int tikcet1 = OrderSend(Symbol(),OP_SELL,Lots,Bid,3,0,Bid-TakeProfit*Point*10,EAComment, MagicNumber,0);
        }
     }
   closesell();
   closebuy();

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
void closebuy()
  {
   for(int i = OrdersTotal() - 1; i >= 0; i--)
     {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
        {
         if((OrderMagicNumber() == MagicNumber) && (OrderSymbol() == _Symbol))
           {
            if((OrderType() != OP_SELL)&&Val2()>0)
              {
               if(!OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(), MODE_BID), 5, Red))
                 {
                  // Delete failed (need to deal with situation)
                  // Check Error Codes
                 }
               double marlot=0.00;
               double martp=0;
               if(LastOrderClosedProfit()<0)
                 {
                  marlot=LastOrderLots()*2;
                 }
               else
                 {
                  marlot = Lots;
                 }
               if(Jarak_loss()<30)
                 {
                  martp=30;
                 }
               else
                  if(Jarak_loss()>30)
                    {
                     martp=Jarak_loss();
                    }
               int ticket = OrderSend(Symbol(),OP_SELL,marlot,Bid,3,0,Bid-martp*Point*10,EAComment,MagicNumber);
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
            if((OrderType() != OP_BUY)&&(Val1()>0))
              {
               if(!OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(), MODE_ASK), 5, Red))
                 {
                  // Delete failed (need to deal with situation)
                  // Check Error Codes
                 }
               double marlot=0.00;
               double martp=0;
               if(LastOrderClosedProfit()<0)
                 {
                  marlot=LastOrderLots()*2;
                 }
               else
                 {
                  marlot = Lots;
                 }
               if(Jarak_loss()<30)
                 {
                  martp=30;
                 }
               else
                  if(Jarak_loss()>30)
                    {
                     martp=Jarak_loss();
                    }
               int ticket = OrderSend(Symbol(),OP_BUY,marlot,Ask,3,0,Ask+martp*Point*10,EAComment,MagicNumber);
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
   double val1 = iCustom(NULL,0,"FXVEN3",0,0,0,2,shift);
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
   double val2 = iCustom(NULL,0,"FXVEN3",0,0,0,3,shift);
   return(val2);
  }
//+------------------------------------------------------------------+
