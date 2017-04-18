//
//  BlockViewController.m
//  ios-Note
//
//  Created by SL on 13/04/2017.
//  Copyright © 2017 Sam. All rights reserved.
//

#import "BlockViewController.h"

typedef void (^ blk_t)(id, id);


@interface BlockViewController ()

@end

@implementation BlockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    int (^blk_t2)(int) = ^(int var){return 0;};
    
    //参数中使用block类型变量
    void func(void(^blk)(void));
//    func(^{
//        
//    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"didReceiveMemoryWarning");
}

- (void)dealloc {
    NSLog(@"BlockViewController dealloc %p",self);
}

#pragma mark- Methods

- (id)getNum {
    return ^(){return 0;};
}

- (void)setBlock:(blk_t)block {
    
    NSLog(@"block begin");
    
    __weak typeof(self) weakSelf = self;
    block(@"你好", weakSelf);
    
    NSLog(@"block end");
}


- (void)setBlock2:(blk_t)block {
    NSLog(@"block2 begin");
    
    block(@"你好", nil);
    
    NSLog(@"block2 end");

}

- (void)run {
    
    [self setBlock:^(NSString *string, BlockViewController *obj_) {
        NSLog(@"block %@",string);
        
        [obj_ setBlock2:^(NSString *obj1, id obj2) {
            NSLog(@"block2 %@",obj1);
        }];
        
    }];;
    
    
    //1
    __block NSString *string = @"nihao";
    void (^ blk001)(int) = ^(int num) {
        string = @"ni hao a";
        NSLog(@"blk001 %@", string);
    };
    
    string = @"shijie nihao";
    NSLog(@"%@",string);
    
    blk001(0);
    
    void (^ blk002)(int);
    
    blk002 = blk001;
    
    
    //2
    id array = [NSMutableArray array];
    void (^ blk004)() = ^{
        id obj = [NSObject new];
        [array addObject:obj];
        //        array = [NSMutableArray new];
    };

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
