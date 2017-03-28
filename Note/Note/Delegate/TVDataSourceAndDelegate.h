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

- (id)initWithItems:(NSArray *)items cellIdentifier:(NSString *)cellIdentifier configureBlock:(TVCConfigureBlock)configureBlock;
- (id)initWithItems:(NSArray *)items cellIdentifier:(NSString *)cellIdentifier configureBlock:(TVCConfigureBlock)configureBlock parentViewController:(id)parentViewController;


@property (weak, nonatomic) UIViewController *parentViewController;

@end
