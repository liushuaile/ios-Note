//
//  NSURLSessionBlockDownloadFileViewController.m
//  Note
//
//  Created by SL on 29/03/2017.
//  Copyright © 2017 Sam. All rights reserved.
//

#import "NSURLSessionBlockDownloadFileViewController.h"

@interface NSURLSessionBlockDownloadFileViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation NSURLSessionBlockDownloadFileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *newFilePath = [documentsPath stringByAppendingPathComponent:@"image.jpg"];
    self.imageView.image = [UIImage imageWithContentsOfFile:newFilePath];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 * 点击按钮 -- 使用NSURLSession的block方法下载文件
 */
- (IBAction)downloadBtnClicked:(id)sender {
    // 创建下载路径
    //https://b-ssl.duitang.com/uploads/item/201407/02/20140702104335_HKXBM.jpeg
    NSURL *url = [NSURL URLWithString:@"https://b-ssl.duitang.com/uploads/item/201407/02/20140702104335_HKXBM.jpeg"];
    
    // 创建NSURLSession对象
    NSURLSession *session = [NSURLSession sharedSession];
    
    // 创建下载任务,其中location为下载的临时文件路径
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithURL:url completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        
        // 文件将要移动到的指定目录
        NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        
        // 新文件路径
        NSString *newFilePath = [documentsPath stringByAppendingPathComponent:@"image.jpg"];
        
        NSLog(@"File downloaded to: %@",newFilePath);
        // 移动文件到新路径
        [[NSFileManager defaultManager] moveItemAtPath:location.path toPath:newFilePath error:nil];
        // 回到主线程，刷新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.imageView.image = [UIImage imageWithContentsOfFile:newFilePath];
        });
        
    }];
    
    // 开始下载任务
    [downloadTask resume];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
