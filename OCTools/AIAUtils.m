//
//  AIAUtils.m
//  iApp
//
//  Created by Sam Liu on 16/4/25.
//
//

#import "AIAUtils.h"
#import <CommonCrypto/CommonDigest.h>
#import "SVProgressHUD.h"

NSString * const AIAIDRegex = @"^\\d{17}(\\d|X)$";
NSString * const AIAPhoneRegex = @"(^13|14|15|17|18)\\d{9}$";
//2-3位的整数
NSString * const AIAHeightRegex = @"^\\d\\d\\d?$";
//1-3位的整数
NSString * const AIAWeightRegex = @"^\\d\\d?\\d?$";

NSString * const kCBSDKIfInPayment = @"CBSDKIfInPaymentKey";

BOOL isNumber (char ch)
{
    if (!(ch >= '0' && ch <= '9')) {
        return FALSE;
    }
    return TRUE;
}

@implementation AIAUtils

#pragma mark- 金额数字处理

+(double) PV:(double)rate:(double)nper:(double)pmt{
    return pmt / rate * (1 - pow(1 + rate, -nper));
}


+(double)PMT:(double)rateForPeriod :(NSInteger)numberOfPayments :(double)loanAmount :(double)futureValue :(NSInteger)type
{
    double q;
    
    q = pow(1 + rateForPeriod, numberOfPayments);
    
    return (rateForPeriod * (futureValue + (q * loanAmount))) / ((-1 + q) * (1 + rateForPeriod * (type)));
}


+(double)Roundup:(double)num :(int) digit{
    double rate;
    if(digit == 0){
        rate = 1;
    }else{
        rate =  pow(10.0 , digit) ;
    }
    
    return ((long long)(num * rate + 0.5)) / rate;
}


+ (BOOL) isValidNumber:(NSString*)value{
    const char *cvalue = [value UTF8String];
    int len = (int)strlen(cvalue);
    for (int i = 0; i < len; i++) {
        if(!isNumber(cvalue[i])){
            return FALSE;
        }
    }
    return TRUE;
}

+ (BOOL) isValidString:(NSString*)value byRegex:(NSString *)regex {
    NSPredicate *_text = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [_text evaluateWithObject:value];
}

+ (BOOL) isValidPhone:(NSString*)value {
    
    NSPredicate *_text = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", AIAPhoneRegex];
    return [_text evaluateWithObject:value];

}

+ (BOOL) isValidId:(NSString *)value {
    NSPredicate *_text = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", AIAIDRegex];
    return [_text evaluateWithObject:value];
}

+ (BOOL)validateEmail:(NSString *)value
{
    NSArray *array = [value componentsSeparatedByString:@"."];
    if ([array count] >= 4) {
        return FALSE;
    }
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:value];
}

+ (NSString *) md5:(NSString *)str{
    
    const char *cStr = [str UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest);
    
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", digest[i]];
    }
    
    return [result copy];
}

+ (NSString *) fileMD5:(NSString*)path
{
    NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:path];
    if( handle== nil ) {
        return @"ERROR GETTING FILE MD5"; // file didnt exist
    }
    
    CC_MD5_CTX md5;
    CC_MD5_Init(&md5);
    
    BOOL done = NO;
    while(!done)
    {
        NSData* fileData = [handle readDataOfLength: UINT_MAX ];
        CC_MD5_Update(&md5, [fileData bytes], (CC_LONG)[fileData length]);
        if( [fileData length] == 0 ) done = YES;
    }
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(digest, &md5);
    
    NSMutableString * result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", digest[i]];
    }
    return result;
}

+(NSString *) imageMD5:(UIImage *)image
{
    CC_MD5_CTX md5;
    CC_MD5_Init(&md5);
    
    NSData *imageData = [NSData dataWithData:UIImageJPEGRepresentation(image, 0.1)];
    CC_MD5_Update(&md5, [imageData bytes], (CC_LONG)[imageData length]);
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(digest, &md5);
    
    NSMutableString * result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", digest[i]];
    }
    return result;
}

//2017 预售版
#define DBFILE_IAPP_APPGROUP @"iApp.db"
#define DBFILE_IAPP_BACK_APPGROUP @"iApp.db_back"

