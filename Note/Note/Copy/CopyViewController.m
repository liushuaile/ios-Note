//
//  CopyViewController.m
//  Note
//
//  Created by SL on 04/04/2017.
//  Copyright © 2017 Sam. All rights reserved.
//

#import "CopyViewController.h"

static NSString * const cellIdentifier = @"cell";

/*
    ClassA
 */
@interface ClassA : NSObject <NSCopying, NSCoding>

@property (copy, nonatomic) NSString *name;
@property (strong, nonatomic) NSArray *superClasses;
@property (weak, nonatomic) id delegate;
@property (assign, nonatomic) NSInteger number;

@end

@implementation ClassA

//浅拷贝
- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
//    [aCoder encodeObject:self.name forKey:@"name"];

    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.superClasses forKey:@"superClasses"];
    [aCoder encodeObject:self.delegate forKey:@"delegate"];
    [aCoder encodeInteger:self.number forKey:@"number"];
}
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
//        self.name = [aDecoder decodeObjectForKey:@"name"];

        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.superClasses = [aDecoder decodeObjectForKey:@"superClasses"];
        self.delegate = [aDecoder decodeObjectForKey:@"delegate"];
        self.number = [aDecoder decodeIntegerForKey:@"number"];
    }
    return self;
}


@end
/*
    ClassB
 */

@interface ClassB : NSObject <NSCopying>

@property (copy, nonatomic) NSString *name;
@property (strong, nonatomic) NSArray *superClasses;
@property (weak, nonatomic) id delegate;
@property (assign, nonatomic) NSInteger number;

@end

@implementation ClassB
//深拷贝
- (id)copyWithZone:(NSZone *)zone {
    
    ClassB *copy = [[[self class] allocWithZone:zone] init];
    
    //属性对象若要实现深拷贝，需要在此处实现
    copy.name = [self.name mutableCopy];
    copy.superClasses = self.superClasses;
    copy.delegate = self.delegate;
    copy.number = self.number;
    
    return copy;
}

@end



@interface CopyViewController ()

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) TVDataSourceAndDelegate *tvDelegate;

@property (strong, nonatomic) NSArray *dataArray;

@end

@implementation CopyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.delegate = self.tvDelegate;
    self.tableView.dataSource = self.tvDelegate;
    
//    ClassA *clsA = [[ClassA alloc] init];
//    ClassA *clsACopy = [NSKeyedUnarchiver unarchiveObjectWithData:
//                            [NSKeyedArchiver archivedDataWithRootObject:clsA]];;
//    NSLog(@"%p%p",clsA,clsACopy);
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

- (NSArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSArray arrayWithObjects:@"NSArray的copy和mutableCopy探索", @"NSMutableArray的copy和mutableCopy探索", @"自定义对象copy探索", @"双层深copy", @"完全深拷贝(NSKeyedArchiver)", nil];
    }
    return _dataArray;
}

- (TVDataSourceAndDelegate *)tvDelegate {
    if (_tvDelegate == nil) {
        
        __weak typeof(self) weakSelf = self;
        _tvDelegate = [[TVDataSourceAndDelegate alloc] initWithItems:self.dataArray cellIdentifier:cellIdentifier configureBlock:^(UITableViewCell *cell, NSString *item, NSIndexPath *indexPath, NSInteger style) {
            
            if (style == CellControlLoadData) {
                cell.textLabel.text = item;
                cell.textLabel.adjustsFontSizeToFitWidth = YES;

            } else if (style == CellControlSelect) {
                
                NSInteger row = indexPath.row;
                switch (row) {
                    case 0:
                        [weakSelf test1];
                        break;
                    case 1:
                        [weakSelf test2];
                        break;
                    case 2:
                        [weakSelf test3];
                        break;
                    case 3:
                        [weakSelf test4];
                        break;
                    case 4:
                        [weakSelf test5];
                        break;
                    default:
                        
                        break;
                }
            }
            
        } parentViewController:self];
    }
    return _tvDelegate;
}

