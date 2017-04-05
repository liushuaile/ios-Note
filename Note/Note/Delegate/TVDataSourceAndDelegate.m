//
//  TVDataSourceAndDelegate.m
//  Note
//
//  Created by SL on 27/03/2017.
//  Copyright © 2017 Sam. All rights reserved.
//

#import "TVDataSourceAndDelegate.h"

@implementation TVDataSourceAndDelegate

- (instancetype)initWithItems:(NSArray *)items cellIdentifier:(NSString *)cellIdentifier configureBlock:(TVCConfigureBlock)configureBlock {
    
    if (self = [super init]) {
        _cellIdenifier = cellIdentifier;
        _items = items;
        _configureBlock = [configureBlock copy];
    }
    return self;
}
- (instancetype)initWithItems:(NSArray *)items cellIdentifier:(NSString *)cellIdentifier configureBlock:(TVCConfigureBlock)configureBlock parentViewController:(id)parentViewController {
    
    if (self = [super init]) {
        _cellIdenifier = cellIdentifier;
        _items = items;
        _configureBlock = [configureBlock copy];
        _parentViewController = parentViewController;
    }
    return self;
}
#pragma mark- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.items.count > 0) {
        return self.items.count;
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdenifier];
    if (cell == nil) {
        [tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:0];
        cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdenifier];
    }
    
    id item = [self.items objectAtIndex:indexPath.row];
    self.configureBlock(cell, item, indexPath, CellControlLoadData);
    return cell;
    
}

#pragma mark- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    id item = [self.items objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    self.configureBlock(cell, item, indexPath, CellControlSelect);
    
}

@end
