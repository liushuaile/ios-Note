//
//  WFCollectionViewCell.m
//  ios-Note
//
//  Created by SL on 12/04/2017.
//  Copyright © 2017 Sam. All rights reserved.
//

#import "WFCollectionViewCell.h"
#import <UIImageView+WebCache.h>
@interface WFCollectionViewCell ()

@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation WFCollectionViewCell

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
//        [_imageView sd_setImageWithURL:self.imageURL placeholderImage:[UIImage imageNamed:@"img001.jpg"]];
        [self.contentView addSubview:_imageView];
    }
    return _imageView;
}

- (void)setImageURL:(NSURL *)imageURL {
    _imageURL = imageURL;
    [self.imageView sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"img002.jpg"]];
}

@end
