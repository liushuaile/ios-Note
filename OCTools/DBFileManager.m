//
//  DBFileManager.m
//  iApp
//
//  Created by SL on 3/8/17.
//
//

#import "DBFileManager.h"
#import <MTLIB/MTLIB.h>

#define AIAAlertViewShowForMessage(promptMessage)   [[[UIAlertView alloc] initWithTitle:@"提示" message:promptMessage delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];

#define AIAAlertViewShowForError(error)     [[[UIAlertView alloc] initWithTitle:@"提示" message:[error localizedFailureReason] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show] ;


@implementation DBFileManager


#define DBFILE_ISERVICE_APPGROUP @"AIAISERVICE.db"
#define DBFILE_ISERVICE_TMP_APPGROUP @"AIAISERVICE_TMP.db"


+(void)removeAppDBAtAppGroupPathAndRestart{
//    //只有4.2.9 4.2.9.1 的时候才删数据库重新启动
//    NSString *appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
//    if (!([appVersion isEqualToString:@"4.2.9"] || [appVersion isEqualToString:@"4.2.9.1"])) {
//        return;
//    }
    [self removeAppDBAtAppGroupPath];
    __block int timeout = 6; //倒计时时间
    dispatch_semaphore_t sem = dispatch_semaphore_create(0);
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            
            dispatch_semaphore_signal(sem);
            exit(0);
            
        }else{
            NSLog(@"%.2d",timeout);
            NSString *strTime = [NSString stringWithFormat:@"数据库错误%.2d秒后将要重新启动", timeout];
//            [SVProgressHUD showInfoWithStatus:strTime];
            AIAAlertViewShowForMessage(strTime)
            timeout--;
            
        }
    });
    dispatch_resume(_timer);
    
    dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
    
    
}
+(void)removeAppDBAtAppGroupPath{
    //App 在 AppGroup路径下的 DB 文件
    NSString *PATH_APPDB_APPGROUP = [[[MShare sharePath] URLByAppendingPathComponent:DBFILE_ISERVICE_APPGROUP] path];
    
    [self removeFileWithPath:PATH_APPDB_APPGROUP];
}

+(void)removeFileWithPath:(NSString*)path{
//    DDLogInfo(@"%s_line:%d_removeFileWithPath:%@",__PRETTY_FUNCTION__,__LINE__,path);
    NSLog(@"%s_line:%d_removeFileWithPath:%@",__PRETTY_FUNCTION__,__LINE__,path);
    
    if (!path || [path isEqualToString:@""]) {
        return;
    }
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:path]) {
        NSError * removeError;
        [fm removeItemAtPath:path error:&removeError];
        if (removeError) {
            AIAAlertViewShowForError(removeError);
//            DDLogInfo(@"%s_line:%d_removeFileWithPath:error %@",__PRETTY_FUNCTION__,__LINE__,removeError);
            NSLog(@"%s_line:%d_removeFileWithPath:error %@",__PRETTY_FUNCTION__,__LINE__,removeError);
        }
    }
    return;
}

