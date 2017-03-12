//
//  HTTPWorker.m
//  PMS
//
//  Created by ligh on 15/10/8.
//
//

#import "HTTPWorker.h"

#import "ITTMaskActivityView.h"

@implementation HTTPWorker


static id instance;


+ (id)sharedHTTPWorker
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] initWithBaseURL:[NSURL URLWithString:Host_Url]];
        [instance securityPolicy].allowInvalidCertificates = YES;

        AFJSONResponseSerializer *jsonSerializer = [AFJSONResponseSerializer serializer];
        //解决AFNetworing bug
        jsonSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];

        [instance setResponseSerializer:jsonSerializer];
       
        //JSON parameter
       // [instance setRequestSerializer:[AFHTTPRequestSerializer serializer]];

    });
    
    return instance;
}


+(instancetype)manager {
    
    return [self sharedHTTPWorker];
}


- (void)showIndicatorInView:(UIView*)inView {
  
    if(!inView)return;
    
    [self hidenIndicatorInView:inView];

    UIView *indicatorView = [ITTMaskActivityView viewFromXIB];
    indicatorView.center = inView.center;
    indicatorView.tag = 1000;
    [inView addSubview:indicatorView];
    
    
    
}

- (void)hidenIndicatorInView:(UIView*)inView {
    
    if(!inView)return;
    
    UIView *indicatorView = [inView viewWithTag:1000];
    if(indicatorView) {
        [indicatorView removeFromSuperview];
    }

}



-(void)cancelRequest:(NSString *)urls,... {
   
    NSMutableArray *argsArray = [[NSMutableArray alloc] init];
    va_list params; //定义一个指向个数可变的参数列表指针；
    va_start(params,urls);//va_start  得到第一个可变参数地址,
    id arg;
    
    if (urls) {
        //将第一个参数添加到array
        id prev = urls;
        [argsArray addObject:prev];
        
        //va_arg 指向下一个参数地址
        //这里是问题的所在 网上的例子，没有保存第一个参数地址，后边循环，指针将不会在指向第一个参数
        while( (arg = va_arg(params,id)) )
        {
            if ( arg ){
                [argsArray addObject:arg];
            }
            
        }
        //置空
        va_end(params);
        
//        //这里循环 将看到所有参数
//        for (AFHTTPRequestOperation *operation in self.operationQueue.operations) {
//            
//            if([argsArray containsObject:operation.identifier]) {
//                
//                [operation cancel];
//                
//                DDLogWarn(@"AFHTTPRequestOperation cancel");
//                
//            }
//        }
     
    }
  
}



/**
 *  构建NSMutableURLRequest
 *
 *  @param URLString  地址
 *  @param method     请求方式
 *  @param parameters 参数
 *  @param error      错误
 *
 *  @return 返回request
 */
-(NSMutableURLRequest *) buildRequest:(NSString *)URLString method:(NSString *)method parameters:(id)parameters  error:(NSError *__autoreleasing *)error{
    
    
    NSMutableDictionary *newParams = [NSMutableDictionary dictionaryWithDictionary:parameters ? parameters : @{}];

    
    //分析是否有图片数据
    NSMutableDictionary *imageParams = [NSMutableDictionary dictionaryWithCapacity:1];
    for (NSString *key in [parameters allKeys]) {
        
        id value = newParams[key];
        if ([value isKindOfClass:[UIImage class]]) {
            [imageParams setObject:value forKey:key];
            [newParams removeObjectForKey:key];
        }
        
    }
    
    NSString *urlString = [[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString];
    
    //如果有上传图片
    if (imageParams.allKeys.count > 0) {
        
        return [self.requestSerializer multipartFormRequestWithMethod:@"POST" URLString:urlString parameters:newParams constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            
            
            for (NSString *key in [imageParams allKeys]) {
                
                id image = imageParams[key];
                
                NSData *imageData = UIImageJPEGRepresentation(image, 1);
                
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                formatter.dateFormat = @"yyyyMMddHHmmss";
                NSString *str = [formatter stringFromDate:[NSDate date]];
                NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
                
                // 上传图片，以文件流的格式
                [formData appendPartWithFileData:imageData name:key fileName:fileName mimeType:@"image/jpeg"];
            }
            
            
        } error:error];
        
    }else {
        
        return [self.requestSerializer requestWithMethod:method URLString:urlString
                                              parameters:newParams error:error];
    }
    
    
}



