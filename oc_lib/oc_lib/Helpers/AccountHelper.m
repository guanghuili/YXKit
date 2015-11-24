//
//  AccountHelper.m
//  Carte
//
//  Created by ligh on 14-4-29.
//
//

#import "AccountHelper.h"

@implementation AccountHelper

+(BOOL)isLogin
{
    return [self userInfo] != nil && !isBankString([self uid]);
}

+(UserModel *) userInfo
{
    return (UserModel *)[[DataCacheManager sharedDataCacheManager] getCachedObjectByKey:Store_UserInfoKey];
}

+(NSString *)uid
{
    
    NSString *uid = [[self userInfo] userId];
   
    if (isBankString(uid))
    {
        return @"";
    }
    return uid;

}


+(void)saveUserInfo:(UserModel *)userInfoModel
{
    [[DataCacheManager sharedDataCacheManager] addObject:userInfoModel forKey:Store_UserInfoKey];
}


+(void)logout
{

    [[DataCacheManager sharedDataCacheManager] removeObjectInCacheByKey:Store_UserInfoKey];
}

@end
