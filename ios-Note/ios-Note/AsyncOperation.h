//
//  AsyncOperation.h
//  ios-Note
//
//  Created by SL on 25/05/2017.
//  Copyright © 2017 Sam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AsyncOperation : NSOperation
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) void (^successHandler)(id responseObject);
@property (nonatomic, copy) void (^errorHandler)(NSError * error);

@end
