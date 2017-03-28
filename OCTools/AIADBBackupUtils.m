//
//  AIADBBackupUtils.m
//  iApp
//
//  Created by Sam Liu on 16/5/24.
//
//

#import "AIADBBackupUtils.h"

@implementation AIADBBackupUtils

//SAM_LIU,2016-5-24,签名前进行DB文件的备份工作，当DB执行失败以后，复原执行
#define SAPPGROUPID @"group.com.aia"
#define DBFILENAME @"aiatouch.db"
#define OLDDBFILENAME @"aiatouchOld.db"
#define BACKUPDB_FOLDERNAME @"BACKUPDB"
#define UDKBACKUPDB @"BACKUPDB"
#define KBACKUPDB_FILENAME @"BACKUPDB_FILENAME"
#define KBACKUPDB_STATUS @"BACKUPDB_STATUS"

- (id)init {
    
    if (self = [super init]) {
        
        FM = [NSFileManager defaultManager];
        /*
        DB目录
        备份DB目录
         */
        DB_DIR = [FM containerURLForSecurityApplicationGroupIdentifier:SAPPGROUPID];
        BACKUPDB_DIR = [DB_DIR URLByAppendingPathComponent:BACKUPDB_FOLDERNAME];
        
        /*
         DB文件路径
         */
        DB_PATH = [[DB_DIR URLByAppendingPathComponent:DBFILENAME] path];

        /*
         创建备份DB要存储的目录
         */
        [FM createDirectoryAtPath:[BACKUPDB_DIR path] withIntermediateDirectories:NO attributes:nil error:nil];
    }
    return self;
}

- (BOOL)DBBackup
{
    //SAM_LIU,2016-5-23,签名后保存DB做备份处理
    NSString* (^GETBACKUPDBNAME)(void) = ^(void)
    {
        NSTimeInterval newDBName_double = [[NSDate date] timeIntervalSince1970];
        NSString *newDBName = [NSString stringWithFormat:@"%.f",newDBName_double];
        return newDBName;
    };
    /*
     将要备份的DB文件名
     */
    NSString *BACKUPDB_FILENAME = GETBACKUPDBNAME();
    /*
     备份文件路径
     */
    NSString *BACKUPDB_PATH = [[BACKUPDB_DIR URLByAppendingPathComponent:BACKUPDB_FILENAME] path];
    /*
     备份DB临时存储目录
     */
    NSString *TMP_BACKUPDB_PATH = [NSTemporaryDirectory() stringByAppendingPathComponent:BACKUPDB_FILENAME];
    /*
     判断原DB文件是否存在
     */
    BOOL b_exist = [FM fileExistsAtPath:DB_PATH];
    if (b_exist) {
        NSError *error = nil;
        /*
         COPY原DB文件到TMP目录下
         */
        BOOL b_copy = [FM copyItemAtPath:DB_PATH toPath:TMP_BACKUPDB_PATH error:&error];
        if (b_copy) {
            BOOL b_move = [FM moveItemAtPath:TMP_BACKUPDB_PATH toPath:BACKUPDB_PATH error:&error];
            if (b_move) {
                
                NSUserDefaults *UD = [NSUserDefaults standardUserDefaults];
                /*
                 BACKUPDB_STATUS： 0 1
                 0: DB保存操作执行前备份状态
                 1: DB保存操作执行后备份状态
                 
                 BACKUPDB_FILENAME：最后一次DB备份文件名
                 */
                NSNumber *backupStatus = [NSNumber numberWithInt:0];
                NSDictionary *BACKUPDB_UDDICT = [NSDictionary dictionaryWithObjectsAndKeys:
                                                 BACKUPDB_FILENAME,KBACKUPDB_FILENAME,
                                                 backupStatus,KBACKUPDB_STATUS, nil];
                [UD setValue:BACKUPDB_UDDICT forKey:UDKBACKUPDB];
                [UD synchronize];
                
                DLog(@"DBBackup finished");
            } else {
                DLog(@"moveItemAtPath:TMP_BACKUPDB_PATH toPath:BACKUPDB_PATH error:&error");
                return NO;
            }
        }
        else {
            DLog(@"copyItemAtPath:DB_PATH toPath:TMP_BACKUPDB_PATH error:&error");
            return NO;
        }
    }
    
    return YES;
}
- (BOOL)DBBackupRecover
{
    NSUserDefaults *UD = [NSUserDefaults standardUserDefaults];
    NSDictionary *BACKUPDB_UDDICT = [UD valueForKey:UDKBACKUPDB];
    if (BACKUPDB_UDDICT)
    {
        NSNumber *backupStatus = [BACKUPDB_UDDICT valueForKey:KBACKUPDB_STATUS];
        NSString *backupFileName = [BACKUPDB_UDDICT valueForKey:KBACKUPDB_FILENAME];
        if (backupStatus && backupFileName)
        {
            int status = [backupStatus intValue];
            if (status == 0)
            {
                BOOL b = [self DBRecover:[backupFileName copy]];
                [UD removeObjectForKey:UDKBACKUPDB];
                return b;
            }
        }
    } else {
        [UD removeObjectForKey:UDKBACKUPDB];
    }
    [UD synchronize];
    return YES;
}

