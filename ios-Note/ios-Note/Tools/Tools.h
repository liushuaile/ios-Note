//
//  Tools.h
//  Note
//
//  Created by SL on 05/04/2017.
//  Copyright © 2017 Sam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tools : NSObject

+ (NSString*)dictionaryToJson:(NSDictionary *)dic;

//颜色16进制转换 52c332
+ (UIColor *)getColor:(NSString *)hexColor;
//计算中英文字符串长度
+ (NSInteger)getToInt:(NSString*)strtemp;
//计算中英文字符串长度
+ (int)convertToInt:(NSString*)strtemp;

@end
