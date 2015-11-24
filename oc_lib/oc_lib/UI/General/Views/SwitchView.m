//
//  SwitchView.m
//  PMS
//
//  Created by ligh on 14-7-29.
//
//

#import "SwitchView.h"

@interface SwitchView()
{
    UIView  *_onView;
    UIView  *_offView;
}
@end

@implementation SwitchView

-(void)awakeFromNib
{
    [super awakeFromNib];
 
    [self buidActionViews];
}


-(void) buidActionViews
{

    [self buildOffActionBgView];
    
    
    _onView = [self buidOnActionView];

    _onView.left = _offView.width;
    
    [self addSubview:_offView];
    [self addSubview:_onView];
    
    
    self.width = _onView.width;
    self.backgroundColor = [UIColor clearColor];
}


-(UIView *) buidOnActionView
{

    UIImage *bgImage = UIImageForName(@"mag_Button1");
    UIControl *actionControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, bgImage.size.width/2.0, bgImage.size.height/2.0)];
   
    UIButton *actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [actionButton setImage:bgImage forState:UIControlStateNormal];
    [actionControl addSubview:actionButton];
    
    UIImage *onImage = UIImageForName(@"mag_Button3");
    UIImageView *onImageView = [[UIImageView alloc] initWithImage:onImage];
    onImageView.size = CGSizeMake(onImage.size.width/2.0, onImage.size.height/2.0);
    [actionControl addSubview:onImageView];
    actionControl.backgroundColor = [UIColor clearColor];
    
    [actionControl addTarget:self action:@selector(onAction:) forControlEvents:UIControlEventTouchUpInside];
 
    return actionControl;
}

-(void) buildOffActionBgView
{
    UIImage *bgImage = UIImageForName(@"mag_Button2");
    UIImageView *actionButton = [[UIImageView alloc] initWithImage:bgImage];
    actionButton.size = CGSizeMake(bgImage.size.width/2.0, actionButton.size.height/2.0);
    [self addSubview:actionButton];

}

-(void) onAction:(UIControl *) sender
{
  
    [UIView beginAnimations:@"OnAnimation" context:nil];
    
    
    
    [UIView commitAnimations];
}

-(void) offAction:(UIControl *) sender
{
    
}


@end
