//+------------------------------------------------------------------+
//|                                                    MACD joss.mq4 |
//|                           Copyright 2022, NEXT TRADING EVOLUTION |
//|                                        YourSmartTradingEvolution |
//+------------------------------------------------------------------+
//#property icon "Logo TraderVibes (1).ico"
#property copyright "Copyright 2022, Trader Vibes"
#property link      "TraderVibes"
#property version   "1.10"

enum lmd
  {
   a = 1, //1:1
   b = 2, //1:2
   c = 3, //1:3
   d = 4 // sl/tp custom

  };

extern int                Slippage                   = 3;
extern int                MagicNumber                = 30290;
extern string             info_I                     = "P E N D I N G  O R D E R   I F   G A P ( P I P S )";
extern int                Gap                        = 50; //gap in pips
extern string             info_1                     = "R I S K / R E W A R D  M O D E";
extern lmd                RR_MODE                    = 1;
extern int                TakeProfit                 = 10;
extern int                StopLoss                   = 10;
extern string             risk                       = "M O N E Y   M A N A G E M E N T"; //Alert
extern double             Lots                       = 0.01;
extern bool               Use_RiskManagement_LotSize = false;
extern double             Risk_Percent               = 1; //Percentage of Account Balance to Risk
extern string             Risk_break                 = "=======================================";
extern string             info_2                     = "I N D I C A T O R   S E T T I N G";
extern string             mcd                        = "=== MACD ===";
extern int                Fast                       = 50;
extern int                Slow                       = 100;
extern int                mcd_sma                    = 9;
extern ENUM_APPLIED_PRICE mcd_price                  = PRICE_CLOSE;
extern string             max                        = "=== MA ===";
extern int                Period_ma                  = 34;
extern ENUM_MA_METHOD     ma_mode                    = MODE_SMA;
extern ENUM_APPLIED_PRICE ma_price                   = PRICE_CLOSE;
//extern int timedelay = 6;
string EAComment = "Barcode";

int barcount = 30;
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

   double qnmac1 = iMACD(NULL,0,Fast,Slow,mcd_sma,PRICE_CLOSE,MODE_MAIN,1);
   double qnmac2 = iMACD(NULL,0,Fast,Slow,mcd_sma,PRICE_CLOSE,MODE_SIGNAL,1);
   double qnmac3 = iMACD(NULL,0,Fast,Slow,mcd_sma,PRICE_CLOSE,MODE_MAIN,2);
   double qnmac4 = iMACD(NULL,0,Fast,Slow,mcd_sma,PRICE_CLOSE,MODE_SIGNAL,2);
   double qnma = iMA(NULL,0,Period_ma,0,ma_mode,ma_price,1);

   int qnhighest = iHighest(NULL,0,MODE_HIGH,15,0);
   int qnlowest = iLowest(NULL,0,MODE_LOW,15,0);
   double resis = High[qnhighest];
   double support = Low[qnlowest];

   double slbuy = stoplevelbuy();
   double tpbuy = stoplevelbuy();
   double slsell = stoplevelsell();
   double tpsell = stoplevelsell();

   double lot = Lots;

   if(Use_RiskManagement_LotSize)
     {
      lot = RMLotSize();
     }

   if(RR_MODE == 2)
     {
      tpbuy = stoplevelbuy()*2;
      tpsell = stoplevelsell()*2;
     }
   if(RR_MODE == 3)
     {
      tpbuy = stoplevelbuy()*3;
      tpsell = stoplevelsell()*3;
     }
   if(RR_MODE == 4)
     {
      tpbuy = TakeProfit;
      tpsell = TakeProfit;
      slbuy = StopLoss;
      slsell = StopLoss;
     }

   int ticket;
   if(OrdersTotal()==0)
     {
      if(qnmac1>0)
        {
         if(qnmac3<qnmac4 && qnmac1>qnmac2 && stoplevelbuy()<Gap)
           {
            ticket = OrderSend(Symbol(),OP_BUY,lot,Ask,3,Ask-slbuy*Point*10,Ask+tpbuy*Point*10,EAComment,MagicNumber);
           }
         if(stoplevelbuy()>=Gap && (qnmac3<qnmac4 && qnmac1>qnmac2))
           {
            ticket = OrderSend(Symbol(),OP_BUYLIMIT,lot,qnma,3,Close[1]-slbuy*Point*10,Close[1]+tpbuy*Point*10,EAComment,MagicNumber);
           }
        }
      if(qnmac1<0)
        {
         if(qnmac3>qnmac4 && qnmac1<qnmac2 && stoplevelsell()<Gap)
           {
            ticket = OrderSend(Symbol(),OP_SELL,lot,Bid,3,Bid+slsell*Point*10,Bid-tpsell*Point*10,EAComment,MagicNumber);
           }
         if(stoplevelsell()>=Gap && (qnmac3>qnmac4 && qnmac1<qnmac2))
           {
            ticket = OrderSend(Symbol(),OP_SELLLIMIT,lot,qnma,3,Close[1]+slsell*Point*10,Close[1]-slsell*Point*10,EAComment,MagicNumber);
           }
        }
     }
   /*
   if(IsNewBar())
     {
      DeletePendingOrders();
     }*/
   CloseAll();
   /*
   if(IsNewBar())
   {
    if((AccountEquity() > AccountBalance()))
      {
       CloseAll();
      }
   }*/

   Comment("\nStopLevelSell : ", stoplevelsell(),
           "\nStopLevelBuy : ", stoplevelbuy(),
           "\nresis : ", resis,
           "\nsupport : ", support,
           "\nLast Close : ", Close[1]);

  }
