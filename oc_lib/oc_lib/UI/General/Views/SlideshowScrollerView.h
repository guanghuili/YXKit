//
//  SlideshowScrollerView
//
//  Created by sprint on 12-11-24.
//
//

#import <UIKit/UIKit.h>

@protocol SlideshowScrollerViewDelegate <NSObject>

@optional
-(void)slideshowScrollerViewDidClickPageIndex:(NSUInteger)index;
-(void)slideshowScrollerViewPlayingPageIndex:(NSUInteger)index;
-(CGRect) rectForPageAtIndex:(NSInteger) index;

@end


//支持幻灯片播放 支持无限轮滑
@interface SlideshowScrollerView : UIView<UIScrollViewDelegate>
{
	UIScrollView *scrollView;
	NSArray *imageArray;
    id<SlideshowScrollerViewDelegate> delegate;
    NSInteger _currentPageIndex;
    UIView      *pageDotContainer;//page点
}


@property(nonatomic,strong) id<SlideshowScrollerViewDelegate> delegate;
@property(assign,nonatomic) NSInteger currentPageIndex;

//设置显示的图片地址（可以是网络地址也可以是本地图片）
-(void) setImageUrlArray:(NSArray *) imgArr;
//幻灯片播放
-(void) playSlideshow;
//停止播放幻灯片
-(void) stopSlideshow;

@end
