//
//  VerinfoModel.h
//  PMS
//
//  Created by ligh on 14/11/14.
//
//

#import "BaseModelObject.h"

//app 版本
@interface VerinfoModel : BaseModelObject

@property (strong,nonatomic) NSString *hasnew;//是否有新版本
@property (strong,nonatomic) NSString *brandId; //品牌id
@property (strong,nonatomic) NSString *platform;  //平台id
@property (strong,nonatomic) NSString *appVersion;  //新版版本号
@property (strong,nonatomic) NSString *verStatus;   //版本状态（正式版为空，其它版如beta等）
@property (strong,nonatomic) NSString *releaseDate;  //发布日期
@property (strong,nonatomic) NSString *updateInfo;  //更新说明
@property (strong,nonatomic) NSString *downUrl;   //下载url

@end
