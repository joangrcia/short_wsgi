//+------------------------------------------------------------------+
//       _____  _____   __  _________  ___  ____________  ______     |
//====  /  _/ |/ / _ | / / / ___/ __ \/ _ \/  _/_  __/  |/  / _ |    |
//==== _/ //    / __ |/ /_/ (_ / /_/ / , _// /  / / / /|_/ / __ |    |
//====/___/_/|_/_/ |_/____|___/\____/_/|_/___/ /_/ /_/  /_/_/ |_|    |
//
//+------------------------------------------------------------------+

#property copyright "Copyright 2022, INALGORITMA Software Corp."
#property link      "https://www.inalgoritmafx.com"
#property version   "1.00"

#include      <stdlib.mqh>
#import "Kernel32.dll"
void GetSystemTime(int& a0[]);

enum lmd {Multiple,Increase};

//=========================================================================================================================||
long     NomorAccount   = 0; //Ganti nomor account yang diijinkan disini. Isi dengan angka 0 jika ingin tanpa lock account
datetime Expired        = D'23.01.2030';   //Ganti tanggal expired disini
string   LockBroker     = "abc"; //Ganti nama broker disini. Isi dengan abc jika ingin tanpa lock
//=========================================================================================================================||

extern int     TakeProfit      = 20;
extern bool    TPAveragingFirstOP = true;
extern double  TargetProfit    = 10;
extern double  MaxLoss         = 20;
extern int     PipStep         = 20;
extern double  Lots            = 0.01;
extern lmd     LotMode         = Multiple;
extern double  LotFactor       = 2;

extern int     MagicNumber     = 12345;

string  SettingMA = "-----------";
int     PeriodMA = 14;
int     Shift = 0;
ENUM_MA_METHOD MAMethod = MODE_SMA;
ENUM_APPLIED_PRICE Applyto = PRICE_CLOSE;

string  SettingBB = "-------------";
int     PeriodBB = 20;
double  Deviation = 2;
int     ShiftBB = 0;
ENUM_APPLIED_PRICE ApplytoBB = PRICE_CLOSE;

extern string  info1 = "================== Time Filter ==================";
extern string  _6 = "— Trading Hours —";
extern bool    AutoGMTOffset = true;
extern double  ManualGMTOffset = 0;
extern bool    UseTradingHours = true;
extern bool    TradeAsianMarket = true;
extern double  StartTime1 = 03.00;
extern double  EndTime1 = 07.00;
extern bool    TradeEuropeanMarket = true;
extern double  StartTime2 = 07.00;
extern double  EndTime2 = 11.00;
extern bool    TradeNewYorkMarket = false;
extern double  StartTime3 = 12.00; // 8:00 EST
extern double  EndTime3 = 17.00;
int gmtoffset;
string gs_548 = "";

bool           ShowInfo        = true;
int            Corner          = 1;
int            PT              = 1,
               DIGIT,SlipPage;
double         POINT;
int            xnumb           = 2147483647;
datetime       timeTrade;
//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   SlipPage = 4;
   AutoDigit();
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   DelObject();
   Comment("");
  }
//+------------------------------------------------------------------+
//| Expert start function                                   |
//+------------------------------------------------------------------+
void OnTick()
  {
   if(!IsTesting() && AutoGMTOffset == TRUE)
      gmtoffset = TimeGMTOffset();
   else
      gmtoffset = ManualGMTOffset;
   string ls_52 = "Your Strategy is Running.";
   string ls_60 = "Your Strategy is set up for time zone GMT " + gmtoffset;
   string ls_76 = "Account Balance= " + DoubleToStr(AccountBalance(), 2);
   string ls_84 = " ";

   Comment("\n",
           "\n", " ",
           "\n", " ",
           "\n", " ", ls_52,
           "\n", " ", ls_60,
           "\n", " ", ls_76,
// “\n”, ” “, ls_77,
           "\n");

   if(IsDemo()==false)
     {
      return(0);
      Alert("For Demo Only");
     }

   if(IsTrade())
     {
      int eastate = 0;
      if(TimeCurrent() >= Expired)
        {
         Comment("EA Expired");
         eastate = 1;
        }
      if(AccountNumber()!=NomorAccount && NomorAccount > 0)
        {
         Comment("Wrong account");
         eastate = 1;
        }
      if(LockBroker != "abc" && LockBroker != AccountCompany())
        {
         Comment("Wrong broker - "+AccountCompany());
         eastate = 1;
        }
      if(eastate == 0)
        {
         if(TargetProfit > 0)
           {
            if(TotalProfit(0) >= TargetProfit)
              {
               while(TotalOrder(0) > 0)
                 {
                  CloseOrder(0);
                 }
              }

            if(TotalProfit(1) >= TargetProfit)
              {
               while(TotalOrder(1) > 0)
                 {
                  CloseOrder(1);
                 }
              }
           }

         if(MaxLoss > 0)
           {
            double ml = (AccountBalance()*MaxLoss)/100;
            if(TotalProfit() <= ml*-1)
              {
               while(TotalOrder()> 0)
                 {
                  CloseOrder();
                 }
              }
           }
         SetupTrade();
         av();
         settp();
         DisplayShow();
        }
     }

  }
