//
//  ConfigHelper.h
//  Carte
//
//  Created by ligh on 14-7-1.
//
//

#import <Foundation/Foundation.h>



@interface ConfigHelper : NSObject



+(id) objectForInfoDictionaryKey:(NSString *) key;

+(NSString *) appScheme;

//判断用户是否允许发生推送
+(BOOL) isAllowPush;
//打开推送
+(void) openPush;
//关闭推送
+(void) closePush;


+(NSString *) API_URL;
+(NSString *) API_PIC_URL;
+(NSString *) API_SHARE_PRODUCT_URL;
+(NSString *) API_SHARE_PHOTO_URL;
+(NSString *) API_SHARE_SALES_URL;
+(NSString *) APP_API_KEY;
+(NSString *) APP_API_VERSION;
+(NSString *) APP_BRAND_ID;
+(NSString *) APP_BRAND_NAME;

+(NSString *)   SINA_APP_KEY;
+(NSString *)   WX_APP_ID;
+(NSString *)   QQ_APP_KEY;
+(NSString *)   UM_APP_KEY;

@end
