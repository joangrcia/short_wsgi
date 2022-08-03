//+------------------------------------------------------------------+
//|                                                 BBMA LOGIC 1.mq4 |
//|                           Copyright 2022, NEXT TRADING EVOLUTION |
//|                                        YourSmartTradingEvolution |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, NEXT TRADING EVOLUTION"
#property link      "YourSmartTradingEvolution"
#property version   "1.00"

enum lmd {Multiple,Increase};

extern int     TakeProfit      = 20;
//extern bool    TPAveragingFirstOP = true;
//extern double  TargetProfit    = 10;
//extern double  MaxLoss         = 20;
extern double  Lots            = 0.01;
//extern lmd     LotMode         = Multiple;
//extern double  LotFactor       = 2;
extern int     MagicNumber     = 1234;
extern string  EAComment       = "Magic";

extern string info1 = "==============Marti Setting==============";
extern double   Lot_exponent      = 2;
extern int      PipStep           = 200;
extern int      MaxAveraging      = 15;

string  SettingMA = "-----------";
int     PeriodMA = 40;
int     Shift = 0;
ENUM_MA_METHOD MAMethod = MODE_SMMA;
ENUM_APPLIED_PRICE Applyto = PRICE_CLOSE;

string  SettingBB = "-------------";
int     PeriodBB = 20;
double  Deviation = 3;
int     ShiftBB = 0;
ENUM_APPLIED_PRICE ApplytoBB = PRICE_CLOSE;

int            PT              = 1,
               DIGIT,SlipPage;
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
   string comment = WindowExpertName();
   int ticket;
   if(OrdersTotal()==0)
     {
      if(ma(1)>bb(MODE_SIGNAL,1))
        {
         if(Close[1]<bb(MODE_LOWER,1) && Open[1]<bb(MODE_LOWER,1))
           {
            ticket = OrderSend(Symbol(),OP_BUY,Lots,Ask,SlipPage,0,Ask+TakeProfit*Point*10,EAComment,MagicNumber);
           }
        }

      if(ma(1)<bb(MODE_SIGNAL,1))
        {
         if(Close[1]>bb(MODE_UPPER,1) && Open[1]>bb(MODE_UPPER,1))
           {
            ticket = OrderSend(Symbol(),OP_SELL,Lots,Bid,SlipPage,0,Bid-TakeProfit*Point*10,EAComment,MagicNumber);
           }
        }
     }


   if(NewBar())
     {
      QnStart();
     }

  }
//+------------------------------------------------------------------+
double bb(int buf,int shift)
  {
   return(iBands(Symbol(),Period(),PeriodBB,Deviation,ShiftBB,ApplytoBB,buf,shift));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double ma(int shift)
  {
   return(iMA(Symbol(),Period(),PeriodMA,Shift,MAMethod,Applyto,shift));
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
