//
//  PromptView.m
//  EKS
//
//  Created by ligh on 14/12/19.
//
//

#import "PromptView.h"

@interface PromptView()
{

    //提示view
    IBOutlet UILabel *_promptLabel;
    
    
    IBOutlet UIView *_promptTextView;

}
@end

@implementation PromptView

- (void)dealloc
{
    RELEASE_SAFELY(_promptLabel);
    RELEASE_SAFELY(_promptTextView);
    RELEASE_SAFELY(_actionButton);
    RELEASE_SAFELY(_promptTextView);
}

-(void)awakeFromNib
{
    [super awakeFromNib];


}

-(void)setPromptText:(NSString *)promptText
{
 //	   _promptTextView.bottom = self.height/2 - 10;
    _promptLabel.text = promptText;
}

@end
