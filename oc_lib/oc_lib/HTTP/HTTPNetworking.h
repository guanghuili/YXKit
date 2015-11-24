//
//  HTTPNetworking.h
//  常用宏定义 及 头文件
//
//  Created by ligh on 15/10/14.
//
//

#ifndef HTTPNetworking_h
#define HTTPNetworking_h

#import "HTTPWorker.h"
#import "NSOperation+Identifier.h"

/**
 *
 *  @param _indicatorInView_ 指示器所在view
 *  @param _objClass_        解析的对象
 *  @param _url_             请求地址
 *  @param _parameters_      参数
 *  @param _success_         成功回调
 *  @param _failure_         失败回调
 *
 */
//POST GET请求



#define POSTResponseJSON(_indicatorInView_,_url_,_parameters_,_success_,_failure_)\
[[HTTPWorker sharedHTTPWorker] POSTResponseJSON:_indicatorInView_ url:_url_ parameters:_parameters_ success:_success_ failure:_failure_]

#define GETResponseJSON(_indicatorInView_,_url_,_parameters_,_success_,_failure_)\
[[HTTPWorker sharedHTTPWorker] GETResponseJSON:_indicatorInView_ url:_url_ parameters:_parameters_ success:_success_ failure:_failure_]


//=======================================response object=============================================//
#define POSTResponseObject(_indicatorInView_,_objClass_,_url_,_parameters_,_success_,_failure_)\
[[HTTPWorker sharedHTTPWorker] POSTResponseObject:_indicatorInView_ objClass:_objClass_ url:_url_ parameters:_parameters_ success:_success_ failure:_failure_]
#define GETResponseObject(_indicatorInView_,_objClass_,_url_,_parameters_,_success_,_failure_)\
[[HTTPWorker sharedHTTPWorker] GETResponseObject:_indicatorInView_ objClass:_objClass_ url:_url_ parameters:_parameters_ success:_success_ failure:_failure_]


//=======================================response object array=============================================//
#define POSTResponseObjectArray(_indicatorInView_,_objClass_,_url_,_parameters_,_success_,_failure_)\
[[HTTPWorker sharedHTTPWorker] POSTResponseObjectArray:_indicatorInView_ objClass:_objClass_ url:_url_ parameters:_parameters_ success:_success_ failure:_failure_]
#define GETResponseObjectArray(_indicatorInView_,_objClass_,_url_,_parameters_,_success_,_failure_)\
[[HTTPWorker sharedHTTPWorker] GETResponseObjectArray:_indicatorInView_ objClass:_objClass_ url:_url_ parameters:_parameters_ success:_success_ failure:_failure_]

//=======================================response object result=============================================//
#define POSTResponseObjectResult(_indicatorInView_,_objClass_,_url_,_parameters_,_success_,_failure_)\
[[HTTPWorker sharedHTTPWorker] POSTResponseObjectResult:_indicatorInView_ objClass:_objClass_ url:_url_ parameters:_parameters_ success:_success_ failure:_failure_]

#define GETResponseObjectResult(_indicatorInView_,_objClass_,_url_,_parameters_,_success_,_failure_)\
[[HTTPWorker sharedHTTPWorker] GETResponseObjectResult:_indicatorInView_ objClass:_objClass_ url:_url_ parameters:_parameters_ success:_success_ failure:_failure_]


//=======================================response result object array=============================================//
#define POSTResponseObjectArrayResult(_indicatorInView_,_objClass_,_url_,_parameters_,_success_,_failure_)\
[[HTTPWorker sharedHTTPWorker] POSTResponseObjectArrayResult:_indicatorInView_ objClass:_objClass_ url:_url_ parameters:_parameters_ success:_success_ failure:_failure_]
#define GETResponseObjectArrayResult(_indicatorInView_,_objClass_,_url_,_parameters_,_success_,_failure_)\
[[HTTPWorker sharedHTTPWorker] GETResponseObjectArrayResult:_indicatorInView_ objClass:_objClass_ url:_url_ parameters:_parameters_ success:_success_ failure:_failure_]



#define POSTResponseResult(_indicatorInView_,_url_,_parameters_,_success_,_failure_)\
[[HTTPWorker sharedHTTPWorker] POSTResponseResult:_indicatorInView_ url:_url_ parameters:_parameters_ success:_success_ failure:_failure_]

#define GETResponseResult(_indicatorInView_,_url_,_parameters_,_success_,_failure_)\
[[HTTPWorker sharedHTTPWorker] GETResponseResult:_indicatorInView_ url:_url_ parameters:_parameters_ success:_success_ failure:_failure_]



//=======================================response image object array=============================================//
#define ResposneImage(_indicatorInView_,_url_,_success_,_progress_,_failure_)\
[[HTTPWorker sharedHTTPWorker] ResposneImage:_indicatorInView_ url:_url_ success:_success_ progress:_progress_ failure:_failure_]

/**
 *  取消请求
 *
 *  @param ... 请求列表
 *
 */
//取消请求 可以同时取消多个请求
#define Cancel_Request(...) \
[[HTTPWorker sharedHTTPWorker] cancelRequest:__VA_ARGS__]



#endif /* HTTPNetworking_h */
