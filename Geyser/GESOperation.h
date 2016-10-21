//
//  GESOperation.h
//  jdd
//
//  Created by nidom on 16/8/29.
//
//

#import <Foundation/Foundation.h>

@interface GESOperation : NSObject


///------------------------------------------------
/// @name Getting HTTP URL Connection Information
///------------------------------------------------

/**
 The last HTTP response received by the operation's connection.
 */
@property (nonatomic, strong,nullable ) NSURLSessionDataTask *task;

///------------------------------------------------
/// @name Getting HTTP URL Connection Information
///------------------------------------------------

/**
 The last HTTP response received by the operation's connection.
 */
@property (nonatomic, strong,nullable ) NSHTTPURLResponse *response;

/**
 The last HTTP response received by the operation's connection.
 */
@property (nonatomic, strong,nullable ) NSData *responseData;


/**
 An object constructed by the `responseSerializer` from the response and response data. Returns `nil` unless the operation `isFinished`, has a `response`, and has `responseData` with non-zero content length. If an error occurs during serialization, `nil` will be returned, and the `error` property will be populated with the serialization error.
 */
@property ( nonatomic, strong, nullable) id responseObject;


/**
 An object constructed by the `responseSerializer` from the response and response data. Returns `nil` unless the operation `isFinished`, has a `response`, and has `responseData` with non-zero content length. If an error occurs during serialization, `nil` will be returned, and the `error` property will be populated with the serialization error.
 */
@property (readonly, nonatomic, assign) BOOL isExecuting;

@end
