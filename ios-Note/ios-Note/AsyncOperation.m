//
//  AsyncOperation.m
//  ios-Note
//
//  Created by SL on 25/05/2017.
//  Copyright © 2017 Sam. All rights reserved.
//

#import "AsyncOperation.h"

@implementation AsyncOperation{
    BOOL finished;
    BOOL executing;
    AFHTTPSessionManager *_sessionManager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        finished = NO;
        executing = NO;
        
        _sessionManager = [AFHTTPSessionManager manager];
    }
    return self;
}
//-(void)main;//main函数执行完成后, isExecuting会被置为NO, 而isFinished则被置为YES.
//启动任务,默认在当前队列同步执行；当实现了start方法时，默认会执行start方法，而不执行main方法
- (void)start {
    //always check for cancellation before launching the task
    if ([self isCancelled]) {
        // Must move the operation to the finished state if it is canceled.
        [self willChangeValueForKey:@"isFinished"];
        finished = YES;
        [self didChangeValueForKey:@"isFinished"];
        return;
    }
    // If the operation is not canceled, begin executing the task.
    [self willChangeValueForKey:@"isExecuting"];
    executing = YES;
    [self didChangeValueForKey:@"isExecuting"];
    
    [self performTask];
}

- (void)performTask {
    
    _sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [_sessionManager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    @weakify_self;
    [_sessionManager GET:_url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        @strongify_self;
        if (self.successHandler) {
            self.successHandler(responseObject);
        }
        //设置线程结束状态
        [self setExecuting:NO];
        [self setFinished:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        @strongify_self;
        if (self.errorHandler) {
            self.errorHandler(error);
        }
        //设置线程结束状态
        [self setExecuting:NO];
        [self setFinished:YES];
    }];
}

- (void)setFinished:(BOOL)b {
    [self willChangeValueForKey:@"isFinished"];
    finished = b;
    [self didChangeValueForKey:@"isFinished"];
}

- (void)setExecuting:(BOOL)b {
    [self willChangeValueForKey:@"isExecuting"];
    executing = b;
    [self didChangeValueForKey:@"isExecuting"];

}


- (BOOL)isFinished {
    return finished;
}

- (BOOL)isExecuting {
    return executing;
}

@end
