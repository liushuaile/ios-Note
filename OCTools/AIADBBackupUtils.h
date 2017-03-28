//
//  AIADBBackupUtils.h
//  iApp
//
//  Created by Sam Liu on 16/5/24.
//
//

#import <Foundation/Foundation.h>

@interface AIADBBackupUtils : NSObject
{
    NSFileManager *FM;
    NSURL *DB_DIR;
    NSURL *BACKUPDB_DIR;
    
    NSString *DB_PATH;
}
//DB备份 签名前
- (BOOL)DBBackup;
//DB备份恢复
- (BOOL)DBBackupRecover;
//DB备份 签名成功后
- (BOOL)DBBackupFinish;

@end
