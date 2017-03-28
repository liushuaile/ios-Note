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

static NSString * const cellIdentifier = @"cell";

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) TVDataSourceAndDelegate *tvDelegate;

@property (strong, nonatomic) NSArray *dataArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.tableView.delegate = self.tvDelegate;
    self.tableView.dataSource = self.tvDelegate;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSArray arrayWithObjects:@"GCD",@"CoreData", nil];
    }
    return _dataArray;
}

- (TVDataSourceAndDelegate *)tvDelegate {
    if (_tvDelegate == nil) {
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
                        [self performSegueWithIdentifier:@"GotoGCD" sender:self];
                        break;
                    case 1:
                        [self performSegueWithIdentifier:@"GotoCoreData" sender:self];
                        break;
                    default:
                        
                        break;
                }
            }
            
        } parentViewController:self];
    }
    return _tvDelegate;
}

@end
