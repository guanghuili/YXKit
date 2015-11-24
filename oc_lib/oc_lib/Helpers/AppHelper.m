//
//  AppHelper.m
//  EKS
//
//  Created by ligh on 14/12/2.
//
//

#import "AppHelper.h"

@implementation AppHelper


+(NSString *)appVer
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
  //  CFShow(infoDictionary);
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    return app_Version;
}


@end
