//
//  ConfigHelper.m
//  Carte
//
//  Created by ligh on 14-7-1.
//
//

#import "ConfigHelper.h"


#define PushOnOffKey @"PushOnOffKey"


#import "APService.h"

@implementation ConfigHelper


+(id) objectForInfoDictionaryKey:(NSString *) key
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:key];
}


+(NSString *)appScheme
{
    NSArray *schemes = [self objectForInfoDictionaryKey:@"CFBundleURLTypes"];
    for (NSDictionary *dic in schemes)
    {
        if ([dic[@"CFBundleURLName"] isEqualToString:@"appSchemes"])
        {
            return dic[@"CFBundleURLSchemes"][0];
        }
    }
    
    return @"PMSSchemes";
}


+(BOOL)isAllowPush
{
    NSString *onOff = (NSString *)[[DataCacheManager sharedDataCacheManager] getCachedObjectByKey:PushOnOffKey];
    return isBankString(onOff) || [onOff boolValue];
}

+(void)openPush
{
    [[DataCacheManager sharedDataCacheManager] addObject:@"1" forKey:PushOnOffKey];
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0)
    {
        //可以添加自定义categories
        [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                       UIUserNotificationTypeSound |
                                                       UIUserNotificationTypeAlert)
                                           categories:nil];
    } else {
        //categories 必须为nil
        [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                       UIRemoteNotificationTypeSound |
                                                       UIRemoteNotificationTypeAlert)
                                           categories:nil];
    }
#else
    //categories 必须为nil
    [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                   UIRemoteNotificationTypeSound |
                                                   UIRemoteNotificationTypeAlert)
                                       categories:nil];
#endif
    
}

+(void)closePush
{

    [[DataCacheManager sharedDataCacheManager] addObject:@"0" forKey:PushOnOffKey];
    [[UIApplication sharedApplication] unregisterForRemoteNotifications];
}



+(NSDictionary *) configDictionary
{
      NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"pms_config" ofType:@"plist"];
      NSDictionary *configDictionary = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    
     return configDictionary;
}

+(NSString *) API_URL
{
    return [self configDictionary][@"api_url"];
}

+(NSString *) API_PIC_URL
{
    return [self configDictionary][@"api_pic_url"];
}

+(NSString *)API_SHARE_PRODUCT_URL
{
    return [NSString stringWithFormat:@"%@/%@",[self configDictionary][@"api_share_url"],[self configDictionary][@"api_share_product_url"]];
}

+(NSString *)API_SHARE_PHOTO_URL
{
    
    return [NSString stringWithFormat:@"%@/%@",[self configDictionary][@"api_share_url"],[self configDictionary][@"api_share_photo_url"]];
}

+(NSString *)API_SHARE_SALES_URL
{
    return [NSString stringWithFormat:@"%@/%@",[self configDictionary][@"api_share_url"],[self configDictionary][@"api_share_sales_url"]];
}

+(NSString *)APP_API_KEY
{
    return [self configDictionary][@"api_key"];

}

+(NSString *)APP_API_VERSION
{
    return [self configDictionary][@"api_version"];
}


+(NSString *)APP_Brand_ID
{
    return [self configDictionary][@"brand_id"];
}


+(NSString *)APP_BRAND_ID
{
    return [self configDictionary][@"brand_id"];
}


+(NSString *)APP_BRAND_NAME
{
    return [self configDictionary][@"brand_name"];
}

+(NSString *)SINA_APP_KEY
{
    return [self configDictionary][@"sina_app_key"];
}

+(NSString *)WX_APP_ID
{
    return [self configDictionary][@"wx_app_id"];
}

+(NSString *)QQ_APP_KEY
{
    return [self configDictionary][@"qq_app_key"];
}

+(NSString *)UM_APP_KEY
{
    return [self configDictionary][@"um_app_key"];
}

@end