+(void)removeLocalIAppDBAndRestart{
    //只有4.2.9 4.2.9.1 的时候才删数据库重新启动
    NSString *appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    if (!([appVersion isEqualToString:@"4.2.9"] || [appVersion isEqualToString:@"4.2.9.1"])) {
        return;
    }
    [self removeLocalIAppDB];
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
            [SVProgressHUD showInfoWithStatus:strTime];
            
            timeout--;
            
        }
    });
    dispatch_resume(_timer);
    
    dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);

    
}
+(void)removeLocalIAppDB{
    //iApp的私有DB AppGroup路径 PATH_IAPPDB_APPGROUP
    NSString *PATH_IAPPDB_APPGROUP = [[[MShare sharePath] URLByAppendingPathComponent:DBFILE_IAPP_APPGROUP] path];

    

    [self removeFileWithPath:PATH_IAPPDB_APPGROUP];
}

+(void)removeFileWithPath:(NSString*)path{
    DDLogInfo(@"%s_line:%d_removeFileWithPath:%@",__PRETTY_FUNCTION__,__LINE__,path);
    
    if (!path || [path isEqualToString:@""]) {
        return;
    }
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:path]) {
        NSError * removeError;
        [fm removeItemAtPath:path error:&removeError];
        if (removeError) {
            AIAAlertViewShowAlertForRequestError(removeError);
            DDLogInfo(@"%s_line:%d_removeFileWithPath:error %@",__PRETTY_FUNCTION__,__LINE__,removeError);
        
        }
    }
    return;
}

