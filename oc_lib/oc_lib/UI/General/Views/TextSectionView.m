//
//  TextSectionView.m
//  PMS
//
//  Created by ligh on 14-7-20.
//
//

#import "TextSectionView.h"

@interface TextSectionView()
{

    IBOutlet UILabel *_titleLabel;//一级标题
    
    IBOutlet UILabel *_title2Label;//二级标题

}
@end

@implementation TextSectionView


- (void)dealloc
{
    RELEASE_SAFELY(_title2Label);
    RELEASE_SAFELY(_titleLabel);
}


-(void)setTitle:(NSString *)title title2:(NSString *)title2
{

    _titleLabel.text = title;
    _title2Label.text = title2;
    float width = [_titleLabel sizeThatFits:CGSizeMake(self.width/2.0, _titleLabel.height)].width;
    _titleLabel.width = width;
    _title2Label.left = _titleLabel.right + MARGIN_S;
    _title2Label.width = [_title2Label sizeThatFits:CGSizeMake(self.width/2.0, _title2Label.height)].width;
}


@end
