//
//  LSAlertController.m
//  Note
//
//  Created by SL on 28/03/2017.
//  Copyright © 2017 Sam. All rights reserved.
//

#import "LSAlertController.h"

@interface LSAlertController ()

@end

@implementation LSAlertController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (instancetype)alertControllerWithTitle:(nullable NSString *)title message:(nullable NSString *)message buttons:(nullable NSArray *)buttons handler:(void (^ __nullable)(UIAlertAction *action))handler {
    
    return nil;
}
+ (instancetype)actionSheetControllerWithTitle:(nullable NSString *)title message:(nullable NSString *)message buttons:(nullable NSArray *)buttons handler:(void (^ __nullable)(UIAlertAction *action))handler {

    return nil;
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
