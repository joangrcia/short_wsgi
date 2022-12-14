//+------------------------------------------------------------------+
//|                                              Heiken_Ashi_ADX.mq4 |
//|                               Copyright 2021, Trading Programmer |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, Trading Programmer"
#property version   "1.00"
#property strict

#define MAGIC_NO 19001
 
//--- Orders  
extern double lots = 0.1;
extern int takeprofit = 500;
extern int stoploss = 500;

//--- ADX
extern int ADX_Period = 14;


//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason) {

}

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick() {

   modifyTrendLine();
   trade();
     
}

//+------------------------------------------------------------------+
//| Modify tade lines                                                |
//+------------------------------------------------------------------+
void modifyTrendLine() {
   for( int n=ObjectsTotal()-1; n>=0; n-- ){
      string str= ObjectName(n);

      if( ObjectType(str) != OBJ_TREND )
         continue;

      if( StringGetChar(str,0) != '#' )
         continue;

      ObjectSet(str,OBJPROP_WIDTH,4);
      ObjectSet(str,OBJPROP_STYLE, STYLE_SOLID);
   }
}

//+------------------------------------------------------------------+
//| Orders - Open, Close                                             |
//+------------------------------------------------------------------+

void openSell() {
   OrderSend(Symbol(), OP_SELL, lots, Bid, 3, Bid+stoploss*Point, Bid-takeprofit*Point, "Sell trade", MAGIC_NO, 0, Red);
}

void openBuy() {
   OrderSend(Symbol(), OP_BUY, lots, Ask, 3, Ask-stoploss*Point, Ask+takeprofit*Point, "Buy trade", MAGIC_NO, 0, Blue);
}

void closeSell(){

   OrderSelect(0, SELECT_BY_POS, MODE_TRADES);
   
   if(OrderType() == OP_SELL && OrderMagicNumber() == MAGIC_NO && OrderSymbol() == Symbol()) {
      OrderClose(OrderTicket(), OrderLots(), Ask, 3, Yellow);
   }
}

void closeBuy(){
   
   OrderSelect(0, SELECT_BY_POS, MODE_TRADES);

   if(OrderType() == OP_BUY && OrderMagicNumber() == MAGIC_NO && OrderSymbol() == Symbol()) {
      OrderClose(OrderTicket(), OrderLots(), Bid, 3, Yellow); 
   } 
}

//+------------------------------------------------------------------+
//| Check Open indicator patterns                                    |
//+------------------------------------------------------------------+

int checkOpenConditions() {

   double adx0 = iADX(Symbol(), 0, ADX_Period, PRICE_CLOSE, MODE_MAIN, 0);
   double adx_plus1 = iADX(Symbol(), 0, ADX_Period, PRICE_CLOSE, MODE_PLUSDI, 1);
   double adx_plus2 = iADX(Symbol(), 0, ADX_Period, PRICE_CLOSE, MODE_PLUSDI, 2);
   double adx_minus1 = iADX(Symbol(), 0, ADX_Period, PRICE_CLOSE, MODE_MINUSDI, 1);
   double adx_minus2 = iADX(Symbol(), 0, ADX_Period, PRICE_CLOSE, MODE_MINUSDI, 2);

   if(adx_plus1 < adx_minus1 && heikenAshi(1) == "red" && heikenAshi(2) == "green" && heikenAshi(3) == "green" && heikenAshi(4) == "green") {
      return (1);
      
   } else if(adx_plus1 > adx_minus1 && heikenAshi(1) == "green" && heikenAshi(2) == "red" && heikenAshi(3) == "red" && heikenAshi(4) == "red") {
      return (2);
      
   } else {
      return (0);
   }
}

int checkCloseConditions() {

   if(heikenAshi(1) == "red" && heikenAshi(2) == "green" && heikenAshi(3) == "green" && heikenAshi(4) == "green") {
      return (1);
      
   } else if(heikenAshi(1) == "green" && heikenAshi(2) == "red" && heikenAshi(3) == "red" && heikenAshi(4) == "red") {
      return (2);
      
   } else {
      return (0);
   }
}

string heikenAshi(int i) {

   double open = iCustom(NULL, 0, "Heiken Ashi", 2, i);
   double close = iCustom(NULL, 0, "Heiken Ashi", 3, i);
   
   if(open > close)
      return ("red");    //--- Red bar 
   else
      return ("green");   //--- Green Bar
}

//+------------------------------------------------------------------+
//| Check indicator conditions                                       |
//+------------------------------------------------------------------+
void trade() {
    
   bool new_bar = false;
   
   if(newBar()) {
      new_bar = true;
   }
   
   if(new_bar && OrdersTotal() != 0) {  
      if(checkCloseConditions() == 2){
         closeSell();
         Alert("Close Sell Trade");
      }  
      if(checkCloseConditions() == 1){
         closeBuy();
         Alert("Close Buy Trade");
      }  
   } 
   
   if(new_bar && OrdersTotal() == 0) {
      if(checkOpenConditions() == 1){
         openSell();
         Alert("Open Sell Trade");
      } 
      if(checkOpenConditions() == 2){
         openBuy();
         Alert("Open Buy Trade");
      }   
   }
}

//+------------------------------------------------------------------+
//| Get the 1st tick of a new bar                                    |
//+------------------------------------------------------------------+
bool newBar() {
   static datetime newTime = 0;
   bool newBar = false;
   
   if (newTime != Time[0]){
      newTime = Time[0];
      newBar = true;
   }
   return(newBar);
}