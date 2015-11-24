//
//  AppMacro.h
//  MinFramework
//  app相关的宏定义
//
//  Created by ligh on 14-3-10.
//
//

#ifndef MinFramework_AppMacro_h
#define MinFramework_AppMacro_h

#import "AppDelegate.h"
#import "AccountStatusObserverManager.h"

#define Host_Url                @"" //接口地址
#define Pic_Host_Url            [ConfigHelper API_PIC_URL]//图片服务器地址

#define Share_Product_Url       [ConfigHelper API_SHARE_PRODUCT_URL]//套餐分享地址
#define Share_Photo_Url         [ConfigHelper API_SHARE_PHOTO_URL] // //照片分享地址
#define Share_Sales_Url         [ConfigHelper API_SHARE_SALES_URL] //促销分享地址

#define API_KEY                 [ConfigHelper APP_API_KEY]//apikey
#define API_VER                 [ConfigHelper APP_API_VERSION] //api版本号
#define Brand_ID                [ConfigHelper APP_BRAND_ID]//商家id
#define Brand_Name              [ConfigHelper APP_BRAND_NAME] //商家名称


#define APP_VER                 [AppHelper appVer]
#define APP_BUILD_VER           [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]

#define Pic_ServerHost_Key      @"Pic_ServerHost_Key"






#endif
