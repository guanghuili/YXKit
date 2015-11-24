//
//  SlideMenuModel.h
//  PMS
//
//  Created by ligh on 14-7-14.
//
//

#import <Foundation/Foundation.h>

typedef enum
{
    SlideMenuHomeType,
    SlideMenuPackageType,
    SlideMenuActivityType,
    SlideMenuOutSceneType,
    SlideMenuMeType,
    SlideMenuMsgType
    
}SlideMenuType;
//菜单model
@interface SlideMenuModel : NSObject

@property (strong,nonatomic) NSString   *title;//显示的标题
@property (strong,nonatomic) NSString   *normalIconImageName;
@property (strong,nonatomic) NSString   *selectedIconImageName;
@property (assign,nonatomic) BOOL       selected;//是否选中

@property (assign,nonatomic) SlideMenuType menuype;


@end
