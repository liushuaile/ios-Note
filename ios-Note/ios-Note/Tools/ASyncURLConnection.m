//
//  ASyncURLConnection.m
//  Note
//
//  Created by SL on 06/04/2017.
//  Copyright © 2017 Sam. All rights reserved.
//

#import "ASyncURLConnection.h"

@implementation ASyncURLConnection 

+ (id)request:(NSString *)requestUrl completeBlock:(completeBlock_t)completeBlock errorBlock:(errorBlock_t)errorBlock {

    return [[self alloc] initWithRequest:requestUrl completeBlock:completeBlock errorBlock:errorBlock];
}

- (id)initWithRequest:(NSString *)requestUrl completeBlock:(completeBlock_t)completeBlock errorBlock:(errorBlock_t)errorBlock {
    
    NSURL *url = [NSURL URLWithString:requestUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    if ((self = [super initWithRequest:request delegate:self startImmediately:NO])) {
        
        completeBlock_ = [completeBlock copy];
        errorBlock_ = [errorBlock copy];
        
        [self start];
    }
    return self;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(nonnull NSURLResponse *)response {
    [data_ setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(nonnull NSData *)data {
    [data_ appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    completeBlock_(data_);
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    errorBlock_(error);
}

@end
