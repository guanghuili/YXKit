//
//  AliPayManager.h
//  Carte
//
//  Created by ligh on 14-4-17.
//
//

#import <Foundation/Foundation.h>

#import "Order.h"

#import <AlipaySDK/AlipaySDK.h>
#import "APAuthV2Info.h"


//支付结果
typedef void(^AliPayManagerPayStatusBlock)(BOOL);


@interface Product : NSObject
{
@private
	float _price;
	NSString *_subject;
	NSString *_body;
	NSString *_orderId;
}

@property (nonatomic, assign) float price;
@property (nonatomic, retain) NSString *subject;
@property (nonatomic, retain) NSString *body;
@property (nonatomic, retain) NSString *orderId;

@end

@interface AliPayManager : NSObject
{
    
}

@property (copy,nonatomic) AliPayManagerPayStatusBlock statusBlock;

-(void) handleHomeBack;

+(id) shareManager;


///根据服务器返回的订单加密信息进行支付
-(void) payForOrderSignedString:(NSString *) signedString completion:(AliPayManagerPayStatusBlock) completionBlock;


//处理支付宝
- (BOOL)handleOpenURL:(NSURL *)url;

@end