- (NSString *)getBackupDBPath:(NSString *)backupFileName
{
    NSString *restoreDbPath = [[BACKUPDB_DIR URLByAppendingPathComponent:backupFileName] path];
    return restoreDbPath;
}

- (BOOL)DBRecover:(NSString *)backupFileName
{
    NSString *OLDDB_PATH = [[DB_DIR URLByAppendingPathComponent:OLDDBFILENAME] path];
    
    NSString *BACKUPDB_PATH = [self getBackupDBPath:backupFileName];
    //删除旧有的DB备份文件
    BOOL b_exist = [FM fileExistsAtPath:OLDDB_PATH];
    if (b_exist) {
        [FM removeItemAtPath:OLDDB_PATH error:nil];
    }
    //备份当前数据库文件
    NSError *error = nil;
    BOOL b_oldBackuoDB_move = [FM moveItemAtPath:DB_PATH toPath:OLDDB_PATH error:&error];
    if (b_oldBackuoDB_move) {
        //恢复DB之前备份文件
        BOOL b_restoreDb_move = [FM moveItemAtPath:BACKUPDB_PATH toPath:DB_PATH error:&error];
        //TRUE 恢复成功\
        FALSE 复原之前
        if (b_restoreDb_move) {
            //DB恢复以后，清理NSUserDefaults
            NSUserDefaults *UD = [NSUserDefaults standardUserDefaults];
            [UD removeObjectForKey:UDKBACKUPDB];
            [UD synchronize];
            
            DLog(@"DBBackupRestore finished");
            return YES;
        } else {
            if ([FM fileExistsAtPath:DB_PATH]) {
                [FM removeItemAtPath:DB_PATH error:nil];
            }
            [FM moveItemAtPath:OLDDB_PATH toPath:DB_PATH error:&error];
            
            //DB恢复失败，恢复，清理NSUserDefaults
            NSUserDefaults *UD = [NSUserDefaults standardUserDefaults];
            [UD removeObjectForKey:UDKBACKUPDB];
            [UD synchronize];
            
            DLog(@"moveItemAtPath:restoreDbPath toPath:DB_PATH error:&restoreDbError");
            return NO;
        }
    } else {
        DLog(@"moveItemAtPath:DB_PATH toPath:OLDDB_PATH error:&error");
        return NO;
    }
    return YES;
}
/*
 签名成功后，清理NSUserDefaults和DB备份文件
 */
- (BOOL)DBBackupFinish
{
    NSUserDefaults *UD = [NSUserDefaults standardUserDefaults];
    NSDictionary *BACKUPDB_UDDICT = [UD valueForKey:UDKBACKUPDB];
    if (BACKUPDB_UDDICT)
    {
        NSNumber *backupStatus = [BACKUPDB_UDDICT valueForKey:KBACKUPDB_STATUS];
        NSString *backupFileName = [BACKUPDB_UDDICT valueForKey:KBACKUPDB_FILENAME];
        if (backupStatus && backupFileName)
        {
            int status = [backupStatus intValue];
            if (status == 0)
            {
                //1、清理NSUserDefaults
                [UD removeObjectForKey:UDKBACKUPDB];
                
                //2、清理DB备份文件
                NSString *BACKUPDB_PATH = [self getBackupDBPath:backupFileName];
                [FM removeItemAtPath:BACKUPDB_PATH error:nil];
                
                DLog(@"%s: finished",__func__);
                return YES;
            }
        }
    } else {
        [UD removeObjectForKey:UDKBACKUPDB];
    }
    [UD synchronize];
    
    return YES;
}
@end
