//+------------------------------------------------------------------+
//|                                                     cobacoba.mq4 |
//|                        Copyright 2022, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright ©Next X Trading2022."
#property link      "Your Smart Trading Evolution"
#property version   "1.67"
#property icon "X-Logo.ico"

extern int TakeProfit = 20;
//extern int StopLoss = 30;
extern double Lots = 0.01;
extern int MagicNumber = 30290;
extern int Exit_Loss = 50;
extern bool auto_compound = false;
string EAComment = "EA AUTOMA Z+";
extern int std = 30;
extern int std2 = 55;
extern string info1 = "==============Marti Setting==============";
extern double   Lot_exponent      = 2;
extern int      PipStep           = 200;
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
extern string  info3 = "================== Time Filter ==================";
extern string  _6 = "— Trading Hours —";
extern bool    AutoGMTOffset = TRUE;
extern double  ManualGMTOffset = 0;
extern bool    UseTradingHours = true;
extern bool    TradeAsianMarket = true;
extern double  StartTime1 = 22.00;
extern double  EndTime1 = 07.00;
extern bool    TradeEuropeanMarket = true;
extern double  StartTime2 = 07.00;
extern double  EndTime2 = 12.00;
extern bool    TradeNewYorkMarket = true;
extern double  StartTime3 = 12.00; // 8:00 EST
extern double  EndTime3 = 17.00;
int gmtoffset;
string gs_548 = "";
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

   HideTestIndicators(false);

   double MyPoint=Point;
   if(Digits==3 || Digits==5)
      MyPoint=Point*10;

   if(auto_compound)
     {
      if((AccountBalance()>=3000)&&(AccountBalance()<=5000))
        {
         Lots = 0.01;
        }
      else
         if((AccountBalance()>=5000)&&(AccountBalance()<=10000))
           {
            Lots = 0.01;
           }
         else
            if((AccountBalance()>=10000)&&(AccountBalance()<=15000))
              {
               Lots = 0.02;
              }
            else
               if((AccountBalance()>=15000)&&(AccountBalance()<=20000))
                 {
                  Lots = 0.03;
                 }
               else
                  if((AccountBalance()>=20000)&&(AccountBalance()<=25000))
                    {
                     Lots = 0.04;
                    }
                  else
                     if((AccountBalance()>=25000)&&(AccountBalance()<=30000))
                       {
                        Lots = 0.05;
                       }
     }

   double qneq = AccountEquity();
   double qnbllnc = AccountBalance();
   double prft = qneq-qnbllnc;

   double qntrget = (Lots*TakeProfit)*10;

   double l_ibans_0 = iBands(NULL,0,std,2,0,PRICE_CLOSE,MODE_UPPER,0);
   double l_ibans_1 = iBands(NULL,0,std,2,0,PRICE_CLOSE,MODE_LOWER,0);
   double l_ibans_2 = iBands(NULL,0,std,2,0,PRICE_CLOSE,MODE_MAIN,0);
   double l_ima_0 = iMA(NULL,0,std2,0,MODE_SMA,PRICE_CLOSE,0);
   double l_ima_1 = iMA(NULL,0,std2,0,MODE_SMA,PRICE_CLOSE,2);
   static string crt="none";

   if(l_ima_0-l_ibans_0>0|| l_ima_0-l_ibans_1<0)
     {
      crt="OK";
     }
   int ticket;
   if(OrdersTotal()==0 && (DaytoTrade()) && (TradeTime()))
     {
      if((crt=="OK"&&l_ima_0<l_ibans_0 && l_ima_0>l_ibans_1))
        {
         if(l_ima_0<l_ibans_2 && (Bid >= l_ibans_0))
           {
            ticket = OrderSend(Symbol(),OP_BUY,Lots,Ask,3,0,Ask+TakeProfit*Point*10,EAComment,MagicNumber);
           }
         else
            if(l_ima_0>l_ibans_2 && (Bid <= l_ibans_1))
              {
               ticket = OrderSend(Symbol(),OP_SELL,Lots,Bid,3,0,Bid-TakeProfit*Point*10,EAComment,MagicNumber);
              }
        }
     }
   if(OrdersTotal()>0)
     {
      crt="none";
     }
   if(NewBar())
     {
      QnStart();
     }
   double prsn = (-prft/AccountBalance())*100;


   if((prft>=qntrget)
      ||(prsn>=Exit_Loss)
     )
     {
      CloseAll();
     }

