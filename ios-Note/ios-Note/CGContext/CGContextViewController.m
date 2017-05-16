//
//  CGContextViewController.m
//  ios-Note
//
//  Created by SL on 21/04/2017.
//  Copyright © 2017 Sam. All rights reserved.
//

#import "CGContextViewController.h"
#import "KView.h"

@interface CGContextViewController ()
@property (nonatomic, strong) KView    *kView;
@property (nonatomic, strong) NSTimer  *timer;

@property (strong, nonatomic) UISegmentedControl *segControl;
@property (strong, nonatomic) UIScrollView *SCScrollView;

@end

@implementation CGContextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self run];
    [self.SCScrollView addSubview:self.segControl];
    [self.view addSubview:self.SCScrollView];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIScrollView *)SCScrollView {
    if (!_SCScrollView) {
        _SCScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.bounds), 40)];
        _SCScrollView.contentSize = CGSizeMake(1024, 40);
//        _SCScrollView.contentOffset = CGPointMake(0, 0);
//        _SCScrollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    return _SCScrollView;
}


- (UISegmentedControl *)segControl {
    if (!_segControl) {
        _segControl = [[UISegmentedControl alloc] initWithItems:@[@"1",@"2",@"3",@"4",@"5",]];
        [_segControl addTarget:self action:@selector(click:) forControlEvents:UIControlEventValueChanged];
        _segControl.frame = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 40);
    }
    return _segControl;
}

-(void)click:(UISegmentedControl *)seg {
    // 获取当前选中的按钮编号
    NSInteger index = seg.selectedSegmentIndex;
    // 根据获取到的index,修改背景颜色
    switch (index + 1)
    {
        case 1:
            self.kView.type = @1;
            break;
        case 2:
            self.kView.type = @2;
            break;
        case 3:
            self.kView.type = @3;
            break;
        case 4:
            self.kView.type = @4;
            break;
        case 5:
            self.kView.type = @5;
            break;
        default:  break;
    }
}

#define kScreenWidth CGRectGetWidth([UIScreen mainScreen].bounds)
#define kScreenHeight CGRectGetHeight([UIScreen mainScreen].bounds)
- (KView *)kView {
    if (!_kView) {
        _kView                   = [[KView alloc] initWithFrame:CGRectMake(0, 104, kScreenWidth, kScreenHeight-104)];
        //        _kView.center            = self.view.center;
        _kView.layer.borderColor = [[UIColor blackColor] colorWithAlphaComponent:0.5].CGColor;
        _kView.layer.borderWidth = 0.5f;
        //        _kView.contentMode = UIViewContentModeRedraw;
    }
    return _kView;
}

- (void)run {
    
    [self.view addSubview:self.kView];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(event) userInfo:nil repeats:YES];
}

- (void)event {
    
    [self.kView setNeedsDisplay];
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
