//
//  UIMacro.h
//  MinFramework
//
//  Created by ligh on 14-3-10.
//
//

#ifndef MinFramework_UIMacro_h
#define MinFramework_UIMacro_h

#import "FrameLineView.h"


//字体相关
#define FONT_S             [UIFont systemFontOfSize:12]
#define FONT_M             [UIFont systemFontOfSize:14]
#define FONT_L             [UIFont systemFontOfSize:17]
#define FONT_L1             [UIFont systemFontOfSize:19]
#define FONT_HTMLTEXT      [UIFont systemFontOfSize:17]
//粗体
#define BOLD_FONT_S         [UIFont boldSystemFontOfSize:12]
#define BOLD_FONT_M         [UIFont boldSystemFontOfSize:14]
#define BOLD_FONT_L         [UIFont boldSystemFontOfSize:17]

//系统色值
#define AppThemeBackgroundColor     UIColorFromRGB(245,246,248)
#define AppThemeLineColor           UIColorFromRGB(220,220,220)
#define AppThemeMainColor           UIColorFromRGB(185,212,68)


#define AppThemeMainTextColor       AppThemeMainColor
#define AppThemeSelectedColor       AppThemeMainTextColor

//间隔
#define MARGIN_S            5
#define MARGIN_M            10
#define MARGIN_L            15

//屏幕相关
#define SCREEN_BOUNDS          [[UIScreen mainScreen] bounds]
#define SCREEN_HEIGHT           UISCREEN.size.height
#define SCREEN_WIDTH            UISCREEN.size.width

#define SmallPlaceHolderImage      UIImageForName(@"bg_bottom-QGlogo")
#define BigPlaceHolderImage         UIImageForName(@"bg_bottom-QGlogo")
#define MiddlePlaceHolderImage      UIImageForName(@"bg_bottom-QGlogo")
#define PortraitPlaceHolderImage    UIImageForName(@"nav_Head2")

//状态栏相关
#define STATUS_BAR_HEIGHT        20

#endif