// do not work on holidays.
   DaytoTrade();

   Comment("Moment : ", qntrget);

  }
//+------------------------------------------------------------------+
int QnAveraging()
  {
   int result = 0;
   for(int i=OrdersTotal()-1; i>=0; i--)
     {
      if(!OrderSelect(i,SELECT_BY_POS)
         || OrderSymbol()!=Symbol()
         || OrderType()>1
         || OrderMagicNumber()!=MagicNumber)
         continue; //continue = lanjut ke urutan berikutnya
      //yg pertama dicheck di sini pasti order yang dibuat terakhir
      if(OrderProfit()>0)
         break;
      //hitung minusnya
      int profit = 0;
      if(OrderType()==OP_BUY)
        {
         profit = QnPips(OrderClosePrice(),OrderOpenPrice());
        }
      else
        {
         profit = QnPips(OrderOpenPrice(),OrderClosePrice());
        }
      if(profit<=-PipStep)
        {
         //lakukan averaging
         double myLots = NormalizeDouble((OrderLots()*Lot_exponent),2);
         QnOrder3(OrderType(),myLots);
        }
      break;
     }
   return(result);
  }
//=============================================================
void QnOrder3(int myCom, double myLots)
  {
   double pTP = 0;
//double pTp = qnAveragingPrice(MagicNumber,OrderType());
   double price = 0;
   if(myCom==OP_BUY)
     {
      price = Ask;
      pTP = qnAveragingPrice(MagicNumber,myCom);
     }
   if(myCom==OP_SELL)
     {
      price = Bid;
      pTP = qnAveragingPrice(MagicNumber,myCom);
     }
   int ticket = OrderSend(Symbol(),myCom,myLots,price,0,0,pTP,EAComment,MagicNumber);
   if(ticket>0)
     {
      QnModifyTP(myCom,pTP);
     }
  } ///*///
//=============================================================
int QnTotalOrder()
  {
   int result=0;
   for(int i=OrdersTotal()-1; i>=0; i--)
     {
      if(!OrderSelect(i,SELECT_BY_POS)
         || OrderSymbol()!= Symbol()
         || OrderType()>1
         || OrderMagicNumber()!=MagicNumber)
         continue; //continue = lanjut ke urutan berikutnya
      result++;
     }
   return(result);
  }
//=============================================================
void QnModifyTP(int myCom,double myTP)
  {
   for(int i=OrdersTotal()-1; i>=0; i--)
     {
      if(!OrderSelect(i,SELECT_BY_POS)
         || OrderSymbol()!= Symbol()
         || OrderType()!=myCom
         || OrderMagicNumber()!=MagicNumber)
         continue; //continue = lanjut ke urutan berikutnya
      //modifikasi order sesuai dengan myTP
      int bkp = OrderModify(OrderTicket(),OrderOpenPrice(),0,myTP,0);
     }
  }
//=============================================================
void QnStart()
  {
   int tOrder = QnTotalOrder();
   if(tOrder>=MaxAveraging)
      return;
   QnAveraging();

  }
//=============================================================
int QnPips(double n1, double n2)
  {
//sekumpulan perintah
   int result =  int(MathRound((n1-n2)/Point()));
   return(result);
  }
//=============================================================
double qnAveragingPrice(int myMagic = 0, int myType=-1)
  {
   double result, tLots,tPrice;
   int fDigits = MarketInfo(Symbol(),MODE_DIGITS);
   for(int i=OrdersTotal()-1; i>=0; i--)
     {
      if(!OrderSelect(i,SELECT_BY_POS,MODE_TRADES)
         || (myMagic!=0 && OrderMagicNumber()!=myMagic)
         || (OrderSymbol()!=Symbol())
         || (OrderType()>1)
         || (myType!=-1 && OrderType()!=myType))
         continue;
      tPrice+=OrderOpenPrice() * OrderLots();
      tLots+=OrderLots();
     }
   if(tLots>0 && tPrice>0)
      result=NormalizeDouble(tPrice/tLots, fDigits);
   return(result);
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
//+------------------------------------------------------------------+
