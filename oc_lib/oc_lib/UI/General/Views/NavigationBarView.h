//
//  SHNavigationBarView.h
//  ShenHuaLuGang
//
//  Created by sprint on 13-7-3.
//
//

#import <UIKit/UIKit.h>
#import "XibView.h"



/**
    自定义导航栏
 **/
@interface NavigationBarView : XibView


-(UIButton *) leftBarButton;
-(UIButton *) left2BarButton;

-(UIButton *) rightBarButton;
-(UIButton *) right2BarButton;

-(UILabel  *) navigationBarTitleLabel;



-(void) setNavigationBarTitle:(NSString *) title;


@end
