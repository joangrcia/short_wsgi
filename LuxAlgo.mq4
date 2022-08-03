//+------------------------------------------------------------------+
//|                                                      Indomie.mq4 |
//|                           Copyright 2022, NEXT TRADING EVOLUTION |
//|                                        YourSmartTradingEvolution |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, NEXT TRADING EVOLUTION"
#property link      "YourSmartTradingEvolution"
#property version   "1.00"

enum lme
  {
   e = 1, //Normal
   f = 2, //Multiple
   g = 3, //increase
  };

extern int TakeProfit = 30;
extern int StopLoss = 70;
extern int                TrailingStop               = 0;
extern lme                Lot_Mode                   = 1;
extern int QnPeriod = 10;
extern double Lots = 0.01;
extern int MagicNumber = 30290;
extern int Slippage = 3;
string EAComment = "EA";

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

   ChartSetInteger(0,CHART_SHOW_GRID,false); // false to remove grid
   ChartSetInteger(0,CHART_MODE,CHART_CANDLES);

   if(OrdersTotal()==0)
     {
      if((stoch(10,6,6,2) > 80 && stoch(10,6,6,1) < 80) && (rsi(14,2) > 70 && rsi(14,1) < 70) && (Close[1] > tema(45,1)))
        {
         order(0);
        }
      if((stoch(10,6,6,2) < 20 && stoch(10,6,6,1) > 20) && (rsi(14,2) < 30 && rsi(14,1) > 30) && (Close[1] < tema(45,1)))
        {
         order(1);
        }
     }
   Trailing();
  }
//+------------------------------------------------------------------+
string CheckCandle(int shift = 1)
  {
   string result;
   if(Open[shift] < Close[shift])
      result="Bullish";
   if(Open[shift] > Close[shift])
      result="Bearish";
   return(result);
  }
//+------------------------------------------------------------------+
double stoch(int kperiod, int dperiod, int slowperiod, int shift)
  {
   return(iStochastic(Symbol(),Period(),kperiod,dperiod,slowperiod,MODE_SMA,1,MODE_MAIN,shift));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double rsi(int period, int shift)
  {
   return(iRSI(Symbol(),Period(),period,PRICE_CLOSE,shift));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double tema(int period, int shift)
  {
   return(iCustom(Symbol(),Period(),"TEMA",period,0,shift));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double dema(int period, int shift)
  {
   return(iCustom(Symbol(),Period(),"DEMA",period,0,shift));
  }
//+------------------------------------------------------------------+
bool BulEngulfing()
  {
   bool result=false;
   if((High[2] < High[1])&&(Low[2] > Low[1])&&(CheckCandle(2)=="Bearish")&&((CheckCandle()=="Bullish")))
      result=true;
   return(result);
  }
//+------------------------------------------------------------------+
bool BerEngulfing()
  {
   bool result=false;
   if((High[2] < High[1])&&(Low[2] > Low[1])&&(CheckCandle(2)=="Bullish")&&((CheckCandle()=="Bearish")))
      result=true;
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

   ticket = OrderSend(Symbol(),cmd,LotMod(),Price,Slippage,stoploss,takeprofit,EAComment,MagicNumber);

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Trailing()
  {

   double MyPoint=Point;
   if(Digits==3 || Digits==5)
      MyPoint=Point*10;

   for(int cnt=0; cnt<OrdersTotal(); cnt++)
     {
      int kr = OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
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
                     int re = OrderModify(OrderTicket(),OrderOpenPrice(),Bid-TrailingStop*MyPoint,OrderTakeProfit(),0,Green);
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
                     int yu = OrderModify(OrderTicket(),OrderOpenPrice(),Ask+MyPoint*TrailingStop,OrderTakeProfit(),0,Red);
                     //return(0);
                    }
                 }
              }
           }
        }
     }
  }
//+------------------------------------------------------------------+
double LotMod()
  {
   double hasil = Lots;
   double increase;

   if(LastOrderLots()<0.1 && LastOrderLots()>=0.01)
     {
      increase = 0.01;
     }
   if(LastOrderLots()<1 && LastOrderLots()>=0.1)
     {
      increase = 0.1;
     }
   if(LastOrderLots()<10 && LastOrderLots()>=1)
     {
      increase = 1;
     }
   if(LastOrderClosedProfit()<0)
     {
      if(Lot_Mode == 2)
        {
         hasil = LastOrderLots()*2;
        }
      else
         if(Lot_Mode == 3)
           {
            hasil = LastOrderLots()+increase;
           }
     }
   return(hasil);
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
