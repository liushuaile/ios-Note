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
#import "BlockViewController.h"
#import "CGContextViewController.h"

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
        _dataArray = [NSArray arrayWithObjects:@"GCD", @"CoreData", @"FileDownload", @"Copy", @"RunLoop", @"Masonry", @"RSA", @"WaterFall", @"Block", NSLocalizedString(@"LStringCode00001", nil),@"金额精度处理", nil];
    }
    return _dataArray;
}

- (TVDataSourceAndDelegate *)tvDelegate {
    if (_tvDelegate == nil) {
//        __weak typeof(self) weakSelf = self;
        @weakify_self;
        _tvDelegate = [[TVDataSourceAndDelegate alloc] initWithItems:self.dataArray cellIdentifier:cellIdentifier configureBlock:^(UITableViewCell *cell, NSString *item, NSIndexPath *indexPath, NSInteger style) {
            @strongify_self;
            
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
                        [self performSegueWithIdentifier:@"GotoGCD" sender:nil];
                        break;
                    case 1:
                        [self performSegueWithIdentifier:@"GotoCoreData" sender:nil];
                        break;
                    case 2:
                        [self performSegueWithIdentifier:@"GotoFileDownload" sender:nil];
                        break;
                    case 4:
                        [self performSegueWithIdentifier:@"GotoRunLoop" sender:nil];
                        break;
                    case 3:
                        [self performSegueWithIdentifier:@"GotoCopy" sender:nil];
                        break;
                    case 5:
                        [self performSegueWithIdentifier:@"GotoMasonry" sender:nil];
                        break;
                    case 6:
                        [self performSegueWithIdentifier:@"GotoRSA" sender:nil];
                        break;
                    case 7: {
                        WaterFallViewController *WFViewControler = [[WaterFallViewController alloc] init];
                        [self.navigationController pushViewController:WFViewControler animated:YES];
                    }
                        break;
                    case 8: {
                        BlockViewController *vc = [[BlockViewController alloc] init];
                        vc.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                        break;
                    case 9: {
                        CGContextViewController *vc = [[CGContextViewController alloc] init];
                        vc.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                        break;
                    case 10: {
                        
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

#pragma mark - 金额精度处理
-(void)AmountTest {
    double d1 = 0.01;
    double d2 = 999999;
    double d3 = d1 * d2;
    NSLog(@"%f",d3);
    
    NSDecimalNumber* n1 = [NSDecimalNumber       decimalNumberWithString:[NSString    stringWithFormat:@"%f",d1]];
    
    NSDecimalNumber* n2 = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f",d2]];
    
    NSDecimalNumber* n3 = [n1 decimalNumberByMultiplyingBy:n2];
    
    NSLog(@"%@",n3);
    
    
}

@end
