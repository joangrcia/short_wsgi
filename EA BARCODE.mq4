//+------------------------------------------------------------------+
//|                                                   EA BARCODE.mq4 |
//|                           Copyright 2022, NEXT TRADING EVOLUTION |
//|                                        YourSmartTradingEvolution |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, Trader Vibes"
#property link      "Trader Vibes"
#property version   "2.70"

enum lmd
  {
   a = 1, //1:1
   b = 2, //1:2
   c = 3, //1:3
   d = 4 // sl/tp custom
  };
enum lme
  {
   e = 1, //Normal
   f = 2, //Multiple
   g = 3, //increase
  };

enum lmf
  {
   h = 1, //Trend Swing
   i = 2, //Actual Trend
   j = 3, //Trend Swing + Actual Trend
  };


//=========================================================================================================================||
long     NomorAccount   = 0; //Ganti nomor account yang diijinkan disini. Isi dengan angka 0 jika ingin tanpa lock account
datetime Expired        = D'23.01.2030';   //Ganti tanggal expired disini
string   LockBroker     = "abc"; //Ganti nama broker disini. Isi dengan abc jika ingin tanpa lock
//=========================================================================================================================||


extern string             rrsetting                  = "R I S K   R E W A R D   S E T T I N G";
extern string             lrt                        = "=== Kosongkan SL/TP jika ingin menggunakan auto RR ===";
extern lmd                RR_MODE                    = 1;
extern int                TakeProfit                 = 0;
extern int                StopLoss                   = 0;
extern bool               Reverse_Order              = false;
extern string             lotssetting                = "L O T S  S E T T I N G";
extern lme                Lot_Mode                   = 1;
extern double             Lots                       = 0.01;
string                    EAComment                  = "EA Barcode";
extern int                TrailingStop               = 0;
extern string             info_2                     = "I N D I C A T O R   S E T T I N G";
extern bool               HideIndicator              = false;
extern lmf                Set_Indicator              = 1;
extern string             mcd                        = "=== MACD ===";
extern int                Fast                       = 50;
extern int                Slow                       = 100;
extern int                mcd_sma                    = 9;
extern string             MA                         = "=== MA 1 ===";
extern int                maPeriod1                  = 5;
extern ENUM_MA_METHOD     maMode1                    = MODE_SMMA;
extern ENUM_APPLIED_PRICE maPrice1                   = PRICE_CLOSE;
extern string             MA24                       = "=== MA 2 ===";
extern int                maPeriod2                  = 24;
extern ENUM_MA_METHOD     maMode2                    = MODE_EMA;
extern ENUM_APPLIED_PRICE maPrice2                   = PRICE_CLOSE;
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
extern int                MagicNumber                = 30290;
extern int                Slippage                   = 3;
int gmtoffset;
string gs_548 = "";

int Range = 50;
int Qnbuy = 0;
int Qnsell = 1;
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
   HideTestIndicators(HideIndicator);

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
     }

   if(Reverse_Order)
     {
      Qnbuy = 1;
      Qnsell = 0;
     }

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

//if((macd(PRICE_CLOSE,MODE_MAIN,2)<macd(PRICE_CLOSE,MODE_SIGNAL,2)) && (macd(PRICE_CLOSE,MODE_MAIN,1)>macd(PRICE_CLOSE,MODE_SIGNAL,1)))

   if(TotalOrder()==0 && TradeTime() && NewBar())
     {
      if(Set_Indicator == 1)
        {
         trendswing();
        }
      else
         if(Set_Indicator == 2)
           {
            actualtrend();
           }
         else
            if(Set_Indicator == 3)
              {
               both();
              }
     }

   Trailing();
  }
//+------------------------------------------------------------------+
double macd(int macd_price,int macd_mode,int shift)
  {
   return(iMACD(NULL,0,Fast,Slow,mcd_sma,macd_price,macd_mode,shift));
  }
