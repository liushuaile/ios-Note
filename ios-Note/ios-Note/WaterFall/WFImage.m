//
//  WFImage.m
//  ios-Note
//
//  Created by SL on 12/04/2017.
//  Copyright © 2017 Sam. All rights reserved.
//

#import "WFImage.h"

@implementation WFImage

+ (instancetype)imageWithImageDic:(NSDictionary *)imageDic {
    
    WFImage *image = [[WFImage alloc] init];
    image.imageURL = [NSURL URLWithString:imageDic[@"img"]];
    image.imageW = [imageDic[@"w"] floatValue];
    image.imageH = [imageDic[@"h"] floatValue];
    return image;
}

@end
