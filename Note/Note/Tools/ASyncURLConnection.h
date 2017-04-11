//
//  ASyncURLConnection.h
//  Note
//
//  Created by SL on 06/04/2017.
//  Copyright © 2017 Sam. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^completeBlock_t)(NSData *data);
typedef void (^errorBlock_t)(NSError *error);

@interface ASyncURLConnection : NSURLConnection <NSURLConnectionDataDelegate>
{
    NSMutableData *data_;
    completeBlock_t completeBlock_;
    errorBlock_t errorBlock_;
}

+ (id)request:(NSString *)requestUrl completeBlock:(completeBlock_t)completeBlock errorBlock:(errorBlock_t)errorBlock;

- (id)initWithRequest:(NSString *)requestUrl completeBlock:(completeBlock_t)completeBlock errorBlock:(errorBlock_t)errorBlock;

@end