//+------------------------------------------------------------------+
int CloseAll()
  {
   for(int i = OrdersTotal() - 1; i >= 0; i--)      //Why do you count up the loop while you delete trades ???
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false)
         break; //Why not if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false)break;
      if(OrderType()>1 && OrderOpenTime() < Time[10])
         OrderDelete(OrderTicket());
     }

   return(0);
  }
//+------------------------------------------------------------------+
void CheckMarketDeletePending()
  {
   for(int i = OrdersTotal() - 1; i >= 0; i--)
     {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
        {
         if((OrderMagicNumber() == MagicNumber) && (OrderSymbol() == _Symbol))
           {
            if((OrderType() == OP_BUY) || (OrderType() == OP_SELL))
              {
               DeletePendingOrders();
               break;
              }
           }
        }
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void DeletePendingOrders()
  {
   for(int i = OrdersTotal() - 1; i >= 0; i--)
     {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
        {
         if((OrderMagicNumber() == MagicNumber) && (OrderSymbol() == _Symbol))
           {
            if((OrderType() != OP_BUY) && (OrderType() != OP_SELL))
              {
               if(!OrderDelete(OrderTicket()))
                 {
                  // Delete failed (need to deal with situation)
                  // Check Error Codes
                 }
              }
           }
        }
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CloseMarketOrders()
  {
   for(int i = OrdersTotal() - 1; i >= 0; i--)
     {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
        {
         if((OrderMagicNumber() == MagicNumber) && (OrderSymbol() == _Symbol))
           {
            if((OrderType() == OP_BUY) || (OrderType() == OP_SELL))
              {
               if(!OrderClose(OrderTicket(), OrderLots(), OrderClosePrice(), Slippage))
                 {
                  // Close failed (need to deal with situation)
                  // Check Error Codes
                 }
              }
           }
        }
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CloseDeleteAllOrders()
  {
   for(int i = OrdersTotal() - 1; i >= 0; i--)
     {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
        {
         if((OrderMagicNumber() == MagicNumber) && (OrderSymbol() == _Symbol))
           {
            if((OrderType() == OP_BUY) || (OrderType() == OP_SELL))
              {
               if(!OrderClose(OrderTicket(), OrderLots(), OrderClosePrice(), Slippage))
                 {
                  // Close failed (need to deal with situation)
                  // Check Error Codes
                 }
              }
            else
              {
               if(!OrderDelete(OrderTicket()))
                 {
                  // Delete failed (need to deal with situation)
                  // Check Error Codes
                 }
              }
           }
        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool IsNewBar()
  {
   static   datetime lastBar;
   datetime currBar  =  iTime(Symbol(), Period(), 0);

   if(lastBar != currBar)
     {
      lastBar  =  currBar;
      return (true);
     }
   else
     {
      return(false);
     }
  }
//+------------------------------------------------------------------+
double RMLotSize()
  {
   /*
   //-------------------------------------------------------------------------------------------------
   //Risk Management
   //-------------------------------------------------------------------------------------------------
   extern string risk="Use Risk Management to set LotSize - True or False";//Alert
   extern bool   Use_RiskManagement_LotSize=false;
   extern double Risk_Percent=2;//Percentage of Account Balance to Risk
   extern string Risk_break="";//=======================================
   */
//-------------------------------------------------------------------------------------------------
//current account balance
   double acctbal=0.00;
   if(AccountBalance()>0)
     {
      acctbal=AccountBalance();
     }
//-------------------------------------------------------------------------------------------------
//risk percentage
   double riskpercentage=0.00;
   if(Risk_Percent>0)
     {
      riskpercentage=Risk_Percent/100;
     }
//-------------------------------------------------------------------------------------------------
//amount of capitol to risk based on percentage
   double riskcapitol=0.00;
   if(acctbal>0)
     {
      riskcapitol=acctbal*riskpercentage;
     }
//-------------------------------------------------------------------------------------------------
//lotsize based on risk capitol
   double lotsize=0.00;
   if(riskcapitol>0)
     {
      lotsize=riskcapitol*0.01;
     }
//-------------------------------------------------------------------------------------------------
//if lotsize is more than is permitted change the lotsize to the maximum  permitted
   if(lotsize>MarketInfo(Symbol(),MODE_MAXLOT))
     {
      lotsize=MarketInfo(Symbol(),MODE_MAXLOT);
     }
//-------------------------------------------------------------------------------------------------
//if lotsize is less than is permitted change the lotsize to the minimum  permitted
   if(lotsize<MarketInfo(Symbol(),MODE_MINLOT))
     {
      lotsize=MarketInfo(Symbol(),MODE_MINLOT);
     }
//-------------------------------------------------------------------------------------------------
//if there is no orders available print Account Information and LotSize available
   if(OrdersTotal()==0)
     {
      Print("-------------------------------------------------------------------------------------------------");
      Print("LotSize based on the Capitol available...",DoubleToStr(lotsize,2));
      Print("Amount of Capitol to Risk...",DoubleToStr(riskcapitol,2));
      Print("Risk Percentage...",DoubleToStr(Risk_Percent,2));
      Print("Account Balance...",DoubleToStr(acctbal,2));
      Print("-------------------------------------------------------------------------------------------------");
     }
   return(lotsize);
  }
//+------------------------------------------------------------------+
double stoplevelbuy()
  {
   int qnlowest = iLowest(NULL,0,MODE_LOW,barcount,0);
   double support = Low[qnlowest];
   double lastqn = Close[1];

   double hasil = MathRound(lastqn-support);

   return(hasil*10);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double stoplevelsell()
  {
   int qnhighest = iHighest(NULL,0,MODE_HIGH,barcount,0);
   double resis = High[qnhighest];
   double lastqn = Close[1];

   double hasil = MathRound(resis-lastqn);

   return(hasil*10);
  }
//+------------------------------------------------------------------+
