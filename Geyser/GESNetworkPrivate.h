//
//  GESNetworkPrivate.h
//  Sample
//
//  Created by nidom on 16/6/29.
//  Copyright © 2016年 nidom. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "GESBaseRequest.h"
#import "GESBatchRequest.h"
#import "GESChainRequest.h"
FOUNDATION_EXPORT void GESLog(NSString *format, ...) NS_FORMAT_FUNCTION(1,2);

@interface GESNetworkPrivate : NSObject

+ (BOOL)checkJson:(id)json withValidator:(id)validatorJson;

+ (NSString *)urlStringWithOriginUrlString:(NSString *)originUrlString
                          appendParameters:(NSDictionary *)parameters;

+ (void)addDoNotBackupAttribute:(NSString *)path;

+ (NSString *)md5StringFromString:(NSString *)string;

+ (NSString *)appVersionString;

@end