+(void)progressFileCopy{
    //iApp的私有DB AppGroup路径 PATH_IAPPDB_APPGROUP
    NSString *PATH_IAPPDB_APPGROUP = [[[MShare sharePath] URLByAppendingPathComponent:DBFILE_IAPP_APPGROUP] path];
    
    //临时存储的数据库文件
    NSString *PATH_IAPPDB_BACK_APPGROUP = [[[MShare sharePath] URLByAppendingPathComponent:DBFILE_IAPP_BACK_APPGROUP] path];
    
    //平台共享DB AppGroup路径 PATH_IPASSPORTDB_APPGROUP
    NSString *PATH_IPASSPORTDB_APPGROUP = [MShare dbPath];
    
    /*
     判断iApp的私有DB APPGROUP路径 是否存在
     */
    NSFileManager *FM = [NSFileManager defaultManager];
    NSDictionary* ipassportDBAttr = [FM attributesOfItemAtPath:PATH_IPASSPORTDB_APPGROUP error:nil] ;
    unsigned long long  ipassportDBSize = [ipassportDBAttr fileSize];

    
    __block int timeout = 999; //倒计时时间
    __block unsigned long long  iappBackDBSize = 0;
    //dispatch_semaphore_t sem = dispatch_semaphore_create(0);
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),0.01*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(ipassportDBSize<=iappBackDBSize || timeout > 500){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
            });
            //dispatch_semaphore_signal(sem);
            //exit(0);
            
        }else{
            NSDictionary* iappBackDBAttr = [FM attributesOfItemAtPath:PATH_IAPPDB_BACK_APPGROUP error:nil] ;
            iappBackDBSize = [iappBackDBAttr fileSize];
            NSString *strTime = [NSString stringWithFormat:@"数据库升级%llu/%llu", iappBackDBSize,ipassportDBSize];
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"strTime:%@",strTime);
                [SVProgressHUD showInfoWithStatus:strTime];
            });


            
            timeout--;
            
        }
    });
    dispatch_resume(_timer);
    
   // dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);

}
//iapp先copy到备份位置 再移动到正确位置 alarm错误信息
+ (BOOL) isExistIAppPrivateDB
{
    NSLog(@"--------isExistIAppPrivateDB start");
    //dispatch_semaphore_t sem = dispatch_semaphore_create(1);
    //dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
    
    
    //iApp的私有DB AppGroup路径 PATH_IAPPDB_APPGROUP
    NSString *PATH_IAPPDB_APPGROUP = [[[MShare sharePath] URLByAppendingPathComponent:DBFILE_IAPP_APPGROUP] path];
    
    //临时存储的数据库文件
    NSString *PATH_IAPPDB_BACK_APPGROUP = [[[MShare sharePath] URLByAppendingPathComponent:DBFILE_IAPP_BACK_APPGROUP] path];
    
    //平台共享DB AppGroup路径 PATH_IPASSPORTDB_APPGROUP
    NSString *PATH_IPASSPORTDB_APPGROUP = [MShare dbPath];
    
    /*
     判断iApp的私有DB APPGROUP路径 是否存在
     */
    NSFileManager *FM = [NSFileManager defaultManager];
    BOOL b_exist = [FM fileExistsAtPath:PATH_IAPPDB_APPGROUP];
    __block BOOL result = YES;
    if (b_exist) {
        //打开［iApp的私有DB AppGroup路径］数据库
        result = YES;
        
    } else {
    
            [SVProgressHUD showInfoWithStatus:@"数据库开始升级请稍等"];

        dispatch_semaphore_t sem = dispatch_semaphore_create(0);
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            //AIAAlertViewShowAlertForPrompt(@"数据库升级中请稍作等待");
            //进入前先清理bak数据后copy
            [self removeFileWithPath:PATH_IAPPDB_BACK_APPGROUP];
            
            
            //复制 ［平台共享DB AppGroup路径］到 ［iApp的私有DB AppGroup路径］
            NSError *error = nil;
            //原文件大小
            //        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            //            [self progressFileCopy];
            //        });
            
            BOOL b_copy = [FM copyItemAtPath:PATH_IPASSPORTDB_APPGROUP toPath:PATH_IAPPDB_BACK_APPGROUP error:&error];
            
            if (b_copy) {
                DDLogInfo(@"%s_line:%d_copy 成功%@ \n to: %@",__PRETTY_FUNCTION__,__LINE__,PATH_IPASSPORTDB_APPGROUP,PATH_IAPPDB_BACK_APPGROUP);
                
                //copy 成功后mv
                NSError * mvError = nil;
                if([FM moveItemAtPath:PATH_IAPPDB_BACK_APPGROUP toPath:PATH_IAPPDB_APPGROUP error:&mvError]){
                    
                    //成功后清理数据后copy
                    [self removeFileWithPath:PATH_IAPPDB_BACK_APPGROUP];
                    //打开［iApp的私有DB AppGroup路径］数据库
                    result = YES;
                }else{
                    AIAAlertViewShowAlertForRequestError(mvError);
                    DDLogInfo(@"复制 ［平台共享DB AppGroup路径］到 ［iApp的私有DB AppGroup路径］error failed:%@",error.userInfo);
                    
                    result = NO;
                }
                
                
                
            } else {
                AIAAlertViewShowAlertForRequestError(error);
                DDLogInfo(@"复制 ［平台共享DB AppGroup路径］到 ［iApp的私有DB AppGroup路径］ error failed:%@",error.userInfo);
                
                result = NO;
            }
            dispatch_semaphore_signal(sem);
        });
        dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
        
    }

        if(result){
            [SVProgressHUD showInfoWithStatus:@"数据库初始化完成"];
        }else{
            [SVProgressHUD showInfoWithStatus:@"数据库初始化失败"];
        }
        //[SVProgressHUD dismissWithDelay:5];

    
    //dispatch_semaphore_signal(sem);
    NSLog(@"--------isExistIAppPrivateDB end");
    return result;
    
}

+ (NSString *)bundleIdentifier
{
    static NSString *bundleId;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bundleId = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"];
    });
    return bundleId;
}

+ (NSString *) PathIAppPrivateDB
{
    NSString *PATH_IAPPDB_APPGROUP = [[[MShare sharePath] URLByAppendingPathComponent:DBFILE_IAPP_APPGROUP] path];
    return PATH_IAPPDB_APPGROUP;
}

+ (void)value:(id)value key:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setValue:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (id)forKey:(NSString *)key
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:key];
}
+ (void)deleteKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
}

+ (NSString *)msgOfPayBack
{
    return @"友邦保险有限公司在华各分支公司（本公司）2016年第4季度的综合偿付能力充足率为451.01%，2016年第3季度的风险综合评级为A类，本公司的偿付能力充足率达到监管要求，公司治理、资金运用、市场行为等方面符合监管要求。";
}
@end
