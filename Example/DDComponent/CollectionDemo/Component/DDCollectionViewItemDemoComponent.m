//
//  DDCollectionViewItemDemoComponent.m
//  DDComponent_Example
//
//  Created by mac on 2021/8/31.
//  Copyright © 2021 liuxc123. All rights reserved.
//

#import "DDCollectionViewItemDemoComponent.h"
#import "DDComponentDemoCollectionViewCell.h"
#import "DDCollectionHeaderFooterView.h"

@implementation DDCollectionViewItemDemoComponent

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.size = CGSizeMake(DDComponentAutomaticDimension, 60);
    }
    return self;
}

- (void)prepareCollectionView {
    [super prepareCollectionView];
    [self.collectionView registerClass:[DDComponentDemoCollectionViewCell class] forCellWithReuseIdentifier:@"DDComponentDemoCollectionViewCell"];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DDComponentDemoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DDComponentDemoCollectionViewCell" forIndexPath:indexPath];
    cell.contentView.backgroundColor = indexPath.section%2 == 0 ? UIColor.redColor : UIColor.greenColor;
    NSLog(@"section: %ld, item: %ld", indexPath.section, indexPath.item);
    return cell;
}

@end