#pragma mark - Methods
- (void)test1 {
    
    @autoreleasepool {
        
        NSArray *array = [NSArray new];
        NSArray *arrayCopy = [array copy];
        NSArray *arrayMutableCopy = [array mutableCopy];
        
        NSString *msg = [NSString stringWithFormat:@"NSArray的copy和mutableCopy探索： \n array %p\n copy array %p\n mutableCopy array %p",array,arrayCopy,arrayMutableCopy];
        NSLog(@"%@", msg);

        [UIAlertController showAlertInViewController:self withTitle:@"Logs" message:msg cancelButtonTitle:@"sure" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:nil];
    };
}

- (void)test2 {
    
    @autoreleasepool {
        NSMutableArray *mutableArray = [NSMutableArray new];
        NSArray *mutableArrayCopy = [mutableArray copy];
        NSArray *mutableArrayMutableCopy = [mutableArray mutableCopy];
        
        NSString *msg = [NSString stringWithFormat:@"NSMutableArray的copy和mutableCopy探索： \n mutableArray %p\n copy mutableArray %p\n mutableCopy mutableArray %p",mutableArray,mutableArrayCopy,mutableArrayMutableCopy];
        NSLog(@"%@", msg);
        
        [UIAlertController showAlertInViewController:self withTitle:@"Logs" message:msg cancelButtonTitle:@"sure" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:nil];

        
    };
}

- (void)test3 {

    @autoreleasepool {
        /*
         浅copy:指针复制，不会创建一个新的对象。
         深copy:内容复制，会创建一个新的对象。
         */
        
        ClassA *clsA = [[ClassA alloc] init];
        ClassA *clsACopy = [clsA copy];
        NSLog(@"copyWithZone自实现浅拷贝：\n%p\n%p",clsA,clsACopy);
        
        
        ClassB *clsB = [[ClassB alloc] init];
        clsB.name = @"name";
        clsB.superClasses = [NSArray new];
        ClassB *clsBCopy = [clsB copy];
        NSLog(@"copyWithZone自实现深拷贝：\n%p\n%p",clsB,clsBCopy);
        
        NSLog(@"copy property：\n%p\n%p",clsB.name,clsBCopy.name);
        NSLog(@"strong property：\n%p\n%p",clsB.superClasses,clsBCopy.superClasses);
        
        NSString *msg = [NSString stringWithFormat:@"copyWithZone自实现浅拷贝：\n%p\n%p \ncopyWithZone自实现单层深拷贝(对象内property不一定深拷贝)：\n%p\n%p", clsA, clsACopy, clsB, clsBCopy];
        [UIAlertController showAlertInViewController:self withTitle:@"Logs" message:msg cancelButtonTitle:@"sure" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:nil];

    };
}

- (void)test4 {
    
    @autoreleasepool {
        // 随意创建一个NSMutableString对象
        NSMutableString *mutableString = [NSMutableString stringWithString:@"1"];
        
        // 随意创建一个包涵NSMutableString的NSMutableArray对象
        NSMutableString *mutalbeString1 = [NSMutableString stringWithString:@"1"];
        NSMutableArray *mutableArr = [NSMutableArray arrayWithObjects:mutalbeString1, nil];
        
        // 将mutableString和mutableArr放入一个新的NSArray中
        NSArray *testArr = [NSArray arrayWithObjects:mutableString, mutableArr, nil];
        // 通过官方文档提供的方式创建copy
        NSArray *testArrCopy = [[NSArray alloc] initWithArray:testArr copyItems:YES];
        
        // testArr和testArrCopy指针对比
        NSLog(@"testArr：%p", testArr);
        NSLog(@"testArrCopy：%p", testArrCopy);
        
        // testArr和testArrCopy中元素指针对比
        // mutableString对比
        NSLog(@"testArr[0]：%p", testArr[0]);
        NSLog(@"testArrCopy[0]：%p", testArrCopy[0]);
        // mutableArr对比
        NSLog(@"testArr[1]：%p", testArr[1]);
        NSLog(@"testArrCopy[1]：%p", testArrCopy[1]);
        
        // mutableArr中的元素对比，即mutalbeString1对比
        NSLog(@"testArr[1][0]：%p", testArr[1][0]);
        NSLog(@"testArrCopy[1][0]：%p", testArrCopy[1][0]);
        
        NSMutableArray *array = [NSMutableArray new];
        [array addObject:[NSString stringWithFormat:@"testArr：%p", testArr]];
        [array addObject:[NSString stringWithFormat:@"testArrCopy：%p", testArrCopy]];
        
        [array addObject:[NSString stringWithFormat:@"testArr[0]：%p", testArr[0]]];
        [array addObject:[NSString stringWithFormat:@"testArrCopy[0]：%p", testArrCopy[0]]];
        
        [array addObject:[NSString stringWithFormat:@"testArr[1]：%p", testArr[1]]];
        [array addObject:[NSString stringWithFormat:@"testArrCopy[1]：%p", testArrCopy[1]]];
        
        [array addObject:[NSString stringWithFormat:@"testArr[1][0]：%p", testArr[1][0]]];
        [array addObject:[NSString stringWithFormat:@"testArrCopy[1][0]：%p", testArrCopy[1][0]]];
        
        NSDictionary *dict = [NSDictionary dictionaryWithObject:array forKey:@"content"];
        
        NSString *msg = [Tools dictionaryToJson:dict];
        [UIAlertController showAlertInViewController:self withTitle:@"Logs" message:msg cancelButtonTitle:@"sure" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:nil];
    };

}


