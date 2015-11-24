//
//  HTTPWorker.h
//  PMS
//
//  Created by ligh on 15/10/8.
//
//

#import <Foundation/Foundation.h>

#import <AFNetworking/AFNetworking.h>

#import "HTTPRouter.h"
#import "HTTPResult.h"
#import "ARCSingleton.h"



/**
 *  http请求者 所有的网络请求应该通过它发送
 */
@interface HTTPWorker : AFHTTPRequestOperationManager


SINGLETON_H_ARC(HTTPWorker)


/**
 *  取消请求
 *
 *  @param url 取消的url地址
 */
-(void) cancelRequest:(NSString *)urls,...;


-(void) responseWithIndicatorInView:(UIView *) inView
                             method:(NSString *) method
                           url:(NSString *)URLString
                          parameters:(id)parameters
                         success:(void (^)(id))success
                         failure:(void (^)(NSError *))failure;


/**
 * 响应JSON
 *
 *  @param inView     loading所在view
 *  @param URLString  请求地址
 *  @param parameters 参数
 *  @param success    成功回调
 *  @param failure    失败回调
 */
-(void)GETResponseJSON:(UIView *) inView
                   url:(NSString *)URLString
            parameters:(id)parameters
               success:(void (^)(id))success
               failure:(void (^)(NSError *))failure;


-(void)POSTResponseJSON:(UIView *) inView
                    url:(NSString *)URLString
             parameters:(id)parameters
                success:(void (^)(id))success
                failure:(void (^)(NSError *))failure;



// MARK--- 响应对象
/**
 *  响应一个object对象 （GET请求）
 *
 *  @param objClass   响应的object对象 class
 *  @param URLString  请求地址
 *  @param parameters 参数
 *  @param success    成功回调 会返回数据对象
 *  @param failure    失败回调
 */
-(void)GETResponseObject:(UIView *) inView
                    objClass:(Class )clazz
                    url:(NSString *)URLString
                    parameters:(id)parameters
                    success:(void (^)(id))success
                    failure:(void (^)(NSError *))failure;

-(void)POSTResponseObject:(UIView *) inView
                 objClass:(Class )clazz
                      url:(NSString *)URLString
               parameters:(id)parameters
                  success:(void (^)(id))success
                  failure:(void (^)(NSError *))failure;

// MARK--- 响应数组
/**
 *  响应一个object array
 *
 *  @param objClass  响应的object对象 class
 *  @param URLString  请求地址
 *  @param parameters 参数
 *  @param success    成功回调
 *  @param failure    失败回调
 */
-(void)GETResponseObjectArray:(UIView *) inView
                  objClass:(Class )clazz
                       url:(NSString *)URLString
                parameters:(id)parameters
                   success:(void (^)(id))success
                   failure:(void (^)(NSError *))failure;



-(void)POSTResponseObjectArray:(UIView *) inView
                  objClass:(Class )clazz
                       url:(NSString *)URLString
                parameters:(id)parameters
                   success:(void (^)(id))success
                   failure:(void (^)(NSError *))failure;




/**
 *  响应一个result 数据为dataClass 实例
 *
 *  @param inView     loading View所在容器
 *  @param dataClass  响应的data class
 *  @param URLString  请求地址
 *  @param parameters 参数
 *  @param success    成功回调
 *  @param failure    失败回调
 */

-(void)GETResponseObjectResult:(UIView *) inView
                       objClass:(Class )dataClass
                          url:(NSString *)URLString
                   parameters:(id)parameters
                      success:(void (^)(HTTPResult*))success
                      failure:(void (^)(NSError *))failure;

-(void)POSTResponseObjectResult:(UIView *) inView
                       objClass:(Class )dataClass
                            url:(NSString *)URLString
                     parameters:(id)parameters
                        success:(void (^)(HTTPResult*))success
                        failure:(void (^)(NSError *))failure;


/**
 *  响应一个result 数据为dataClass Array实例
 *
 *  @param inView     loading View所在容器
 *  @param dataClass  响应的data class
 *  @param URLString  请求地址
 *  @param parameters 参数
 *  @param success    成功回调
 *  @param failure    失败回调
 */
-(void)GETResponseObjectArrayResult:(UIView *) inView
                            objClass:(Class )dataClass
                           url:(NSString *)URLString
                    parameters:(id)parameters
                       success:(void (^)(HTTPResult*))success
                       failure:(void (^)(NSError *))failure;



-(void)POSTResponseObjectArrayResult:(UIView *) inView
                            objClass:(Class )dataClass
                                 url:(NSString *)URLString
                          parameters:(id)parameters
                             success:(void (^)(HTTPResult*))success
                             failure:(void (^)(NSError *))failure;


/**
 *  响应一个httpResult
 *
 *  @param inView      loading View所在容器
 *  @param URLString  请求地址
 *  @param parameters 参数
 *  @param success     成功回调
 *  @param failure    失败回调
 */
-(void)GETResponseResult:(UIView *) inView
                                url:(NSString *)URLString
                         parameters:(id)parameters
                            success:(void (^)(HTTPResult*))success
                            failure:(void (^)(NSError *))failure;


-(void)POSTResponseResult:(UIView *) inView
                     url:(NSString *)URLString
              parameters:(id)parameters
                 success:(void (^)(HTTPResult*))success
                 failure:(void (^)(NSError *))failure;


/**
 *  下载一个图片 并加入缓存
 *
 *  @param inView    指示器view
 *  @param URLString 图片地址
 *  @param success   成功回调
 *  @param progress  进度block
 *  @param failure   失败回调
 */
-(void) ResposneImage:(UIView *) inView
                  url:(NSString *)URLString
              success:(void (^)(UIImage*))success
             progress:(void (^)(float bytesRead)) progress
              failure:(void (^)(NSError *))failure;

@end
