//
//  ShareView.m
//  Carte
//
//  Created by ligh on 14-4-16.
//
//

#import "ShareView.h"
#import "JCRBlurView.h"
#import "ITTMaskActivityView.h"
#import "AppDelegate.h"

typedef void(^DownloadThumgBlock)(NSData *data);


@interface ShareView()
{

    //显示的标题
    IBOutlet UILabel    *_titleLabel;
    
    //朋友圈
    IBOutlet UILabel    *_friendCircleTitleLabel;
    //新浪微博
    IBOutlet UILabel    *_sinaWeiboTitleLabel;
    //腾讯微博
    IBOutlet UILabel    *_weixinFriendLabel;
    IBOutlet UIButton   *_cancelButton;

    
    TencentOAuth        *_tencentOAuth;
}
@end

@implementation ShareView


- (void)dealloc
{
    RELEASE_SAFELY(_shareContent);
    RELEASE_SAFELY(_shareImageUrl);
    RELEASE_SAFELY(_shareWebUrl);
    
    RELEASE_SAFELY(_titleLabel);
    RELEASE_SAFELY(_friendCircleTitleLabel);
    RELEASE_SAFELY(_sinaWeiboTitleLabel);
    RELEASE_SAFELY(_weixinFriendLabel);
    RELEASE_SAFELY(_cancelButton);

}


-(void)awakeFromNib
{
    [super awakeFromNib];
    
    _shareContent = Brand_Name;
}

-(void)showInView:(UIView *)inView shareContent:(NSString *)shareContent title:(NSString *)title
{
    self.shareContent = shareContent;
    [self showInView:inView title:title];
}

-(void)showInView:(UIView *)inView shareContent:(NSString *)shareContent
{
    [self showInView:inView shareContent:shareContent title:@"分享到"];
}

-(void)showInView:(UIView *)inView shareContent:(NSString *)shareContent imageUrl:(NSString *)shareImageUrl
{
    [self showInView:inView shareContent:shareContent imageUrl:shareImageUrl webUrl:nil];
}

-(void)showInView:(UIView *)inView shareContent:(NSString *)shareContent imageUrl:(NSString *)shareImageUrl webUrl:(NSString *)webUrl
{
    self.shareContent = shareContent;
    self.shareImageUrl =  [NSString stringWithFormat:@"%@%@",Pic_Host_Url,shareImageUrl];
    self.shareWebUrl = webUrl;
    [self showInView:inView title:@"分享到"];
}

-(void)showInView:(UIView *)inView title:(NSString *)title
{
    _titleLabel.text = title;
    
    [self showPickerInView:inView];

}


//#pragma mark ViewAcitons
//#//////////////////////////////////////////////////////////////////////////////////////////////
//#pragma mark 新浪微博
/////////////////////////////////////////////////////////////////////////////////////////////////


- (void)handleQQSendResult:(QQApiSendResultCode)sendResult
{
    switch (sendResult)
    {
            
        case EQQAPIQQNOTINSTALLED:
        {
            
            [BDKNotifyHUD showCryingHUDWithText:@"未安装手机客户端"];
            
            break;
        }
        
        default:
        {
          //  [BDKNotifyHUD showCryingHUDInView:self.superview text:@"发送失败"];
            break;
        }
    }
}

//对图片进行大小缩放
- (UIImage *)thumbImageWithImage:(UIImage *)scImg limitSize:(CGSize)limitSize
{
    if (scImg.size.width <= limitSize.width && scImg.size.height <= limitSize.height) {
        return scImg;
    }
    CGSize thumbSize;
    if (scImg.size.width / scImg.size.height > limitSize.width / limitSize.height) {
        thumbSize.width = limitSize.width;
        thumbSize.height = limitSize.width / scImg.size.width * scImg.size.height;
    }
    else {
        thumbSize.height = limitSize.height;
        thumbSize.width = limitSize.height / scImg.size.height * scImg.size.width;
    }
    UIGraphicsBeginImageContext(thumbSize);
    [scImg drawInRect:(CGRect){CGPointZero,thumbSize}];
    UIImage *thumbImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return thumbImg;
}



//下载
-(void) fetchThumgImageDataWithBlock:(DownloadThumgBlock) imageBlock
{
    ITTMaskActivityView *activityView = [ITTMaskActivityView viewFromXIB];
    UIView *superView = self.superview;
    activityView.center = superView.center;
    [superView addSubview:activityView];
    
    ResposneImage(self.superview, _shareImageUrl, ^(UIImage *image){
    
        
        UIImage *thumbImg = [self thumbImageWithImage:image limitSize:CGSizeMake(150, 150)];
        NSData *data = UIImageJPEGRepresentation(thumbImg, 1);
        imageBlock(data);
        
    }, nil, ^(NSError *error){
          [BDKNotifyHUD showCryingHUDWithText:@"哦分享失败啦~~"];
  
    });
    
   
}

