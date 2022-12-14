//+------------------------------------------------------------------+
//|                                                     cobacoba.mq4 |
//|                        Copyright 2022, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright ©Next X Trading2022."
#property link      "Your Smart Trading Evolution"
#property version   "4.10"
#property icon "X-Logo.ico"
#property strict

enum TypeNS
  {
   INVEST=0,   // Investing.com
   DAILYFX=1,  // Dailyfx.com
  };

extern int TakeProfit = 20;
//extern int StopLoss = 30;
extern double Lots = 0.01;
extern int MagicNumber = 30290;
extern int Exit_Loss = 50;
extern bool auto_compound = false;
string EAComment = "EA AUTOMA Z+";
extern int std = 30;
extern int std2 = 55;
extern string info1 = "==============Marti Setting==============";
extern double   Lot_exponent      = 2;
extern int      PipStep           = 200;
extern int      MaxAveraging      = 15;
extern string info2 = "==============Day Setting==============";
extern bool Sunday = true;
extern bool Monday = true;
extern bool Tuesday = true;
extern bool Wednesday = true;
extern bool Thursday = true;
extern bool Friday = false;
extern bool NFP_Friday = true;
extern bool NFP_ThursdayBefore = true;
extern bool ChristmasHolidays = true;
extern double XMAS_DayBeginBreak = 15;
extern bool NewYearsHolidays = true;
extern double NewYears_DayEndBreak = 3;
extern string info3 = "==============NEWS FILTER==============";
extern TypeNS SourceNews=INVEST;
extern bool     LowNews             = false;
extern int      LowIndentBefore     = 15;
extern int      LowIndentAfter      = 15;
extern bool     MidleNews           = false;
extern int      MidleIndentBefore   = 30;
extern int      MidleIndentAfter    = 30;
extern bool     HighNews            = true;
extern int      HighIndentBefore    = 60;
extern int      HighIndentAfter     = 60;
extern bool     NFPNews             = true;
extern int      NFPIndentBefore     = 180;
extern int      NFPIndentAfter      = 180;

extern bool    DrawNewsLines        = true;
extern color   LowColor             = clrGreen;
extern color   MidleColor           = clrBlue;
extern color   HighColor            = clrRed;
extern int     LineWidth            = 1;
extern ENUM_LINE_STYLE LineStyle    = STYLE_DOT;
extern bool    OnlySymbolNews       = true;
extern int  GMTplus=7;     // Your Time Zone, GMT (for news)

