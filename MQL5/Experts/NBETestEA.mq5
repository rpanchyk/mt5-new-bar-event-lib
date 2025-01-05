//+------------------------------------------------------------------+
//|                                                    NBETestEA.mq5 |
//|                                         Copyright 2025, rpanchyk |
//|                                      https://github.com/rpanchyk |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, rpanchyk"
#property link      "https://github.com/rpanchyk"
#property version   "1.00"

// includes
#include <NewBarEvent.mqh>

// runtime
NewBarEvent newBar1(_Symbol);
NewBarEvent newBar2(_Symbol);

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   return INIT_SUCCEEDED;
  }

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
  }

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
   ENUM_TIMEFRAMES timeframe = _Period;

// Example: Method 1
   newBar1.CheckAndSet();
   if(newBar1.On(timeframe))
     {
      PrintFormat("Method 1, first call: new bar appears on %s timeframe at %s",
                  EnumToString(timeframe), TimeToString(TimeCurrent()));
     }
   if(newBar1.On(timeframe))
     {
      PrintFormat("Method 1, second call: new bar appears on %s timeframe at %s",
                  EnumToString(timeframe), TimeToString(TimeCurrent()));
     }
   newBar1.Reset();

// Example: Method 2
   if(newBar2.IsNewBar(timeframe))
     {
      PrintFormat("Method 2: new bar appears on %s timeframe at %s",
                  EnumToString(timeframe), TimeToString(TimeCurrent()));
     }
  }
//+------------------------------------------------------------------+
