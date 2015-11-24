//
//  ShareView.h
//  Carte
//
//  Created by ligh on 14-4-16.
//
//

#import "AnimationPicker.h"

/**
 *  分享
 */
@interface ShareView : AnimationPicker

-(void) showInView:(UIView *) inView shareContent:(NSString *) shareContent title:(NSString *) title;
-(void) showInView:(UIView *) inView shareContent:(NSString *) shareContent;
-(void) showInView:(UIView *) inView shareContent:(NSString *) shareContent imageUrl:(NSString *) shareImageUrl;


/**
    shareContent:分享的具体内容
    shareImageUrl:分享的缩略图url
    webUrl:分享内容的详细wap地址
 **/
-(void) showInView:(UIView *) inView shareContent:(NSString *) shareContent imageUrl:(NSString *) shareImageUrl webUrl:(NSString *) webUrl;


@property (strong,nonatomic) NSString *shareContent;//分享的文本内容
@property (strong,nonatomic) NSString *shareImageUrl;//分享的图片数据
@property (strong,nonatomic) NSString *shareWebUrl;//分享的网页地址


@end
