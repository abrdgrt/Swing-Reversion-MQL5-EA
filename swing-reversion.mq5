//+------------------------------------------------------------------+
//|                                              SwingReversionEA.mq5 |
//|                        Copyright 2014-2025, StateSpeed Solutions         |
//|                                             https://statespeed.solutions |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014-2025, StateSpeed Solutions"
#property link      "https://statespeed.solutions"
#property version   "1.00"

//--- input parameters
input int    InpMagic      = 123456;      // Magic Number
input int    InpAverageProfitPips = 10;   // Average Profit (pips)
input int    InpTradeGapPips = 5;         // Trade Gap (pips)
input double InpSwingFraction = 0.5;      // Swing Fraction

//--- global variables
double BuyTailPrice = 0;
double BuyExitPrice = 0;
double buyTotal = 0;
int buyCount = 0;
double buyAverage = 0;

double SellTailPrice = 0;
double SellExitPrice = 0;
double sellTotal = 0;
int sellCount = 0;
double sellAverage = 0;

double swingHighPrice = 0;
double swingLowPrice = 0;
int swingHigh = 0;
int swingLow = 0;

//+------------------------------------------------------------------+
//| Expert initialization function                                     |
//+------------------------------------------------------------------+
int OnInit()
{
   Trade.SetExpertMagicNumber(InpMagic);
   Direction = -1;
   EntryPrice = 0;

   AverageProfit = PipsToDouble(Symbol(), InpAverageProfitPips);
   TradeGap = PipsToDouble(Symbol(), InpTradeGapPips);

   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                   |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
}

//+------------------------------------------------------------------+
//| Expert tick function                                              |
//+------------------------------------------------------------------+
void OnTick()
{
   UpdateLevels();
   
   double swingDelta = swingHighPrice - swingLowPrice;
   double entryDelta = swingDelta * InpSwingFraction;

   if (swingHigh > swingLow)
   {
      Direction = ORDER_TYPE_SELL;
      if (SellTailPrice == 0)
      {
         EntryPrice = swingLowPrice + entryDelta;
      }
      else
      {
         EntryPrice = SellTailPrice + TradeGap;
      }
   }
   else
   {
      Direction = ORDER_TYPE_BUY;
      if (BuyTailPrice == 0)
      {
         EntryPrice = swingHighPrice - entryDelta;
      }
      else
      {
         EntryPrice = BuyTailPrice - TradeGap;
      }
   }
   
   for (int i = PositionsTotal() - 1; i >= 0; i--)
   {
      if (!PositionInfo.SelectByIndex(i)) continue;
      if (PositionInfo.Symbol() != Symbol()) continue;
      if (PositionInfo.Magic() != InpMagic) continue;

      if (PositionInfo.PositionType() == POSITION_TYPE_BUY)
      {
         if (BuyTailPrice == 0 || PositionInfo.PriceOpen() < BuyTailPrice) BuyTailPrice = PositionInfo.PriceOpen();
         buyTotal += PositionInfo.PriceOpen();
         buyCount++;
      }
      else
      {
         if (SellTailPrice == 0 || PositionInfo.PriceOpen() > SellTailPrice) SellTailPrice = PositionInfo.PriceOpen();
         sellTotal += PositionInfo.PriceOpen();
         sellCount++;
      }
   }

   if (buyCount > 0)
   {
      buyAverage = buyTotal / (double)buyCount;
      BuyExitPrice = buyAverage + AverageProfit;
   }

   if (sellCount > 0)
   {
      sellAverage = sellTotal / (double)sellCount;
      SellExitPrice = sellAverage - AverageProfit;
   }
}

//+------------------------------------------------------------------+
//| Update swing levels                                               |
//+------------------------------------------------------------------+
void UpdateLevels()
{
   swingHigh = SwingHigh(InpSwingPeriod, 1);
   swingHighPrice = iHigh(Symbol(), Period(), swingHigh);
   swingLow = SwingLow(InpSwingPeriod, 1);
   swingLowPrice = iLow(Symbol(), Period(), swingLow);
}

//+------------------------------------------------------------------+
//| Calculate Swing High                                              |
//+------------------------------------------------------------------+
int SwingHigh(int swingPeriod, int startBar = 0)
{
   int swingHigh = iHighest(Symbol(), Period(), MODE_HIGH, swingPeriod, startBar);
   return swingHigh;
}

//+------------------------------------------------------------------+
//| Calculate Swing Low                                               |
//+------------------------------------------------------------------+
int SwingLow(int swingPeriod, int startBar = 0)
{
   int swingLow = iLowest(Symbol(), Period(), MODE_LOW, swingPeriod, startBar);
   return swingLow;
}

//+------------------------------------------------------------------+
//| Convert pips to price                                             |
//+------------------------------------------------------------------+
double PipsToDouble(string symbol, double pips)
{
   return pips * Point * 10;
}

//+------------------------------------------------------------------+
//| Global variables                                                 |
//+------------------------------------------------------------------+
ENUM_ORDER_TYPE Direction;
double EntryPrice;
double AverageProfit;
double TradeGap;