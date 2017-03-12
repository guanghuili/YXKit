//
//  AppDelegate.m
//  iTotemMinFramework
//
//  Created by  on 12-8-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
//#import "CheckVersionRequest.h"

#import "PushNotificaitonModel.h"
#import "AliPayManager.h"
#import "MPNotificationView.h"
#import "APService.h"


#import "Weather.h"
  

@interface AppDelegate()<WeiboSDKDelegate,WXApiDelegate>
{
   
}
@end

@implementation AppDelegate


- (void)dealloc
{
    RELEASE_SAFELY(_window);
    RELEASE_SAFELY(_mMDrawerController);

    RELEASE_SAFELY(_rootNavigaitonController);
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
//    [self registerJPushWithOptions:launchOptions];

//    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    
//    _slideMenuVC  = [[SlideMenuVC alloc] init];
//    
//    self.mMDrawerController = [[MMDrawerController alloc]
//                               initWithCenterViewController:[_slideMenuVC sampleAlbumListVC]
//                               leftDrawerViewController:_slideMenuVC
//                               rightDrawerViewController:nil];
//    
//    
//    [[MMExampleDrawerVisualStateManager sharedManager] setLeftDrawerAnimationType:MMDrawerAnimationTypeSlideAndScale];
//    [[MMExampleDrawerVisualStateManager sharedManager] setRightDrawerAnimationType:MMDrawerAnimationTypeSlideAndScale];
//    
//    [self.mMDrawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
//    [self.mMDrawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
//    
//    self.mMDrawerController.shouldStretchDrawer = NO;
//    
//    
//    [self.mMDrawerController
//     setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
//         MMDrawerControllerDrawerVisualStateBlock block;
//         block = [[MMExampleDrawerVisualStateManager sharedManager]
//                  drawerVisualStateBlockForDrawerSide:drawerSide];
//         if(block){
//             block(drawerController, drawerSide, percentVisible);
//         }
//     }];
//    
//    _rootNavigaitonController = [[SloppySwiperNavigationController alloc] initWithRootViewController:self.mMDrawerController];
//    _rootNavigaitonController.navigationBarHidden = YES;
//
//    self.window.rootViewController = [[UIViewController alloc] init];
//    self.window.backgroundColor = [UIColor whiteColor];
//    [self.window makeKeyAndVisible];
//    

    
    POSTResponseObject(self.window, [Weather class], @"http://www.weather.com.cn/data/sk/101010100.html",nil, ^(Weather* object) {
        
        NSLog(@"%@",object.city);
        
    }, nil);


   

    return YES;
}



-(void) changeBackground {
    
    
    [self print:@"aa" age:@"c"];
    
    
}

-(void) print:(NSString *) name age:(NSString *)age {
    
    NSLog(@"%@==%@",name,age);
    
}


//注册远程通知
-(void) registerJPushWithOptions:(NSDictionary *)launchOptions
{
    
    if([ConfigHelper isAllowPush])
            [ConfigHelper openPush];
    
    // Required
    [APService setupWithOption:launchOptions];
}



//全局控制禁止转屏
- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
    
    //如果用户通过双击home键返回到app  客户端无法接受此事件 需要手动调用处理
    AliPayManager *manager =[AliPayManager shareManager];
    [manager performSelector:@selector(handleHomeBack) withObject:nil afterDelay:0.5];
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
   // [self checkAppVersion:nil];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    
    //如果用户按照正常流程支付 则取消程序自动处理home键返回
    AliPayManager *manager =[AliPayManager shareManager];
    [AliPayManager cancelPreviousPerformRequestsWithTarget:manager selector:@selector(handleHomeBack) object:nil];
    //
    
    if([WeiboSDK handleOpenURL:url delegate:self])
    {
        return  YES;
        
    }else  if([WXApi handleOpenURL:url delegate:self])
    {
        return YES;
        
    } else if( [[AliPayManager shareManager] handleOpenURL:url])
    {
        return YES;
        
    }else
    {
        //  [self handleRemoteOpenURL:url];
    }
    
    
    return YES;
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    
    //如果用户按照正常流程支付 则取消程序自动处理home键返回
    AliPayManager *manager =[AliPayManager shareManager];
    [AliPayManager cancelPreviousPerformRequestsWithTarget:manager selector:@selector(handleHomeBack) object:nil];
    //
   
    if([WeiboSDK handleOpenURL:url delegate:self])
    {
        return  YES;
        //新浪微博
        
    }else if([WXApi handleOpenURL:url delegate:self])
    {
        return YES;
        
    }else if( [[AliPayManager shareManager] handleOpenURL:url])
    {
        return YES;
        
    }else
    {
        // [self handleRemoteOpenURL:url];
    }
    
    return YES;
}



