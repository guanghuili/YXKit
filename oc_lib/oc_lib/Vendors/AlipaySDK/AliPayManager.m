//
//  AliPayManager.m
//  Carte
//
//  Created by ligh on 14-4-17.
//
//

#import "AliPayManager.h"


@implementation Product
@synthesize price = _price;
@synthesize subject = _subject;
@synthesize body = _body;
@synthesize orderId = _orderId;

@end

@implementation AliPayManager

@synthesize statusBlock = _statusBlock;

static id instance;
+ (id)shareManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}





-(void)payForOrderSignedString:(NSString *)signedString completion:(AliPayManagerPayStatusBlock)completionBlock
{

    /*
     *生成订单信息及签名
     *由于demo的局限性，采用了将私钥放在本地签名的方法，商户可以根据自身情况选择签名方法(为安全起见，在条件允许的前提下，我们推荐从商户服务器获取完整的订单信息)
     */
    
    
    _statusBlock = nil;
    
    if (completionBlock)
    {
        _statusBlock  = [completionBlock copy];
        
    }
    
    NSString *appScheme = [ConfigHelper appScheme];
        
    
    [[AlipaySDK defaultService] payOrder:signedString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            
            [self handePayResult:resultDic];
            
    }];
 

}



-(void)handleHomeBack
{
    if (!_statusBlock)
    {
        return;
    }
    
    [self handePayResult:nil];
}

//处理支付结果
-(void) handePayResult:(NSDictionary *) payResult
{
 
    
    NSInteger statusCode = [payResult[@"resultStatus"] integerValue];
    
    if (statusCode == 9000)
    {
        if(_statusBlock)
        _statusBlock(YES);
        [BDKNotifyHUD showSmileyHUDWithText:@"支付成功"];
        _statusBlock = nil;
    }else
    {
        //交易失败
        if(_statusBlock)
        _statusBlock(NO);
     //   [BDKNotifyHUD showCryingHUDWithText:@"支付失败"];
        _statusBlock = nil;
    }
}

//处理Auth授权结果
-(void) handleAuthResult:(NSDictionary *) resultDic
{

}


-(BOOL)handleOpenURL:(NSURL *)url
{

    if ([url.host isEqualToString:@"safepay"])
  {
      
      [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
          
          [self handePayResult:resultDic];
          
      }];

      return YES;
  }
    

    return NO;
}

///**
// *  处理web支付结果
// *
// *  @param resultDic 响应结果字典
// */
//-(void) handleWapPayResult:(NSString *) resultDic
//{
//
//    if(!_statusBlock)
//    {
//        return;
//    }
//    
//    AlixPayResult*result = [[AlixPayResult alloc] initWithString:resultDic];
//    
//    if (result)
//    {
//		
//		if (result.statusCode == 9000)
//        {
//			/*
//			 *用公钥验证签名 严格验证请使用result.resultString与result.signString验签
//			 */
//            //交易成功
//            NSString* key = AlipayPubKey;//签约帐户后获取到的支付宝公钥
//			id<DataVerifier> verifier;
//            verifier = CreateRSADataVerifier(key);
//            
//			if ([verifier verifyString:result.resultString withSign:result.signString])
//            {
//                //验证签名成功，交易结果无篡改
//			}
//            _statusBlock(YES);
//            [BDKNotifyHUD showSmileyHUDWithText:@"支付成功"];
//            RELEASE_SAFELY(_statusBlock);
//            _statusBlock = nil;
//        }
//        else
//        {
//            //交易失败
//            _statusBlock(YES);
//            [BDKNotifyHUD showCryingHUDWithText:@"支付失败"];
//            RELEASE_SAFELY(_statusBlock);
//            _statusBlock = nil;
//        }
//    }
//    else
//    {
//        //失败
//          _statusBlock(YES);
//          [BDKNotifyHUD showCryingHUDWithText:@"支付失败"];
//        RELEASE_SAFELY(_statusBlock);
//        _statusBlock = nil;
//    }
//   
//    
//}

//
///**
// *  处理支付宝客户端支付结果
// *
// *  @param result <#result description#>
// */
//-(void)handlePayResult:(AlixPayResult *) result
//{
//
////    sResultStatus.put("9000", "支付成功");
////    sResultStatus.put("4000", "系统异常");
////    sResultStatus.put("4001", "数据格式不正确");
////    sResultStatus.put("4003", "该用户绑定的支付宝账户被冻结或不允许支付");
////    sResultStatus.put("4004", "该用户已解除绑定");
////    sResultStatus.put("4005", "绑定失败或没有绑定");
////    sResultStatus.put("4006", "订单支付失败");
////    sResultStatus.put("4010", "重新绑定账户");
////    sResultStatus.put("6000", "支付服务正在进行升级操作");
////    sResultStatus.put("6001", "用户中途取消支付操作");
////    sResultStatus.put("7001", "网页支付失败");
//    
//    if(!_statusBlock)
//    {
//        return;
//    }
//    
//
//    if (result)
//    {
//		
//		if (result.statusCode == 9000)
//        {
//			/*
//			 *用公钥验证签名 严格验证请使用result.resultString与result.signString验签
//			 */
//            //交易成功
//            NSString* key = AlipayPubKey;//签约帐户后获取到的支付宝公钥
//			id<DataVerifier> verifier;
//            verifier = CreateRSADataVerifier(key);
//            
//			if ([verifier verifyString:result.resultString withSign:result.signString])
//            {
//                //验证签名成功，交易结果无篡改
//			}
//            
//            [BDKNotifyHUD showSmileyHUDWithText:@"支付成功" completion:^{
//                
//                _statusBlock(YES);
//                
//                RELEASE_SAFELY(_statusBlock);
//                _statusBlock = nil;
//
//            }];
//        }
//        else
//        {
//            //交易失败
//            [BDKNotifyHUD showCryingHUDWithText:@"支付失败" completion:^{
//                
//                
//                _statusBlock(NO);
//                
//                RELEASE_SAFELY(_statusBlock);
//                _statusBlock = nil;
//
//            }];
//        }
//    }
//    else
//    {
//        if (result)
//        {
//            //失败
//            [BDKNotifyHUD showCryingHUDWithText:@"支付失败" completion:^{
//                _statusBlock(NO);
//                
//                RELEASE_SAFELY(_statusBlock);
//                _statusBlock = nil;
//
//            }];
//        }else
//        {
//             _statusBlock(NO);
//            
//            RELEASE_SAFELY(_statusBlock);
//            _statusBlock = nil;
//
//        }
//        
//    }
//    
//}





@end
