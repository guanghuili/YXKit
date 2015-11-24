//
//  ExpandFrameView.h
//  Carte
//
//  Created by ligh on 14-4-12.
//
//

#import "FrameView.h"
#define Default_Height 48.0f

@protocol ExpandFrameViewDeleagte;

@interface ExpandFrameView : XibView

@property (strong,nonatomic) IBOutlet UIButton *arrowButton;
@property (strong,nonatomic) IBOutlet UIButton *headerTitleButton;

@property (weak,nonatomic) IBOutlet id<ExpandFrameViewDeleagte> layoutDelegate;

@property (nonatomic,assign) BOOL opened;

//切换显示
-(IBAction) switchShow;
-(void) layoutSuperView;
-(float) allSubViewHeight;


//展开
-(void)openup:(BOOL) animation;
-(void) openup;
//闭合
-(void) close;

@end

@protocol ExpandFrameViewDeleagte <NSObject>
//返回view 距离顶部view的距离
-(float) expandFrameView:(ExpandFrameView *) expandFrameView topMarginOfView:(UIView *) view;
@end
