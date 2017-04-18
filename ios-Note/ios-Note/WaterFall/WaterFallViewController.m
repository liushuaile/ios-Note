//
//  WaterFallViewController.m
//  ios-Note
//
//  Created by SL on 12/04/2017.
//  Copyright © 2017 Sam. All rights reserved.
//

#import "WaterFallViewController.h"
#import "WaterFallLayout.h"
#import "WFImage.h"
#import "WFCollectionViewCell.h"

@interface WaterFallViewController () <UICollectionViewDataSource, WFLayoutDelegate>

@property (nonatomic, strong) WaterFallLayout *WFLayout;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray<WFImage *> *images;

@end

@implementation WaterFallViewController

#pragma mark- Lifecyle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.collectionView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- Custom Accessors

- (WaterFallLayout *)WFLayout {
    if (!_WFLayout) {
        _WFLayout = [WaterFallLayout wfLayoutWithColumnCount:2];
        [_WFLayout setColumnSpacing:10 rowSpacing:10 sectionInset:UIEdgeInsetsMake(160, 10, 10, 10)];
        _WFLayout.delegate = self;
    }
    return _WFLayout;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:self.WFLayout];
        [_collectionView registerClass:[WFCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableView"];
        _collectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _collectionView.dataSource = self;
//        _collectionView.delegate = self;
        
        [_collectionView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    }
    return _collectionView;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentOffset"]) {
        CGPoint contentOffset = self.collectionView.contentOffset;
        NSLog(@"contentOffset_Y:%f",contentOffset.y);
        
        //此处监听坐标变化，重置collectionView Header位置坐标
//        [self.WFLayout prepareLayout];
        [self.collectionView setCollectionViewLayout:self.WFLayout animated:NO];
    }
}

- (void)dealloc {
    
    [self.collectionView removeObserver:self forKeyPath:@"contentOffset"];
}

- (NSMutableArray *)images {
    if (!_images) {
        _images = [NSMutableArray array];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"images" ofType:@"plist"];
        NSArray *imageDics = [NSArray arrayWithContentsOfFile:path];
        for (NSDictionary *imageDic in imageDics) {
            WFImage *image = [WFImage imageWithImageDic:imageDic];
            [_images addObject:image];
        }
    }
    return _images;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark- UICollectionViewDataSource

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.images.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    WFCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.imageURL = self.images[indexPath.item].imageURL;
//    NSLog(@"*cell:%p",cell);
    return cell;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:
                                            UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableView" forIndexPath:indexPath];
    UIImageView *iv = [[UIImageView alloc] initWithFrame:headerView.bounds];
    [iv setImage:[UIImage imageNamed:@"img002.jpg"]];
    [headerView addSubview:iv];
    return headerView;
}

#pragma mark- WFLayoutDelegate

- (CGFloat)wfLaout:(WaterFallLayout *)wfLayout itemHeightForWidth:(CGFloat)itemWidth atIndexPath:(NSIndexPath *)indexPath {
    WFImage *image = self.images[indexPath.item];
    return image.imageH / image.imageW * itemWidth;
}

@end