int NomNews=0,Now=0,MinBefore=0,MinAfter=0;
string NewsArr[4][1000];
datetime LastUpd;
string ValStr;
int   Upd            = 86400;      // Period news updates in seconds
bool  Next           = false;      // Draw only the future of news line
bool  Signal         = false;      // Signals on the upcoming news
datetime TimeNews[300];
string Valuta[300],News[300],Vazn[300];
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   string v1=StringSubstr(_Symbol,0,3);
   string v2=StringSubstr(_Symbol,3,3);
   ValStr=v1+","+v2;
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   Comment("");
   del("NS_");
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---

   string TextDisplay="";

   /*  Check News   */
   bool trade=true;
   string nstxt="";
   int NewsPWR=0;
   datetime nextSigTime=0;
   if(LowNews || MidleNews || HighNews || NFPNews)
     {
      if(SourceNews==0)
        {
         // Investing
         if(CheckInvestingNews(NewsPWR,nextSigTime))
           {
            trade=false;   // news time
           }
        }
      if(SourceNews==1)
        {
         //DailyFX
         if(CheckDailyFXNews(NewsPWR,nextSigTime))
           {
            trade=false;   // news time
           }
        }
     }
   if(trade)
     {
      // No News, Trade enabled
      nstxt="No News";
      if(ObjectFind(0,"NS_Label")!=-1)
        {
         ObjectDelete(0,"NS_Label");
        }

     }
   else  // waiting news , check news power
     {
      color clrT=LowColor;
      if(NewsPWR>3)
        {
         nstxt= "Waiting Non-farm Payrolls News";
         clrT = HighColor;
        }
      else
        {
         if(NewsPWR>2)
           {
            nstxt= "Waiting High News";
            clrT = HighColor;
           }
         else
           {
            if(NewsPWR>1)
              {
               nstxt= "Waiting Midle News";
               clrT = MidleColor;
              }
            else
              {
               nstxt= "Waiting Low News";
               clrT = LowColor;
              }
           }
        }
      // Make Text Label
      if(nextSigTime>0)
        {
         nstxt=nstxt+" "+TimeToString(nextSigTime,TIME_MINUTES);
        }
      if(ObjectFind(0,"NS_Label")==-1)
        {
         LabelCreate(StringConcatenate(nstxt),clrT);
        }
      if(ObjectGetInteger(0,"NS_Label",OBJPROP_COLOR)!=clrT)
        {
         ObjectDelete(0,"NS_Label");
         LabelCreate(StringConcatenate(nstxt),clrT);
        }
     }
   nstxt="\n"+nstxt;
   /*  End Check News   */

   TextDisplay=TextDisplay+nstxt;
   //Comment(TextDisplay);

   HideTestIndicators(true);

   double MyPoint=Point;
   if(Digits==3 || Digits==5)
      MyPoint=Point*10;

   if(auto_compound)
     {
      if((AccountBalance()>=3000)&&(AccountBalance()<=5000))
        {
         Lots = 0.01;
        }
      else
         if((AccountBalance()>=5000)&&(AccountBalance()<=10000))
           {
            Lots = 0.01;
           }
         else
            if((AccountBalance()>=10000)&&(AccountBalance()<=15000))
              {
               Lots = 0.02;
              }
            else
               if((AccountBalance()>=15000)&&(AccountBalance()<=20000))
                 {
                  Lots = 0.03;
                 }
               else
                  if((AccountBalance()>=20000)&&(AccountBalance()<=25000))
                    {
                     Lots = 0.04;
                    }
                  else
                     if((AccountBalance()>=25000)&&(AccountBalance()<=30000))
                       {
                        Lots = 0.05;
                       }
     }

   double qneq = AccountEquity();
   double qnbllnc = AccountBalance();
   double prft = qneq-qnbllnc;

   double qntrget = (Lots*TakeProfit)*10;

   double l_ibans_0 = iBands(NULL,0,std,2,0,PRICE_CLOSE,MODE_UPPER,0);
   double l_ibans_1 = iBands(NULL,0,std,2,0,PRICE_CLOSE,MODE_LOWER,0);
   double l_ibans_2 = iBands(NULL,0,std,2,0,PRICE_CLOSE,MODE_MAIN,0);
   double l_ima_0 = iMA(NULL,0,std2,0,MODE_SMA,PRICE_CLOSE,0);
   double l_ima_1 = iMA(NULL,0,std2,0,MODE_SMA,PRICE_CLOSE,2);
   static string crt="none";

   if(l_ima_0-l_ibans_0>0|| l_ima_0-l_ibans_1<0)
     {
      crt="OK";
     }
   int ticket;
   if((OrdersTotal()==0)&&(DaytoTrade())&&(trade))
     {
      if((crt=="OK"&&l_ima_0<l_ibans_0 && l_ima_0>l_ibans_1))
        {
         if((l_ima_1>l_ibans_2&&l_ima_0<l_ibans_2)  || ((l_ima_1<l_ibans_2)&&(Close[2]<l_ibans_2&&Close[1]>l_ibans_2)))
           {
            ticket = OrderSend(Symbol(),OP_BUY,Lots,Ask,3,0,Ask+TakeProfit*Point*10,EAComment,MagicNumber);
           }
         else
            if((l_ima_1<l_ibans_2&&l_ima_0>l_ibans_2)|| ((l_ima_1>l_ibans_2)&&(Close[2]>l_ibans_2&&Close[1]<l_ibans_2)))
              {
               ticket = OrderSend(Symbol(),OP_SELL,Lots,Bid,3,0,Bid-TakeProfit*Point*10,EAComment,MagicNumber);
              }
        }
     }
   if(OrdersTotal()>0)
     {
      crt="none";
     }

   if(DaytoTrade() == false)
     {
      crt="libur";
     }
   if(NewBar())
     {
      QnStart();
     }
   double prsn = (-prft/AccountBalance())*100;


   if((prft>qntrget&&OrdersTotal()>=7)
      ||(prsn>=Exit_Loss)
     )
     {
      CloseAll();
     }

