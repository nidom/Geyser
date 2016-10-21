//
//  GESBaseRequest.h
//  Sample
//
//  Created by nidom on 16/6/29.
//  Copyright © 2016年 nidom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "GESOperation.h"
#import "GESNetworkPrivate.h"

typedef NS_ENUM(NSInteger , GESRequestMethod) {
    GESRequestMethodGet = 0,
    GESRequestMethodPost,
    GESRequestMethodHead,
    GESRequestMethodPut,
    GESRequestMethodDelete,
    GESRequestMethodPatch
};
typedef NS_ENUM(NSInteger , GESRequestSerializerType) {

    GESRequestSerializerTypeHTTP = 0,
    GESRequestSerializerTypeJSON
};

@class GESBaseRequest;

@protocol GESRequestDelegate <NSObject>
@optional
- (void)requestFinished:(GESBaseRequest *)request;
- (void)requestFailed:(GESBaseRequest *)request;
- (void)clearRequest;
@end


@protocol GESRequestAccessory <NSObject>
@optional
- (void)requestWillStart:(id)request;
- (void)requestWillStop:(id)request;
- (void)requestDidStop:(id)request;
@end

typedef void(^GESRequestCompletionBlock)(__kindof GESBaseRequest *request);
typedef void (^AFConstructingBlock)(id<AFMultipartFormData> formData);

@interface GESBaseRequest:NSObject
/// Tag
@property (nonatomic) NSInteger tag;

/// User info
@property (nonatomic, strong) NSDictionary *userInfo;



@property (nonatomic, strong) GESOperation * operation ;


/// request delegate object
@property (nonatomic, weak) id<GESRequestDelegate> delegate;

@property (nonatomic, strong, readonly) NSDictionary *responseHeaders;

@property (nonatomic, strong, readonly) NSData *responseData;


@property (nonatomic, strong, readonly) id responseJSONObject;

@property (nonatomic, readonly) NSInteger responseStatusCode;

@property (nonatomic, copy) GESRequestCompletionBlock successCompletionBlock;

@property (nonatomic, copy) GESRequestCompletionBlock failureCompletionBlock;

@property (nonatomic, strong) NSMutableArray *requestAccessories;

/// append self to request queue
- (void)start;
/// remove self from request queue
- (void)stop;

- (BOOL)isExecuting;

/// block回调
- (void)startWithCompletionBlockWithSuccess:(GESRequestCompletionBlock)success
                                    failure:(GESRequestCompletionBlock)failure;

- (void)setCompletionBlockWithSuccess:(GESRequestCompletionBlock)success
                              failure:(GESRequestCompletionBlock)failure;

/// 把block置nil来打破循环引用
- (void)clearCompletionBlock;

/// Request Accessory，可以hook Request的start和stop
- (void)addAccessory:(id<GESRequestAccessory>)accessory;

/// 以下方法由子类继承来覆盖默认值

/// 请求成功的回调
- (void)requestCompleteFilter;

/// 请求失败的回调
- (void)requestFailedFilter;

/// 请求的URL
- (NSString *)requestUrl;

/// 请求的CdnURL
- (NSString *)cdnUrl;

/// 请求的BaseURL
- (NSString *)baseUrl;

/// 请求的连接超时时间，默认为60秒
- (NSTimeInterval)requestTimeoutInterval;

/// 请求的参数列表
- (id)requestArgument;

/// 用于在cache结果，计算cache文件名时，忽略掉一些指定的参数
- (id)cacheFileNameFilterForRequestArgument:(id)argument;

/// Http请求的方法
- (GESRequestMethod)requestMethod;

/// 请求的SerializerType
- (GESRequestSerializerType)requestSerializerType;

/// 请求的Server用户名和密码
- (NSArray *)requestAuthorizationHeaderFieldArray;

/// 在HTTP报头添加的自定义参数
- (NSDictionary *)requestHeaderFieldValueDictionary;

/// 构建自定义的UrlRequest，
/// 若这个方法返回非nil对象，会忽略requestUrl, requestArgument, requestMethod, requestSerializerType
- (NSURLRequest *)buildCustomUrlRequest;

/// 是否使用CDN的host地址
- (BOOL)useCDN;

/// 用于检查JSON是否合法的对象
- (id)jsonValidator;

/// 用于检查Status Code是否正常的方法
- (BOOL)statusCodeValidator;

/// 当POST的内容带有文件等富文本时使用
- (AFConstructingBlock)constructingBodyBlock;

/// 当需要断点续传时，指定续传的地址
- (NSString *)resumableDownloadPath;

/// 当需要断点续传时，获得下载进度的回调
//- (AFDownloadProgressBlock)resumableDownloadProgressBlock;
@end


@interface GESBaseRequest (RequestAccessory)
- (void)toggleAccessoriesWillStartCallBack;
- (void)toggleAccessoriesWillStopCallBack;
- (void)toggleAccessoriesDidStopCallBack;

@end

