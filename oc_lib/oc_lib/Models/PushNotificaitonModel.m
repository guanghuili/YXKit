//
//  RemoteNotificaitonModel.m
//  Carte
//
//  Created by ligh on 14-5-28.
//
//

#import "PushNotificaitonModel.h"


@implementation PushNotificaitonModel



-(id)initWithDataDic:(NSDictionary *)data
{
    if (self = [super initWithDataDic:data])
    {
        self.alert = data[@"aps"][@"alert"];
    }
    return self;
}

-(void)handle
{

    PushNotificaitonType notificationType = self.paramtype.intValue;
    AppDelegate *appDelegate = KAPP_Delegate;
    

    

}

@end
