//+------------------------------------------------------------------+
//|                                                     Scientis.mq4 |
//|                           Copyright 2022, NEXT TRADING EVOLUTION |
//|                                        YourSmartTradingEvolution |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, NEXT TRADING EVOLUTION"
#property link      "YourSmartTradingEvolution"
#property version   "1.00"

extern int TakeProfit = 0;
extern int StopLoss = 0;
extern double Lots = 0.01;
extern int TrailingStop=50;
extern int MagicNumber = 30290;
extern int Slippage = 3;
string EAComment = "EA AUTOMA Z+";
int Range = 2;
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

   if(Hour()==9 && Minute()==0 && Seconds()==0)
     {
      if(Close[1] > ma1(1))
        {
         order(0);
        }
      if(Close[1] < ma1(1))
        {
         order(1);
        }
     }
   Comment("\nMA Distance : ", ma_distance());

  }
//+------------------------------------------------------------------+
string candle(int shift)
  {
   string parent="";
   if(Open[shift]<Close[shift])
      parent="Bullish";
   if(Open[shift]>Close[shift])
      parent="Bearish";

   return(parent);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double ma1(int shift)
  {
   return(iMA(Symbol(),Period(),23,0,MODE_EMA,PRICE_CLOSE,shift));
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double ma2(int shift)
  {
   return(iMA(Symbol(),Period(),46,0,MODE_SMMA,PRICE_CLOSE,shift));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int ma_distance()
  {
   double hma = MathMax(ma1(1),ma2(1));
   double lma = MathMin(ma1(1),ma2(1));
   int pipsMAsell = (int)MathFloor(MathAbs(hma-lma)/(_Point));

   return(pipsMAsell);
  }
//+------------------------------------------------------------------+
void trailing()
  {
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
                     //return(0);
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
                     //return(0);
                    }
                 }
              }
           }
        }
     }
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

   if(cmd == OP_BUYLIMIT)
     {
      Price = Ask-Range*Point*10;
      if(StopLoss>0)
        {
         stoploss = Price-StopLoss*Point*10;
        }
      if(TakeProfit>0)
        {
         takeprofit = Price+TakeProfit*Point*10;
        }
     }

   if(cmd == OP_SELLLIMIT)
     {
      Price = Bid+Range*Point*10;
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