/**
 *  所有请求的统一调用点
 *
 *  @param inView     loading执行的view
 *  @param method     请求方式
 *  @param URLString  请求地址i
 *  @param parameters 请求参数
 *  @param success    成功回调
 *  @param failure    失败回调
 */
-(void)responseWithIndicatorInView:(UIView *)inView method:(NSString *)method url:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    
    
    [self showIndicatorInView:inView];
    
    
    
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [self buildRequest:URLString method:method parameters:parameters error:&serializationError];
    
    
    if (serializationError) {
        if (failure) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
            dispatch_async(self.completionQueue ?: dispatch_get_main_queue(), ^{
                failure(serializationError);
                
                [self hidenIndicatorInView:inView];
                
            });
#pragma clang diagnostic pop
        }
        
        
    }
    
    Cancel_Request(URLString,nil);
    
   NSURLSessionDataTask *task = [self dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error)
    {
          [self hidenIndicatorInView:inView];
       
        if(error)
        {
            if(failure)
                failure(error);
            
        }else
        {
            
            success(responseObject);
            
            
        }
        
    }];
    
    [task resume];

    
    
}

/**
 ****************************************  响应JSON  ****************************************
 *
 */

-(void)GETResponseJSON:(UIView *)inView url:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    
    
    [self responseWithIndicatorInView:inView method:@"GET" url:URLString parameters:parameters success:^(id responseObject) {
        
        
        success(responseObject);
        
        
    }  failure:failure];
    
}


-(void)POSTResponseJSON:(UIView *)inView  url:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    
    [self responseWithIndicatorInView:inView method:@"POST" url:URLString parameters:parameters success:^(id responseObject) {
        
        
        success(responseObject);
        
        
    }  failure:failure];
}

/**
 ****************************************  响应一个对象  ****************************************
 *
 */
-(void)GETResponseObject:(UIView *) inView
                                   objClass:(Class )clazz
                                        url:(NSString *)URLString
                                 parameters:(id)parameters
                                    success:(void (^)(id))success
                                    failure:(void (^)(NSError *))failure {

    [self responseWithIndicatorInView:inView method:@"GET" url:URLString parameters:parameters success:^(id responseObject) {
        
        id object = [clazz mj_objectWithKeyValues:responseObject];
        
        
        success(object);

        
    }  failure:failure];
   
}


-(void)POSTResponseObject:(UIView *) inView
                 objClass:(Class )clazz
                      url:(NSString *)URLString
               parameters:(id)parameters
                  success:(void (^)(id))success
                  failure:(void (^)(NSError *))failure {

   [self responseWithIndicatorInView:inView method:@"POST" url:URLString parameters:parameters success:^(id responseObject) {
        
        id object = [clazz mj_objectWithKeyValues:responseObject];
        
        success(object);
        
        
    }  failure:failure];
    
}



-(void)GETResponseObjectArray:(UIView *) inView
                  objClass:(Class )clazz
                       url:(NSString *)URLString
                parameters:(id)parameters
                   success:(void (^)(id))success
                   failure:(void (^)(NSError *))failure {
    
    
    [self responseWithIndicatorInView:inView method:@"GET" url:URLString parameters:parameters success:^(id responseObject) {
        
        id object = [clazz mj_objectArrayWithKeyValuesArray:responseObject];
        
        success(object);
        
        
    }  failure:failure];
}


-(void)POSTResponseObjectArray:(UIView *) inView
                       objClass:(Class )clazz
                            url:(NSString *)URLString
                     parameters:(id)parameters
                        success:(void (^)(id))success
                        failure:(void (^)(NSError *))failure {
    
    
    [self responseWithIndicatorInView:nil method:@"POST" url:URLString parameters:parameters success:^(id responseObject) {
        
        id object = [clazz mj_objectArrayWithKeyValuesArray:responseObject];
        
        success(object);
        
        
    }  failure:failure];
}


