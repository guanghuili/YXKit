//
//  HTTPResult.h
//  PMS
//
//  Created by ligh on 15/10/9.
//
//

#import <Foundation/Foundation.h>

//http resul
@interface HTTPResult : NSObject

//是否成功
@property (assign,nonatomic) BOOL result;
@property (strong,nonatomic) NSString *msg;

//返回的数据
@property (strong,nonatomic) id data;
@property (strong,nonatomic) id objData;

-(BOOL) isSuccess;


@end
