//
//  ImageSliderView.m
//  WSJJ_iPad
//
//  Created by lian jie on 2/12/11.
//  Copyright 2011 2009-2010 Dow Jones & Company, Inc. All rights reserved.
//

#import "ImageSliderView.h"

@interface ImageSliderView()
{
    id<ImageSliderViewDelegate> __weak _delegate;
    UIScrollView    *_scrollView;
    NSArray         *_imageUrls;           //image urls
    NSMutableSet    *_recycledPages;
    NSMutableSet    *_visiblePages;
    // these values are stored off before we start rotation so we adjust our content offset appropriately during rotation
    int             firstVisiblePageIndexBeforeRotation;
    CGFloat         percentScrolledIntoFirstVisiblePage;
    
    
    NSMutableDictionary *_pageDic;
    
    NSTimeInterval             autoPalyAfterDelay ;
    
    
}

- (void)configurePage:(UIImageView *)page forIndex:(NSInteger)index;
- (BOOL)isDisplayingPageForIndex:(NSInteger)index;

- (CGRect)frameForPageAtIndex:(NSInteger)index;
- (CGSize)contentSizeForPagingScrollView;

- (void)tilePages;
- (void)clearPages;
- (UIImageView *)dequeueRecycledPageForIndex:(NSInteger)index;

@end


@implementation ImageSliderView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _recycledPages = [[NSMutableSet alloc] init];
        _visiblePages  = [[NSMutableSet alloc] init];
        
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self addSubview:_scrollView];
        
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.clipsToBounds = NO;
        _scrollView.delegate = self;
//        _scrollView.backgroundColor = UIColorFromRGB(245, 245, 245);
        _scrollView.alpha = 0;
        _scrollView.zoomScale = 1;
        _scrollView.minimumZoomScale = 0.5;
        _scrollView.maximumZoomScale = 1.5;
        
        autoPalyAfterDelay = 3;
        
        _scrollView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
       // self.backgroundColor = UIColorFromRGB(245, 245, 245);
        
        _pageDic = [NSMutableDictionary dictionary];
        
    }
    return self;
}

-(void)setScrollEnabled:(BOOL)scrollEnabled
{
    _scrollView.scrollEnabled = scrollEnabled;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _recycledPages = [[NSMutableSet alloc] init];
        _visiblePages  = [[NSMutableSet alloc] init];
        
     
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self addSubview:_scrollView];
        
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.clipsToBounds = NO;
        _scrollView.delegate = self;
        _scrollView.alpha = 0;
        _scrollView.minimumZoomScale = 0.5;
        _scrollView.maximumZoomScale = 1.5;
        _scrollView.zoomScale = 1;
        
        
        _scrollView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        
           _pageDic = [NSMutableDictionary dictionary];
        
    }
    return self;
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    _scrollView.size = frame.size;
    
}

- (void)setImageUrls:(NSArray*)imageUrls
{
    [self clearPages];
    RELEASE_SAFELY(_imageUrls);
    _imageUrls = imageUrls;

    _scrollView.alpha = 1;
    _scrollView.contentSize = [self contentSizeForPagingScrollView];
    
    [_scrollView setContentOffset:CGPointZero];
    if ([_delegate respondsToSelector:@selector(imageDidEndDeceleratingWithIndex:)]) {
        [_delegate imageDidEndDeceleratingWithIndex:_scrollView.contentOffset.x/_scrollView.bounds.size.width];
    }
    [self tilePages];
}


-(UIScrollView *)scrollView
{
    return _scrollView;
}


-(void)autoPlay:(NSTimeInterval)interval
{
    autoPalyAfterDelay = interval;
        
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(startAutoSwitchPageAnimationing) object:nil];
    [self performSelector:@selector(startAutoSwitchPageAnimationing) withObject:nil afterDelay:autoPalyAfterDelay];
}


-(void) startAutoSwitchPageAnimationing
{
    
    float offsetX = _scrollView.contentOffset.x + self.width;
    
    offsetX =offsetX >= _scrollView.contentSize.width ? 0 :offsetX;
    
    int pageIndex =  offsetX / self.width;
    
    [_scrollView setContentOffset:CGPointMake(MIN(offsetX,_scrollView.contentSize.width - self.width), 0) animated:offsetX!=0];
    
    [self tilePages];
    
    if ([_delegate respondsToSelector:@selector(imageDidEndDeceleratingWithIndex:)])
    {
        [_delegate imageDidEndDeceleratingWithIndex:pageIndex];
    }
    
    [self performSelector:@selector(startAutoSwitchPageAnimationing) withObject:nil afterDelay:autoPalyAfterDelay];
    
    
}

- (void)dealloc
{
    _delegate = nil;
    RELEASE_SAFELY(_scrollView);
    RELEASE_SAFELY(_recycledPages);
    RELEASE_SAFELY(_visiblePages);
    RELEASE_SAFELY(_imageUrls);
}



#pragma mark - Tiling and page configuration
-(NSInteger)currentPageIndex
{
    CGRect visibleBounds = _scrollView.bounds;
    NSInteger currentIndex = floorf(CGRectGetMinX(visibleBounds) / CGRectGetWidth(visibleBounds));
    currentIndex = MAX(currentIndex,0);
    currentIndex = MIN(currentIndex,[_imageUrls count] + 1);
    
    return currentIndex;
}

-(UIImageView *)currentPageImageView
{
    return  [_pageDic objectForKey:[NSString stringWithFormat:@"%ld",[self currentPageIndex]]];
}

