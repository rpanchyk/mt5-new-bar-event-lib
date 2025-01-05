//+------------------------------------------------------------------+
//|                                                  NewBarEvent.mqh |
//|                                         Copyright 2025, rpanchyk |
//|                                      https://github.com/rpanchyk |
//|                      Based on https://www.mql5.com/ru/code/38100 |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, rpanchyk"
#property link      "https://github.com/rpanchyk"

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
   bool              IsValidTimeframe(ENUM_TIMEFRAMES timeframe);
   int               FindTimeframeIndex(ENUM_TIMEFRAMES timeframe);
   void              RegisterTimeframe(ENUM_TIMEFRAMES timeframe);

   string            m_Symbol;
   bool              m_Debug;

   ENUM_TIMEFRAMES   m_Timeframes[];
   int               m_Bars[];
   bool              m_Results[];
  };

//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
NewBarEvent::NewBarEvent(string symbol, bool debug = false)
  {
   m_Symbol = symbol;
   m_Debug = debug;
  }

//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
NewBarEvent::~NewBarEvent()
  {
   ArrayResize(m_Timeframes, 0);
   ArrayResize(m_Bars, 0);
   ArrayResize(m_Results, 0);
  }

//+------------------------------------------------------------------+
//| Returns true if given timeframe is valid                         |
//+------------------------------------------------------------------+
bool NewBarEvent::IsValidTimeframe(ENUM_TIMEFRAMES timeframe)
  {
   if(timeframe == PERIOD_CURRENT)
     {
      PrintFormat("Given %s timeframe is not valid. Use {PERIOD_M1 .. PERIOD_MN1} or _Period or Period()",
                  EnumToString(timeframe));
      return false;
     }
   return true;
  }

//+------------------------------------------------------------------+
//| Returns index of given timeframe or -1 if not found              |
//+------------------------------------------------------------------+
int NewBarEvent::FindTimeframeIndex(ENUM_TIMEFRAMES timeframe)
  {
   for(int i = 0; i < ArraySize(m_Timeframes); i++)
     {
      if(timeframe == m_Timeframes[i])
        {
         return i;
        }
     }
   return -1;
  }

//+------------------------------------------------------------------+
//| Register given timeframe                                         |
//+------------------------------------------------------------------+
void NewBarEvent::RegisterTimeframe(ENUM_TIMEFRAMES timeframe)
  {
   int index = ArraySize(m_Timeframes);

   ArrayResize(m_Timeframes, index + 1);
   m_Timeframes[index] = timeframe;

   ArrayResize(m_Bars, index + 1);
   m_Bars[index] = iBars(m_Symbol, timeframe);

   ArrayResize(m_Results, index + 1);
   m_Results[index] = false;
  }

//+------------------------------------------------------------------+
//| Checks new bar appears and updates state                         |
//+------------------------------------------------------------------+
void NewBarEvent::CheckAndSet()
  {
   for(int i = 0; i < ArraySize(m_Timeframes); i++)
     {
      ENUM_TIMEFRAMES timeframe = m_Timeframes[i];

      int prev = m_Bars[i];
      int curr = iBars(m_Symbol, timeframe);
      if(prev != curr)
        {
         m_Bars[i] = curr;
         m_Results[i] = true;

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
   if(!IsValidTimeframe(timeframe))
     {
      return false;
     }

   int i = FindTimeframeIndex(timeframe);
   if(i == -1)
     {
      RegisterTimeframe(timeframe);
      return false;
     }
   else
     {
      return m_Results[i];
     }
  }

//+------------------------------------------------------------------+
//| Resets results for all timeframes                                |
//+------------------------------------------------------------------+
void NewBarEvent::Reset()
  {
   for(int i = 0; i < ArraySize(m_Timeframes); i++)
     {
      m_Results[i] = false;
     }
  }

//+------------------------------------------------------------------+
//| Returns true if new bar appears on given timeframe               |
//+------------------------------------------------------------------+
bool NewBarEvent::IsNewBar(ENUM_TIMEFRAMES timeframe)
  {
   if(!IsValidTimeframe(timeframe))
     {
      return false;
     }

   int i = FindTimeframeIndex(timeframe);
   if(i == -1)
     {
      RegisterTimeframe(timeframe);
      return false;
     }
   else
     {
      int prev = m_Bars[i];
      int curr = iBars(m_Symbol, timeframe);
      if(prev != curr)
        {
         m_Bars[i] = curr;
         m_Results[i] = true;

         if(m_Debug)
           {
            PrintFormat("New bar appears for %s timeframe", EnumToString(timeframe));
           }
        }
      return m_Results[i];
     }
  }
//+------------------------------------------------------------------+
