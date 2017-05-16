//
//  Example1Controller.m
//  DemoMasonry
//
//  Created by Ralph Li on 7/1/15.
//  Copyright (c) 2015 LJC. All rights reserved.
//

#import "Example1Controller.h"
#import <Masonry/Masonry.h>
#import <MMPlaceHolder/MMPlaceHolder.h>

@interface Example1Controller ()

@end

@implementation Example1Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(10, 100, 200, 30)];
    lab.text = @"text";
    lab.font = [UIFont systemFontOfSize:100];
    [self.view addSubview:lab];
    
    UIView *sv = [UIView new];
    [sv showPlaceHolder];
    sv.backgroundColor = [UIColor blackColor];
    [self.view addSubview:sv];
    [sv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(300, 300));
    }];
    
    /*
     x按照a值进行了比例缩放，y按照d的值进行比列缩放，最重要的是缩放的过程中View的point（中心点）是不会改变的
     x会跟着c的值进行拉伸(View的宽度是跟着改变)，y会跟着b的值进行拉伸（View的高度跟着改变），要注意到的是c和b的值改变不会影响到View的point（center中心点）的改变
     x会跟着t.x进行x做表平移，y会跟着t.y进行平移。这里的point（center）是跟着变换的。
     CGAffineTransform CGAffineTransformMake(CGFloat a, CGFloat b,
     CGFloat c, CGFloat d, CGFloat tx, CGFloat ty)
     */
    //混合变换 仿射变换
//    CGAffineTransform identity = CGAffineTransformIdentity;
//    identity = CGAffineTransformScale(identity, .5, .5);//执行缩放操作
//    identity = CGAffineTransformRotate(identity, M_PI_4);//执行旋转操作
//    self.view.transform = identity;
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
