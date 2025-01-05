# Forex New Bar Event Library for MT5
Library allows to subscribe on new bar event in MetaTrader 5.

## Installation
- Open data folder in MetaTrader from menu `File -> Open Data Folder`.
- Copy [NewBarEvent.mqh](MQL5/Include/NewBarEvent.mqh) file to `<METATRADER_DATA_DIR>\MQL5\Include` folder.

## Usage
There are two methods to use the library. See [example](MQL5/Experts/NBETestEA.mq5) expert advisor.

### Method 1
This method is used for multiple checks of new bar event:
```mql5
newBar.CheckAndSet();

if(newBar.On(PERIOD_H1))
 {
   // your code here...
 }

if(newBar.On(PERIOD_H1))
 {
  // your code here...
 }

newBar.Reset();
```

### Method 2
This method is used for single check of new bar event:
```mql5
if(newBar.IsNewBar(PERIOD_H1))
 {
   // your code here...
 }
```

### Logs
Output logs of example EA:
```
2023.11.28 14:00:00   Method 1, first call: new bar appears on PERIOD_M15 timeframe at 2023.11.28 14:00
2023.11.28 14:00:00   Method 1, second call: new bar appears on PERIOD_M15 timeframe at 2023.11.28 14:00
2023.11.28 14:00:00   Method 2: new bar appears on PERIOD_M15 timeframe at 2023.11.28 14:00

2023.11.28 14:15:00   Method 1, first call: new bar appears on PERIOD_M15 timeframe at 2023.11.28 14:15
2023.11.28 14:15:00   Method 1, second call: new bar appears on PERIOD_M15 timeframe at 2023.11.28 14:15
2023.11.28 14:15:00   Method 2: new bar appears on PERIOD_M15 timeframe at 2023.11.28 14:15

2023.11.28 14:30:00   Method 1, first call: new bar appears on PERIOD_M15 timeframe at 2023.11.28 14:30
2023.11.28 14:30:00   Method 1, second call: new bar appears on PERIOD_M15 timeframe at 2023.11.28 14:30
2023.11.28 14:30:00   Method 2: new bar appears on PERIOD_M15 timeframe at 2023.11.28 14:30
```

## Contribution
Feel free to create an issue or a pull request if any ideas.

## Disclaimer
The source code of this repository is provided AS-IS and WITH NO WARRANTY of any kind.
Author and/or contributor are NOT responsible for any type of losses as a result of using source code, 
compiled binaries or other outcomes related to this repository.