#pragma mark -WXApiDelegate
-(void)onResp:(BaseResp *)resp
{
    if(resp.errCode)
    {
        [BDKNotifyHUD showCryingHUDWithText:@"分享失败"];
    }else
    {
        [BDKNotifyHUD showSmileyHUDWithText:@"已分享"];
    }
}

//新浪微博
- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class])
    {
        if (response.statusCode == 0) //分享成功
        {
            [BDKNotifyHUD showSmileyHUDInView:self.window text:@"已分享到新浪微博"];
        }else
        {
            [BDKNotifyHUD showCryingHUDInView:self.window text:@"分享失败"];
        }
    }
}

/**
 *  启动app store
 */
-(void) startAppStore
{
  
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.pgyer.com/qigsy"]];
    
  
//    ///TODO:替换appid
//    if (IOS_VERSION_CODE  < 7)
//    {
//        NSString * appstoreUrlString = [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?mt=8&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software&id=%@",@"672596239"];
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appstoreUrlString]];
//    }else
//    {
//        NSString * appstoreUrlString = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@",@"672596239"];
//        
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appstoreUrlString]];
//    }
    
}


//检测app版本
-(void) checkAppVersion:(void (^)(VerinfoModel *versionModel)) block
{
//    NSLog(@"%@",APP_BUILD_VER);
//    [CheckVersionRequest requestWithParameters:@{} withIndicatorView:block ? self.window : nil onRequestFinished:^(ITTBaseDataRequest *request)
//     {
//         if (request.isSuccess)
//         {
//             
//             VerinfoModel *versionInfoModel = request.resultDic[KRequestResultDataKey];
//             if (block)
//             {
//                 block(versionInfoModel);
//                 
//             }
//             
//             if (versionInfoModel.hasnew.integerValue)
//             {
//                 NSString *msg = [NSString stringWithFormat:@"发现新版本%@ \n%@",versionInfoModel.appVersion,versionInfoModel.updateInfo];
//                 
//                 [[MessageAlertView viewFromXIB] showAlertViewInView:self.window msg:msg cancelTitle:@"取消" confirmTitle:@"更新" onCanleBlock:^{
//                     
//                     
//                 } onConfirmBlock:^{
//                     
//                   [self startAppStore];
//                
//                     
//                 }];
//             }
//             
//             
//         }
//         
//     } onRequestFailed:^(ITTBaseDataRequest *request)
//     {
//         
//     }];
}


#pragma mark 推送通知
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [APService registerDeviceToken:deviceToken];
    NSLog(@"registrationID==%@",[APService registrationID]);
    
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    
}

// Called when your app has been activated by the user selecting an action from
// a local notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void (^)())completionHandler
{
    
}

// Called when your app has been activated by the user selecting an action from
// a remote notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo  completionHandler:(void (^)())completionHandler
{
    
}
#endif

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [APService handleRemoteNotification:userInfo];
    [self handleRemoteNotificaiton:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [APService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    //判断程序是不是由推送服务完成的
    [self handleRemoteNotificaiton:userInfo];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{

    [APService showLocalNotificationAtFront:notification identifierKey:nil];
}



/**
 * 处理推送
 *
 *  @param notificationModel 推送内容
 */
-(void) handleRemoteNotificaiton:(NSDictionary *)userInfo
{
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    //判断程序是不是由推送服务完成的
    if (userInfo)
    {
        //如果程序正在前台
        if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive)
        {
            PushNotificaitonModel *notificaitonModel = [[PushNotificaitonModel alloc] initWithDataDic:userInfo];
            
            [MPNotificationView notifyWithText:Brand_Name detail:notificaitonModel.alert image:UIImageForName(@"icon") duration:5 andTouchBlock:^(id sender)
             {
                 [notificaitonModel handle];
                 
             }];
            
        }else
        {
            PushNotificaitonModel *notificaitonModel = [[PushNotificaitonModel alloc] initWithDataDic:userInfo];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [notificaitonModel handle];
                
            });
        }
    }
}

@end
