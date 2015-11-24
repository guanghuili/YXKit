//
//  SlideshowScrollerView
//
//  Created by sprint on 12-11-24.
//
//

#import "SlideshowScrollerView.h"

@implementation SlideshowScrollerView

@synthesize delegate;

- (void)dealloc
{

    if (imageArray) {
        imageArray=nil;
    }

}


-(void)setImageUrlArray:(NSArray *)imgArr
{
    [self stopSlideshow];
    
    if (imgArr.count == 0)
    {
        return;
    }
    

    
    self.userInteractionEnabled=YES;
    NSMutableArray *tempArray=[NSMutableArray arrayWithArray:imgArr];
    [tempArray insertObject:[imgArr objectAtIndex:([imgArr count]-1)] atIndex:0];
    [tempArray addObject:[imgArr objectAtIndex:0]];
    imageArray=[NSArray arrayWithArray:tempArray];
    NSUInteger pageCount=[imageArray count];
    
    if (!scrollView)
    {
        scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.size.width, self.size.height)];
        scrollView.pagingEnabled = YES;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.scrollsToTop = NO;
        scrollView.minimumZoomScale = 0.5;
        scrollView.maximumZoomScale = 1.5;
        scrollView.delegate = self;
         [self addSubview:scrollView];
    }
    
    for (int i=0; i<pageCount; i++)
    {
        NSString *imgURL=[imageArray objectAtIndex:i];
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.tag = i;
        imgView.contentMode = UIViewContentModeScaleToFill;
        if ([imgURL hasPrefix:@"http://"] || [imgURL hasPrefix:@"https://"])
        {
       
            imgView.backgroundColor = [UIColor clearColor];
            [imgView setImageWithURLString:imgURL placeholderImage:BigPlaceHolderImage];
        }
        else
        {
            
            UIImage *img=[UIImage imageNamed:[imageArray objectAtIndex:i]];
            [imgView setImage:img];
        }
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(rectForPageAtIndex:)])
        {
            [imgView setFrame:[self.delegate rectForPageAtIndex:i]];
            
        }else
        {
            [imgView setFrame:CGRectMake(self.size.width*i, 0,self.size.width, self.size.height)];
        }
        
        imgView.tag= i ;
        UITapGestureRecognizer *Tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imagePressed:)];
        [Tap setNumberOfTapsRequired:1];
        [Tap setNumberOfTouchesRequired:1];
        imgView.userInteractionEnabled=YES;
        [imgView addGestureRecognizer:Tap];
        [imgView setClipsToBounds:YES];
        [scrollView setClipsToBounds:YES];
        [scrollView addSubview:imgView];
    }
    
    
    scrollView.contentSize = CGSizeMake(self.size.width * pageCount, self.size.height);
    [scrollView setContentOffset:CGPointMake(pageCount > 1 ?  self.size.width : 0, 0)];

    
    NSInteger pageHW = 15;
    //
    if (pageDotContainer == nil) {
        
        pageDotContainer = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - pageHW ,imgArr.count * pageHW ,pageHW)];
        pageDotContainer.backgroundColor = [UIColor clearColor];
    }
    
    pageDotContainer.width = imgArr.count * pageHW;
    pageDotContainer.left = (self.width - pageDotContainer.width)/2.0;
    [self addSubview:pageDotContainer];
    
    
    for (int i = 0; i<imgArr.count;i++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake( i*pageHW, 0, pageHW-5, pageHW-5);
        [btn setImage:UIImageForName(@"content_Photo_days") forState:UIControlStateNormal];
        [btn setImage:UIImageForName(@"content_Photo_Place") forState:UIControlStateSelected];
        btn.selected = i==0;
        [pageDotContainer addSubview:btn];
        
    }
    
}

-(void)playSlideshow
{
    [UIView animateWithDuration:0.3 animations:^{
        
        [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x + scrollView.width, 0)];
        
    } completion:^(BOOL finished) {

        [self scrollViewDidEndDecelerating:scrollView];
        [self performSelector:@selector(playSlideshow) withObject:nil afterDelay:5];
    }];
}


-(void)stopSlideshow
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *) sender
{
    CGFloat pageWidth = scrollView.width;
    _currentPageIndex =   floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    if (_currentPageIndex==0) {
      
        [scrollView setContentOffset:CGPointMake(([imageArray count]-2)*self.width, 0)];
    }
    if (_currentPageIndex==([imageArray count]-1)) {
       
        [scrollView setContentOffset:CGPointMake(self.width, 0)];
        
    }
    
    NSInteger currentPageIndex = (scrollView.contentOffset.x/scrollView.bounds.size.width)-1;
    
    if ([delegate respondsToSelector:@selector(slideshowScrollerViewPlayingPageIndex:)])
    {
        [delegate slideshowScrollerViewPlayingPageIndex:_currentPageIndex];
    }
    
    for (int i = 0; i<pageDotContainer.subviews.count;i++) {
        
        UIButton *dotBtn = pageDotContainer.subviews[i];
        dotBtn.selected = i == currentPageIndex;
    }

}

- (void)imagePressed:(UITapGestureRecognizer *)sender
{

    if ([delegate respondsToSelector:@selector(slideshowScrollerViewDidClickPageIndex:)])
    {
        [delegate slideshowScrollerViewDidClickPageIndex:sender.view.tag-1];
    }
}

@end
