//
//  VendorMacro.h
//  MinFramework
//  第三方常量
//  Created by ligh on 14-3-10.
//
//

#ifndef MinFramework_VendorMacro_h
#define MinFramework_VendorMacro_h

//友盟统计
#define UMENG_KEY               [ConfigHelper UM_APP_KEY]
#define UMENG_CHANNEL_ID        @"appstore"

//新浪微博相关
#define SINA_APPKEY             [ConfigHelper SINA_APP_KEY]
#define SINA_RedirectURI        @"http://www.qcdn.net"
#import "WeiboSDK.h"


//微信
#define WXAppid                 [ConfigHelper WX_APP_ID]
#import "WXApi.h"
#import "WXApiObject.h"

//QQ
#define QQAppKey                [ConfigHelper QQ_APP_KEY]
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/TencentApiInterface.h>
#import <TencentOpenAPI/QQApi.h>
#import <TencentOpenAPI/TencentMessageObject.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/QQApiInterfaceObject.h>




#endif
