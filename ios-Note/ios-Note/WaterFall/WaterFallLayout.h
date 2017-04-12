//
//  WaterFallLayout.h
//  ios-Note
//
//  Created by SL on 12/04/2017.
//  Copyright © 2017 Sam. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kDeviceWidth ([UIScreen mainScreen].bounds.size.width)
#define kDeviceHeight ([UIScreen mainScreen].bounds.size.height)

@class WaterFallLayout;
@protocol WFLayoutDelegate <NSObject>

@required

// 计算item高度，将item高度与indexPath传递给外界
- (CGFloat)wfLaout:(WaterFallLayout *)wfLayout itemHeightForWidth:(CGFloat)itemWidth atIndexPath:(NSIndexPath *)indexPath;

@end

@interface WaterFallLayout : UICollectionViewLayout
//队列数／由此参数计算item宽度
@property (nonatomic, assign) NSInteger columnCount;
//列间距
@property (nonatomic, assign) NSInteger columnSpacing;
//行间距
@property (nonatomic, assign) NSInteger rowSpacing;
//section与collectionView的间距
@property (nonatomic, assign) UIEdgeInsets sectionInset;

- (void)setColumnSpacing:(NSInteger)columnSpacing rowSpacing:(NSInteger)rowSepacing sectionInset:(UIEdgeInsets)sectionInset;
//代理，返回计算item高度
@property (nonatomic, weak) id<WFLayoutDelegate> delegate;

+ (instancetype)wfLayoutWithColumnCount:(NSInteger)columnCount;

- (instancetype)initWithColumnCount:(NSInteger)columnCount;


@end
