//
//  AppDatePicker.h
//  PMS
//
//  Created by ligh on 14/11/3.
//
//

#import "AnimationPicker.h"

typedef void(^AppDatePickerBlock)(NSDate *);

//选择事件picker
@interface AppDatePicker : AnimationPicker


@property (copy,nonatomic) AppDatePickerBlock actionBlock;

-(void) setMinimumDate:(NSDate *) date;


@end
