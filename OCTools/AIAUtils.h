//
//  AIAUtils.h
//  iApp
//
//  Created by Sam Liu on 16/4/25.
//
//


#import <Foundation/Foundation.h>

//typedef NS_ENUM(NSInteger, AIARegexType) {
//    AIAIDRegex,
//    AIAPhoneRegex,
//    AIAHeightRegex,
//    AIAWeightRegex,
//};

extern NSString * const AIAIDRegex;
extern NSString * const AIAPhoneRegex;
//2-3位的整数
extern NSString * const AIAHeightRegex;
//1-3位的整数
extern NSString * const AIAWeightRegex;

extern NSString * const kCBSDKIfInPayment; /*#1292, 存储 NSNumber * 对象*/

@interface AIAUtils : NSObject

+ (BOOL) isValidString:(NSString*)value byRegex:(NSString *)regex;

//判断是否数字
+ (BOOL) isValidNumber:(NSString*)value;

//判断是否手机号
+ (BOOL) isValidPhone:(NSString*)value;

//校验邮箱
+ (BOOL) validateEmail:(NSString *)candidate;

//身份证校验
+ (BOOL) isValidId:(NSString *)value;

//
+ (NSString *) md5:(NSString *)str;
+ (NSString *) fileMD5:(NSString*)path;
+ (NSString *) imageMD5:(UIImage *)image;
//数据库初始化
/*
 1、监测iApp private DB AppGroup路径下 DB 文件是否存在
 if （存在）｛
 2、打开 iApp private DB AppGroup路径下 DB 文件
 ｝ else ｛
 3、COPY 平台 DB AppGroup路径下 DB 文件 到 iApp private DB AppGroup路径下
 打开 iApp private DB AppGroup路径下 DB 文件
｝
 */
+ (BOOL) isExistIAppPrivateDB;
// iApp AppGroup 路径下 DB 文件
+ (NSString *) PathIAppPrivateDB;
//删除iApp AppGroup下的文件
+(void)removeLocalIAppDB;
+(void)removeLocalIAppDBAndRestart;

//
+ (void) value:(id)value key:(NSString *)key;
+ (id) forKey:(NSString *)key;
+ (void) deleteKey:(NSString *)key;

//偿二代信息
+ (NSString *)msgOfPayBack;

@end
