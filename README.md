# MQL5 Scroll to Recent Button

This MQL5 script adds a dynamic button to the MetaTrader 5 chart, enabling users to quickly navigate to the most recent bar. 
The button is intelligently designed to appear when the chart is scrolled back and disappear when the chart is at the most recent bar, 
enhancing the user's chart navigation experience.

## Table of Contents

- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
- [Input Parameters](#input-parameters)
- [Customization](#customization)
- [Script Code](#script-code)
- [Contributing](#contributing)
- [License](#license)

## Features

- Dynamic Button Visibility: The "Scroll to Recent" button appears when you scroll back on the chart and disappears when you are at the most recent bar.
- Convenient Navigation: One-click navigation to the most recent bar on the chart.

## Installation

1. Download the Script: Download the ScrollToRecentButton.mq5 file from this repository.
2. Open MetaTrader 5
   - Launch MetaTrader 5.
   - Go to `File` -> `Open Data Folder`.
3. Place the Script
   - Navigate to `MQL5` -> `Experts`.
   - Copy the `ScrollToRecentButton.mq5` file into the Experts folder.
4. Refresh MetaTrader 5
   - Restart MetaTrader 5 or right-click in the Navigator window and select Refresh.

## Usage

1. Load the Script
   - Open MetaTrader 5.
   - In the Navigator window, find the `ScrollToRecentButton` script under `Expert Advisors`.
   - Drag and drop the `ScrollToRecentButton` script onto the chart where you want to use it.
2. Interact with the Button
   - The "Scroll to Recent" button will appear at the bottom-right corner of the chart when you scroll back.
   - Click the button to immediately scroll to the most recent bar.
   - The button will disappear automatically when the chart reaches the most recent bar.

## Input Parameters

```markdown
- `Position`: Specifies the position of the button on the chart. (Default is `CORNER_RIGHT_LOWER`)
- `Button Color`: Specifies the background color of the button. (Default is `clrWhite`)
- `Text Color`: Specifies the color of the button text. (Default is `clrBlack`)
```

## Customization

You can customize the size and position of the x and y axes of the button by modifying the following defines in the script

```mql5
#define BUTTON_NAME "ScrollToRecentButton"
#define BUTTON_X_POSITION 50
#define BUTTON_Y_POSITION 50
#define BUTTON_WIDTH 25
#define BUTTON_HEIGHT 25
```

## Script Code
Below is the MQL5 code used to create the "Scroll to Recent" button
```mql5
//+------------------------------------------------------------------+
//|                                         ScrollToRecentButton.mq5 |
//|                                           Copyright 2024, FaceND |
//|                       https://github.com/FaceND/Scroll-to-Recent |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, FaceND"
#property link      "https://github.com/FaceND/Scroll-to-Recent"
#property version   "1.0"

#define BUTTON_NAME "ScrollToRecentButton"

#define BUTTON_X_POSITION 50
#define BUTTON_Y_POSITION 50
#define BUTTON_WIDTH 25
#define BUTTON_HEIGHT 25

input ENUM_BASE_CORNER positon = CORNER_RIGHT_LOWER;   // Position
input color button_color = clrWhite;                   // Button Color
input color text_color = clrBlack;                     // Text Color
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   if(!CreateButton())
     {
      return(INIT_FAILED);
     }
   UpdateButtonVisibility();
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   ObjectDelete(0, BUTTON_NAME);
  }
//+------------------------------------------------------------------+
//| Chart event handler function                                     |
//+------------------------------------------------------------------+
void OnChartEvent(const int id, const long &lparam, const double &dparam, const string &sparam)
  {
   if(id == CHARTEVENT_OBJECT_CLICK && sparam == BUTTON_NAME)
     {   
      ChartNavigate(0, CHART_END);
      
      ObjectDelete(0, BUTTON_NAME);
     }
   if(id == CHARTEVENT_CHART_CHANGE || id == CHARTEVENT_MOUSE_WHEEL)
     {
      UpdateButtonVisibility();
     }
  }
//+------------------------------------------------------------------+
//| Function to create a button                                      |
//+------------------------------------------------------------------+
bool CreateButton()
  {
   if(!ObjectCreate(0, BUTTON_NAME, OBJ_BUTTON, 0, 0, 0))
     {
      Print("Failed to create the button object: ", BUTTON_NAME);
      return(false);
     }
   // Set button properties
   ObjectSetInteger(0, BUTTON_NAME, OBJPROP_XDISTANCE, BUTTON_X_POSITION);
   ObjectSetInteger(0, BUTTON_NAME, OBJPROP_YDISTANCE, BUTTON_Y_POSITION);
   ObjectSetInteger(0, BUTTON_NAME, OBJPROP_XSIZE, BUTTON_WIDTH);
   ObjectSetInteger(0, BUTTON_NAME, OBJPROP_YSIZE, BUTTON_HEIGHT);
   ObjectSetInteger(0, BUTTON_NAME, OBJPROP_BGCOLOR, button_color);
   ObjectSetInteger(0, BUTTON_NAME, OBJPROP_BORDER_COLOR, button_color);
   ObjectSetInteger(0, BUTTON_NAME, OBJPROP_CORNER, positon);

   // Set text properties
   ObjectSetString (0, BUTTON_NAME, OBJPROP_TEXT, ">>");
   ObjectSetInteger(0, BUTTON_NAME, OBJPROP_COLOR, text_color);
   ObjectSetString (0, BUTTON_NAME,OBJPROP_FONT, "Arial Bold");
   ObjectSetInteger(0, BUTTON_NAME, OBJPROP_FONTSIZE, 12);

   return(true);
  }
//+------------------------------------------------------------------+
//| Function to update button visibility based on chart position     |
//+------------------------------------------------------------------+
void UpdateButtonVisibility()
  {
   long firstVisibleBarIndex = ChartGetInteger(0, CHART_FIRST_VISIBLE_BAR);
   long visibleBarsCount = ChartGetInteger(0, CHART_VISIBLE_BARS)-1;
   if(firstVisibleBarIndex == visibleBarsCount)
     {
      ObjectDelete(0, BUTTON_NAME);
      Sleep(250);
     }
   else
     {
      if(ObjectFind(0, BUTTON_NAME) == -1)
        {
         CreateButton();
        }
     }
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
