//
//  DDCollectionViewComponentHelper.h
//  DDComponent_Example
//
//  Created by liuxc on 2021/8/30.
//  Copyright © 2021 liuxc123. All rights reserved.
//

#import "DDCollectionViewComponent.h"
#import "DDCollectionViewItemComponent.h"
#import "DDCollectionViewSectionComponent.h"
#import "DDCollectionViewSectionGroupComponent.h"
#import "DDCollectionViewStatusComponent.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDCollectionViewHeaderFooterSectionComponent (Helper)

+ (instancetype)componentWithHeader:(DDCollectionViewSectionComponent *)header
                             footer:(DDCollectionViewSectionComponent *)footer;

@end

@interface DDCollectionViewItemGroupComponent (Helper)

+ (instancetype)componentWithHeader:(DDCollectionViewSectionComponent *)header
                             footer:(DDCollectionViewSectionComponent *)footer
                      subComponents:(NSArray<DDCollectionViewItemComponent *> *)subComponents;

+ (instancetype)componentWithSubComponents:(NSArray<DDCollectionViewItemComponent *> *)subComponents;

@end

@interface DDCollectionViewSectionGroupComponent (Helper)

+ (instancetype)componentWithSubComponents:(NSArray<DDCollectionViewSectionComponent *> *)subComponents;

@end

@interface DDCollectionViewRootComponent (Helper)

+ (instancetype)componentWithCollectionView:(UICollectionView *)collectionView
                         subComponents:(NSArray<DDCollectionViewSectionComponent *> *)subComponents;

@end

@interface DDCollectionViewStatusComponent (Helper)

+ (instancetype)componentWithComponents:(NSDictionary<NSString *, DDCollectionViewSectionComponent *> *)components;

@end

NS_ASSUME_NONNULL_END
