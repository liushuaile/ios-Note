//
//  TVDataSourceAndDelegate.h
//  Note
//
//  Created by SL on 27/03/2017.
//  Copyright © 2017 Sam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


/*
 当使用enum时，推荐使用新的固定基本类型规格，因为它有更强的类型检查和代码补全。现在SDK有一个宏NS_ENUM()来帮助和鼓励你使用固定的基本类型。
 */
typedef NS_ENUM(NSInteger, CellControlStyle) {
    CellControlLoadData,
    CellControlSelect,
    CellControlDelete,
};


typedef void (^TableViewCellConfigureBlock)(id cell, id item, NSIndexPath *indexPath);
typedef void (^TVCConfigureBlock)(id cell, id item, NSIndexPath *indexPath, NSInteger style);


@interface TVDataSourceAndDelegate : NSObject <UITableViewDataSource, UITableViewDelegate>

@property (copy, nonatomic) TVCConfigureBlock configureBlock;
@property (strong, nonatomic) NSArray *items;
@property (copy, nonatomic) NSString *cellIdenifier;

/*
 ①instancetype可以返回和方法所在类相同类型的对象，id只能返回未知类型的对象；(确定对象的类型，能够帮助编译器更好的为我们定位代码书写问题,比如未知方法的调用)
 example：[[[NSArray alloc] init] mediaPlaybackAllowsAirPlay]; //  "No visible @interface for `NSArray` declares the selector `mediaPlaybackAllowsAirPlay`" 
 ②instancetype只能作为返回值，不能像id那样作为参数
 */
- (instancetype)initWithItems:(NSArray *)items cellIdentifier:(NSString *)cellIdentifier configureBlock:(TVCConfigureBlock)configureBlock;
- (instancetype)initWithItems:(NSArray *)items cellIdentifier:(NSString *)cellIdentifier configureBlock:(TVCConfigureBlock)configureBlock parentViewController:(id)parentViewController;


@property (weak, nonatomic) UIViewController *parentViewController;

@end
