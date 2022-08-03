//+------------------------------------------------------------------+
//|                                                       bielsa.mq4 |
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
string EAComment = "EA";
extern string info1 = "==============Marti Setting==============";
extern double   Lot_exponent      = 2;
extern int      PipStep           = 200;
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
   HideTestIndicators(true);
   ChartSetInteger(0,CHART_SHOW_GRID,false); // false to remove grid
   ChartSetInteger(0,CHART_MODE,CHART_CANDLES);

   if(OrdersTotal()==0)
     {
      if(Close[1] > kumo_a())
        {
         if(Close[1]>bb(MODE_UPPER,1) && Open[1]>bb(MODE_UPPER,1) && ma(1)<bb(MODE_SIGNAL,1))
           {
            order(0);
           }
        }
     }
     QnStart();

  }
//+------------------------------------------------------------------+
double bb(int mode, int shift)
  {
   return(iBands(Symbol(),Period(),30,2,0,PRICE_CLOSE,mode,shift));
  }
//+------------------------------------------------------------------+
double ma(int shift)
  {
   return(iMA(Symbol(),Period(),40,0,MODE_SMMA,PRICE_CLOSE,shift));
  }
//+------------------------------------------------------------------+
double kumo_a()
  {
   return(iIchimoku(NULL, 0, 7, 22, 44, MODE_SENKOUSPANA, -22));
  }
//+------------------------------------------------------------------+
double kumo_b()
  {
   return(iIchimoku(NULL, 0, 7, 22, 44, MODE_SENKOUSPANB, -22));
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
   double autosl;
   if(cmd==0)
     {
      autosl=Low[1];
     }
   if(cmd==1)
     {
      autosl=High[1];
     }

   ticket = OrderSend(Symbol(),cmd,Lots,Price,Slipage,stoploss,takeprofit,EAComment,MagicNumber);

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
