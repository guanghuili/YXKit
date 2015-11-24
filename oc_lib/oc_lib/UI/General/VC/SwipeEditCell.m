//
//  SlideEditCell.m
//  Travelbag
//
//  Created by ligh on 13-11-17.
//  Copyright (c) 2013年 partner. All rights reserved.
//

#import "SwipeEditCell.h"

#define KSwipeCellWillSwipeEditNotificaitonName @"SwipeCellWillSwipeEditNotificaitonName"


@interface SwipeEditCell()
{

    float           _swipeContentViewX;


}
@end

@implementation SwipeEditCell



-(void)awakeFromNib
{
    [super awakeFromNib];
    [self enableSlideEdit];
    
    _swipeContentViewX = _swipeContentView.left;
    
    
    _swipeLeftEditView.hidden = YES;
    _swipeRightEditView.hidden = YES;
    
    [_swipeLeftEditView addTarget:self action:@selector(didTapLeftEditView) forControlEvents:UIControlEventTouchUpInside];
    [_swipeRightEditView addTarget:self action:@selector(didTapRightEdithView) forControlEvents:UIControlEventTouchUpInside];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willEditNotification:) name:KSwipeCellWillSwipeEditNotificaitonName object:nil];
}


-(void)setCellData:(id)cellData
{
    [super setCellData:cellData];
    
    [self pullbackSwipeContentViewAnimationd:YES];
}

-(void) enableSlideEdit
{
    _swipeContentView.userInteractionEnabled = YES;
    
    UIPanGestureRecognizer *swipGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    swipGestureRecognizer.delegate = self;
    [_swipeContentView addGestureRecognizer:swipGestureRecognizer];
    
}


-(void) willEditNotification:(NSNotification *) notification
{
    if(notification.object != self)
    {
        [self pullbackSwipeContentViewAnimationd:YES];
    }
}


/////////////////////////////////////////////////////////////////////////
#pragma mark EditView Actions
/////////////////////////////////////////////////////////////////////////
-(void)didTapLeftEditView
{
    
    [UIView animateWithDuration:0.3 animations:^{
        
        [self pullbackSwipeContentViewAnimationd:NO];
        
    } completion:^(BOOL finished) {
        
        if (_delegate &&  [_delegate respondsToSelector:@selector(didSelectLeftEditViewOfCell:)])
        {
            [_delegate didSelectLeftEditViewOfCell:self];
        }
        
    }];

}


-(void) didTapRightEdithView
{
    
    [UIView animateWithDuration:0.3 animations:^{
        
        [self pullbackSwipeContentViewAnimationd:NO];
        
    } completion:^(BOOL finished) {
        
        if (_delegate &&  [_delegate respondsToSelector:@selector(didSelectRightEditViewOfCell:)])
        {
            [_delegate didSelectRightEditViewOfCell:self];
        }
        
    }];

}

/////////////////////////////////////////////////////////////////////////
#pragma mark UIGestureRecognizerDelegate
/////////////////////////////////////////////////////////////////////////
 float  touchuFirstY;
-(BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer respondsToSelector:@selector(translationInView:)])
    {
        CGPoint translation = [gestureRecognizer translationInView:self.superview];
        
        return (translation.y - touchuFirstY) < 5;
        
    }
    
    return NO;
}

+(BOOL) pullbackCellsForTableView:(UITableView *)tableView
{
    
    NSArray *cells =  [tableView visibleCells];
   __block BOOL result = NO;
    
    [cells enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([[obj class] isSubclassOfClass:[self class]])
        {
            SwipeEditCell *cell = obj;
            if (cell.isEditing)
            {
                [cell pullbackSwipeContentViewAnimationd:YES];
                result = YES;
            }
        }
    }];
    
    return result;

}

-(void)pullbackSwipeContentViewAnimationd:(BOOL)animation completion:(void (^)(void))completion
{
    [self setEditing:NO];
    
    touchuFirstY = 0;
    
    if (animation)
    {
        [UIView animateWithDuration:0.3 animations:^{
            
            _swipeContentView.left = _swipeContentViewX;
            
        } completion:^(BOOL finished) {
            _swipeLeftEditView.hidden = YES;
            _swipeRightEditView.hidden = YES;
            if(completion)
            {
                completion();
            }
        }];
        
    }else
    {
        _swipeContentView.left = _swipeContentViewX;
        _swipeLeftEditView.hidden = YES;
        _swipeRightEditView.hidden = YES;
        if(completion)
        {
            completion();
        }
    }

}

-(void)pullbackSwipeContentViewAnimationd:(BOOL)animation
{
    
    [self pullbackSwipeContentViewAnimationd:animation completion:nil];
  
}


//当 当前View不是阅读模式时（当前view的left!=0) 监听Panview拖动事件
-(void) handlePanGesture:(UIPanGestureRecognizer *) recognizer
{
    
    CGPoint translation = [recognizer translationInView:self.superview];
    
//    if (_swipeContentViewX == _swipeContentView.left)
//    {
//        //向右滑动
//        if (translation.x > 0 && !_swipeLeftEditView)
//        {
//            return;
//            
//        }else if(translation.x < 0 && !_swipeRightEditView)//向左滑动
//        {
//            return;
//        }
//    }

    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:KSwipeCellWillSwipeEditNotificaitonName object:self];
        
        CGPoint translation = [recognizer translationInView:self.superview];
        touchuFirstY = translation.y;
        
    } else if(recognizer.state == UIGestureRecognizerStateChanged) {
        _swipeContentView.left += translation.x;
        [recognizer setTranslation:CGPointZero inView:self.superview];
        
        _swipeLeftEditView.hidden = _swipeContentView.left < _swipeLeftEditView.left;
        _swipeRightEditView.hidden = _swipeContentView.left > _swipeLeftEditView.left;
        
    } else if(recognizer.state == UIGestureRecognizerStateEnded) {
    
        
        
        if (_swipeLeftEditView && _swipeContentView.left  >= _swipeLeftEditView.right / 2) {
            [UIView beginAnimations:@"AnimationMove" context:NULL];
    
                _swipeContentView.left = _swipeLeftEditView.right + MARGIN_M;
            
            [UIView commitAnimations];
        
            [self setEditing:YES];
            
        } else if (_swipeRightEditView && _swipeContentView.right <= _swipeRightEditView.right - _swipeRightEditView.width/2) {
            
            [UIView beginAnimations:@"AnimationMove" context:NULL];
            
                _swipeContentView.right = _swipeRightEditView.left - MARGIN_M;
            
            [UIView commitAnimations];
            
            
            [self setEditing:YES];
            
        } else {
            
            [self pullbackSwipeContentViewAnimationd:YES];
        }
        
    }else {
      //  [self pullbackSwipeContentViewAnimationd:YES];
    }
}
@end
