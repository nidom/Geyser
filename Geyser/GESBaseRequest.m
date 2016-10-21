//
//  GESBaseRequest.m
//  Sample
//
//  Created by nidom on 16/6/29.
//  Copyright © 2016年 nidom. All rights reserved.
//

#import "GESBaseRequest.h"
#import "GESNetworkAgent.h"

@implementation GESBaseRequest
/// for subclasses to overwrite



- (void)requestCompleteFilter {

}

- (void)requestFailedFilter {
}

- (NSString *)requestUrl {
    return @"";
}

- (NSString *)cdnUrl {
    return @"";
}

- (NSString *)baseUrl {
    
     return @"";
}

- (NSTimeInterval)requestTimeoutInterval {
    return 60;
}

- (id)requestArgument {
    return nil;
}

- (id)cacheFileNameFilterForRequestArgument:(id)argument {
    return argument;
}

- (GESRequestMethod)requestMethod {
     
    return GESRequestMethodGet;
}

- (GESRequestSerializerType)requestSerializerType {
    return GESRequestSerializerTypeHTTP;
}

- (NSArray *)requestAuthorizationHeaderFieldArray {
    return nil;
}

- (NSDictionary *)requestHeaderFieldValueDictionary {
    return nil;
}

- (NSURLRequest *)buildCustomUrlRequest {
    return nil;
}

- (BOOL)useCDN {
    return NO;
}
-(id)jsonValidator {
    return nil;
}

- (BOOL)statusCodeValidator {
    NSInteger statusCode = [self responseStatusCode];
    if (statusCode >= 200 && statusCode <=299) {
        return YES;
    } else {
        return NO;
    }
}

- (AFConstructingBlock)constructingBodyBlock {
    return nil;
}
- (NSString *)resumableDownloadPath {
    return nil;
}

//- (AFDownloadProgressBlock)resumableDownloadProgressBlock {
//    return nil;
//}

/// append self to request queue
- (void)start {
    [self toggleAccessoriesWillStartCallBack];
    [[GESNetworkAgent sharedInstance] addRequest:self];
}

/// remove self from request queue
- (void)stop {
    [self toggleAccessoriesWillStopCallBack];
    self.delegate = nil;
    [[GESNetworkAgent sharedInstance] cancelRequest:self];
    [self toggleAccessoriesDidStopCallBack];
}

- (BOOL)isExecuting {
    return self.operation.isExecuting;
}

- (void)startWithCompletionBlockWithSuccess:(GESRequestCompletionBlock)success
                                    failure:(GESRequestCompletionBlock)failure {
    [self setCompletionBlockWithSuccess:success failure:failure];
    [self start];
}

- (void)setCompletionBlockWithSuccess:(GESRequestCompletionBlock)success
                              failure:(GESRequestCompletionBlock)failure {
    self.successCompletionBlock = success;
    self.failureCompletionBlock = failure;
}

- (void)clearCompletionBlock {
    // nil out to break the retain cycle.
    self.successCompletionBlock = nil;
    self.failureCompletionBlock = nil;
}

- (id)responseJSONObject {
     return self.operation.responseObject;
}

- (NSData *)responseData {
  
     return self.operation.responseData;
}


- (NSInteger)responseStatusCode {
     
     return [self.operation.response statusCode];

}
- (NSDictionary *)responseHeaders {
     
     return [self.operation.response allHeaderFields];
}
#pragma mark - Request Accessoies
- (void)addAccessory:(id<GESRequestAccessory>)accessory {
    if (!self.requestAccessories) {
        self.requestAccessories = [NSMutableArray array];
    }
    [self.requestAccessories addObject:accessory];
}
@end



@implementation GESBaseRequest (RequestAccessory)

- (void)toggleAccessoriesWillStartCallBack {
     for (id<GESRequestAccessory> accessory in self.requestAccessories) {
          if ([accessory respondsToSelector:@selector(requestWillStart:)]) {
               [accessory requestWillStart:self];
          }
     }
}

- (void)toggleAccessoriesWillStopCallBack {
     for (id<GESRequestAccessory> accessory in self.requestAccessories) {
          if ([accessory respondsToSelector:@selector(requestWillStop:)]) {
               [accessory requestWillStop:self];
          }
     }
}

- (void)toggleAccessoriesDidStopCallBack {
     for (id<GESRequestAccessory> accessory in self.requestAccessories) {
          if ([accessory respondsToSelector:@selector(requestDidStop:)]) {
               [accessory requestDidStop:self];
          }
     }
}

@end

