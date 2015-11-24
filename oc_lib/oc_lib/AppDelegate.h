//
//  AppDelegate.h
//  iTotemMinFramework
//
//  Created by  on 12-8-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SloppySwiperNavigationController.h"
#import "VerinfoModel.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate> {

}

@property (strong, nonatomic)    UIWindow *window;
@property (strong, nonatomic)    UINavigationController *rootNavigaitonController;
@property (strong,nonatomic)     MMDrawerController *mMDrawerController;
//@property (strong,nonatomic)      SlideMenuVC        *slideMenuVC; //左边侧边栏菜单

-(void) startAppStore;
-(void) checkAppVersion:(void (^)(VerinfoModel *versionModel)) block;


@end
