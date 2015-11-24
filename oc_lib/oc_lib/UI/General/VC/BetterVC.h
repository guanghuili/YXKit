//
//  SHBaseViewController.h
//  ShenHuaLuGang
//
//  Created by 李光辉 on 13-6-27.
//  
//

#import <UIKit/UIKit.h>

#import "NavigationBarView.h"
#import "AccountStatusObserverManager.h"

#import "PromptView.h"

typedef enum
{
    UIButtonStyleBack, //返回
    UIButtonStyleMenu,//菜单
    UIButtonStyleVoice,//语音
    UIButtonStyleShare,//分享
    UIButtonStylePicture,//图片
    UIButtonStyleDownload,//下载
    UIButtonStyleStores,//店铺列表
    UIButtonStyleSales,//折扣优惠信息
    UIButtonStylePicCategory,//图片分类
    UIButtonStyleClose,//关闭
    UIButtonStyleMap
    
} UIButtonStyle;


/**
    基本的ViewController    定制navigationBar
 **/
@interface BetterVC : UIViewController <UITextFieldDelegate>



+(id) initVC;



/***
    ContentView的作用： 主要用来适配ios7 在ios7中所有y=0 代表UIView从状态栏显示
                                      在ios7之前y=0 有两种情况如果显示系统导航栏代表导航栏之下为0 否则状态栏之下
 
    为了适配这三种情况加入contentView  xib 或者代码布局时 应该将显示内容的view放入此view种（导航栏view排除），BaseViewController 会自动根据当前ViewController状态（是显示系统导航栏还是自定义导航栏）及 ios版本调整contentView的显示位置。 xib布局则按照以前的布局方式
 
 **/
@property (strong,nonatomic) IBOutlet UIView *contentView;



//解释下：
//
//有些ViewController contentView的top 可能不是从navigationBarView的底部开始。如果带有tab栏的viewcontroller
//通过此function设置contentview的顶部坐标时，当键盘消失后 会参考此contentViewTop，而不是使用navigationBarView.bottom的数值。
//如果不设置contentViewTop,键盘消失后会使用navigationBarView.bottom作为contentView的y坐标。
//
//
-(void) setContentViewTop:(float) contentViewTop;

/**************导航栏**************************/
-(NavigationBarView *) navigationBarView;
//点击左边导航栏按钮
-(void) actionClickNavigationBarLeftButton;
//点击右边导航栏按钮
-(void) actionClickNavigationBarRightButton;
-(void) actionClickNavigationBarRightButton2;
//是否显示自定义导航栏 需要子类重写 默认显示
-(Boolean)          isCustomNavigationBar;
-(void) setNavigationBarTitle:(NSString *) title;
//设置uibutton 样式
-(void) setUIButtonStyle:(UIButtonStyle) style withUIButton:(UIButton *) button;
-(void) setLeftNavigationBarButtonStyle:(UIButtonStyle) style;
-(void) setRightNavigationBarButtonStyle:(UIButtonStyle) style;
-(void)  configViewController;

//从当前viewcontroler push一个新的viewcontrller
-(void) setViewControllersWithVC:(UIViewController *) vc;

//弹出自己 并且push一个新的viewcontroller
-(void) popSelfAndPushViewController:(UIViewController *) vc;

/****************键盘事件************************/
//如果开启此功能 则VieController 会自动监听键盘弹起事件 自动将编辑中的view拖动到可见区域
-(void)enableKeyboardManger;    /*default enabled*/
//禁用自动托起功能
-(void)disableKeyboardManager;
-(BOOL) isEnableKeyboardManger;
-(BOOL) isShowBackgroundImage;

//结束编辑退出软键盘
-(void) endEditing;
//键盘弹起通知
- (void)keyboardWillShow:(NSNotification *)notification;
//键盘退出通知
- (void)keyboardWillHide:(NSNotification *)notification;
- (void) textFieldDidChange:(UITextField *) textField;
-(void) postNotificaitonName:(NSString *) notificationName;

-(void) loginIfNeed:(AccountStatusObserverBlock)block;

-(PromptView *)  promptView;
-(void) showPromptViewWithText:(NSString *) text;
-(void) hidePromptView;
-(void) tapPromptViewAction;

@end
