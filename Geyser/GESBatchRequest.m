//
//  GESBatchRequest.m
//
//  Copyright (c) 2012-2014 GESNetwork https://github.com/GESNetwork
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "GESBatchRequest.h"
#import "GESNetworkPrivate.h"
#import "GESBatchRequestAgent.h"
@interface GESBatchRequest() <GESRequestDelegate>
@property (nonatomic) NSInteger finishedCount;

@end

@implementation GESBatchRequest

- (id)initWithRequestArray:(NSArray *)requestArray {
    self = [super init];
    if (self) {
        _requestArray = [requestArray copy];
        _finishedCount = 0;
        for (GESRequest * req in _requestArray) {
            if (![req isKindOfClass:[GESRequest class]]) {
                 GESLog(@"Error, request item must be GESRequest instance.");
                return nil;
            }
        }
    }
    return self;
}

- (void)start {
    if (_finishedCount > 0) {
      GESLog(@"Error! Batch request has already started.");
        return;
    }
    [[GESBatchRequestAgent sharedInstance] addBatchRequest:self];
      [self toggleAccessoriesWillStartCallBack];
    for (GESRequest * req in _requestArray) {
        req.delegate = self;
        [req start];
    }
}

- (void)stop {
   [self toggleAccessoriesWillStopCallBack];
    _delegate = nil;
    [self clearRequest];
    [self toggleAccessoriesDidStopCallBack];
    [[GESBatchRequestAgent sharedInstance] removeBatchRequest:self];
}

- (void)startWithCompletionBlockWithSuccess:(void (^)(GESBatchRequest *batchRequest))success
                                    failure:(void (^)(GESBatchRequest *batchRequest))failure {
    [self setCompletionBlockWithSuccess:success failure:failure];
    [self start];
}

- (void)setCompletionBlockWithSuccess:(void (^)(GESBatchRequest *batchRequest))success
                              failure:(void (^)(GESBatchRequest *batchRequest))failure {
    self.successCompletionBlock = success;
    self.failureCompletionBlock = failure;
}

- (void)clearCompletionBlock {
    // nil out to break the retain cycle.
    self.successCompletionBlock = nil;
    self.failureCompletionBlock = nil;
}

- (BOOL)isDataFromCache {
    BOOL result = YES;
    for (GESRequest *request in _requestArray) {
        if (!request.isDataFromCache) {
            result = NO;
        }
    }
    return result;
}


- (void)dealloc {
    [self clearRequest];
}
#pragma mark - Network Request Delegate
- (void)requestFinished:(GESRequest *)request {
    _finishedCount++;
    if (_finishedCount == _requestArray.count) {
        [self toggleAccessoriesWillStopCallBack];
        if ([_delegate respondsToSelector:@selector(batchRequestFinished:)]) {
            [_delegate batchRequestFinished:self];
        }
        if (_successCompletionBlock) {
            _successCompletionBlock(self);
        }
        [self clearCompletionBlock];
        [self toggleAccessoriesDidStopCallBack];
    }
}
- (void)requestFailed:(GESRequest *)request {
     [self toggleAccessoriesWillStopCallBack];
    // Stop
    for (GESRequest *req in _requestArray) {
        [req stop];
    }
    // Callback
    if ([_delegate respondsToSelector:@selector(batchRequestFailed:)]) {
        [_delegate batchRequestFailed:self];
    }
    if (_failureCompletionBlock) {
        _failureCompletionBlock(self);
    }
    // Clear
    [self clearCompletionBlock];
    
    [self toggleAccessoriesDidStopCallBack];
    [[GESBatchRequestAgent sharedInstance] removeBatchRequest:self];
}

- (void)clearRequest {
    for (GESRequest * req in _requestArray) {
        [req stop];
    }
    [self clearCompletionBlock];
}

#pragma mark - Request Accessoies

- (void)addAccessory:(id<GESRequestAccessory>)accessory {
    if (!self.requestAccessories) {
        self.requestAccessories = [NSMutableArray array];
    }
    [self.requestAccessories addObject:accessory];
}
@end



@implementation GESBatchRequest (RequestAccessory)

-(void)toggleAccessoriesWillStartCallBack {
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