- (IBAction)qqAction:(id)sender
{
    
    if (!_tencentOAuth){
        //必须调用此OAuth 注册AppID
        _tencentOAuth = [[TencentOAuth alloc] initWithAppId:QQAppKey andDelegate:nil];
        _tencentOAuth.redirectURI = @"www.qq.com"; 
    }
   
    if (isBankString(_shareWebUrl))
    {
        QQApiTextObject *txtObj = [QQApiTextObject objectWithText:_shareContent];
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:txtObj];
        QQApiSendResultCode code = [QQApiInterface sendReq:req];
        [self handleQQSendResult:code];
        
        [self dismissPicker];
        
    }else
    {
        [self fetchThumgImageDataWithBlock:^(NSData *data) {
            
            
            NSURL *url = [NSURL URLWithString: isBankString(_shareWebUrl) ? _shareImageUrl : _shareWebUrl];
            
            QQApiNewsObject *imgObj = [QQApiNewsObject objectWithURL:url title:Brand_Name description:_shareContent previewImageData:data];
            
            SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:imgObj];
            //将内容分享到qq
            QQApiSendResultCode sent = [QQApiInterface sendReq:req];
            [self handleQQSendResult:sent];
            
            
        }];
        
        
        [self hidenPicker];
    }


}

- (IBAction)sinaAction:(id)sender
{
    
    if(![WeiboSDK isWeiboAppInstalled])
    {
        [BDKNotifyHUD showCryingHUDWithText:@"尚未新浪微博客户端"];
        [self dismissPicker];
        return;
    }

    
    if (isBankString(_shareWebUrl))
    {

        WBMessageObject *message = [WBMessageObject message];
        message.text = _shareContent;
        WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message];
        [WeiboSDK sendRequest:request];
        
        [self dismissPicker];
        
    }else
    {
        
        [self fetchThumgImageDataWithBlock:^(NSData *data)
        {
         
            WBMessageObject *message = [WBMessageObject message];
            message.text = [NSString stringWithFormat:@"%@ %@",_shareContent,_shareWebUrl];
         
            WBImageObject *imageObject = [WBImageObject object];
            imageObject.imageData = data;
            message.imageObject = imageObject;
            
            
            WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message];
            [WeiboSDK sendRequest:request];
            
        }];
        
        [self hidenPicker];
        
    }
    
}


//分享到微信朋友圈
- (IBAction)wxSceneTimelineAction:(id)sender
{
    
        //未安装微信客户端
        if(![WXApi isWXAppInstalled])
        {
            [BDKNotifyHUD showCryingHUDWithText:@"尚未安装微信客户端"];
            [self dismissPicker];
            return;
        }

    
    if (isBankString(_shareWebUrl))
    {
    
        SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
        
        req.text = _shareContent;
        req.bText = YES;
        [WXApi sendReq:req];
        
        [self dismissPicker];
        
    }else
    {
        
        [self fetchThumgImageDataWithBlock:^(NSData *data)
        {
        
              SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
            WXWebpageObject *webPageObject = [WXWebpageObject object];
            webPageObject.webpageUrl = isBankString(_shareWebUrl) ?  _shareImageUrl : _shareWebUrl;
            
            WXMediaMessage *message = [WXMediaMessage message];
            message.title = Brand_Name;
            message.description = _shareContent;
            message.mediaObject = webPageObject;
            message.thumbData = data;
            
            req.scene = WXSceneTimeline;
            req.bText = NO;
            req.message = message;
            [WXApi sendReq:req];
        }];
        
        [self hidenPicker];
    }
    
  
}


- (IBAction)wxSceneSessionAction:(id)sender
{
    
    //未安装微信客户端
    if(![WXApi isWXAppInstalled])
    {
        [BDKNotifyHUD showCryingHUDWithText:@"尚未安装微信客户端"];
        [self dismissPicker];
        return;
    }
    
    
    
    if (isBankString(_shareWebUrl))
    {
    
        SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
        req.text = _shareContent;
        req.bText = YES;
        [WXApi sendReq:req];
        [self dismissPicker];
    }else
    {
        [self fetchThumgImageDataWithBlock:^(NSData *data) {
            
            WXWebpageObject *webPageObject = [WXWebpageObject object];
            webPageObject.webpageUrl = isBankString(_shareWebUrl) ?  _shareImageUrl : _shareWebUrl;
            
            WXMediaMessage *message = [WXMediaMessage message];
            message.title = Brand_Name;
            message.description = _shareContent;
            message.mediaObject = webPageObject;
            message.thumbData = data;
            
            SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
            req.scene = WXSceneSession;
            req.message = message;
            req.bText = NO;
            req.message = message;
            [WXApi sendReq:req];
 
        }];
        
        [self hidenPicker];
    }

    

}


@end