/*
 归档和解档的前提是NSArray中所有的对象都实现了NSCoding协议。
 */
- (void)test5 {

    @autoreleasepool {
        // 随意创建一个NSMutableString对象
        NSMutableString *mutableString = [NSMutableString stringWithString:@"1"];
        // 随意创建一个包涵NSMutableString的NSMutableArray对象
        NSMutableString *mutalbeString1 = [NSMutableString stringWithString:@"1"];
        NSMutableArray *mutableArr = [NSMutableArray arrayWithObjects:mutalbeString1, nil];
        // 将mutableString和mutableArr放入一个新的NSArray中
        NSArray *testArr = [NSArray arrayWithObjects:mutableString, mutableArr, nil];
        // 通过归档、解档方式创建copy
        NSArray *testArrCopy = [NSKeyedUnarchiver unarchiveObjectWithData:
                                [NSKeyedArchiver archivedDataWithRootObject:testArr]];;
        
        // testArr和testArrCopy指针对比
        NSLog(@"%p", testArr);
        NSLog(@"%p", testArrCopy);
        
        // testArr和testArrCopy中元素指针对比
        // mutableString对比
        NSLog(@"%p", testArr[0]);
        NSLog(@"%p", testArrCopy[0]);
        // mutableArr对比
        NSLog(@"%p", testArr[1]);
        NSLog(@"%p", testArrCopy[1]);
        
        // mutableArr中的元素对比，即mutalbeString1对比
        NSLog(@"%p", testArr[1][0]);
        NSLog(@"%p", testArrCopy[1][0]);
        
        NSMutableArray *array = [NSMutableArray new];
        [array addObject:[NSString stringWithFormat:@"testArr：%p", testArr]];
        [array addObject:[NSString stringWithFormat:@"testArrCopy：%p", testArrCopy]];
        
        [array addObject:[NSString stringWithFormat:@"testArr[0]：%p", testArr[0]]];
        [array addObject:[NSString stringWithFormat:@"testArrCopy[0]：%p", testArrCopy[0]]];
        
        [array addObject:[NSString stringWithFormat:@"testArr[1]：%p", testArr[1]]];
        [array addObject:[NSString stringWithFormat:@"testArrCopy[1]：%p", testArrCopy[1]]];
        
        [array addObject:[NSString stringWithFormat:@"testArr[1][0]：%p", testArr[1][0]]];
        [array addObject:[NSString stringWithFormat:@"testArrCopy[1][0]：%p", testArrCopy[1][0]]];
        
        NSDictionary *dict = [NSDictionary dictionaryWithObject:array forKey:@"content"];
        
        NSString *msg = [Tools dictionaryToJson:dict];
        [UIAlertController showAlertInViewController:self withTitle:@"Logs" message:msg cancelButtonTitle:@"sure" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:nil];

    };
    
}

- (void)dealloc {
    NSLog(@"%s",__func__);
}

@end
