//
//  WFImage.h
//  ios-Note
//
//  Created by SL on 12/04/2017.
//  Copyright © 2017 Sam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WFImage : NSObject

@property (nonatomic, strong) NSURL *imageURL;
@property (nonatomic, assign) CGFloat imageW;
@property (nonatomic, assign) CGFloat imageH;

+ (instancetype)imageWithImageDic:(NSDictionary *)imageDic;

@end