//========================================

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void SetupTrade()
  {
   bool buy1   = ma(1) < bb(MODE_MAIN,1) && open(1) < bb(MODE_LOWER,1) && close(1) < bb(MODE_LOWER,1);
   bool sell1  = ma(1) > bb(MODE_MAIN,1) && open(1) > bb(MODE_UPPER,1) && close(1) > bb(MODE_UPPER,1);

   string comment = WindowExpertName();

   if(TotalOrder()==0 && TradeTime())
     {
      if(buy1)
        {
         Order(0,comment,AskPrice(),SetupLot());
        }
      if(sell1)
        {
         Order(1,comment,BidPrice(),SetupLot());
        }
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double ma(int shift)
  {
   return(iMA(Symbol(),Period(),PeriodMA,Shift,MAMethod,Applyto,shift));
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double bb(int buf,int shift)
  {
   return(iBands(Symbol(),Period(),PeriodBB,Deviation,ShiftBB,ApplytoBB,buf,shift));
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
datetime candleTime(int shift)
  {
   return(iTime(Symbol(),Period(),shift));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double open(int shift)
  {
   return(iOpen(Symbol(),Period(),shift));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double close(int shift)
  {
   return(iClose(Symbol(),Period(),shift));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double high(int shift)
  {
   return(iHigh(Symbol(),Period(),shift));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double low(int shift)
  {
   return(iLow(Symbol(),Period(),shift));
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double TotalPips()
  {
   double totalPip = 0, pip = 0;
   string date     = TimeToString(TimeCurrent(),TIME_DATE);

   for(int i = OrdersHistoryTotal()-1; i >= 0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY))
        {
         if(OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber)
           {
            if(StringFind(TimeToString(OrderCloseTime(),TIME_DATE),date) != -1)
              {
               if(OrderType() == OP_BUY)
                 {
                  pip = (OrderClosePrice()-OrderOpenPrice())/POINT;
                  totalPip += pip;
                 }

               if(OrderType() == OP_SELL)
                 {
                  pip = (OrderOpenPrice()-OrderClosePrice())/POINT;
                  totalPip += pip;
                 }
              }
           }
        }
     }

   return(totalPip);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int TotalOrder(int ordertype = -1)
  {
   int Order = 0;

   for(int i = 0; i < OrdersTotal(); i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if(OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber)
           {
            if(ordertype == -1)
               Order++;
            else
               if(ordertype == OrderType())
                  Order++;
           }
        }
     }

   return(Order);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double SetupLot()
  {
   double lot    = 0, firstLot = 0,
          MinLot = MarketInfo(Symbol(),MODE_MINLOT),
          MaxLot = MarketInfo(Symbol(),MODE_MAXLOT);

   for(int i = 0; i < OrdersTotal(); i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if(OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber)
           {
            lot = MathMax(lot,OrderLots());
           }
        }
     }

   lot = Lots;

   if(MinLot == 0.01)
      firstLot = NormalizeDouble(firstLot,2);
   else
      firstLot = NormalizeDouble(firstLot,1);

   if(lot == 0)
      lot = MinLot;

   if(lot < MinLot)
      lot = MinLot;
   if(lot > MaxLot)
      lot = MaxLot;

   if(MinLot == 0.01)
      lot = NormalizeDouble(lot,2);
   else
      lot = NormalizeDouble(lot,1);

   return(lot);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double AskPrice(string symbol = "")
  {
   if(symbol == "")
      symbol = Symbol();
   return(MarketInfo(symbol,MODE_ASK));
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double BidPrice(string symbol = "")
  {
   if(symbol == "")
      symbol = Symbol();
   return(MarketInfo(symbol,MODE_BID));
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int StopLevel(string symbol = "")
  {
   if(symbol == "")
      symbol = Symbol();
   return(MarketInfo(symbol,MODE_STOPLEVEL));
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string OrderCmd(int ordertype)
  {
   string label;

   switch(ordertype)
     {
      case 0:
         label = "Buy";
         break;
      case 1:
         label = "Sell";
         break;
      case 2:
         label = "Buy Limit";
         break;
      case 3:
         label = "Sell Limit";
         break;
      case 4:
         label = "Buy Stop";
         break;
      case 5:
         label = "Sell Stop";
         break;
     }

   return(label);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int Order(int ordertype, string comment, double price, double lot)
  {
   int             ticket;
   double          sl = 0, tp = 0;
   color           clrs = clrRed;

   if(ordertype == 0 || ordertype == OP_BUYSTOP || ordertype == OP_BUYLIMIT)
      clrs = clrBlue;

   if(TotalOrder(ordertype)==0)
     {
      if(ordertype == OP_BUY || ordertype == OP_BUYSTOP || ordertype == OP_BUYLIMIT)
        {
         if(TakeProfit > 0)
            tp = NormalizeDouble(price+(TakeProfit*POINT),DIGIT);
        }

      if(ordertype == OP_SELL || ordertype == OP_SELLSTOP || ordertype == OP_SELLLIMIT)
        {
         if(TakeProfit > 0)
            tp = NormalizeDouble(price-(TakeProfit*POINT),DIGIT);
        }
     }
   ticket = OrderSend(Symbol(),ordertype,lot,price,SlipPage,sl,tp,comment,MagicNumber,0,clrs);
   if(ticket == -1)
      ShowError("Order " + OrderCmd(ordertype));

   return(ticket);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CloseOrder(int ordertype = -1)
  {
   for(int i = OrdersTotal()-1; i >= 0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if(OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber)
           {
            if(ordertype == -1)
              {
               if(OrderType() == OP_BUY)
                 {
                  if(!OrderClose(OrderTicket(),OrderLots(),BidPrice(OrderSymbol()),SlipPage,Blue))
                     ShowError("Close " + OrderCmd(OrderType()));
                 }
               else
                  if(OrderType() == OP_SELL)
                    {
                     if(!OrderClose(OrderTicket(),OrderLots(),AskPrice(OrderSymbol()),SlipPage,Red))
                        ShowError("Close " + OrderCmd(OrderType()));
                    }
                  else
                    {
                     if(!OrderDelete(OrderTicket()))
                        ShowError("Delete Pending Order " + OrderCmd(OrderType()));
                    }
              }
            else
              {
               if(OrderType() == ordertype)
                 {
                  if(ordertype == OP_BUY)
                    {
                     if(!OrderClose(OrderTicket(),OrderLots(),BidPrice(OrderSymbol()),SlipPage,Blue))
                        ShowError("Close " + OrderCmd(OrderType()));
                    }
                  else
                     if(ordertype == OP_SELL)
                       {
                        if(!OrderClose(OrderTicket(),OrderLots(),AskPrice(OrderSymbol()),SlipPage,Red))
                           ShowError("Close " + OrderCmd(OrderType()));
                       }
                     else
                       {
                        if(!OrderDelete(OrderTicket()))
                           ShowError("Delete Pending Order " + OrderCmd(OrderType()));
                       }
                 }
              }
           }
        }
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double TotalProfit(int ordertype = -1)
  {
   double profit = 0;

   for(int i = 0; i < OrdersTotal(); i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if(OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber)
           {
            if(OrderType()==ordertype || ordertype == -1)
              {
               profit += OrderProfit()+OrderSwap()+OrderCommission();
              }
           }
        }
     }

   return(profit);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ShowError(string label)
  {
   string Error;
   int    error = GetLastError();

   Error        = StringConcatenate("Terminal: ",TerminalName(),"\n",
                                    label," error ",error,"\n",
                                    ErrorDescription(error));
   if(error > 2)
     {
      if(IsTesting())
         Comment(Error);
      else
         Alert(Error);
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void AutoDigit()
  {
   POINT = MarketInfo(Symbol(),MODE_POINT);
   DIGIT = MarketInfo(Symbol(),MODE_DIGITS);

   if(DIGIT == 3 || DIGIT == 5)
     {
      PT              = 10;

      TakeProfit     *= 10;
      PipStep        *= 10;
      SlipPage       *= 10;
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool IsTrade()
  {
   bool trade = true;

   if(!IsTesting())
     {
      if(!IsTradeAllowed())
        {
         Alert("Allow live trading is disable, press F7, \nselect Common tab, check Allow live trading");
         trade = false;
        }

      if(!IsExpertEnabled())
        {
         Alert("Expert Advisor is disable, click AutoTrading button to activate it ");
         trade = false;
        }
     }

   return(trade);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void DelObject(string objectName = "")
  {
   for(int i = ObjectsTotal()-1; i >= 0; i--)
     {
      if(StringFind(ObjectName(i),WindowExpertName()) != -1)
        {
         if(objectName == "")
            ObjectDelete(ObjectName(i));
         else
            if(StringFind(ObjectName(i),objectName) != -1)
               ObjectDelete(ObjectName(i));
        }
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void DisplayShow()
  {
   if(ShowInfo)
     {
      DisplayInfo("Balance",StringConcatenate("",DoubleToString(AccountBalance(),2)));
      if(AccountMargin() != 0)
         DisplayInfo("Equity",StringConcatenate("",DoubleToString(AccountEquity(),2)));
      if(AccountMargin() == 0)
         DisplayInfo("Equity",DoubleToStr(AccountBalance(),2));
      DisplayInfo("Spread",StringConcatenate("",MarketInfo(Symbol(),MODE_SPREAD)));
      if(AccountMargin() != 0)
        {
         DisplayInfo("Margin",StringConcatenate(DoubleToString((AccountEquity()/AccountMargin())*100,2),"%"));
        }
      if(AccountMargin() == 0)
        {
         DisplayInfo("Margin","-");
        }
      DisplayInfo("Profit",StringConcatenate("",DoubleToString(TotalProfit(),2)));
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void DisplayInfo(string name, string value)
  {
   color      LabelColor      = White,
              BackgroundColor = DarkGreen;
   string     Font            = "Arial", name1,name2,name3;
   int        FontSize        = 9,
              Space           = 15,
              X1,X2,X3;
   static int Y;

   if(name == "Balance")
      Y = 30;
   else
      Y += Space;
   if(Corner % 2 == 0)
     {
      X1 = 10;
      X2 = 70;
      X3 = 80;
     }
   else
     {
      X1 = 90;
      X2 = 80;
      X3 = 10;
     }

   if(name != "")
     {
      name1 = StringConcatenate(WindowExpertName(),name);
      name2 = StringConcatenate(WindowExpertName(),name,":");
      name3 = StringConcatenate(WindowExpertName(),name,"Value");

      ObjectDelete(name3);

      ObjectCreate(name1,OBJ_LABEL,0,0,0);
      ObjectCreate(name2,OBJ_LABEL,0,0,0);
      ObjectCreate(name3,OBJ_LABEL,0,0,0);

      ObjectSetText(name1,name,FontSize,Font, LabelColor);
      ObjectSetText(name2,":",FontSize,Font,LabelColor);
      ObjectSetText(name3,value,FontSize,Font,LabelColor);

      ObjectSet(name1,OBJPROP_CORNER,Corner);
      ObjectSet(name2,OBJPROP_CORNER,Corner);
      ObjectSet(name3,OBJPROP_CORNER,Corner);

      ObjectSet(name1,OBJPROP_XDISTANCE, X1);
      ObjectSet(name2,OBJPROP_XDISTANCE, X2);
      ObjectSet(name3,OBJPROP_XDISTANCE, X3);

      ObjectSet(name1,OBJPROP_YDISTANCE,Y);
      ObjectSet(name2,OBJPROP_YDISTANCE,Y);
      ObjectSet(name3,OBJPROP_YDISTANCE,Y);
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double last_price(int ordertype = -1)
  {
   int i;
   double price;
   for(i=0; i<OrdersTotal(); i++)
     {
      if(OrderSelect(i,SELECT_BY_POS))
         if(OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber)
           {
            if(ordertype == -1 || OrderType()==ordertype)
              {
               price = NormalizeDouble(OrderOpenPrice(),DIGIT);
              }
           }
     }
   return(price);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double last_lot(int ordertype = -1)
  {
   int i;
   double lot;
   for(i=0; i<OrdersTotal(); i++)
     {
      if(OrderSelect(i,SELECT_BY_POS))
         if(OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber)
           {
            if(ordertype == -1 || OrderType()==ordertype)
              {
               lot = OrderLots();
              }
           }
     }
   return(lot);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void av()
  {
   double price,lot;
   if(TotalOrder(0) > 0)
     {
      price = NormalizeDouble(last_price(0)-(PipStep*POINT),DIGIT);

      lot   = NormalizeDouble(last_lot(0),2);

      if(LotMode == Multiple)
        {
         lot   = NormalizeDouble(last_lot(0)*LotFactor,2);
         if(LotFactor > 1 && lot == last_lot(0))
           {
            lot+=0.01;
           }
        }

      if(LotMode == Increase)
        {
         lot = NormalizeDouble(last_lot(0)+LotFactor,2);
        }

      if(AskPrice() <= price)
        {
         Order(0,WindowExpertName(),AskPrice(),lot);
        }
     }

   if(TotalOrder(1) > 0)
     {
      price = NormalizeDouble(last_price(1)+(PipStep*POINT),DIGIT);
      lot   = NormalizeDouble(last_lot(1),2);

      if(LotMode == Multiple)
        {
         lot   = NormalizeDouble(last_lot(1)*LotFactor,2);
         if(LotFactor > 1 && lot == last_lot(1))
           {
            lot+=0.01;
           }
        }

      if(LotMode == Increase)
        {
         lot = NormalizeDouble(last_lot(1)+LotFactor,2);
        }

      if(BidPrice() >= price)
        {
         Order(1,WindowExpertName(),BidPrice(),lot);
        }
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void TPModif(int ordertype = -1, double price = 0)
  {
   bool q;
   int i;
   for(i=0; i<OrdersTotal(); i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if(OrderType()==ordertype && OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber && OrderTakeProfit()!=price)
            q = OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),price,OrderExpiration(),clrWhite);
        }
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double firstprice(int type)
  {
   double price = 0;
   datetime EarliestOrder = D'2099/12/31';

   for(int i = 0; i < OrdersTotal(); i++)
     {
      if(OrderSelect(i, SELECT_BY_POS))
        {
         if(OrderType() == type && OrderSymbol() == Symbol() && OrderMagicNumber()==MagicNumber)
           {
            if(EarliestOrder > OrderOpenTime())
              {
               EarliestOrder = OrderOpenTime();
               price = OrderOpenPrice();
              }
           }
        }
     }
   return(price);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void settp()
  {
   double price;
   if(TPAveragingFirstOP)
     {
      if(TotalOrder(0)> 1)
        {
         price = NormalizeDouble(firstprice(0),DIGIT);
         TPModif(0,price);
        }
      if(TotalOrder(1)> 1)
        {
         price = NormalizeDouble(firstprice(1),DIGIT);
         TPModif(1,price);
        }
     }

   if(!TPAveragingFirstOP)
     {
      if(TotalOrder(0)> 1)
        {
         TPModif(0,0);
        }
      if(TotalOrder(1) > 1)
        {
         TPModif(1,0);
        }
     }
  }
//+------------------------------------------------------------------+
int TradeTime()
  {
   if(!IsTesting() && AutoGMTOffset == TRUE)
      gmtoffset = TimeGMTOffset();
   else
      gmtoffset = ManualGMTOffset;
   int TradingTime=0;
   int CurrentHour=Hour(); // Server time in hours
   double CurrentMinute =Minute(); // Server time in minutes
   double CurrentTime=CurrentHour + CurrentMinute/100; // Current time
   double CurrentTime1 = CurrentTime + gmtoffset;

   if(CurrentTime1==0)
      CurrentTime=00;
   if(CurrentTime1<0)
      CurrentTime1 = CurrentTime1 + 24;
   if(CurrentTime1 >= 24)
      CurrentTime1 = CurrentTime1 - 24;

   if(UseTradingHours==true)
     {
      if(TradeAsianMarket==true)
        {
         if(StartTime1 < EndTime1)
           {
            if(CurrentTime1 >= StartTime1 && CurrentTime1 <= EndTime1)
               TradingTime=1;
           }

         if(StartTime1 > EndTime1)
           {
            if(CurrentTime1 >= StartTime1 || CurrentTime1 <= EndTime1)
               TradingTime=1;
           }
        }

      if(TradeEuropeanMarket==true)
        {
         if(StartTime2 < EndTime2)
           {
            if(CurrentTime1 >= StartTime2 && CurrentTime1 <= EndTime2)
               TradingTime=1;
           }

         if(StartTime2 > EndTime2)
           {
            if(CurrentTime1 >= StartTime2 || CurrentTime1 <= EndTime2)
               TradingTime=1;
           }
        }

      if(TradeNewYorkMarket==true)
        {
         if(StartTime3 < EndTime3)
           {
            if(CurrentTime1 >= StartTime3 && CurrentTime1 <= EndTime3)
               TradingTime=1;
           }

         if(StartTime3 > EndTime3)
           {
            if(CurrentTime1 >= StartTime3 || CurrentTime1 <= EndTime3)
               TradingTime=1;
           }
        }
     }

   else
      TradingTime=1;

   return(TradingTime);
  }
//+------------------------------------------------------------------+
