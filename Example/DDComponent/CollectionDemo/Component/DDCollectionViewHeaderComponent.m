//
//  DDCollectionViewHeaderComponent.m
//  DDComponent_Example
//
//  Created by mac on 2021/8/31.
//  Copyright © 2021 liuxc123. All rights reserved.
//

#import "DDCollectionViewHeaderComponent.h"
#import "DDCollectionHeaderFooterView.h"

@implementation DDCollectionViewHeaderComponent

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.headerSize = CGSizeMake(DDComponentAutomaticDimension, 30);
    }
    return self;
}

- (void)prepareCollectionView {
    [super prepareCollectionView];
    [self.collectionView registerClass:[DDCollectionHeaderFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"DDCollectionHeaderFooterView"];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    return [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"DDCollectionHeaderFooterView" forIndexPath:indexPath];
}

@end
