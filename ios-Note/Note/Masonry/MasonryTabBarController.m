//
//  MasonryTabBarController.m
//  Note
//
//  Created by SL on 09/04/2017.
//  Copyright © 2017 Sam. All rights reserved.
//

#import "MasonryTabBarController.h"
#import "Example1Controller.h"
#import "Example2Controller.h"
#import "Example3Controller.h"
#import "Example4Controller.h"
#import "Example5Controller.h"

@interface MasonryTabBarController ()

@end

@implementation MasonryTabBarController
//
//- (instancetype) init {
//    
//    if (self = [super init]) {
//
//    }
//    
//
//
//    return self;
//}

- (void)clickBack {
    
//    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self popoverPresentationController];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

    UIViewController *vc1 = [Example1Controller new];
    UIViewController *vc2 = [Example2Controller new];
    UIViewController *vc3 = [Example3Controller new];
    UIViewController *vc4 = [Example4Controller new];
    UIViewController *vc5 = [Example5Controller new];
    
    vc1.tabBarItem.title = @"Exp 1";
    vc2.tabBarItem.title = @"Exp 2";
    vc3.tabBarItem.title = @"Exp 3";
    vc4.tabBarItem.title = @"Exp 4";
    vc5.tabBarItem.title = @"Exp 5";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.viewControllers = @[vc1,vc2,vc3,vc4,vc5];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
