//
//  GESNetworkConfig.m
//  Sample
//
//  Created by nidom on 16/6/29.
//  Copyright © 2016年 nidom. All rights reserved.
//

#import "GESNetworkConfig.h"

@implementation GESNetworkConfig{
    NSMutableArray *_urlFilters;
    NSMutableArray *_cacheDirPathFilters;
}
+ (GESNetworkConfig *)sharedInstance {
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
        _urlFilters = [NSMutableArray array];
        _cacheDirPathFilters = [NSMutableArray array];
        _securityPolicy = [AFSecurityPolicy defaultPolicy];
    }
    return self;
}

- (void)addUrlFilter:(id<GESUrlFilterProtocol>)filter {
    [_urlFilters addObject:filter];
}

- (void)addCacheDirPathFilter:(id<GESCacheDirPathFilterProtocol>)filter {
    [_cacheDirPathFilters addObject:filter];
}

- (NSArray *)urlFilters {
    return [_urlFilters copy];
}

- (NSArray *)cacheDirPathFilters {
    return [_cacheDirPathFilters copy];
}
@end
