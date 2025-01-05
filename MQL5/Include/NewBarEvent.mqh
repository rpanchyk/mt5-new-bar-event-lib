//+------------------------------------------------------------------+
//|                                                  NewBarEvent.mqh |
//|                                         Copyright 2025, rpanchyk |
//|                                      https://github.com/rpanchyk |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, rpanchyk"
#property link      "https://github.com/rpanchyk"

// includes
#include <Generic\HashMap.mqh>

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class NewBarEvent
  {
public:
                     NewBarEvent(string symbol, bool debug = false);
                    ~NewBarEvent();
   // Method 1 (allows multiple checks)
   void              CheckAndSet();
   bool              On(ENUM_TIMEFRAMES timeframe);
   void              Reset();
   // Method 2 (allows single check only)
   bool              IsNewBar(ENUM_TIMEFRAMES timeframe);
private:
   string            m_Symbol;
   bool              m_Debug;

   ENUM_TIMEFRAMES   m_Timeframes[];
   CHashMap<ENUM_TIMEFRAMES, int>* m_Bars;
   CHashMap<ENUM_TIMEFRAMES, bool>* m_Markers;
  };

//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
NewBarEvent::NewBarEvent(string symbol, bool debug = false)
  {
   m_Symbol = symbol;
   m_Debug = debug;

   ENUM_TIMEFRAMES timeframes[] =
     {
      PERIOD_M1,
      PERIOD_M2,
      PERIOD_M3,
      PERIOD_M4,
      PERIOD_M5,
      PERIOD_M6,
      PERIOD_M10,
      PERIOD_M12,
      PERIOD_M15,
      PERIOD_M20,
      PERIOD_M30,
      PERIOD_H1,
      PERIOD_H2,
      PERIOD_H3,
      PERIOD_H4,
      PERIOD_H6,
      PERIOD_H8,
      PERIOD_H12,
      PERIOD_D1,
      PERIOD_W1,
      PERIOD_MN1
     };
   ArrayResize(m_Timeframes, ArraySize(timeframes));
   ArrayCopy(m_Timeframes, timeframes);

   m_Bars = new CHashMap<ENUM_TIMEFRAMES, int>(ArraySize(m_Timeframes));
   m_Markers = new CHashMap<ENUM_TIMEFRAMES, bool>(ArraySize(m_Timeframes));
   for(int i = 0; i < ArraySize(m_Timeframes); i++)
     {
      ENUM_TIMEFRAMES timeframe = m_Timeframes[i];

      m_Bars.Add(timeframe, iBars(m_Symbol, timeframe));
      m_Markers.Add(timeframe, false);
     }
  }

//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
NewBarEvent::~NewBarEvent()
  {
   m_Bars.Clear();
   m_Markers.Clear();
  }

//+------------------------------------------------------------------+
//| Checks new bar appears and updates state                         |
//+------------------------------------------------------------------+
void NewBarEvent::CheckAndSet()
  {
   for(int i = 0; i < ArraySize(m_Timeframes); i++)
     {
      ENUM_TIMEFRAMES timeframe = m_Timeframes[i];

      int prev;
      if(!m_Bars.TryGetValue(timeframe, prev))
        {
         PrintFormat("Cannot get bars count for %s timeframe", EnumToString(timeframe));
         return;
        }

      int curr = iBars(m_Symbol, timeframe);
      if(prev != curr)
        {
         if(!m_Bars.TrySetValue(timeframe, curr))
           {
            PrintFormat("Cannot set bars count for %s timeframe", EnumToString(timeframe));
            return;
           }

         if(!m_Markers.TrySetValue(timeframe, true))
           {
            PrintFormat("Cannot set marker for %s timeframe", EnumToString(timeframe));
            return;
           }

         if(m_Debug)
           {
            PrintFormat("New bar appears for %s timeframe", EnumToString(timeframe));
           }
        }
     }
  }

//+------------------------------------------------------------------+
//| Returns true if new bar appears on given timeframe               |
//+------------------------------------------------------------------+
bool NewBarEvent::On(ENUM_TIMEFRAMES timeframe)
  {
   if(timeframe == PERIOD_CURRENT)
     {
      PrintFormat("Given %s timeframe is not valid. Use {PERIOD_M1 .. PERIOD_MN1} or _Period or Period()",
                  EnumToString(timeframe));
      return false;
     }

   bool result;
   if(!m_Markers.TryGetValue(timeframe, result))
     {
      PrintFormat("Cannot get marker for %s timeframe", EnumToString(timeframe));
      return false;
     }
   return result;
  }

//+------------------------------------------------------------------+
//| Resets markers for all timeframes                                |
//+------------------------------------------------------------------+
void NewBarEvent::Reset()
  {
   for(int i = 0; i < ArraySize(m_Timeframes); i++)
     {
      ENUM_TIMEFRAMES timeframe = m_Timeframes[i];

      if(!m_Markers.TrySetValue(timeframe, false))
        {
         PrintFormat("Cannot reset marker for %s timeframe", EnumToString(timeframe));
         return;
        }
     }
  }

//+------------------------------------------------------------------+
//| Returns true if new bar appears on given timeframe               |
//+------------------------------------------------------------------+
bool NewBarEvent::IsNewBar(ENUM_TIMEFRAMES timeframe)
  {
   if(timeframe == PERIOD_CURRENT)
     {
      PrintFormat("Given %s timeframe is not valid. Use {PERIOD_M1 .. PERIOD_MN1} or _Period or Period()",
                  EnumToString(timeframe));
      return false;
     }

   int prev;
   if(!m_Bars.TryGetValue(timeframe, prev))
     {
      PrintFormat("Cannot get bars count for %s timeframe", EnumToString(timeframe));
      return false;
     }

   int curr = iBars(m_Symbol, timeframe);
   if(prev != curr)
     {
      if(!m_Bars.TrySetValue(timeframe, curr))
        {
         PrintFormat("Cannot set bars count for %s timeframe", EnumToString(timeframe));
         return false;
        }

      if(m_Debug)
        {
         PrintFormat("New bar appears for %s timeframe", EnumToString(timeframe));
        }
      return true;
     }

   return false;
  }
//+------------------------------------------------------------------+