-(void)setCurrentPageIndex:(NSInteger)currentPageIndex
{
    _currentPageIndex = currentPageIndex;
    [_scrollView setContentOffset:CGPointMake(_currentPageIndex * _scrollView.width, 0) animated:YES];
    if ([_delegate respondsToSelector:@selector(imageDidEndDeceleratingWithIndex:)]) {
        [_delegate imageDidEndDeceleratingWithIndex:_scrollView.contentOffset.x/_scrollView.bounds.size.width];
    }
    [self tilePages];
}

- (void)updateFrame
{
    [_scrollView setContentSize:[self contentSizeForPagingScrollView]];
    CGFloat offsetX = floorf(_scrollView.contentOffset.x/_scrollView.width)*_scrollView.width;
    [_scrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
}

- (void)tilePages
{
	NSInteger firstIndex = 0;
	NSInteger lastIndex = [_imageUrls count] - 1;
	// Calculate which pages are visible

    NSInteger currentIndex = [self currentPageIndex];
    
	NSInteger previousPageIndex = currentIndex - 2;
	NSInteger nextPageIndex = currentIndex + 2;
	
	previousPageIndex = MAX(previousPageIndex,firstIndex);
	nextPageIndex  = MIN(nextPageIndex,lastIndex);
	
    NSMutableArray *visibleIndexes = [NSMutableArray array];
    for (NSInteger i = previousPageIndex; i<=nextPageIndex; i++) {
        [visibleIndexes addObject:@(i)];
    }
	// Recycle no-longer-visible pages
	for (UIImageView *page in _visiblePages) {
        NSInteger indexInImages = page.tag;
        if (indexInImages < previousPageIndex || indexInImages > nextPageIndex){
			[_recycledPages addObject:page];
			[page removeFromSuperview];
			
		}
	}
	[_visiblePages minusSet:_recycledPages];
	
	// add missing pages
	for (int i = 0; i < [visibleIndexes count]; i++) {
		int index = [(NSNumber*)visibleIndexes[i] intValue];
		if (![self isDisplayingPageForIndex:index]) {
			UIImageView *page = [self dequeueRecycledPageForIndex:index];
			if (page == nil) {
				page = [[UIImageView alloc] initWithFrame:_scrollView.bounds];
                page.userInteractionEnabled = YES;
                page.backgroundColor = [UIColor clearColor];
            
                
                UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClicked:)];
                [page addGestureRecognizer:tapGestureRecognizer];
                
                page.contentMode = UIViewContentModeScaleAspectFill;
                [page setClipsToBounds:YES];
    
      
			}
			
		[self configurePage:page forIndex:index];
			[_scrollView addSubview:page];
			[_visiblePages addObject:page];
		}
	}
    for (UIImageView *page in _visiblePages) {
        NSInteger indexInImages = page.tag;
        if (indexInImages!=NSNotFound) {
            [self configurePage:page forIndex:indexInImages];
        }
	}
}

- (void)clearPages
{
    for (UIImageView *page in _visiblePages) {
        [_recycledPages addObject:page];
        [page removeFromSuperview];
	}
	[_visiblePages minusSet:_recycledPages];
}

- (UIImageView *)dequeueRecycledPageForIndex:(NSInteger)index
{
    UIImageView *page = [_recycledPages anyObject];
    if (page) {
    
        [_recycledPages removeObject:page];
    }
    return page;
}

- (BOOL)isDisplayingPageForIndex:(NSInteger)index
{
	BOOL foundPage = NO;
	for (UIImageView *page in _visiblePages) {
        NSInteger indexInImages = page.tag;
		if (indexInImages == index) {
			foundPage = YES;
			break;
		}
	}
	return foundPage;
}

- (void)configurePage:(UIImageView *)page forIndex:(NSInteger)index
{
    if(index<0)return;
    
    page.tag = index;
    [page setImageWithURLString:_imageUrls[index] placeholderImage:BigPlaceHolderImage];
    page.frame = [self frameForPageAtIndex:index];
    
    [_pageDic setObject:page forKey:[NSString stringWithFormat:@"%ld",index]];
}



#pragma mark - ScrollView delegate methods

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self tilePages];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([_delegate respondsToSelector:@selector(imageDidEndDeceleratingWithIndex:)]) {
        [_delegate imageDidEndDeceleratingWithIndex:scrollView.contentOffset.x/scrollView.bounds.size.width];
    }
}

#pragma mark - Frame calculations

- (CGRect)frameForPageAtIndex:(NSInteger)index
{

	CGRect bounds = _scrollView.bounds;
    
    if (_delegate && [_delegate respondsToSelector:@selector(sizeForPageAtIndex:)])
    {
        CGSize size = [_delegate sizeForPageAtIndex:index];
        bounds = CGRectMake(0, 0, size.width, size.height);
        
    }
  
    bounds.origin = CGPointMake((bounds.size.width * index), (self.height-bounds.size.height)/2.0);
	
	return bounds;
}

- (CGSize)contentSizeForPagingScrollView
{
 
    return CGSizeMake(_scrollView.bounds.size.width * [_imageUrls count] , _scrollView.bounds.size.height);
    

}

- (void)clearCache
{
	[_recycledPages removeAllObjects];
}

#pragma mark - WebImageView delegate
- (void)imageClicked:(UITapGestureRecognizer *)recognizer
{
    UIImageView *imageView = (UIImageView *)recognizer.view;

    if (_delegate && [_delegate respondsToSelector:@selector(imageClickedWithIndex:)])
    {
        [_delegate imageClickedWithIndex:imageView.tag];
    }
}
@end
