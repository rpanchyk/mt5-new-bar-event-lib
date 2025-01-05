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

## Contribution
Feel free to create an issue or a pull request if any ideas.

## Disclaimer
The source code of this repository is provided AS-IS and WITH NO WARRANTY of any kind.
Author and/or contributor are NOT responsible for any type of losses as a result of using source code, 
compiled binaries or other outcomes related to this repository.