// do not work on holidays.
   DaytoTrade();

   Comment("\nMoment : ", qntrget,
           "\nSignal : ", crt,
           TextDisplay);

   return;

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
bool DaytoTrade()
  {
   bool daytotrade = false;

   if(DayOfWeek() == 0 && Sunday)
      daytotrade = true;
   if(DayOfWeek() == 1 && Monday)
      daytotrade = true;
   if(DayOfWeek() == 2 && Tuesday)
      daytotrade = true;
   if(DayOfWeek() == 3 && Wednesday)
      daytotrade = true;
   if(DayOfWeek() == 4 && Thursday)
      daytotrade = true;
   if(DayOfWeek() == 5 && Friday)
      daytotrade = true;
   if(DayOfWeek() == 5 && Day() < 8 && !NFP_Friday)
      daytotrade = false;
   if(DayOfWeek() == 1 && (Day()<12&&Day()>4) && !NFP_ThursdayBefore)
      daytotrade = false;
   if(Month() == 12 && Day() > XMAS_DayBeginBreak && !ChristmasHolidays)
      daytotrade = false;
   if(Month() == 1 && Day() < NewYears_DayEndBreak && ! NewYearsHolidays)
      daytotrade = false;

   return(daytotrade);
  }
//+------------------------------------------------------------------+
//======================================News Filter Function===========================================
//////////////////////////////////////////////////////////////////////////////////
string ReadCBOE()
  {

   string cookie=NULL,headers;
   char post[],result[];
   string TXT="";
   int res;
//--- to work with the server, you must add the URL "https://www.google.com/finance"
//--- the list of allowed URL (Main menu-> Tools-> Settings tab "Advisors"):
   string google_url="http://ec.forexprostools.com/?columns=exc_currency,exc_importance&importance=1,2,3&calType=week&timeZone=15&lang=1";
//---
   ResetLastError();
//--- download html-pages
   int timeout=5000; //--- timeout less than 1,000 (1 sec.) is insufficient at a low speed of the Internet
   res=WebRequest("GET",google_url,cookie,NULL,timeout,post,0,result,headers);
//--- error checking
   if(res==-1)
     {
      Print("WebRequest error, err.code  =",GetLastError());
      MessageBox("You must add the address 'http://ec.forexprostools.com/' in the list of allowed URL tab 'Advisors' "," Error ",MB_ICONINFORMATION);
      //--- You must add the address ' "+ google url"' in the list of allowed URL tab 'Advisors' "," Error "
     }
   else
     {
      //--- successful download
      //PrintFormat("File successfully downloaded, the file size in bytes  =%d.",ArraySize(result));
      //--- save the data in the file
      int filehandle=FileOpen("news-log.html",FILE_WRITE|FILE_BIN);
      //--- проверка ошибки
      if(filehandle!=INVALID_HANDLE)
        {
         //---save the contents of the array result [] in file
         FileWriteArray(filehandle,result,0,ArraySize(result));
         //--- close file
         FileClose(filehandle);

         int filehandle2=FileOpen("news-log.html",FILE_READ|FILE_BIN);
         TXT=FileReadString(filehandle2,ArraySize(result));
         FileClose(filehandle2);
        }
      else
        {
         Print("Error in FileOpen. Error code =",GetLastError());
        }
     }

   return(TXT);
  }
//+------------------------------------------------------------------+
datetime TimeNewsFunck(int nomf)
  {
   string s=NewsArr[0][nomf];
   string time=StringConcatenate(StringSubstr(s,0,4),".",StringSubstr(s,5,2),".",StringSubstr(s,8,2)," ",StringSubstr(s,11,2),":",StringSubstr(s,14,4));
   return((datetime)(StringToTime(time) + GMTplus*3600));
  }