//+------------------------------------------------------------------+
double ma(int prd, int ma_mode, int ma_price, int shift)
  {
   return(iMA(Symbol(),Period(),prd,0,ma_mode,ma_price,shift));
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
void both()
  {
//BUY SETUP
   if(macd(PRICE_CLOSE,MODE_MAIN,1)>0)
     {
      if((macd(PRICE_CLOSE,MODE_MAIN,1)>macd(PRICE_CLOSE,MODE_SIGNAL,1)))
        {
         if(ma(maPeriod1,maMode1,maPrice1,1)>ma(maPeriod2,maMode2,maPrice2,1))
           {
            if(close(2)<ma(maPeriod1,maMode1,maPrice1,1) && close(1)>ma(maPeriod1,maMode1,maPrice1,1))
              {
               order(Qnbuy);
              }

           }
        }
     }
//SELL SETUP
   if(macd(PRICE_CLOSE,MODE_MAIN,1)<0)
     {
      if((macd(PRICE_CLOSE,MODE_MAIN,1)<macd(PRICE_CLOSE,MODE_SIGNAL,1)))
        {
         if(ma(maPeriod1,maMode1,maPrice1,1)<ma(maPeriod2,maMode2,maPrice2,1))
           {
            if(close(2)>ma(maPeriod1,maMode1,maPrice1,1) && close(1)<ma(maPeriod1,maMode1,maPrice1,1))
              {
               order(Qnsell);
              }
           }
        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void trendswing()
  {
//BUY SETUP
   if((macd(PRICE_CLOSE,MODE_MAIN,1)>macd(PRICE_CLOSE,MODE_SIGNAL,1)))
     {
      if(ma(maPeriod1,maMode1,maPrice1,1)>ma(maPeriod2,maMode2,maPrice2,1))
        {
         if(close(2)<ma(maPeriod1,maMode1,maPrice1,1) && close(1)>ma(maPeriod1,maMode1,maPrice1,1))
           {
            order(Qnbuy);
           }

        }
     }
//SELL SETUP
   if((macd(PRICE_CLOSE,MODE_MAIN,1)<macd(PRICE_CLOSE,MODE_SIGNAL,1)))
     {
      if(ma(maPeriod1,maMode1,maPrice1,1)<ma(maPeriod2,maMode2,maPrice2,1))
        {
         if(close(2)>ma(maPeriod1,maMode1,maPrice1,1) && close(1)<ma(maPeriod1,maMode1,maPrice1,1))
           {
            order(Qnsell);
           }
        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void actualtrend()
  {
//BUY SETUP
   if(macd(PRICE_CLOSE,MODE_MAIN,1)>0)
     {
      if(ma(maPeriod1,maMode1,maPrice1,1)>ma(maPeriod2,maMode2,maPrice2,1))
        {
         if(close(2)<ma(maPeriod1,maMode1,maPrice1,1) && close(1)>ma(maPeriod1,maMode1,maPrice1,1))
           {
            order(Qnbuy);
           }

        }
     }
//SELL SETUP
   if(macd(PRICE_CLOSE,MODE_MAIN,1)<0)
     {
      if(ma(maPeriod1,maMode1,maPrice1,1)<ma(maPeriod2,maMode2,maPrice2,1))
        {
         if(close(2)>ma(maPeriod1,maMode1,maPrice1,1) && close(1)<ma(maPeriod1,maMode1,maPrice1,1))
           {
            order(Qnsell);
           }
        }
     }
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
//|                                                                  |
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
//|                                                                  |
//+------------------------------------------------------------------+
double Resistance(int shift)
  {
   int QnHigest = iHighest(Symbol(),Period(),MODE_HIGH,shift,0);
   return(high(QnHigest));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double Support(int shift)
  {
   int QnLowest = iLowest(Symbol(),Period(),MODE_LOW,shift,0);
   return(low(QnLowest));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int QnSupportRange()
  {
   double hasil = QnPips(Close[1],Support(20));
   return(hasil);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int QnResistanaceRange()
  {
   double hasil = QnPips(Resistance(20),Close[1]);
   return(hasil);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int QnPips(double n1, double n2)
  {
//sekumpulan perintah
   int result =  int(MathRound((n1-n2)/Point()));
   return(result);
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
int Rasio()
  {
   int fxma;
   if(RR_MODE == 1)
     {
      fxma = 1;
     }
   if(RR_MODE == 2)
     {
      fxma = 2;
     }
   if(RR_MODE == 3)
     {
      fxma = 3;
     }
   return(fxma);
  }
//+------------------------------------------------------------------+
//|                                                                  |
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
void order(int cmd)
  {

   double MyPoint=Point;
   if(Digits==3 || Digits==5)
      MyPoint=Point*10;

   double Price;
   double stoploss = 0;
   double takeprofit = 0;
   int ticket;
   if(cmd == OP_BUY)
     {
      Price = Ask;
      if(StopLoss>0)
        {
         stoploss = Price-StopLoss*MyPoint;
        }
      else
        {
         stoploss = Support(20);
        }
      if(TakeProfit>0)
        {
         takeprofit = Price+TakeProfit*MyPoint;
        }
      else
        {
         takeprofit = Price+(QnSupportRange()*Rasio())*MyPoint;
        }
     }
   if(cmd == OP_SELL)
     {
      Price = Bid;
      if(StopLoss>0)
        {
         stoploss = Price+StopLoss*MyPoint;
        }
      else
        {
         stoploss = Resistance(20);
        }
      if(TakeProfit>0)
        {
         takeprofit = Price-TakeProfit*MyPoint;
        }
      else
        {
         takeprofit = Price-(QnResistanaceRange()*Rasio())*MyPoint;
        }
     }

   if(cmd == OP_BUYSTOP)
     {
      Price = Open[0]+Range*MyPoint;
      if(StopLoss>0)
        {
         stoploss = Price-StopLoss*MyPoint;
        }
      if(TakeProfit>0)
        {
         takeprofit = Price+TakeProfit*MyPoint;
        }
     }

   if(cmd == OP_SELLSTOP)
     {
      Price = Open[0]-Range*MyPoint;
      if(StopLoss>0)
        {
         stoploss = Price+StopLoss*MyPoint;
        }
      if(TakeProfit>0)
        {
         takeprofit = Price-TakeProfit*MyPoint;
        }
     }

   ticket = OrderSend(Symbol(),cmd,LotMod(),Price,Slippage,stoploss,takeprofit,EAComment,MagicNumber);

  }
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
