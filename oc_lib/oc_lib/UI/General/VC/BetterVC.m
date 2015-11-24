//
//  SHBaseViewController.m
//  ShenHuaLuGang
//
//  Created by sprint on 13-6-27.
//
//

#import "BetterVC.h"

#define KNavigationBarHeight 64

@interface BetterVC ()
{
    
    NavigationBarView       *_navigationBarView;
    
    PromptView              *_promptView;//无数据或网络错误提示view
    
    //***************键盘弹起时自动拖动TextField 到可见区域******************/
    //正在编辑的textview
    UIView            *_editingTextFieldOrTextView;
    id              _textViewOrFieldOrgDelegate;

    float             _contentViewTop;
}
@end

@implementation BetterVC
@synthesize contentView = _contentView;

+(id)initVC
{
    return [[self alloc] init];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    RELEASE_SAFELY(_promptView);
    RELEASE_SAFELY(_contentView);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    [self configViewController];
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self enableKeyboardManger];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self endEditing];
    [self disableKeyboardManager];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self endEditing];
}

-(void)endEditing
{
     [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

/**
    配置ViewController 调整contentView的高度和top属性 如果是ios7版本则设置ViewController的edgesForExtendedLayout 取消偏移
 */
-(void) configViewController
{
    
    if([ self isCustomNavigationBar])
    {
        [self loadNavigationBar];
        
        if(!_contentView)
        {
            _contentView = [[UIView alloc] init];
            [self.view addSubview:_contentView];
        }
    }

    UIWindow *window = KAPP_Delegate.window;
    self.view.size = window.size;
    

    _contentView.top =  _navigationBarView.bottom ;
    _contentView.size = CGSizeMake(self.contentView.width, self.contentView.height - _navigationBarView.bottom);
    
    
    //设置Viewcontroller背景颜色
    _contentView.backgroundColor = AppThemeBackgroundColor;
    [_contentView setClipsToBounds:YES];
    [self.view setClipsToBounds:YES];
    self.view.backgroundColor = [UIColor whiteColor];
    
//    if ([self isShowBackgroundImage])
//    {
//        UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.width, self.contentView.height)];
//        backgroundImageView.image = UIImageForName(@"bg_Login");
//        [self.contentView addSubview:backgroundImageView];
//        [self.contentView sendSubviewToBack:backgroundImageView];
//    }

    

    if ([self respondsToSelector:@selector(extendedLayoutIncludesOpaqueBars)])
    {
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}


//自定义导航栏背景
-(void) loadNavigationBar
{

    [self.navigationController setNavigationBarHidden:YES];
    _navigationBarView = [NavigationBarView viewFromXIB];
    _navigationBarView.height +=  (IOS_VERSION_CODE > 6 ? 20  : 0);
    _navigationBarView.width = self.view.width;
    _navigationBarView.top = 0;
  
    
    [self.view addSubview:_navigationBarView];
    [_navigationBarView.rightBarButton addTarget:self action:@selector(actionClickNavigationBarRightButton) forControlEvents:UIControlEventTouchUpInside];
    [_navigationBarView.leftBarButton addTarget:self action:@selector(actionClickNavigationBarLeftButton) forControlEvents:UIControlEventTouchUpInside];
    [_navigationBarView.right2BarButton addTarget:self action:@selector(actionClickNavigationBarRightButton2) forControlEvents:UIControlEventTouchUpInside];
    
    [self setUIButtonStyle:UIButtonStyleBack withUIButton:self.navigationBarView.leftBarButton];
    
    _navigationBarView.leftBarButton.hidden = NO;
    
    [self.view bringSubviewToFront:_navigationBarView];
    
}

-(BOOL)isShowBackgroundImage
{
    return NO;
}


-(void)setNavigationBarTitle:(NSString *)title
{
    if([self isCustomNavigationBar])
    {
        [self.navigationBarView setNavigationBarTitle:title];
    
    } else
    {
        [self.navigationController setTitle:title];
    }
}

-(NavigationBarView *)navigationBarView
{
    return _navigationBarView;
}

-(void)setUIButtonStyle:(UIButtonStyle)style withUIButton:(UIButton *)button
{
    
    if(style == UIButtonStyleBack)
    {

        [button setImage:[UIImage imageNamed:@"nav_Return"] forState:UIControlStateNormal];
     
    } else if(style == UIButtonStyleMenu)
    {
        [button setImage:[UIImage imageNamed:@"nav_List"] forState:UIControlStateNormal];
        
    }else if(style == UIButtonStyleVoice)
    {
        [button setImage:[UIImage imageNamed:@"nav_Customer service"] forState:UIControlStateNormal];
        
    }else if(style == UIButtonStyleShare)
    {
        [button setImage:[UIImage imageNamed:@"nav_share"] forState:UIControlStateNormal];
     
        
    }else if(style == UIButtonStylePicture)
    {
        [button setImage:[UIImage imageNamed:@"nav_picture"] forState:UIControlStateNormal];
        
    }else if(style == UIButtonStyleDownload)
    {
        [button setImage:[UIImage imageNamed:@"nav_Download"] forState:UIControlStateNormal];
   
        
    }else if(style == UIButtonStyleStores)
    {
        [button setImage:[UIImage imageNamed:@"nav_The-store"] forState:UIControlStateNormal];
      
        
    }else if(style == UIButtonStyleMap)
    {
        [button setImage:[UIImage imageNamed:@"nav_map"] forState:UIControlStateNormal];
     
        
    }else if(style == UIButtonStylePicCategory)
    {
        [button setImage:[UIImage imageNamed:@"nav_Thumbnail"] forState:UIControlStateNormal];
      
    }else if(style == UIButtonStyleSales)
    {
        [button setImage:[UIImage imageNamed:@"nav_sales"] forState:UIControlStateNormal];
           // button.frame = CGRectMake(button.left + MARGIN_M, button.top, 28, 28);
    }else if(style == UIButtonStyleClose) {
        
        [button setImage:[UIImage imageNamed:@"nav_close"] forState:UIControlStateNormal];
    }
    
    
    
    
}

-(void)setLeftNavigationBarButtonStyle:(UIButtonStyle)style
{
    [self setUIButtonStyle:style withUIButton:self.navigationBarView.leftBarButton];
    
}

-(void) setRightNavigationBarButtonStyle:(UIButtonStyle)style
{
    [self setUIButtonStyle:style withUIButton:self.navigationBarView.rightBarButton];

}
//
-(Boolean)isCustomNavigationBar
{
    return true;
}

///////////////////////////////////////////////////////////////////////////////
#pragma mark  view actions
///////////////////////////////////////////////////////////////////////////////
-(void)actionClickNavigationBarLeftButton
{
     [self endEditing];
    
     [self.navigationController popViewControllerAnimated:YES];
}

-(void)actionClickNavigationBarRightButton
{

}

-(void)actionClickNavigationBarRightButton2
{

}

-(void)setViewControllersWithVC:(UIViewController *)vc
{
    
    NSArray *allViewControllers = self.navigationController.viewControllers;
    NSArray *fillterViewControllers = [allViewControllers subarrayWithRange:NSMakeRange(0,[allViewControllers indexOfObject:self]+1)];
    NSMutableArray  *viewControllers = [NSMutableArray arrayWithArray:fillterViewControllers];
    [viewControllers addObject:vc];
    [self.navigationController setViewControllers:viewControllers animated:YES];
}


-(void)popSelfAndPushViewController:(UIViewController *)vc
{

    NSMutableArray *allViewControllers = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    NSArray *removedSelfViewControllers= [allViewControllers subarrayWithRange:NSMakeRange(0, [allViewControllers indexOfObject:self])];
    
    NSMutableArray *newViewControllers = [NSMutableArray arrayWithArray:removedSelfViewControllers];
    [newViewControllers addObject:vc];
    
    [self.navigationController setViewControllers:newViewControllers    animated:YES];
}

///////////////////////////////////////////////////////////////////////////////
#pragma mark  键盘事件
///////////////////////////////////////////////////////////////////////////////

-(BOOL)isEnableKeyboardManger
{
    return YES;
}

-(void)enableKeyboardManger
{
    
    if (![self isEnableKeyboardManger])
    {
        return;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    /*Registering for textField notification*/
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidBeginEditingNotification:) name:UITextFieldTextDidBeginEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidEndEditingNotification:) name:UITextFieldTextDidEndEditingNotification object:nil];
    
    /*Registering for textView notification*/
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidBeginEditingNotification:) name:UITextViewTextDidBeginEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidEndEditingNotification:) name:UITextViewTextDidEndEditingNotification object:nil];

}

