//+------------------------------------------------------------------+
//|                                                   average EA.mq4 |
//|                        Copyright 2022, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"

extern int      TakeProfit        = 50;
//input  int      StopLoss          = 100;
input  int      MagicNumber       = 168;
extern int      Slippage          = 3;
input  double   Lots              = 0.01;
extern string   EAComment         = "EA Jago";

//setting Marti
extern double   Lot_exponent      = 2;
extern int      PipStep           = 200;
extern int      MaxAveraging      = 10;
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


   int ticket;
   if(OrdersTotal()==0)
     {
      if(Open[1]>Close[1])
        {
         ticket = OrderSend(Symbol(),OP_BUY,Lots,Ask,Slippage,0,Ask+TakeProfit*MyPoint,EAComment,MagicNumber);
        }
      else
         if(Open[1]<Close[1])
           {
            ticket = OrderSend(Symbol(),OP_SELL,Lots,Bid,Slippage,0,Bid-TakeProfit*MyPoint,EAComment,MagicNumber);
           }
     }
   QnStart();

  }
//+------------------------------------------------------------------+
//check profit order terakhir dlm pips
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
      OrderModify(OrderTicket(),OrderOpenPrice(),0,myTP,0);
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
         || (myType!=-1 && OrderType()!=myType))continue;
         tPrice+=OrderOpenPrice() * Lots;
         tLots+=OrderLots();
     }
     if(tLots>0 && tPrice>0) result=NormalizeDouble(tPrice/tLots, fDigits);
     return(result);
  }
//+------------------------------------------------------------------+