//////////////////////////////////////////////////////////////////////////////////
void UpdateNews()
  {
   string TEXT=ReadCBOE();
   int sh = StringFind(TEXT,"pageStartAt>")+12;
   int sh2= StringFind(TEXT,"</tbody>");
   TEXT=StringSubstr(TEXT,sh,sh2-sh);

   sh=0;
   while(!IsStopped())
     {
      sh = StringFind(TEXT,"event_timestamp",sh)+17;
      sh2= StringFind(TEXT,"onclick",sh)-2;
      if(sh<17 || sh2<0)
         break;
      NewsArr[0][NomNews]=StringSubstr(TEXT,sh,sh2-sh);

      sh = StringFind(TEXT,"flagCur",sh)+10;
      sh2= sh+3;
      if(sh<10 || sh2<3)
         break;
      NewsArr[1][NomNews]=StringSubstr(TEXT,sh,sh2-sh);
      if(OnlySymbolNews && StringFind(ValStr,NewsArr[1][NomNews])<0)
         continue;

      sh = StringFind(TEXT,"title",sh)+7;
      sh2= StringFind(TEXT,"Volatility",sh)-1;
      if(sh<7 || sh2<0)
         break;
      NewsArr[2][NomNews]=StringSubstr(TEXT,sh,sh2-sh);
      if(StringFind(NewsArr[2][NomNews],"High")>=0 && !HighNews)
         continue;
      if(StringFind(NewsArr[2][NomNews],"Moderate")>=0 && !MidleNews)
         continue;
      if(StringFind(NewsArr[2][NomNews],"Low")>=0 && !LowNews)
         continue;

      sh=StringFind(TEXT,"left event",sh)+12;
      int sh1=StringFind(TEXT,"Speaks",sh);
      sh2=StringFind(TEXT,"<",sh);
      if(sh<12 || sh2<0)
         break;
      if(sh1<0 || sh1>sh2)
         NewsArr[3][NomNews]=StringSubstr(TEXT,sh,sh2-sh);
      else
         NewsArr[3][NomNews]=StringSubstr(TEXT,sh,sh1-sh);

      NomNews++;
      if(NomNews==300)
         break;
     }
  }
//+------------------------------------------------------------------+
int del(string name) // Спец. ф-ия deinit()
  {
   for(int n=ObjectsTotal()-1; n>=0; n--)
     {
      string Obj_Name=ObjectName(n);
      if(StringFind(Obj_Name,name,0)!=-1)
        {
         ObjectDelete(Obj_Name);
        }
     }
   return 0;                                      // Выход из deinit()
  }
