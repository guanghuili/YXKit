//
//  ImageSliderView.h
//  WSJJ_iPad
//
//  Created by lian jie on 2/12/11.
//  Copyright 2011 2009-2010 , Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ImageSliderViewDelegate <NSObject>

@optional
- (void)imageClickedWithIndex:(NSInteger)imageIndex;
- (void)imageDidEndDeceleratingWithIndex:(NSInteger)imageIndex;
-(CGSize) sizeForPageAtIndex:(NSInteger) index;
@end

@interface ImageSliderView : UIView <UIScrollViewDelegate>
{
    NSInteger _currentPageIndex;
}

@property (nonatomic,weak)id<ImageSliderViewDelegate> delegate;

@property (assign,nonatomic) NSInteger currentPageIndex;


-(UIScrollView *) scrollView;
-(void)setScrollEnabled:(BOOL)scrollEnabled;
- (id)initWithFrame:(CGRect)frame;
- (void)setImageUrls:(NSArray*)imagesUrls;
- (void)updateFrame;
-(void) autoPlay:(NSTimeInterval ) interval;
-(UIImageView *) currentPageImageView;


@end
