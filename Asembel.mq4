//+------------------------------------------------------------------+
//|                                                      Asembel.mq4 |
//|                           Copyright 2022, NEXT TRADING EVOLUTION |
//|                                        YourSmartTradingEvolution |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, NEXT TRADING EVOLUTION"
#property link      "YourSmartTradingEvolution"
#property version   "1.00"

extern int TakeProfit = 0;
extern int StopLoss = 0;
extern double Lots = 0.01;
extern int MagicNumber = 30290;
extern int Slipage = 3;
string EAComment = "EA AUTOMA Z+";

string  SettingMA = "-----------";
extern int     Shift = 0;
extern int     PeriodMa = 10;
ENUM_MA_METHOD MAMethod = MODE_SMMA;
ENUM_APPLIED_PRICE Applyto = PRICE_CLOSE;

extern string SettingSAR = "-----------";
extern double SarStep = 0.02;
extern double SarMax = 0.2;
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

   if(OrdersTotal()==0)
     {
      if(BuySignal())
        {
         order(0);
        }
      if(SellSignal())
        {
         order(1);
        }
     }
   if(BuySignal())
     {
      closesell();
     }
   if(SellSignal())
     {
      closebuy();
     }

  }
//+------------------------------------------------------------------+
double ma(int PeriodMA, int shift)
  {
   return(iMA(Symbol(),Period(),PeriodMA,Shift,MAMethod,Applyto,shift));
  }
//+------------------------------------------------------------------+
bool BuySignal()
  {
   bool result = false;
   if((Close[Shift] < ma(PeriodMa,Shift)) && (Close[Shift] < ma(PeriodMa,Shift)) &&(Close[6] > ma(PeriodMa,Shift)))
     {
      if(Close[Shift] < Close[6])
        {
         result = true;
        }
     }
   return(result);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool SellSignal()
  {
   bool result = false;
   if(Close[Shift] > ma(PeriodMa,Shift) && (Close[Shift] > ma(PeriodMa,Shift)) &&(Close[6] < ma(PeriodMa,Shift)))
     {
      if(Close[Shift] > Close[6])
        {
         result = true;
        }
     }
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

   ticket = OrderSend(Symbol(),cmd,compound(),Price,Slipage,stoploss,takeprofit,EAComment,MagicNumber);

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
            if((OrderType() != OP_SELL))
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
            if((OrderType() != OP_BUY))
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
double compound()
  {
   double persen_modal = (AccountBalance()*1)/100;
   double aturan_lots = persen_modal/10/10;

   return(aturan_lots);
  }
//+------------------------------------------------------------------+