/**
 ********************************  响应一个HttpResult  ******************************
 *
 */
/**
 响应一个Result对象 data为一个dataClass实例
 **/

-(void)GETResponseObjectResult:(UIView *) inView
                       objClass:(Class )dataClass
                            url:(NSString *)URLString
                     parameters:(id)parameters
                        success:(void (^)(HTTPResult *result))success
                        failure:(void (^)(NSError *))failure {
    
   [self responseWithIndicatorInView:inView method:@"GET" url:URLString parameters:parameters success:^(id responseObject) {
        
       
        HTTPResult *result = [HTTPResult mj_objectWithKeyValues:responseObject];
       
       if(dataClass!=nil && result.data) {
             result.objData = [dataClass mj_objectWithKeyValues:result.data];
       }
     
        
        success(result);
        
    }  failure:failure];
    
    
}


/**
 响应一个Result对象 data为一个dataClass 数组实例
 **/
-(void)POSTResponseObjectResult:(UIView *) inView
                       objClass:(Class )dataClass
                            url:(NSString *)URLString
                     parameters:(id)parameters
                        success:(void (^)(HTTPResult *result))success
                        failure:(void (^)(NSError *))failure {

    
    [self responseWithIndicatorInView:inView method:@"POST" url:URLString parameters:parameters success:^(id responseObject) {
        
        HTTPResult *result = [HTTPResult mj_objectWithKeyValues:responseObject];
    
        if(dataClass!=nil && result.data) {
            result.objData = [dataClass mj_objectWithKeyValues:result.data];
        }
        
        success(result);
        
    }  failure:failure];
}


-(void)GETResponseResult:(UIView *)inView url:(NSString *)URLString parameters:(id)parameters success:(void (^)(HTTPResult *))success failure:(void (^)(NSError *))failure {
    
    [self responseWithIndicatorInView:inView method:@"GET" url:URLString parameters:parameters success:^(id responseObject) {
        
        
        HTTPResult *result = [HTTPResult mj_objectWithKeyValues:responseObject];
        
        success(result);
        
    }  failure:failure];
}


-(void)POSTResponseResult:(UIView *)inView url:(NSString *)URLString parameters:(id)parameters success:(void (^)(HTTPResult *))success failure:(void (^)(NSError *))failure {
    
    
    [self responseWithIndicatorInView:inView method:@"POST" url:URLString parameters:parameters success:^(id responseObject) {
        
        
        HTTPResult *result = [HTTPResult mj_objectWithKeyValues:responseObject];
        
        success(result);
        
    }  failure:failure];
    
}



-(void)GETResponseObjectArrayResult:(UIView *) inView
                            objClass:(Class )dataClass
                                 url:(NSString *)URLString
                          parameters:(id)parameters
                             success:(void (^)(HTTPResult *result))success
                             failure:(void (^)(NSError *))failure {

    [self responseWithIndicatorInView:inView method:@"GET" url:URLString parameters:parameters success:^(id responseObject) {
        
        
        HTTPResult *result = [HTTPResult mj_objectWithKeyValues:responseObject];
        
        if(dataClass!=nil && result.data) {
             result.objData = [dataClass mj_objectArrayWithKeyValuesArray:result.data];
         }
        
        success(result);
        
    }  failure:failure];
    
}


-(void)POSTResponseObjectArrayResult:(UIView *) inView
                            objClass:(Class )dataClass
                                 url:(NSString *)URLString 
                          parameters:(id)parameters
                             success:(void (^)(HTTPResult *result))success
                             failure:(void (^)(NSError *))failure {
    
    [self responseWithIndicatorInView:inView method:@"POST" url:URLString parameters:parameters success:^(id responseObject) {
        
        
        HTTPResult *result = [HTTPResult mj_objectWithKeyValues:responseObject];
        
        if(dataClass!=nil && result.data) {
            result.objData = [dataClass mj_objectArrayWithKeyValuesArray:result.data];
        }
        
        success(result);
        
    }  failure:failure];
    
}


@end