-(void)disableKeyboardManager
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidBeginEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidEndEditingNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidBeginEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidEndEditingNotification object:nil];
}


-(void)setContentViewTop:(float)contentViewTop
{
    _contentView.top = contentViewTop;
    _contentViewTop = contentViewTop;
}

-(void)keyboardWillShow:(NSNotification *)notification
{
    
    if (!_editingTextFieldOrTextView)
    {
        return;
    }
    /*
        获取通知携带的信息
     */
    NSDictionary *userInfo = [notification userInfo];
    
    // Get the origin of the keyboard when it's displayed.
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    // Get the top of the keyboard as the y coordinate of its origin in self's view's coordinate system. The bottom of the text view's frame should align with the top of the keyboard's final position.
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect toView:self.view];
    
    CGRect textViewRect =  [_editingTextFieldOrTextView.superview convertRect:_editingTextFieldOrTextView.frame toView:self.view];
    
    
    float offsetY  = (textViewRect.origin.y + textViewRect.size.height) - keyboardRect.origin.y;
    
    //输入框未被键盘遮挡 无需调整
    if (offsetY <=0)
    {
        return;
    }
    
  //  offsetY += IOS_VERSION_CODE < IOS_SDK_7 ? 44 :0;
  
    //获取键盘的动画执行时长
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
     self.contentView.top -= (offsetY + 10);
    
    [UIView commitAnimations];
}


