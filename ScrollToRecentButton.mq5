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