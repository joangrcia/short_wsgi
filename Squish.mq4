//+------------------------------------------------------------------+
//|                                                       Squish.mq4 |
//|                           Copyright 2022, NEXT TRADING EVOLUTION |
//|                                        YourSmartTradingEvolution |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, NEXT TRADING EVOLUTION"
#property link      "YourSmartTradingEvolution"
#property version   "1.00"

extern int TakeProfit = 250;
extern int StopLoss = 250;
extern double Lots = 0.01;
extern int TrailingStop=70;
extern int sr_range = 50;
extern int slow_range = 35;
extern int fast_range = 70;
extern int MagicNumber = 30290;
string EAComment = "EA AUTOMA Z+";
extern string info1 = "==============Marti Setting==============";
extern double   Lot_exponent      = 2;
extern int      PipStep           = 250;
extern int      MaxAveraging      = 15;
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

   double QnMH = iMACD(NULL,0,9,69,20,PRICE_CLOSE,MODE_MAIN,0);
   double QnML = iMACD(NULL,0,9,69,20,PRICE_CLOSE,MODE_MAIN,3);
   double QnMA = iMA(NULL,0,10,0,MODE_EMA,PRICE_CLOSE,0);
//double QnMA1 = iMA(NULL,0,1000,0,MODE_EMA,PRICE_CLOSE,2);
//double QnMH1 = iMA(NULL,0,1000,0,MODE_EMA,PRICE_HIGH,3);

   static string crt="none";
   static string crs="none";

   /*
      if((Close[1]<QnMH&&Close[1]>QnML) && (Open[1]<QnMH&&Open[1]>QnML))
        {
         crt="OK";
        }*/

   int ticket;
   if(OrdersTotal()==0)
     {
      if((QnMH> 0) && (Close[1] > QnMA) && (QnML < 0))
        {
         ticket = OrderSend(Symbol(),OP_BUY,Lots,Ask,3,0,Ask+TakeProfit*MyPoint,EAComment,MagicNumber);
        }
      if((QnMH<0) && (Close[1] < QnMA) && (QnML > 0))
        {
         ticket = OrderSend(Symbol(),OP_SELL,Lots,Bid,3,0,Bid-TakeProfit*MyPoint,EAComment,MagicNumber);
        }
     }

   /*
   if(OrdersTotal()>0)
     {
      crt="none";
      crs="none";
     }*/

   QnStart();

//====================================================================
//Trailing Stop
//====================================================================

   for(int cnt=0; cnt<OrdersTotal(); cnt++)
     {
      OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      if(OrderType()<=OP_SELL &&
         OrderSymbol()==Symbol() &&
         OrderMagicNumber()==MagicNumber
        )
        {
         if(OrderType()==OP_BUY)
           {
            if(TrailingStop>0)
              {
               if(Bid-OrderOpenPrice()>MyPoint*TrailingStop)
                 {
                  if(OrderStopLoss()<Bid-MyPoint*TrailingStop)
                    {
                     OrderModify(OrderTicket(),OrderOpenPrice(),Bid-TrailingStop*MyPoint,OrderTakeProfit(),0,Green);
                     return(0);
                    }
                 }
              }
           }
         else
           {
            if(TrailingStop>0)
              {
               if((OrderOpenPrice()-Ask)>(MyPoint*TrailingStop))
                 {
                  if((OrderStopLoss()>(Ask+MyPoint*TrailingStop)) || (OrderStopLoss()==0))
                    {
                     OrderModify(OrderTicket(),OrderOpenPrice(),Ask+MyPoint*TrailingStop,OrderTakeProfit(),0,Red);
                     return(0);
                    }
                 }
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