-(void)keyboardWillHide:(NSNotification *)notification
{

    NSDictionary* userInfo = [notification userInfo];
    
    /*
     Restore the size of the text view (fill self's view).
     Animate the resize so that it's in sync with the disappearance of the keyboard.
     */
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    self.contentView.top =   _contentViewTop > 0? _contentViewTop : self.navigationBarView.bottom;

    [UIView commitAnimations];
}


#pragma mark - UITextField Delegate methods
//Fetching UITextField object from notification.
-(void)textFieldDidBeginEditingNotification:(NSNotification *) notification
{
    _editingTextFieldOrTextView = notification.object;
    if ([_editingTextFieldOrTextView isKindOfClass:[UITextField class]])
    {
        UITextField *textFiled = (UITextField *)_editingTextFieldOrTextView;
        if (!textFiled.delegate)
        {
            [textFiled setDelegate:self];
        }
        [textFiled addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [textFiled setReturnKeyType:UIReturnKeyDone];
    }else
    {
        UITextView *textView = (UITextView *)_editingTextFieldOrTextView;
        [textView setReturnKeyType:UIReturnKeyDone];
    }

}

//Removing fetched object.
-(void)textFieldDidEndEditingNotification:(NSNotification*)notification
{
    [_editingTextFieldOrTextView resignFirstResponder];
    _editingTextFieldOrTextView = nil;
    _textViewOrFieldOrgDelegate =nil;
}

- (void) textFieldDidChange:(UITextField *) textField
{

}

//-(UIStatusBarStyle)preferredStatusBarStyle
//{
//    return UIStatusBarStyleBlackOpaque;
//}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self endEditing];
    return YES;
}

-(void)postNotificaitonName:(NSString *)notificationName
{
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil];
}


-(void) loginIfNeed:(AccountStatusObserverBlock)block
{
    if (![AccountHelper isLogin])
    {
        
        [[AccountStatusObserverManager shareManager] addObserverBlock:block];
        
//        LoginVC *loginVC = [[LoginVC alloc] init];
//        [self.navigationController pushViewController:loginVC animated:YES];
        
    }else
    {
        block(LoginSuccess);
    }
}

-(PromptView *)promptView
{
    if (!_promptView)
    {
        _promptView = [PromptView viewFromXIB];
        [_promptView.actionButton addTarget:self action:@selector(tapPromptViewAction) forControlEvents:UIControlEventTouchUpInside];
        _promptView.frame = CGRectMake(0, 0, self.contentView.width, self.contentView.height);
//        _promptView.backgroundColor = self.contentView.backgroundColor;
    }
    
    return _promptView;
}


-(void)showPromptViewWithText:(NSString *)text
{

    [[self promptView] setPromptText:text];
    [self.contentView addSubview:[self promptView]];
}

-(void)hidePromptView
{
    if (_promptView)
    {
        [[self promptView] removeFromSuperview];
    }

}

-(void)tapPromptViewAction
{

}

@end
