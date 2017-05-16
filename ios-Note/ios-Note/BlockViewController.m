//
//  BlockViewController.m
//  ios-Note
//
//  Created by SL on 13/04/2017.
//  Copyright © 2017 Sam. All rights reserved.
//

#import "BlockViewController.h"

typedef void (^ blk_t)(id, id);
typedef void (^blk_t1)(id);


@interface BlockViewController ()
{
    blk_t1 blk_;
}
@end

@implementation BlockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
//    [self blockRetainCycle];
    
//    @weakify_self;
    __weak typeof(self) weakSelf = self;
    [self setBlock:^(id obj, id obj2) {
//        @strongify_self;
        
        [weakSelf setBlock:^(id obj3, id obj4) {
            
            [weakSelf setBlock:^(id obj3, id obj4) {
                
                [weakSelf setBlock:^(id obj3, id obj4) {
                    
                    [weakSelf setBlock:^(id obj3, id obj4) {
                        
                        
                    }];
                }];
            }];
        }];
    }];

}

/*
 记述全局变量的地方有Block语法，或在函数内不使用截获的自动变量时，生成的Block为globalBlock类对象。
 
 除此之外的Block语法上生成的Block为stackBlock类对象。
 */
void (^blk_g)() = ^{NSLog(@"blk_g");};
- (void)blockGlobal {
    
    /*
     1、记述全局变量的地方有Block语法,生成的Block为globalBlock类对象
     <__NSGlobalBlock__: 0x1008dd360>
     */
    NSLog(@"%p",blk_g);
    
    typedef int (^blk_t2) (int);
    for (int rate = 0; rate < 2; rate++) {
        blk_t2 blk = ^(int count){
//            NSLog(@"%d",rate);
            return  count;
        };
        /*
         2、函数内不使用截获的自动变量时，生成的Block为globalBlock类对象
         <__NSGlobalBlock__: 0x10284a3a0>
         */
        NSLog(@"%p",blk);
    }
}

int global_var = 1;
static int static_global_var = 2;
/*
    block 截获静态变量、静态全局变量、全局变量可执行赋值
 */
- (void)blockHijackGlobalAndStaticVar {
    
    static int static_val = 3;
    int var = 4;
    
    NSLog(@"1111 %p",&global_var);
    NSLog(@"1111 %p",&var);

    void (^blk)() = ^{
        global_var *= 1;
        static_global_var *= 2;
        static_val *= 3;
//        var *= 4;
        NSLog(@"2222 %p",&global_var);
        NSLog(@"2222 %p",&var);

    };
    
    blk();
}

- (void)blockRetainCycle {
#warning MARK: Block Retain Cycle
    
    NSLog(@"1111 %p",&self);
    NSLog(@"1111 %p",self);
    
    //block循环引用，- (void)dealloc；不被执行。\
    blk_为self全局持有
    blk_ = ^(id obj){
        NSLog(@"2222 %p",&self);
        NSLog(@"2222 %p",self);
    };
    blk_(nil);
    
    if (/* DISABLES CODE */ (0)) {
        //1、__weak解决循环引用
        __weak id tmp = self;
        blk_ = ^(id obj){
            NSLog(@"2222 %p",&tmp);
            NSLog(@"2222 %p",tmp);
        };
    }
    
    
    if (/* DISABLES CODE */ (0)) {
        //2、__block解决循环引用\
        为避免循环引用必须执行block
        __block id tmp2 = self;
        blk_ = ^(id obj){
            NSLog(@"2222 %p",&tmp2);
            NSLog(@"2222 %p",tmp2);
            tmp2 = nil;
        };
        blk_(nil);
    }
    
    //为何此处不会引起循环引用
    void (^blk)() = ^{
        NSLog(@"3333 %p",&self);
        NSLog(@"3333 %p",self);
    };
    blk();

}

- (void)blockHijackVlue {
#warning MARK: Block Hijack Value

    //mArray 指针变量\
    block内外，对象指针保持不变，指针地址新生成一份，两个指针地址指向同一对象指针\
    类似于一个房间，一个房间号，两把钥匙
    NSMutableArray *mArray = [NSMutableArray new];
    void (^blk)(NSString *) = ^(NSString *string){
        [mArray addObject:string];
        NSLog(@"2222 mArray %@",mArray);
        NSLog(@"2222 mArray 指针地址 %p",mArray);
        NSLog(@"2222 mArray 指针地址的指向 %p",&mArray);
        
        NSLog(@"self: %p",&self);
    };
    [mArray addObject:@"2"];
    NSLog(@"1111 %@",mArray);
    NSLog(@"1111 %p",mArray);
    NSLog(@"1111 %p",&mArray);
    
    //此时是否有内存泄漏？？
    NSLog(@"self: %p",self);

    blk(@"1");
    
    
    //值变量 瞬间持有\
    block内外，对象指针新生成，指针地址新生成，两个指针地址指向同一对象指针\
    类似于一个房间，两个房间号，两把钥匙
    //    int var = 10;
    NSString *string = @"1";
    void (^blk2)() = ^{
        NSLog(@"2222 %@",string);
        NSLog(@"2222 %p",string);
        NSLog(@"2222 %p",&string);
    };
    //    var = 2;
    string = @"12";
    NSLog(@"1111 %@",string);
    NSLog(@"1111 %p",string);
    NSLog(@"1111 %p",&string);
    blk2();

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
