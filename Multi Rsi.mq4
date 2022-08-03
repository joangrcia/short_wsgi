//+------------------------------------------------------------------+
//|                                                    MACD joss.mq4 |
//|                           Copyright 2022, NEXT TRADING EVOLUTION |
//|                                        YourSmartTradingEvolution |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, NEXT TRADING EVOLUTION"
#property link      "YourSmartTradingEvolution"
#property version   "1.00"

extern int TakeProfit = 10;
extern int StopLoss = 10;
//extern bool auto_compound = false;
//extern int Gap = 20;
extern int Slippage = 3;
extern int MagicNumber = 30290;
extern string risk="M O N E Y   M A N A G E M E N T"; //Alert
extern double Lots = 1;
extern bool   Use_RiskManagement_LotSize=false;
extern double Risk_Percent=2; //Percentage of Account Balance to Risk
extern string Risk_break=""; //=======================================
//extern int timedelay = 6;
string EAComment = "EA AUTOMA Z+";
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

   double JGatr1 = iATR(NULL,PERIOD_D1,12,1);
   double JGatr2 = iATR(NULL,PERIOD_D1,12,2);
   double JGtrend1 = iOpen(NULL,PERIOD_D1,1);
   double JGtrend2 = iClose(NULL,PERIOD_D1,1);
   static string signalatr = " ";
   static string signaltrend = " ";
   double lot = Lots;

   if(Use_RiskManagement_LotSize)
     {
      lot = RMLotSize();
     }

//==================================== Signal ====================================
   if(TimeHour(iTime(NULL,PERIOD_H1,1))==0||TimeHour(iTime(NULL,PERIOD_H1,1))==1)
     {
      if(JGatr2 < JGatr1)
        {
         signalatr="Strong";
        }

      if(JGatr2 > JGatr1)
        {
         signalatr="Weak";
        }
     }

   if(TimeHour(iTime(NULL,PERIOD_H1,1))==0||TimeHour(iTime(NULL,PERIOD_H1,1))==1)
     {
      if(JGtrend2 > JGtrend1)
        {
         signaltrend="Bullish";
        }

      if(JGtrend2 < JGtrend1)
        {
         signaltrend="Bearish";
        }
     }

   string WRSignal = signalatr+" "+signaltrend;
//string TRSignal = signalatr+" "+signaltrend;

   double highprice = iHigh(NULL,PERIOD_D1,1);
   double lowsprice = iLow(NULL,PERIOD_D1,1);

   double persen_modal = (AccountBalance()*1)/100;
   double aturan_lots = persen_modal/StopLoss/10;

   int ticket;
   if(IsNewBar())
     {
      //DeletePendingOrders();
      ticket = OrderSend(Symbol(),OP_BUYSTOP,lot,highprice,3,highprice-StopLoss*Point*10,highprice+TakeProfit*Point*10,EAComment,MagicNumber);
      ticket = OrderSend(Symbol(),OP_SELLSTOP,lot,lowsprice,3,lowsprice+StopLoss*Point*10,lowsprice-TakeProfit*Point*10,EAComment,MagicNumber);
     }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   if(IsNewBar())
     {
      DeletePendingOrders();
     }
   /*
   if(IsNewBar())
   {
    if((AccountEquity() > AccountBalance()))
      {
       CloseAll();
      }
   }*/

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   CheckMarketDeletePending();
   Comment("\nSignal : ", WRSignal);

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
   datetime currBar  =  iTime(Symbol(), PERIOD_D1, 0);

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
