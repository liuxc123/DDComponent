//
//  DDCollectionViewHeaderFooterSectionDemoComponent.m
//  DDComponent_Example
//
//  Created by mac on 2021/8/31.
//  Copyright © 2021 liuxc123. All rights reserved.
//

#import "DDCollectionViewHeaderFooterSectionDemoComponent.h"
#import "DDComponentDemoCollectionViewCell.h"
#import "DDCollectionHeaderFooterView.h"

@implementation DDCollectionViewHeaderFooterSectionDemoComponent

+ (instancetype)componentWithData:(NSArray *)demoData {
    DDCollectionViewHeaderFooterSectionDemoComponent *comp = [self new];
    comp.demoData = demoData;
    return comp;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.size = CGSizeMake(DDComponentAutomaticDimension, 60);
        self.itemSpacing = 5;
        self.lineSpacing = 5;
        self.headerSize = CGSizeMake(DDComponentAutomaticDimension, 10);
    }
    return self;
}

- (void)prepareCollectionView {
    [super prepareCollectionView];
    [self.collectionView registerClass:[DDComponentDemoCollectionViewCell class] forCellWithReuseIdentifier:@"DDComponentDemoCollectionViewCell"];
    [self.collectionView registerClass:[DDCollectionHeaderFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"DDCollectionHeaderFooterView"];
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.demoData.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.demoData[section].count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DDComponentDemoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DDComponentDemoCollectionViewCell" forIndexPath:indexPath];
    cell.contentView.backgroundColor = indexPath.section%2 == 0 ? UIColor.redColor : UIColor.greenColor;
    NSLog(@"section: %ld, item: %ld", indexPath.section, indexPath.item);
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    return [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"DDCollectionHeaderFooterView" forIndexPath:indexPath];
}

@end
