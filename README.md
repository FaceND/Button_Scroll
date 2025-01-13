# Button Scroll

This dynamic button scroll to recent button helps users to quickly navigate to the most recent bar. 
The button is intelligently designed to appear when the chart is scrolled back and disappear 
when the chart is at the most recent bar, enhancing the user's chart navigation experience.

## Table of Contents

- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
- [Inputs](#inputs)
- [Customization](#customization)
- [Script Code](#script-code)
- [Contributing](#contributing)
- [License](#license)

## Features

- Button appears when you scroll back on the chart and disappears when you are at the most recent bar.
- Click the button to instantly scroll the chart to the most recent data.
- Place the button on the chart where it is easily accessible.
- Helps traders focus on the latest market developments and make timely decisions.

## Installation

1. Download the Script: Download the Scroll_To_Recent.mq5 file from this repository.
2. Open MetaTrader 5
   - Launch MetaTrader 5.
   - Go to `File` -> `Open Data Folder`.
3. Place the Script
   - Navigate to `MQL5` -> `Indicators`.
   - Copy the `Button Scroll.mq5` file into the Indicators folder.
4. Refresh MetaTrader 5
   - Restart MetaTrader 5 or right-click in the Navigator window and select Refresh.

## Usage

1. Load the Script
   - Open MetaTrader 5.
   - In the Navigator window, find the `Button Scroll` script under `Indicators`.
   - Drag and drop the `Button Scroll` script onto the chart where you want to use it.
2. Interact with the Button
   - The "Button Scroll" button will appear at the bottom-right corner of the chart when you scroll back.
   - Click the button to immediately scroll to the most recent bar.
   - The button will disappear automatically when the chart reaches the most recent bar.

## Inputs

- **Button Color**: Specifies the background color of the button.
- **Text Color**: Specifies the color of the button text.

## Customization

You can customize the size and position of the x and y axes of the button by modifying the following defines in the script

```mql5
#define BUTTON_X_POSITION 50
#define BUTTON_Y_POSITION 50
#define BUTTON_WIDTH      25
#define BUTTON_HEIGHT     25
```

## Script Code
Below is the MQL5 code used to create the "Button Scroll" button
```mql5
//+------------------------------------------------------------------+
//|                                                Button Scroll.mq5 |
//|                                         Copyright © 2024, FaceND |
//|                          https://github.com/FaceND/Button_Scroll |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2024, FaceND"
#property link      "https://github.com/FaceND/Button_Scroll"

#property description "The button scroll to recent provides a convenient button"
#property description "for quickly scrolling to the most recent data on the chart."
#property description ""
#property description "It enhances the user experience by allowing traders to easily"
#property description "navigate to the latest price action without manually scrolling"
#property description "through historical data."

#property indicator_chart_window
#property indicator_plots 0

#define BUTTON_NAME "RecentButton"

#define BUTTON_X_POSITION 50
#define BUTTON_Y_POSITION 50
#define BUTTON_WIDTH      25
#define BUTTON_HEIGHT     25

input group "STYLE"
input color  buttonColor  = clrWhite;    // Button color
input color  textColor    = clrBlack;    // Text color
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
   if(!CreateButton())
     {
      return INIT_FAILED;
     }
   return INIT_SUCCEEDED;
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   ObjectDelete(0, BUTTON_NAME);
   ChartRedraw();
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int           rates_total,
                const int       prev_calculated,
                const datetime          &time[],
                const double            &open[],
                const double            &high[],
                const double             &low[],
                const double           &close[],
                const long       &tick_volume[],
                const long            &volume[],
                const int             &spread[])
  {
   return rates_total;
  }
//+------------------------------------------------------------------+
//| Chart event handler function                                     |
//+------------------------------------------------------------------+
void OnChartEvent(const int                 id,
                  const long           &lparam,
                  const double         &dparam,
                  const string         &sparam)
  {
   if(id == CHARTEVENT_OBJECT_CLICK && sparam == BUTTON_NAME)
     {
      ChartNavigate(0, CHART_END);
      HideButton(0, BUTTON_NAME);
     }
   if(id == CHARTEVENT_CHART_CHANGE || id == CHARTEVENT_MOUSE_WHEEL)
     {
      UpdateButton();
     }
  }
//+------------------------------------------------------------------+
//| Function to create a button                                      |
//+------------------------------------------------------------------+
bool CreateButton()
  {
   if(buttonColor == clrNONE)
     {
      if(!ObjectCreate(0, BUTTON_NAME, OBJ_LABEL, 0, 0, 0))
        {
         Print("Failed to create the button object: ", BUTTON_NAME);
         return false;
        }
      //-- Set button properties
      ObjectSetInteger(0, BUTTON_NAME, OBJPROP_SELECTABLE,   false);
      ObjectSetInteger(0, BUTTON_NAME, OBJPROP_SELECTED,     false);
      ObjectSetInteger(0, BUTTON_NAME, OBJPROP_HIDDEN,       true);
     }
   else
     {
      if(!ObjectCreate(0, BUTTON_NAME, OBJ_BUTTON, 0, 0, 0))
        {
         Print("Failed to create the button object: ", BUTTON_NAME);
         return false;
        }
      //-- Set button properties
      ObjectSetInteger(0, BUTTON_NAME, OBJPROP_XSIZE,        BUTTON_WIDTH);
      ObjectSetInteger(0, BUTTON_NAME, OBJPROP_YSIZE,        BUTTON_HEIGHT);
      ObjectSetInteger(0, BUTTON_NAME, OBJPROP_BGCOLOR,      buttonColor);
      ObjectSetInteger(0, BUTTON_NAME, OBJPROP_BORDER_COLOR, buttonColor);
     }

   ObjectSetInteger(0, BUTTON_NAME, OBJPROP_CORNER,       CORNER_RIGHT_LOWER); 
   ObjectSetInteger(0, BUTTON_NAME, OBJPROP_ZORDER,       100);
   ObjectSetInteger(0, BUTTON_NAME, OBJPROP_BACK,         false);

   //-- Set text properties
   ObjectSetString (0, BUTTON_NAME, OBJPROP_TEXT,         ">>");
   ObjectSetString (0, BUTTON_NAME, OBJPROP_FONT,         "Arial Bold");
   ObjectSetInteger(0, BUTTON_NAME, OBJPROP_COLOR,        textColor);
   ObjectSetInteger(0, BUTTON_NAME, OBJPROP_FONTSIZE,     12);

   UpdateButton();
   return true;
  }
//+------------------------------------------------------------------+
//| Function to update button based on the chart position            |
//+------------------------------------------------------------------+
void UpdateButton()
  {
   // Check if autoscroll is disabled
   if(!ChartGetInteger(0, CHART_AUTOSCROLL))
     {
      // Timeout(150);
      long firstVisibleBarIndex = ChartGetInteger(0, CHART_FIRST_VISIBLE_BAR);
      long visibleBarsCount     = ChartGetInteger(0, CHART_VISIBLE_BARS)-1;

      if(firstVisibleBarIndex == visibleBarsCount)
         HideButton(0, BUTTON_NAME);
         
      else
         ShowButton(0, BUTTON_NAME);
     }
   else
     {
      ChartNavigate(0, CHART_END);
      HideButton(0, BUTTON_NAME);
     }
  }
//+------------------------------------------------------------------+
//| Function to hide button on the chart                             |
//+------------------------------------------------------------------+
void HideButton(long chart_id, string object_name) 
  {
   ObjectSetInteger(chart_id, object_name, OBJPROP_XDISTANCE, -100);
   ObjectSetInteger(chart_id, object_name, OBJPROP_YDISTANCE, -100);
   
   ChartRedraw();
  }
//+------------------------------------------------------------------+
//| Function to show button on the chart                             |
//+------------------------------------------------------------------+
void ShowButton(long chart_id, string object_name) 
  {
   ObjectSetInteger(chart_id, object_name, OBJPROP_XDISTANCE, BUTTON_X_POSITION);
   ObjectSetInteger(chart_id, object_name, OBJPROP_YDISTANCE, BUTTON_Y_POSITION);
   
   ChartRedraw();
  }
//+------------------------------------------------------------------+
//| Function to execution for the given number of milliseconds       |
//+------------------------------------------------------------------+
void Timeout(double ms)
  {
   double timeWait = GetTickCount() + ms;
   while(GetTickCount() < timeWait);
  }
//+------------------------------------------------------------------+
```
## Contributing

Contributions are welcome! If you have any improvements, bug fixes, or new features to suggest, please follow these steps

1. Fork the repository.
2. Create a new branch for your feature or fix.
3. Commit your changes with descriptive commit messages.
4. Push your branch to your forked repository.
4. Open a pull request to the main repository's main branch.
5. Please ensure your code follows the existing code style and includes comments where necessary.

Please ensure your code follows the existing code style and includes comments where necessary.

## License
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
