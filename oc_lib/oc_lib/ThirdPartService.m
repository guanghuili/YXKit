//
//  ThirdPartService.m
//  PMS
//
//  Created by ligh on 15/9/17.
//
//

#import "ThirdPartService.h"

#import "MobClick.h"
#import "APService.h"
#import <PgyUpdate/PgyUpdateManager.h>

@implementation ThirdPartService

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
       
  
        //向微信注册 appid
        [WXApi registerApp:WXAppid];
        [WeiboSDK enableDebugMode:YES];
        [WeiboSDK registerApp:SINA_APPKEY];
        [MobClick startWithAppkey:UMENG_KEY reportPolicy:REALTIME channelId:UMENG_CHANNEL_ID];
      //  [self registerJPushWithOptions:launchOptions];
        [APService setBadge:0];
        [JPEngine startEngine];
        
         [DDLog addLogger:[DDTTYLogger sharedInstance]];
        [[DDTTYLogger sharedInstance] setColorsEnabled:YES];
        UIColor *c = UIColorFromRGB(0, 0, 255);
        [[DDTTYLogger sharedInstance] setForegroundColor:c
                                         backgroundColor:nil
                                                 forFlag:DDLogFlagInfo];
        
        ////蒲公英启动更新检查SDK
        [[PgyUpdateManager sharedPgyManager] startManagerWithAppId:@""];
        [[PgyUpdateManager sharedPgyManager] checkUpdate];
    
    });
}





@end
