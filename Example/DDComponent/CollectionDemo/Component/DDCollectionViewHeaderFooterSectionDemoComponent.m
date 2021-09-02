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
    }
    return self;
}

- (void)prepareCollectionView {
    [super prepareCollectionView];
    [self.collectionView registerClass:[DDComponentDemoCollectionViewCell class] forCellWithReuseIdentifier:@"DDComponentDemoCollectionViewCell"];    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.demoData.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger converSection = [self convertFromGlobalSection: section];
    return [self.demoData[converSection] count];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DDComponentDemoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DDComponentDemoCollectionViewCell" forIndexPath:indexPath];
    cell.contentView.backgroundColor = indexPath.section%2 == 0 ? UIColor.redColor : UIColor.greenColor;
    
    NSIndexPath *converIndexPath = [self convertFromGlobalIndexPath:indexPath];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@, section:%ld, row:%ld, coverSection:%ld, coverItem:%ld", self.demoData[converIndexPath.section][converIndexPath.item], indexPath.section, indexPath.item, converIndexPath.section, converIndexPath.item];
    
    return cell;
}

@end
