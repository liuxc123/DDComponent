//
//  DDCollectionViewComponentHelper.m
//  DDComponent_Example
//
//  Created by liuxc on 2021/8/30.
//  Copyright © 2021 liuxc123. All rights reserved.
//

#import "DDCollectionViewComponentHelper.h"

@implementation DDCollectionViewHeaderFooterSectionComponent (Helper)

+ (instancetype)componentWithHeader:(DDCollectionViewSectionComponent *)header
                             footer:(DDCollectionViewSectionComponent *)footer {
    DDCollectionViewHeaderFooterSectionComponent *comp = [self new];
    comp.headerComponent = header;
    comp.footerComponent = footer;
    return comp;
}

@end

@implementation DDCollectionViewItemGroupComponent (Helper)

+ (instancetype)componentWithHeader:(DDCollectionViewSectionComponent *)header
                             footer:(DDCollectionViewSectionComponent *)footer
                      subComponents:(NSArray<DDCollectionViewItemComponent *> *)subComponents {
    DDCollectionViewItemGroupComponent *comp = [self componentWithHeader:header footer:footer];
    comp.subComponents = subComponents;
    return comp;
}

+ (instancetype)componentWithSubComponents:(NSArray<DDCollectionViewItemComponent *> *)subComponents {
    DDCollectionViewItemGroupComponent *comp = [self new];
    comp.subComponents = subComponents;
    return comp;
}

@end

@implementation DDCollectionViewSectionGroupComponent (Helper)

+ (instancetype)componentWithSubComponents:(NSArray<DDCollectionViewSectionComponent *> *)subComponents {
    DDCollectionViewSectionGroupComponent *comp = [self new];
    comp.subComponents = subComponents;
    return comp;
}

@end

@implementation DDCollectionViewRootComponent (Helper)

+ (instancetype)componentWithCollectionView:(UICollectionView *)collectionView
                         subComponents:(NSArray<DDCollectionViewSectionComponent *> *)subComponents {
    DDCollectionViewRootComponent *comp = [[self alloc] initWithCollectionView:collectionView];
    comp.subComponents = subComponents;
    return comp;
}

@end

@implementation DDCollectionViewStatusComponent (Helper)

+ (instancetype)componentWithComponents:(NSDictionary<NSString *, DDCollectionViewSectionComponent *> *)components {
    DDCollectionViewStatusComponent *comp = [self new];
    [components enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, DDCollectionViewSectionComponent * _Nonnull obj, BOOL * _Nonnull stop) {
        [comp setComponent:obj forState:key];
    }];
    return comp;
}

@end

