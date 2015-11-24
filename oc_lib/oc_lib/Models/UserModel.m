//
//  UserModel.m
//  PMS
//
//  Created by ligh on 14/10/22.
//
//

#import "UserModel.h"

@implementation UserModel


-(NSString *)sexIconName
{
    return [@"男" isEqualToString:_sex] ? @"nav_icon_Gender_Male" : @"nav_icon_Gender_Female";
}

-(NSString *)sex
{
    return isBankString(_sex) ? @"女" : _sex;
}

@end
