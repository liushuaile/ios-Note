//
//  DBFileManager.h
//  iApp
//
//  Created by SL on 3/8/17.
//
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
//#import "SVProgressHUD.h"

@interface DBFileManager : NSObject


//数据库初始化
/*
 数据库文件迁移 路径由 pathA --> pathB
 
 1、监测 pathB 路径下 DB 文件是否存在
 
 if （存在）｛
 
 2、打开 pathB 路径下 DB 文件,程序继续运行
 
 ｝ else ｛
 
 3、COPY pathA 路径下 DB 文件 到 pathB 路径下
 
 if （COPY 成功）｛
 
 4、为 pathB 路径下DB文件正名，打开 pathB 路径下 DB 文件,程序继续运行
 
 ｝else ｛
 
 5、操作失败，继续使用 pathA 路径下DB文件，程序继续运行。
 
 ｝
 ｝
 */
+ (BOOL) isExistPathAppGroupDB;
// App 在 AppGroup 下 DB 文件路径

+ (NSString *) pathAppGroupDB;
// App 在 私有沙盒 下 DB 文件路径
+ (NSString *) pathAppPrivateDB;

//删除App 在 AppGroup下的 DB 文件
+(void)removeAppDBAtAppGroupPath;
+(void)removeAppDBAtAppGroupPathAndRestart;

@end
