//+------------------------------------------------------------------+
//|                                                       Dinamo.mq4 |
//|                           Copyright 2022, NEXT TRADING EVOLUTION |
//|                                        YourSmartTradingEvolution |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, NEXT TRADING EVOLUTION"
#property link      "YourSmartTradingEvolution"
#property version   "2.00"

extern int TakeProfit = 0;
extern int StopLoss = 0;
extern double Lots = 0.01;
extern int MagicNumber = 30290;
extern int Slippage = 3;
string EAComment = "EA";
extern int Exit_Loss = 50;
extern string info1 = "==============Marti Setting==============";
extern double   Lot_exponent      = 2;
extern int      PipStep           = 200;
extern int      MaxAveraging      = 15;
extern string  info2 = "================== Time Filter ==================";
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

   ChartSetInteger(0,CHART_SHOW_GRID,false); // false to remove grid
   ChartSetInteger(0,CHART_MODE,CHART_CANDLES);
   HideTestIndicators(true);

   if(OrdersTotal()==0 && TradeTime() && NewBar())
     {
      if(ma(14,1)<ma(20,1))
        {
         if((rsi(14,1)<30) && (stoch(5,3,3,1)<20))
           {
            order(0);
           }
        }
      if(ma(14,1)>ma(20,1))
        {
         if((rsi(14,1)>70)&& (stoch(10,6,6,1)>80))
           {
            order(1);
           }
        }
     }
   QnStart();

   double qneq = AccountEquity();
   double qnbllnc = AccountBalance();
   double prft = qneq-qnbllnc;

   double qntrget = (Lots*TakeProfit)*10;

   double prsn = (-prft/AccountBalance())*100;

   if((prft>qntrget)||(prsn>=Exit_Loss))
     {
      CloseAll();
     }

  }
//+------------------------------------------------------------------+
double ma(int prd, int shift)
  {
   return(iMA(Symbol(),Period(),prd,0,MODE_SMA,PRICE_CLOSE,shift));
  }
//+------------------------------------------------------------------+
double rsi(int period, int shift)
  {
   return(iRSI(Symbol(),Period(),period,PRICE_CLOSE,shift));
  }
//+------------------------------------------------------------------+
double stoch(int kperiod, int dperiod, int slowperiod, int shift)
  {
   return(iStochastic(Symbol(),Period(),kperiod,dperiod,slowperiod,MODE_SMA,1,MODE_MAIN,shift));
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
   int ticket = OrderSend(Symbol(),myCom,myLots,price,0,0,0,EAComment,MagicNumber);
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
   double result=0;
   double tLots=0;
   double tPrice=0;
   int fDigits = (int)MarketInfo(Symbol(),MODE_DIGITS);
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
