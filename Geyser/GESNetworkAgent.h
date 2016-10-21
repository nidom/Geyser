//
//  GESNetworkAgent.h
//  Sample
//
//  Created by nidom on 16/6/29.
//  Copyright © 2016年 nidom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GESBaseRequest.h"
#import "GESNetworkPrivate.h"
@interface GESNetworkAgent : NSObject

+ (GESNetworkAgent *)sharedInstance;

- (void)addRequest:(GESBaseRequest *)request;

- (void)cancelRequest:(GESBaseRequest *)request;

- (void)cancelAllRequests;

/// 根据request和networkConfig构建url
- (NSString *)buildRequestUrl:(GESBaseRequest *)request;

@end
