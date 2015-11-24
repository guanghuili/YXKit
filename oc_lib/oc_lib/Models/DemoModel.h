//
//  Car.h
//  iTotemFrame
//
//  Created by Rainbow Zhang on 12/27/11.
//  Copyright (c) 2011 iTotemStudio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModelObject.h"

@interface DemoModel : BaseModelObject
{
}

@property (nonatomic, strong)NSString *modelId;
@property (nonatomic, strong)NSString *name;
@property (nonatomic, strong)NSMutableArray *models;

@end
