//
//  AppDatePicker.m
//  PMS
//
//  Created by ligh on 14/11/3.
//
//

#import "AppDatePicker.h"

@interface AppDatePicker()
{
    
    IBOutlet UIDatePicker   *_datePicker;
    

}
@end

@implementation AppDatePicker

- (void)dealloc
{

    RELEASE_SAFELY(_actionBlock);
    RELEASE_SAFELY(_datePicker);
}

-(void)setMinimumDate:(NSDate *)date
{
    [_datePicker setMinimumDate:date];
}

-(void)okAction:(id)sender
{
    [super okAction:sender];
    if (_actionBlock)
    {
        _actionBlock(_datePicker.date);
    }
}

@end
