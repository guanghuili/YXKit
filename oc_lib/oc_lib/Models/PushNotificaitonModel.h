//
//  RemoteNotificaitonModel.h
//  Carte
//
//  Created by ligh on 14-5-28.
//
//

//type:
typedef enum
{

    SalesNotificaitonType = 1,//优惠信息
    OrderNotificatioinType,//订单信息
    MsgNotificatioinType,//消息
    ReplyCommentNotificaitonType,//新评论

    
}PushNotificaitonType;


#import <UIKit/UIKit.h>

/**
 *  远程推送通知
 */
@interface PushNotificaitonModel : BaseModelObject

@property (strong,nonatomic) NSString *alert;//通知提示消息
@property (strong,nonatomic) NSString *msgid;//新消息所属用户
@property (strong,nonatomic) NSString *paramtype;//商家名称


-(void) handle;


@end
