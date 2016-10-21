//
//  GESOperation.m
//  jdd
//
//  Created by nidom on 16/8/29.
//
//

#import "GESOperation.h"

@implementation GESOperation

-(NSHTTPURLResponse *)response{

     return (NSHTTPURLResponse *)self.task.response;
}

@end
