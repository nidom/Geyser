//
//  GESNetworkAgent.m
//  Sample
//
//  Created by nidom on 16/6/29.
//  Copyright © 2016年 nidom. All rights reserved.
//

#import "GESNetworkAgent.h"
#import "GESNetworkConfig.h"
#import "GESNetworkPrivate.h"
@implementation GESNetworkAgent{
    AFHTTPSessionManager *_manager;
    
    GESNetworkConfig *_config;
    NSMutableDictionary *_requestsRecord;
}


+ (GESNetworkAgent *)sharedInstance {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}
- (id)init {
    self = [super init];
    if (self) {
        _config = [GESNetworkConfig sharedInstance];
        _manager = [AFHTTPSessionManager manager];
        _requestsRecord = [NSMutableDictionary dictionary];
        _manager.operationQueue.maxConcurrentOperationCount = 4;
        _manager.securityPolicy = _config.securityPolicy;
    }
    return self;
}
- (NSString *)buildRequestUrl:(GESBaseRequest *)request {
    NSString *detailUrl = [request requestUrl];
    if ([detailUrl hasPrefix:@"http"]) {
        return detailUrl;
    }
    // filter url
    NSArray *filters = [_config urlFilters];
    for (id<GESUrlFilterProtocol> f in filters) {
        detailUrl = [f filterUrl:detailUrl withRequest:request];
    }
    NSString *baseUrl;
    if ([request useCDN]) {
        if ([request cdnUrl].length > 0) {
            baseUrl = [request cdnUrl];
        } else {
            baseUrl = [_config cdnUrl];
        }
    } else {
        if ([request baseUrl].length > 0) {
            baseUrl = [request baseUrl];
        } else {
            baseUrl = [_config baseUrl];
        }
    }
    return [NSString stringWithFormat:@"%@%@", baseUrl, detailUrl];
}

- (void)addRequest:(GESBaseRequest *)request {
     
     
     GESRequestMethod method = [request requestMethod];
     NSString *url = [self buildRequestUrl:request];
     
     
     id param = request.requestArgument;
     AFConstructingBlock constructingBlock = [request constructingBodyBlock];
     
     if (request.requestSerializerType == GESRequestSerializerTypeHTTP) {
          _manager.requestSerializer = [AFHTTPRequestSerializer serializer];
     } else if (request.requestSerializerType == GESRequestSerializerTypeJSON) {
          _manager.requestSerializer = [AFJSONRequestSerializer serializer];
     }
     _manager.requestSerializer.timeoutInterval = [request requestTimeoutInterval];
     // if api need server username and password
     NSArray *authorizationHeaderFieldArray = [request requestAuthorizationHeaderFieldArray];
     if (authorizationHeaderFieldArray != nil) {
          [_manager.requestSerializer setAuthorizationHeaderFieldWithUsername:(NSString *)authorizationHeaderFieldArray.firstObject
                                                                     password:(NSString *)authorizationHeaderFieldArray.lastObject];
     }
     // if api need add custom value to HTTPHeaderField
     NSDictionary *headerFieldValueDictionary = [request requestHeaderFieldValueDictionary];
     if (headerFieldValueDictionary != nil) {
          for (id httpHeaderField in headerFieldValueDictionary.allKeys) {
               id value = headerFieldValueDictionary[httpHeaderField];
               if ([httpHeaderField isKindOfClass:[NSString class]] && [value isKindOfClass:[NSString class]]) {
                    [_manager.requestSerializer setValue:(NSString *)value forHTTPHeaderField:(NSString *)httpHeaderField];
               } else {
                    NSLog(@"Error, class of key/value in headerFieldValueDictionary should be NSString.");
               }
          }
     }
     
     
     
     GESOperation * operation = [GESOperation new];
     request.operation = operation;
     
     // if api build custom url request
     //  NSURLRequest *customUrlRequest= [request buildCustomUrlRequest];
     
     
     // if (customUrlRequest) {
     //        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:customUrlRequest];
     //        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
     //            [self handleRequestResult:operation];
     //        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
     //            [self handleRequestResult:operation];
     //        }];
     //        request.requestOperation = operation;
     //        operation.responseSerializer = _manager.responseSerializer;
     //        [_manager.operationQueue addOperation:operation];
     //   } else {
     if (method == GESRequestMethodGet) {
          if (request.resumableDownloadPath) {
               
               //TODO:
          } else {
     
               [_manager GET:url  parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
                    
               } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    request.operation.task =task;
                    [self handleRequestResult:request.operation responseObject:responseObject];
                    
               } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    
                    request.operation.task =task;
                    
                    [self handleRequestResult:request.operation responseObject:nil];
               }];
          }
     } else if (method == GESRequestMethodPost) {
          
          // if (constructingBlock != nil) {
          
          [ _manager POST:url parameters:param constructingBodyWithBlock:constructingBlock  progress:^(NSProgress * _Nonnull uploadProgress) {
               
          } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
               
               request.operation.task =task;
               [self handleRequestResult:request.operation responseObject:responseObject];
               
          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
               request.operation.task =task;
               
               [self handleRequestResult:request.operation responseObject:nil];
               
               
          }];
          
          // } else {
          //                request.requestOperation = [_manager POST:url parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
          //                    [self handleRequestResult:operation];
          //                }                                 failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          //                    [self handleRequestResult:operation];
          //                 }];
          //  }
     }
     else if (method == GESRequestMethodHead) {
          
          [_manager HEAD:url parameters:param success:^(NSURLSessionDataTask * _Nonnull task) {
               request.operation.task =task;
               [self handleRequestResult:request.operation responseObject:nil];
               
          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
               request.operation.task =task;
               
               [self handleRequestResult:request.operation responseObject:nil];
               
               
          }];
     } else if (method == GESRequestMethodPut) {
          
          [_manager PUT:url parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
               
               
               
               request.operation.task =task;
               [self handleRequestResult:request.operation responseObject:responseObject];
               
          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
               request.operation.task =task;
               
               [self handleRequestResult:request.operation responseObject:nil];
               
          }];
     } else if (method == GESRequestMethodDelete) {
          
          [_manager DELETE:url parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
               request.operation.task =task;
               [self handleRequestResult:request.operation responseObject:responseObject];
               
          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
               request.operation.task =task;
               
               [self handleRequestResult:request.operation responseObject:nil];
               
          }];
     } else if (method == GESRequestMethodPatch) {
          
          [_manager PATCH:url parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
               request.operation.task =task;
               [self handleRequestResult:request.operation responseObject:responseObject];
               
               
          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
               request.operation.task =task;
               
               [self handleRequestResult:request.operation responseObject:nil];
               
          }];
     } else {
          GESLog(@"Error, unsupport method type");
          return;
     }
     //  }
     
     GESLog(@"Add request: %@", NSStringFromClass([request class]));
     [self addOperation:request];
     
}
- (void)addOperation:(GESBaseRequest *)request {
     
     if (request.operation != nil) {
          NSString *key = [self requestHashKey:request.operation];
          @synchronized(self) {
               _requestsRecord[key] = request;
          }
     }
}
- (void)cancelRequest:(GESBaseRequest *)request {
     [request.operation.task cancel];
     [self removeOperation:request.operation];
     [request clearCompletionBlock];
}

