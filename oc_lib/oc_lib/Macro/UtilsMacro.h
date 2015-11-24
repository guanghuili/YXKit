//
//  UtilsMacro.h
//  MinFramework
//
//  方便使用的宏定义
//
//  Created by ligh on 14-3-10.
//
//

#ifndef MinFramework_UtilsMacro_h
#define MinFramework_UtilsMacro_h



#define USER_DEFAULT [NSUserDefaults standardUserDefaults]
//AppDelegate
#define KAPP_Delegate  (AppDelegate *)[UIApplication sharedApplication].delegate

//创建颜色
#define UIColorFromRGBA(r,g,b,a)    [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define UIColorFromRGB(r,g,b)       UIColorFromRGBA(r,g,b,1)

//16进制
#define UIColorFromHexRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//将int值转为string
#define NSStringFromInt(intValue) [ NSString stringWithFormat:@"%d",intValue]


//ios 版本
#define IOS_VERSION_CODE   [[[UIDevice currentDevice] systemVersion] intValue]
#define IOS_SDK_3          IOS_VERSION_CODE==3
#define IOS_SDK_4          IOS_VERSION_CODE==4
#define IOS_SDK_5          IOS_VERSION_CODE==5
#define IOS_SDK_6          IOS_VERSION_CODE==6

#define IOS7_OR_LATER [[[UIDevice currentDevice] systemVersion] floatValue] >=7.0
#define IS_IPHONE5 [[UIScreen mainScreen] currentMode].size.height ==1136
#define IS_IPHONE4 [[UIScreen mainScreen] currentMode].size.height ==960
#define IS_IPHONE6 [[UIScreen mainScreen] currentMode].size.height ==1334
#define IS_IPHONE6ORLATER [[UIScreen mainScreen] currentMode].size.height >=1334
#define IS_IPHONE6P [[UIScreen mainScreen] currentMode].size.height ==2208


//角度
#define DegreesToRadian(x) (M_PI * (x) / 180.0)
#define RadianToDegrees(radian) (radian*180.0)/(M_PI)

//全局队列
#define Global_Queue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)


#define UIImageForName(_pointer) [UIImage imageNamed:_pointer]

#define RELEASE_SAFELY(__POINTER) {  __POINTER = nil; }

#endif
