//
//  SHNavigationBarView.m
//  ShenHuaLuGang
//
//  Created by sprint on 13-7-3.
//
//

#import "NavigationBarView.h"

@interface NavigationBarView()
{

    //左边按钮
    IBOutlet UIButton       *_leftBarButton;

    IBOutlet UIButton       *_left2BarButton;

    //右边按钮
    IBOutlet UIButton       *_rightBarButton;

    IBOutlet UIButton       *_right2BarButton;
    
    //导航栏标题
    IBOutlet UILabel        *_navigationTitleLabel;

}
@end

@implementation NavigationBarView

- (void)dealloc
{
    RELEASE_SAFELY(_leftBarButton);
    RELEASE_SAFELY(_rightBarButton);
    RELEASE_SAFELY(_right2BarButton);
    RELEASE_SAFELY(_navigationTitleLabel);
    RELEASE_SAFELY(_left2BarButton);
}

-(void)awakeFromNib
{
    [super awakeFromNib];
 //  _navigationTitleLabel.textColor = [ConfigHelper navigationBarTitleColor];
    
 //   _rightBarButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
}

-(void)setNavigationBarTitle:(NSString *)title
{
    [_navigationTitleLabel setText:title];
}

-(UIButton *)leftBarButton
{

    return _leftBarButton;
}

-(UIButton *)left2BarButton
{
    return _left2BarButton;
}

-(UIButton *)rightBarButton
{
    return _rightBarButton;
}


-(UIButton *)right2BarButton
{
    return _right2BarButton;
}


-(UILabel *) navigationBarTitleLabel
{

    return _navigationTitleLabel;
}


@end