- (void)cancelAllRequests {
    NSDictionary *copyRecord = [_requestsRecord copy];
    for (NSString *key in copyRecord) {
        GESBaseRequest *request = copyRecord[key];
        [request stop];
    }
}

- (BOOL)checkResult:(GESBaseRequest *)request {
     
    BOOL result = [request statusCodeValidator];
    if (!result) {
        return result;
    }
    id validator = [request jsonValidator];
    if (validator != nil) {
        id json = [request responseJSONObject];
        result = [GESNetworkPrivate checkJson:json withValidator:validator];
    }
    return result;
}

- (void)handleRequestResult:(GESOperation *)operation  responseObject:(id) responseObject{
    
    NSString *key = [self requestHashKey:operation];
    GESBaseRequest *request = _requestsRecord[key];
    operation.responseObject = responseObject;
    
     GESLog(@"Finished Request: %@", NSStringFromClass([request class]));
    if (request) {
        BOOL succeed = [self checkResult:request];
        if (succeed) {
       
            [request toggleAccessoriesWillStopCallBack];
            [request requestCompleteFilter];
            if (request.delegate != nil) {
                [request.delegate requestFinished:request];
            }
            if (request.successCompletionBlock) {
                request.successCompletionBlock(request);
            }
            [request toggleAccessoriesDidStopCallBack];

        } else {
            GESLog(@"Request %@ failed, status code = %ld",
                   NSStringFromClass([request class]), (long)request.responseStatusCode);
            [request toggleAccessoriesWillStopCallBack];
            [request requestFailedFilter];
            if (request.delegate != nil) {
                [request.delegate requestFailed:request];
            }
            if (request.failureCompletionBlock) {
                request.failureCompletionBlock(request);
            }
            [request toggleAccessoriesDidStopCallBack];
        }
    }
    [self removeOperation:operation];
    [request clearCompletionBlock];
}
- (NSString *)requestHashKey:(GESOperation *)operation {
     
    NSString *key = [NSString stringWithFormat:@"%lu", (unsigned long)[operation hash]];
    return key;

}
-(void)storeRequest:(GESBaseRequest *)request {
     
    if (request.operation != nil) {
        NSString *key = [self requestHashKey:request.operation];
        @synchronized(self) {
            _requestsRecord[key] = request;
        }
    }
}
- (void)removeOperation:(GESOperation *)operation {
    NSString *key = [self requestHashKey:operation];
    @synchronized(self) {
        [_requestsRecord removeObjectForKey:key];
    }
    NSLog(@"Request queue size = %lu", (unsigned long)[_requestsRecord count]);
}

@end
