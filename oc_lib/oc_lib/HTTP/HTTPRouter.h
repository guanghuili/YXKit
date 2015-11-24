//
//  HTTPRouter.h
//  EKS
//
//  Created by ligh on 15/10/12.
//
//

#ifndef HTTPRouter_h
#define HTTPRouter_h


#define URL_Login                               @"customerLogin"//登录
#define URL_TextVerifyCode                      @"getVerifyCode"//短信验证码
#define URL_VoiceCode                           @"sendVoiceVerifyCode"//语音验证码
#define URL_Get_Customer_Purse                  @"getCustomerPurse"//我的钱包
#define URL_GetCustomerAddresses                @"getCustomerAddresses"//获取地址列表

#define URL_CreateCustomerAddress               @"createCustomerAddress"//创建地址
#define URL_UpdateCustomerAddress               @"updateCustomerAddress"//更新地址

#define URL_GetOrderDetail                      @"getOrderDetail" //我的订单详情
#define URL_GetCustomerOrders                   @"getCustomerOrders"//我的订单
#define URL_EncryptionData                      @"encryptionData"//支付加密
#define URL_GiftCardIncome                      @"giftCardIncome"//卡充值
#define URL_GetAccountExchageHistorys           @"getAccountExchageHistorys"//交易记录
#define URL_AccountApply                        @"accountApply"//提现
#define URL_CollectAccountApply                 @"collectAccountApply" //代收货款提现申请
#define URL_GetCouponInfos                      @"getCouponInfos" //获取可用优惠劵
#define URL_GetAllCouponInfos                   @"getAllCouponInfos" //获取所有优惠劵
#define URL_BindCouponCode                      @"bindCouponCode"//兑换优惠劵
#define URL_GetBindAccountInfo                  @"getBindAccountInfo"//获取账号绑定信息
#define URL_GetCustomerInviteRewardHistorys     @"getCustomerInviteRewardHistorys"//奖励明细
#define URL_BindAccountInfo                     @"bindAccountInfo" //绑定账号
#define URL_RemoveBindAccount                   @"removeBindAccount" //解除绑定
#define URL_GetCustomerInviteInfo               @"getCustomerInviteInfo"//获取用户邀请信息
#define URL_CreateOrderInfo                     @"createOrderInfo" //创建订单
#define URL_GetOrderPrice                       @"getOrderPrice" //计算订单价格
#define URL_CustomerHomeInfo                    @"customerHomeInfo" //首页初始化信息
#define URL_DeleteCustomerAddress               @"deleteCustomerAddress"//删除地址
#define URL_GetAccountTransHistoryDetail        @"getAccountTransHistoryDetail" //获取交易记录详情


#endif /* HTTPRouter_h */


