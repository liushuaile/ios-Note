//
//  ViewController.m
//  Note
//
//  Created by SL on 3/24/17.
//  Copyright © 2017 Sam. All rights reserved.
//

#import "ViewController.h"
#import "TVDataSourceAndDelegate.h"
#import "GCDTableViewController.h"
#import "WaterFallViewController.h"


static NSString * const cellIdentifier = @"cell";

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) TVDataSourceAndDelegate *tvDelegate;

@property (strong, nonatomic) NSArray *dataArray;

@end

@implementation ViewController

#pragma mark - Lifecyle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //隐藏/去掉 导航栏返回按钮中的文字,实现机制将字体上移出视图之外。
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];

    self.tableView.delegate = self.tvDelegate;
    self.tableView.dataSource = self.tvDelegate;

//    [self SSKeychainTest];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- Custom Accessors

- (NSArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSArray arrayWithObjects:@"GCD", @"CoreData", @"FileDownload", @"Copy", @"RunLoop", @"Masonry", @"RSA", @"WaterFall", nil];
    }
    return _dataArray;
}

- (TVDataSourceAndDelegate *)tvDelegate {
    if (_tvDelegate == nil) {
        
        __weak typeof(self) weakSelf = self;
        _tvDelegate = [[TVDataSourceAndDelegate alloc] initWithItems:self.dataArray cellIdentifier:cellIdentifier configureBlock:^(UITableViewCell *cell, NSString *item, NSIndexPath *indexPath, NSInteger style) {
            
            if (style == CellControlLoadData) {
                cell.textLabel.text = item;
            } else if (style == CellControlSelect) {
                /*
                 //storyboard 页面跳转交互
                 //根据 segue Identifier跳转界面
                 [self performSegueWithIdentifier:@"GotoTwo" sender:self];
                 
                 //以modal 方式跳转
                 [self presentModalViewController:nil animated:YES];
                 
                 //压进一个viewcontroller
                 [self.navigationController pushViewController:nil animated:YES];
                 
                 //弹出一个viewcontroller  相当与返回上一个界面
                 [self.navigationController popViewControllerAnimated:YES];
                 
                 // 以 modal跳转的返回方法
                 [self dismissModalViewControllerAnimated:YES];
                 */
                NSInteger row = indexPath.row;
                switch (row) {
                    case 0:
                        [weakSelf performSegueWithIdentifier:@"GotoGCD" sender:nil];
                        break;
                    case 1:
                        [weakSelf performSegueWithIdentifier:@"GotoCoreData" sender:nil];
                        break;
                    case 2:
                        [weakSelf performSegueWithIdentifier:@"GotoFileDownload" sender:nil];
                        break;
                    case 4:
                        [weakSelf performSegueWithIdentifier:@"GotoRunLoop" sender:nil];
                        break;
                    case 3:
                        [weakSelf performSegueWithIdentifier:@"GotoCopy" sender:nil];
                        break;
                    case 5:
                        [weakSelf performSegueWithIdentifier:@"GotoMasonry" sender:nil];
                        break;
                    case 6:
                        [weakSelf performSegueWithIdentifier:@"GotoRSA" sender:nil];
                        break;
                    case 7: {
                        WaterFallViewController *WFViewControler = [[WaterFallViewController alloc] init];
                        [self.navigationController pushViewController:WFViewControler animated:YES];
                    }
                        break;
                    default:
                        
                        break;
                }
            }
            
        } parentViewController:self];
    }
    return _tvDelegate;
}

#pragma mark- Methods

- (void)SSKeychainTest {
    
    NSString *userName = @"slliu";
    NSString *password = @"123123";
    NSString *bundleID = [NSBundle mainBundle].bundleIdentifier;
    [SSKeychain setPassword:userName forService:bundleID account:@"username"];
    [SSKeychain setPassword:password forService:bundleID account:@"password"];
    [SSKeychain deletePasswordForService:bundleID account:@"username"];
    NSString *passwords = [SSKeychain passwordForService:bundleID account:@"password"];
    NSLog(@"SSkeychain解密=====%@",passwords);
}

- (void)RetainCountTest {
    @autoreleasepool {
        id obj = [NSArray new];
        printf("retain count = %ld\n",CFGetRetainCount((__bridge CFTypeRef)(obj)));
    };
    id obj = [NSArray new];
    printf("retain count = %ld\n",CFGetRetainCount((__bridge CFTypeRef)(obj)));
    
    id obj1 = [[NSObject alloc]init];
    printf("retain count = %ld\n",CFGetRetainCount((__bridge CFTypeRef)(obj1)));
    
}

@end
