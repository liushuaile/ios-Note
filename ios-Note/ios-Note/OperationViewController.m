//
//  OperationViewController.m
//  ios-Note
//
//  Created by SL on 25/05/2017.
//  Copyright © 2017 Sam. All rights reserved.
//

#import "OperationViewController.h"
#import "AsyncOperation.h"

@interface OperationViewController ()

@end

@implementation OperationViewController {
    NSString *url1;
    NSString *url2;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    url1 = @"http://www.baidu.com";
    url2 = @"http://www.jianshu.com";
    
//    [self testOperation];
    //解决异步任务依赖
//    [self testAsyncOperation];
    [self gcdGroupII];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)gcdGroupII{
    /*
     使用dispatch_group_t可以监控一组block，dispatch_group_t会追踪组内的block的执行状态，当group中所有的block完成以后，可以使用dispatch_group_notify来执行一个额外的block。
     增加dispatch_group_t中block的数量有两种方式，一种是使用dispatch_group_async或者dispatch_group_sync后面添加block，另外一种是使用dispatch_group_enter和dispatch_group_leave组合来代表一个block的开始和结束。
     */
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self getHtmlOfUrl:url1 success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable response) {
            NSLog(@"get data of %@ success",url1);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"get html of %@ fail",url1);
        }];

    });
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self getHtmlOfUrl:url2 success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable response) {
            NSLog(@"get data of %@ success",url2);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"get html of %@ fail",url2);
        }];

    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"push to new controller after all data is ready!");
    });
    /*
     push to new controller after all data is ready!
     get data of http://www.jianshu.com success
     get data of http://www.baidu.com success
     */
}

- (void)gcdGroup{
    /*
     使用dispatch_group_t可以监控一组block，dispatch_group_t会追踪组内的block的执行状态，当group中所有的block完成以后，可以使用dispatch_group_notify来执行一个额外的block。
     增加dispatch_group_t中block的数量有两种方式，一种是使用dispatch_group_async或者dispatch_group_sync后面添加block，另外一种是使用dispatch_group_enter和dispatch_group_leave组合来代表一个block的开始和结束。
     */
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_enter(group);
    [self getHtmlOfUrl:url1 success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable response) {
        NSLog(@"get data of %@ success",url1);
        dispatch_group_leave(group);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"get html of %@ fail",url1);
        dispatch_group_leave(group);
    }];
    
    dispatch_group_enter(group);
    [self getHtmlOfUrl:url2 success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable response) {
        NSLog(@"get data of %@ success",url2);
        dispatch_group_leave(group);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"get html of %@ fail",url2);
        dispatch_group_leave(group);
    }];
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"push to new controller after all data is ready!");
    });
}

- (void)testAsyncOperation {
/*
 NSOperation对象调用start方法时，默认是在调用线程同步执行的。
 */
    NSOperationQueue *queue = [NSOperationQueue new];
    AsyncOperation *op1 = [AsyncOperation new];
    op1.url = url1;
    op1.successHandler = ^(id response) {
        NSLog(@"get data of %@ success",url1);
    };
    op1.errorHandler = ^(NSError *error) {
        NSLog(@"get data of %@ fail",url1);
    };
    [queue addOperation:op1];
    
    AsyncOperation *op2 = [[AsyncOperation alloc] init];
    op2.url = url2;
    op2.successHandler = ^(id response) {
        NSLog(@"get data of %@ success",url2);
    };
    op2.errorHandler = ^(NSError *error) {
        NSLog(@"get data of %@ fail",url2);
    };
    [queue addOperation:op2];
    
    NSOperation *pushOp = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"push to new controller after all data is ready!");
    }];
    [pushOp addDependency:op1];
    [pushOp addDependency:op2];
    [queue addOperation:pushOp];
}

//由于请求是异步的，所以此处依赖处理不能解决o1\o2完成后，再跑o3
- (void)testOperation {
    
    
    NSOperation *operation1 = [NSBlockOperation blockOperationWithBlock:^{
        [self getHtmlOfUrl:url1 success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable response) {
            NSLog(@"get data url1 success");
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"get data url1 failure");
        }];
    }];
    
    NSOperation *operation2 = [NSBlockOperation blockOperationWithBlock:^{
        [self getHtmlOfUrl:url2 success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable response) {
            NSLog(@"get data url2 success");
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"get data url2 success");
        }];
    }];
    
    NSOperation *operation3 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"log message after url1 and url2 have gotten");
    }];
    
    [operation3 addDependency:operation1];
    [operation3 addDependency:operation2];
    
    NSOperationQueue *queue = [NSOperationQueue new];
    ////阻塞当前线程，直到该NSOperation结束。可用于线程执行顺序的同步
    [queue addOperations:@[operation1,operation2,operation3] waitUntilFinished:YES];
    
//    [queue addOperation:operation1];
//    [queue addOperation:operation2];
//    [queue addOperation:operation3];
}

- (void)getHtmlOfUrl:(NSString *)url
             success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable))success
             failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure{
    url = [url stringByRemovingPercentEncoding];
    
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    sessionManager.responseSerializer.acceptableContentTypes = [sessionManager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [sessionManager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(task,responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(task,error);
    }];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
