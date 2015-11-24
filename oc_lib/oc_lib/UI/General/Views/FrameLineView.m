//
//  FrameLineView.m
//  iSchool
//
//  Created by ligh on 13-9-26.
//
//

#import "FrameLineView.h"

@implementation FrameLineView


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
         self.backgroundColor = AppThemeLineColor;
    }
    return self;
}


-(void)awakeFromNib
{
    [super awakeFromNib];
    
    self.backgroundColor = AppThemeLineColor;
    
    if (self.width > 1)
    {
        self.height = 0.5;
        
    }else if(self.height > 1)
    {
        self.width = 0.5;
    }
    
}


@end