//+(void)progressFileCopy{
//    //iApp的私有DB AppGroup路径 PATH_IAPPDB_APPGROUP
//    NSString *PATH_IAPPDB_APPGROUP = [[[MShare sharePath] URLByAppendingPathComponent:DBFILE_ISERVICE_APPGROUP] path];
//    
//    //临时存储的数据库文件
//    NSString *PATH_IAPPDB_BACK_APPGROUP = [[[MShare sharePath] URLByAppendingPathComponent:DBFILE_ISERVICE_TMP_APPGROUP] path];
//    
//    //平台共享DB AppGroup路径 PATH_IPASSPORTDB_APPGROUP
//    NSString *PATH_IPASSPORTDB_APPGROUP = [MShare dbPath];
//    
//    /*
//     判断iApp的私有DB APPGROUP路径 是否存在
//     */
//    NSFileManager *FM = [NSFileManager defaultManager];
//    NSDictionary* ipassportDBAttr = [FM attributesOfItemAtPath:PATH_IPASSPORTDB_APPGROUP error:nil] ;
//    unsigned long long  ipassportDBSize = [ipassportDBAttr fileSize];
//    
//    
//    __block int timeout = 999; //倒计时时间
//    __block unsigned long long  iappBackDBSize = 0;
//    //dispatch_semaphore_t sem = dispatch_semaphore_create(0);
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
//    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
//    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),0.01*NSEC_PER_SEC, 0); //每秒执行
//    dispatch_source_set_event_handler(_timer, ^{
//        if(ipassportDBSize<=iappBackDBSize || timeout > 500){ //倒计时结束，关闭
//            dispatch_source_cancel(_timer);
//            dispatch_async(dispatch_get_main_queue(), ^{
////                [SVProgressHUD dismiss];
//            });
//            //dispatch_semaphore_signal(sem);
//            //exit(0);
//            
//        }else{
//            NSDictionary* iappBackDBAttr = [FM attributesOfItemAtPath:PATH_IAPPDB_BACK_APPGROUP error:nil] ;
//            iappBackDBSize = [iappBackDBAttr fileSize];
//            NSString *strTime = [NSString stringWithFormat:@"数据库升级%llu/%llu", iappBackDBSize,ipassportDBSize];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                NSLog(@"strTime:%@",strTime);
////                [SVProgressHUD showInfoWithStatus:strTime];
//            });
//            
//            
//            
//            timeout--;
//            
//        }
//    });
//    dispatch_resume(_timer);
//    
//    // dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
//    
//}
//iapp先copy到备份位置 再移动到正确位置 alarm错误信息
+ (BOOL) isExistPathAppGroupDB
{
    NSLog(@"--------isExistIAppPrivateDB start");
    //dispatch_semaphore_t sem = dispatch_semaphore_create(1);
    //dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
    
    
    //pathA
    NSString *PATHA_DB = [DBFileManager pathAppPrivateDB];
    
    //pathTMP
    NSString *PATHTMP_DB = [[[MShare sharePath] URLByAppendingPathComponent:DBFILE_ISERVICE_TMP_APPGROUP] path];
    
    //pathB
    NSString *PATHB_DB = [[[MShare sharePath] URLByAppendingPathComponent:DBFILE_ISERVICE_APPGROUP] path];

    
    /*
     判断iApp的私有DB APPGROUP路径 是否存在
     */
    NSFileManager *FM = [NSFileManager defaultManager];
    BOOL b_exist = [FM fileExistsAtPath:PATHB_DB];
    __block BOOL result = YES;
    if (b_exist) {
        //打开［iApp的私有DB AppGroup路径］数据库
        result = YES;
        
    } else {
        
//        [SVProgressHUD showInfoWithStatus:@"数据库开始升级请稍等"];
        
        dispatch_semaphore_t sem = dispatch_semaphore_create(0);
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            //AIAAlertViewShowAlertForPrompt(@"数据库升级中请稍作等待");
            //进入前先清理bak数据后copy
            [self removeFileWithPath:PATHTMP_DB];
            
            
            //复制 ［平台共享DB AppGroup路径］到 ［iApp的私有DB AppGroup路径］
            NSError *error = nil;
            //原文件大小
            //        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            //            [self progressFileCopy];
            //        });
            
            BOOL b_copy = [FM copyItemAtPath:PATHA_DB toPath:PATHTMP_DB error:&error];
            
            if (b_copy) {
                
                //copy 成功后mv
                NSError * mvError = nil;
                if([FM moveItemAtPath:PATHTMP_DB toPath:PATHB_DB error:&mvError]){
                    
                    //成功后清理数据后copy
                    [self removeFileWithPath:PATHTMP_DB];
                    result = YES;
                }else{
                    AIAAlertViewShowForError(mvError);
                    
                    result = NO;
                }
                
                
                
            } else {
                AIAAlertViewShowForError(error);
                
                result = NO;
            }
            dispatch_semaphore_signal(sem);
        });
        dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
        
    }
    
    if(result){
//        [SVProgressHUD showInfoWithStatus:@"数据库初始化完成"];
        AIAAlertViewShowForMessage(@"数据库初始化完成");
    }else{
//        [SVProgressHUD showInfoWithStatus:@"数据库初始化失败"];
        AIAAlertViewShowForMessage(@"数据库初始化失败");
    }
    //[SVProgressHUD dismissWithDelay:5];
    
    
    //dispatch_semaphore_signal(sem);
    NSLog(@"--------isExistIAppPrivateDB end");
    return result;
    
}

+ (NSString *) pathAppGroupDB
{
    NSString *PATH_APPDB_APPGROUP = [[[MShare sharePath] URLByAppendingPathComponent:DBFILE_ISERVICE_APPGROUP] path];
    return PATH_APPDB_APPGROUP;
}

+ (NSString *) pathAppPrivateDB
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString * databasePath = [documentDirectory stringByAppendingPathComponent:@"ClaimData.db"];
    return databasePath;
}

@end
