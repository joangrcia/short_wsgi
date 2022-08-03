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
extern bool NFP_Friday = false;
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
   double MyPoint=Point;
   if(Digits==3 || Digits==5)
      MyPoint=Point*10;

   double qneq = AccountEquity();
   double qnbllnc = AccountBalance();
   double prft = qneq-qnbllnc;

//double qntrget = (Lots*TakeProfit)*10;

   if((OrdersTotal()==0) && (DailyProfit()==0) && (DaytoTrade()) && fbd()<=6)
     {
      if(TimeHour(Time[1])==2)
        {
         if(Close[1]>ODP())
           {
            OrderSend(Symbol(),OP_BUY,Lots,Ask,3,0,Ask+TakeProfit*Point*10,EAComment,MagicNumber);
           }
         else
            if(Close[1]<ODP())
              {
               OrderSend(Symbol(),OP_SELL,Lots,Bid,3,0,Bid-TakeProfit*Point*10,EAComment,MagicNumber);
              }
        }
     }


//if()

   Comment("ODP : ", ODP(), "\nDaily Profit : \n", DailyProfit(), "Last Price Close : ",
           QnPriceLastOrder(), "\nKonfirmasi Switch : ", Konf_sw(), "\nLsat Profit : ", fbd());
// do not work on holidays.
   DaytoTrade();
//QnStart();

   double prsn = (-prft/AccountBalance())*100;
   closebuy();
   closesell();

   /*if((prft>qntrget&&OrdersTotal()>=7)
   //||(prsn>=50)
     )
     {
      CloseAll();
     }*/

  }
//+------------------------------------------------------------------+
double ODP()
  {
   double odp;
   for(int i=0; i<24; i++)
     {
      if(TimeHour(Time[i]) == 1)
        {
         odp = Open[i];
        }
     }
   return(odp);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double fbd()
  {
   double odp;
   for(int i=0; i<24; i++)
     {
      if(TimeHour(Time[i]) == 1)
        {
         double ohigh = MathMax(Open[i],Close[i]);
         double olow = MathMin(Open[i],Close[i]);
         odp = MathRound(ohigh-olow);
        }
     }
   return(MathAbs(odp));
  }
//+------------------------------------------------------------------+
double DailyProfit()
  {
   double profit = 0;
   int i,hstTotal=OrdersHistoryTotal();
   for(i=0; i<hstTotal; i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)==TRUE)
        {
         if(TimeToStr(TimeLocal(),TIME_DATE) == TimeToStr(OrderCloseTime(),TIME_DATE))
           {
            profit += OrderProfit() + OrderSwap() + OrderCommission();
           }
        }
     }
//Alert(profit);
   return(profit);
  }
//+------------------------------------------------------------------+
bool DaytoTrade()
  {
   bool daytotrade = false;

   if(DayOfWeek() == 0 && Sunday)
      daytotrade = true;
   if(DayOfWeek() == 1 && Monday)
      daytotrade = true;
   if(DayOfWeek() == 2 && Tuesday)
      daytotrade = true;
   if(DayOfWeek() == 3 && Wednesday)
      daytotrade = true;
   if(DayOfWeek() == 4 && Thursday)
      daytotrade = true;
   if(DayOfWeek() == 5 && Friday)
      daytotrade = true;
   if(DayOfWeek() == 5 && Day() < 8 && !NFP_Friday)
      daytotrade = false;
   if(DayOfWeek() == 1 && (Day()<12&&Day()>4) && !NFP_ThursdayBefore)
      daytotrade = false;
   if(Month() == 12 && Day() > XMAS_DayBeginBreak && !ChristmasHolidays)
      daytotrade = false;
   if(Month() == 1 && Day() < NewYears_DayEndBreak && ! NewYearsHolidays)
      daytotrade = false;

   return(daytotrade);
  }
//=============================================================
int QnPriceLastOrder()
  {
   datetime last_close  = 0;
   double   close_price = 0;
   for(int i=OrdersHistoryTotal()-1; i>=0; i--)
     {
      if(!OrderSelect(i,SELECT_BY_POS,MODE_HISTORY))
         continue;
      if(OrderSymbol() != _Symbol)
         continue;
      // if(OrderMagicNumber() != magic_no) continue;
      datetime close_time = OrderCloseTime();
      if(close_time > last_close)
        {
         last_close  = close_time;
         close_price = OrderClosePrice();
        }
     }
   return(close_price);
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
            if((OrderType() != OP_SELL) && (Close[1]<ODP()) && (Konf_sw()>10))
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
            if((OrderType() != OP_BUY)&&(Close[1]>ODP())&& (Konf_sw()>10))
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
//|                                                                  |
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
double Konf_sw()
  {
   double konf_sw = 0;
   double qcloser = MathMax(Close[1],ODP());
   double qcloser2 = MathMin(Close[1],ODP());
   konf_sw = MathRound((qcloser - qcloser2)*10);

   return(konf_sw);
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
