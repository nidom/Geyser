//
//  GESNetworkConfig.h
//  Sample
//
//  Created by nidom on 16/6/29.
//  Copyright © 2016年 nidom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFSecurityPolicy.h"
#import "GESBaseRequest.h"
@protocol GESUrlFilterProtocol <NSObject>
- (NSString *)filterUrl:(NSString *)originUrl withRequest:(GESBaseRequest *)request;
@end

@protocol GESCacheDirPathFilterProtocol <NSObject>
- (NSString *)filterCacheDirPath:(NSString *)originPath withRequest:(GESBaseRequest *)request;
@end
@interface GESNetworkConfig : NSObject
+ (GESNetworkConfig *)sharedInstance;
@property (strong, nonatomic) NSString *baseUrl;
@property (strong, nonatomic) NSString *cdnUrl;
@property (strong, nonatomic, readonly) NSArray *urlFilters;
@property (strong, nonatomic, readonly) NSArray *cacheDirPathFilters;
@property (strong, nonatomic) AFSecurityPolicy *securityPolicy;

- (void)addUrlFilter:(id<GESUrlFilterProtocol>)filter;
- (void)addCacheDirPathFilter:(id <GESCacheDirPathFilterProtocol>)filter;
@end