//+------------------------------------------------------------------+
bool CheckInvestingNews(int &pwr,datetime &mintime)
  {

   bool CheckNews=false;
   pwr=0;
   int maxPower=0;
   if(LowNews || MidleNews || HighNews || NFPNews)
     {
      if(TimeCurrent()-LastUpd>=Upd)
        {
         Print("Investing.com News Loading...");
         UpdateNews();
         LastUpd=TimeCurrent();
         Comment("");
        }
      WindowRedraw();
      //---Draw a line on the chart news--------------------------------------------
      if(DrawNewsLines)
        {
         for(int i=0; i<NomNews; i++)
           {
            string Name=StringSubstr("NS_"+TimeToStr(TimeNewsFunck(i),TIME_MINUTES)+"_"+NewsArr[1][i]+"_"+NewsArr[3][i],0,63);
            if(NewsArr[3][i]!="")
               if(ObjectFind(Name)==0)
                  continue;
            if(OnlySymbolNews && StringFind(ValStr,NewsArr[1][i])<0)
               continue;
            if(TimeNewsFunck(i)<TimeCurrent() && Next)
               continue;

            color clrf=clrNONE;
            if(HighNews && StringFind(NewsArr[2][i],"High")>=0)
               clrf=HighColor;
            if(MidleNews && StringFind(NewsArr[2][i],"Moderate")>=0)
               clrf=MidleColor;
            if(LowNews && StringFind(NewsArr[2][i],"Low")>=0)
               clrf=LowColor;

            if(clrf==clrNONE)
               continue;

            if(NewsArr[3][i]!="")
              {
               ObjectCreate(0,Name,OBJ_VLINE,0,TimeNewsFunck(i),0);
               ObjectSet(Name,OBJPROP_COLOR,clrf);
               ObjectSet(Name,OBJPROP_STYLE,LineStyle);
               ObjectSetInteger(0,Name,OBJPROP_WIDTH,LineWidth);
               ObjectSetInteger(0,Name,OBJPROP_BACK,true);
              }
           }
        }
      //---------------event Processing------------------------------------
      int ii;
      CheckNews=false;
      for(ii=0; ii<NomNews; ii++)
        {
         int power=0;
         if(HighNews && StringFind(NewsArr[2][ii],"High")>=0)
           {
            power=3;
            MinBefore=HighIndentBefore;
            MinAfter=HighIndentAfter;
           }
         if(MidleNews && StringFind(NewsArr[2][ii],"Moderate")>=0)
           {
            power=2;
            MinBefore=MidleIndentBefore;
            MinAfter=MidleIndentAfter;
           }
         if(LowNews && StringFind(NewsArr[2][ii],"Low")>=0)
           {
            power=1;
            MinBefore=LowIndentBefore;
            MinAfter=LowIndentAfter;
           }
         if(NFPNews && StringFind(NewsArr[3][ii],"Nonfarm Payrolls")>=0)
           {
            power=4;
            MinBefore=NFPIndentBefore;
            MinAfter=NFPIndentAfter;
           }
         if(power==0)
            continue;

         if(TimeCurrent()+MinBefore*60>TimeNewsFunck(ii) && TimeCurrent()-MinAfter*60<TimeNewsFunck(ii) && (!OnlySymbolNews || (OnlySymbolNews && StringFind(ValStr,NewsArr[1][ii])>=0)))
           {
            if(power>maxPower)
              {
               maxPower=power;
               mintime=TimeNewsFunck(ii);
              }
           }
         else
           {
            CheckNews=false;
           }
        }
      if(maxPower>0)
        {
         CheckNews=true;
        }
     }
   pwr=maxPower;
   return(CheckNews);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool LabelCreate(const string text="Label",const color clr=clrRed)
  {
   long x_distance;
   long y_distance;
   long chart_ID=0;
   string name="NS_Label";
   int sub_window=0;
   ENUM_BASE_CORNER  corner=CORNER_LEFT_UPPER;
   string font="Arial";
   int font_size=28;
   double angle=0.0;
   ENUM_ANCHOR_POINT anchor=ANCHOR_LEFT_UPPER;
   bool back=false;
   bool selection=false;
   bool hidden=true;
   long z_order=0;
//--- определим размеры окна
   ChartGetInteger(0,CHART_WIDTH_IN_PIXELS,0,x_distance);
   ChartGetInteger(0,CHART_HEIGHT_IN_PIXELS,0,y_distance);
   ResetLastError();
   if(!ObjectCreate(chart_ID,name,OBJ_LABEL,sub_window,0,0))
     {
      Print(__FUNCTION__,
            ": failed to create text label! Error code = ",GetLastError());
      return(false);
     }
   ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,(int)(x_distance/2.7));
   ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,(int)(y_distance/1.5));
   ObjectSetInteger(chart_ID,name,OBJPROP_CORNER,corner);
   ObjectSetString(chart_ID,name,OBJPROP_TEXT,text);
   ObjectSetString(chart_ID,name,OBJPROP_FONT,font);
   ObjectSetInteger(chart_ID,name,OBJPROP_FONTSIZE,font_size);
   ObjectSetDouble(chart_ID,name,OBJPROP_ANGLE,angle);
   ObjectSetInteger(chart_ID,name,OBJPROP_ANCHOR,anchor);
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
   return(true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void UpdateDFX()
  {
   string DF="";
   string MF="";
   int DeltaGMT=GMTplus; // 0 -(TimeGMTOffset()/60/60)-DeltaTime;
   int ChasPoyasServera=DeltaGMT;
   datetime NowTimeD1=Time[0];
   datetime LastSunday=NowTimeD1-TimeDayOfWeek(NowTimeD1)*86399;
   int DayFile=TimeDay(LastSunday);
   if(DayFile<10)
      DF="0"+(string)DayFile;
   else
      DF=(string)DayFile;
   int MonthFile=TimeMonth(LastSunday);
   if(MonthFile<10)
      MF="0"+(string)MonthFile;
   else
      MF=(string)MonthFile;
   int YearFile=TimeYear(LastSunday);
   string DateFile=MF+"-"+DF+"-"+(string)YearFile;
   string FileName= DateFile+"_dfx.csv";
   int handle;

   if(!FileIsExist(FileName))
     {
      string url="http://www.dailyfx.com/files/Calendar-"+DateFile+".csv";
      string cookie=NULL,headers;
      char post[],result[];
      string TXT="";
      int res;
      string text="";
      ResetLastError();
      int timeout=5000;
      res=WebRequest("GET",url,cookie,NULL,timeout,post,0,result,headers);
      if(res==-1)
        {
         Print("WebRequest error, err.code  =",GetLastError());
         MessageBox("You must add the address 'http://www.dailyfx.com/' in the list of allowed URL tab 'Advisors' "," Error ",MB_ICONINFORMATION);
        }
      else
        {
         int filehandle=FileOpen(FileName,FILE_WRITE|FILE_BIN);
         if(filehandle!=INVALID_HANDLE)
           {
            FileWriteArray(filehandle,result,0,ArraySize(result));
            FileClose(filehandle);
           }
         else
           {
            Print("Error in FileOpen. Error code =",GetLastError());
           }
        }
     }
   handle=FileOpen(FileName,FILE_READ|FILE_CSV);
   string data,time,month,valuta;
   int startStr=0;
   if(handle!=INVALID_HANDLE)
     {
      while(!FileIsEnding(handle))
        {
         int str_size=FileReadInteger(handle,INT_VALUE);
         string str=FileReadString(handle,str_size);
         string value[10];
         int k=StringSplit(str,StringGetCharacter(",",0),value);
         data = value[0];
         time = value[1];
         if(time=="")
           {
            continue;
           }
         month=StringSubstr(data,4,3);
         if(month=="Jan")
            month="01";
         if(month=="Feb")
            month="02";
         if(month=="Mar")
            month="03";
         if(month=="Apr")
            month="04";
         if(month=="May")
            month="05";
         if(month=="Jun")
            month="06";
         if(month=="Jul")
            month="07";
         if(month=="Aug")
            month="08";
         if(month=="Sep")
            month="09";
         if(month=="Oct")
            month="10";
         if(month=="Nov")
            month="11";
         if(month=="Dec")
            month="12";
         TimeNews[startStr]=StrToTime((string)YearFile+"."+month+"."+StringSubstr(data,8,2)+" "+time)+ChasPoyasServera*3600;
         valuta=value[3];
         if(valuta=="eur" ||valuta=="EUR")
            Valuta[startStr]="EUR";
         if(valuta=="usd" ||valuta=="USD")
            Valuta[startStr]="USD";
         if(valuta=="jpy" ||valuta=="JPY")
            Valuta[startStr]="JPY";
         if(valuta=="gbp" ||valuta=="GBP")
            Valuta[startStr]="GBP";
         if(valuta=="chf" ||valuta=="CHF")
            Valuta[startStr]="CHF";
         if(valuta=="cad" ||valuta=="CAD")
            Valuta[startStr]="CAD";
         if(valuta=="aud" ||valuta=="AUD")
            Valuta[startStr]="AUD";
         if(valuta=="nzd" ||valuta=="NZD")
            Valuta[startStr]="NZD";
         News[startStr]=value[4];
         News[startStr]=StringSubstr(News[startStr],0,60);
         Vazn[startStr]=value[5];
         if(Vazn[startStr]!="High" && Vazn[startStr]!="HIGH" && Vazn[startStr]!="Medium" && Vazn[startStr]!="MEDIUM" && Vazn[startStr]!="MED" && Vazn[startStr]!="Low" && Vazn[startStr]!="LOW")
            Vazn[startStr]=FileReadString(handle);
         startStr++;
        }
     }
   else
     {
      PrintFormat("Error in FileOpen = %s. Error code= %d",FileName,GetLastError());
     }
   NomNews=startStr-1;
   FileClose(handle);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CheckDailyFXNews(int &pwr,datetime &mintime)
  {

   bool CheckNews=false;
   pwr=0;
   int maxPower=0;
   color clrf=clrNONE;
   mintime=0;
   if(LowNews || MidleNews || HighNews || NFPNews)
     {
      if(Time[0]-LastUpd>=Upd)
        {
         Print("News DailyFX Loading...");
         UpdateDFX();
         LastUpd=Time[0];
        }
      WindowRedraw();
      //---Draw a line on the chart news--------------------------------------------
      if(DrawNewsLines)
        {
         for(int i=0; i<NomNews; i++)
           {
            string Lname=StringSubstr("NS_"+TimeToStr(TimeNews[i],TIME_MINUTES)+"_"+News[i],0,63);
            if(News[i]!="")
               if(ObjectFind(0,Lname)==0)
                 {
                  continue;
                 }
            if(TimeNews[i]<TimeCurrent() && Next)
              {
               continue;
              }
            if((Vazn[i]=="High" || Vazn[i]=="HIGH") && HighNews==false)
              {
               continue;
              }
            if((Vazn[i]=="Medium" || Vazn[i]=="MEDIUM" || Vazn[i]=="MED") && MidleNews==false)
              {
               continue;
              }
            if((Vazn[i]=="Low" || Vazn[i]=="LOW") && LowNews==false)
              {
               continue;
              }
            if(Vazn[i]=="High" || Vazn[i]=="HIGH")
              {
               clrf=HighColor;
              }
            if(Vazn[i]=="Medium" || Vazn[i]=="MEDIUM" || Vazn[i]=="MED")
              {
               clrf=MidleColor;
              }
            if(Vazn[i]=="Low" || Vazn[i]=="LOW")
              {
               clrf=LowColor;
              }
            if(News[i]!="" && ObjectFind(0,Lname)<0)
              {
               if(OnlySymbolNews && (Valuta[i]!=StringSubstr(_Symbol,0,3) && Valuta[i]!=StringSubstr(_Symbol,3,3)))
                 {
                  continue;
                 }
               ObjectCreate(0,Lname,OBJ_VLINE,0,TimeNews[i],0);
               ObjectSet(Lname,OBJPROP_COLOR,clrf);
               ObjectSet(Lname,OBJPROP_STYLE,LineStyle);
               ObjectSetInteger(0,Lname,OBJPROP_WIDTH,LineWidth);
               ObjectSetInteger(0,Lname,OBJPROP_BACK,true);
              }
           }
        }
      //---------------event Processing------------------------------------
      for(int i=0; i<NomNews; i++)
        {
         int power=0;
         if(HighNews && (Vazn[i]=="High" || Vazn[i]=="HIGH"))
           {
            power=3;
            MinBefore=HighIndentBefore;
            MinAfter=HighIndentAfter;
           }
         if(MidleNews && (Vazn[i]=="Medium" || Vazn[i]=="MEDIUM" || Vazn[i]=="MED"))
           {
            power=2;
            MinBefore=MidleIndentBefore;
            MinAfter=MidleIndentAfter;
           }
         if(LowNews && (Vazn[i]=="Low" || Vazn[i]=="LOW"))
           {
            power=1;
            MinBefore=LowIndentBefore;
            MinAfter=LowIndentAfter;
           }
         if(NFPNews && StringFind(News[i],"Non-farm Payrolls")>=0)
           {
            power=4;
            MinBefore=NFPIndentBefore;
            MinAfter=NFPIndentAfter;
           }
         if(power==0)
            continue;

         if(TimeCurrent()+MinBefore*60>TimeNews[i] && TimeCurrent()-MinAfter*60<TimeNews[i] && (!OnlySymbolNews || (OnlySymbolNews && (StringSubstr(Symbol(),0,3)==Valuta[i] || StringSubstr(Symbol(),3,3)==Valuta[i]))))
           {
            if(power>maxPower)
              {
               maxPower=power;
               mintime=TimeNews[i];
              }
           }
         else
           {
            CheckNews=false;
           }
        }
      if(maxPower>0)
        {
         CheckNews=true;
        }
     }
   pwr=maxPower;
   return(CheckNews);
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
