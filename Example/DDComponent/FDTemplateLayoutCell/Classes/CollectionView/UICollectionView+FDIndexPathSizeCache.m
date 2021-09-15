//
//  UICollectionView+FDIndexPathSizeCache.m
//  Demo
//
//  Created by mac on 2021/9/14.
//  Copyright © 2021 forkingdog. All rights reserved.
//

#import "UICollectionView+FDIndexPathSizeCache.h"
#import <objc/runtime.h>

typedef NSMutableArray<NSMutableArray<NSValue *> *> FDIndexPathSizesBySection;

@interface FDIndexPathSizeCache ()
@property (nonatomic, strong) FDIndexPathSizesBySection *sizesBySectionForPortrait;
@property (nonatomic, strong) FDIndexPathSizesBySection *sizesBySectionForLandscape;
@end

@implementation FDIndexPathSizeCache

- (instancetype)init {
    self = [super init];
    if (self) {
        _sizesBySectionForPortrait = [NSMutableArray array];
        _sizesBySectionForLandscape = [NSMutableArray array];
    }
    return self;
}

- (FDIndexPathSizesBySection *)sizesBySectionForCurrentOrientation {
    return UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation) ? self.sizesBySectionForPortrait: self.sizesBySectionForLandscape;
}

- (void)enumerateAllOrientationsUsingBlock:(void (^)(FDIndexPathSizesBySection *sizesBySection))block {
    block(self.sizesBySectionForPortrait);
    block(self.sizesBySectionForLandscape);
}

- (BOOL)existsSizeAtIndexPath:(NSIndexPath *)indexPath {
    [self buildCachesAtIndexPathsIfNeeded:@[indexPath]];
    NSValue *value = self.sizesBySectionForCurrentOrientation[indexPath.section][indexPath.row];
    return ![value isEqualToValue:[NSValue valueWithCGSize:CGSizeMake(-1, -1)]];
}

- (void)cacheSize:(CGSize)size byIndexPath:(NSIndexPath *)indexPath {
    self.automaticallyInvalidateEnabled = YES;
    [self buildCachesAtIndexPathsIfNeeded:@[indexPath]];
    self.sizesBySectionForCurrentOrientation[indexPath.section][indexPath.row] = [NSValue valueWithCGSize:size];
}

- (CGSize)sizeForIndexPath:(NSIndexPath *)indexPath {
    [self buildCachesAtIndexPathsIfNeeded:@[indexPath]];
    NSValue *value = self.sizesBySectionForCurrentOrientation[indexPath.section][indexPath.row];
    return value.CGSizeValue;
}

- (void)invalidateSizeAtIndexPath:(NSIndexPath *)indexPath {
    [self buildCachesAtIndexPathsIfNeeded:@[indexPath]];
    [self enumerateAllOrientationsUsingBlock:^(FDIndexPathSizesBySection *sizesBySection) {
        sizesBySection[indexPath.section][indexPath.row] = [NSValue valueWithCGSize:CGSizeMake(-1, -1)];
    }];
}

- (void)invalidateAllSizeCache {
    [self enumerateAllOrientationsUsingBlock:^(FDIndexPathSizesBySection *sizesBySection) {
        [sizesBySection removeAllObjects];
    }];
}

- (void)buildCachesAtIndexPathsIfNeeded:(NSArray *)indexPaths {
    // Build every section array or item array which is smaller than given index path.
    [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath *indexPath, NSUInteger idx, BOOL *stop) {
        [self buildSectionsIfNeeded:indexPath.section];
        [self buildItemsIfNeeded:indexPath.row inExistSection:indexPath.section];
    }];
}

- (void)buildSectionsIfNeeded:(NSInteger)targetSection {
    [self enumerateAllOrientationsUsingBlock:^(FDIndexPathSizesBySection *sizesBySection) {
        for (NSInteger section = 0; section <= targetSection; ++section) {
            if (section >= sizesBySection.count) {
                sizesBySection[section] = [NSMutableArray array];
            }
        }
    }];
}

- (void)buildItemsIfNeeded:(NSInteger)targetItem inExistSection:(NSInteger)section {
    [self enumerateAllOrientationsUsingBlock:^(FDIndexPathSizesBySection *sizesBySection) {
        NSMutableArray<NSValue *> *sizesByItem = sizesBySection[section];
        for (NSInteger item = 0; item <= targetItem; ++item) {
            if (item >= sizesByItem.count) {
                sizesByItem[item] = [NSValue valueWithCGSize:CGSizeMake(-1, -1)];
            }
        }
    }];
}

@end


@implementation UICollectionView (FDIndexPathSizeCache)

- (FDIndexPathSizeCache *)fd_indexPathSizeCache {
    FDIndexPathSizeCache *cache = objc_getAssociatedObject(self, _cmd);
    if (!cache) {
        cache = [FDIndexPathSizeCache new];
        objc_setAssociatedObject(self, _cmd, cache, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return cache;
}

@end

// We just forward primary call, in crash report, top most method in stack maybe FD's,
// but it's really not our bug, you should check whether your table view's data source and
// displaying cells are not matched when reloading.
static void __FD_TEMPLATE_LAYOUT_CELL_PRIMARY_CALL_IF_CRASH_NOT_OUR_BUG__(void (^callout)(void)) {
    callout();
}
#define FDPrimaryCall(...) do {__FD_TEMPLATE_LAYOUT_CELL_PRIMARY_CALL_IF_CRASH_NOT_OUR_BUG__(^{__VA_ARGS__});} while(0)

@implementation UICollectionView (FDIndexPathSizeCacheInvalidation)

- (void)fd_reloadDataWithoutInvalidateIndexPathSizeCache {
    FDPrimaryCall([self fd_reloadData];);
}

+ (void)load {
    // All methods that trigger height cache's invalidation
    SEL selectors[] = {
        @selector(reloadData),
        @selector(insertSections:),
        @selector(deleteSections:),
        @selector(reloadSections:),
        @selector(moveSection:toSection:),
        @selector(insertItemsAtIndexPaths:),
        @selector(deleteItemsAtIndexPaths:),
        @selector(reloadItemsAtIndexPaths:),
        @selector(moveItemAtIndexPath:toIndexPath:)
    };
    
    for (NSUInteger index = 0; index < sizeof(selectors) / sizeof(SEL); ++index) {
        SEL originalSelector = selectors[index];
        SEL swizzledSelector = NSSelectorFromString([@"fd_" stringByAppendingString:NSStringFromSelector(originalSelector)]);
        Method originalMethod = class_getInstanceMethod(self, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(self, swizzledSelector);
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

- (void)fd_reloadData {
    if (self.fd_indexPathSizeCache.automaticallyInvalidateEnabled) {
        [self.fd_indexPathSizeCache enumerateAllOrientationsUsingBlock:^(FDIndexPathSizesBySection *sizesBySection) {
            [sizesBySection removeAllObjects];
        }];
    }
    FDPrimaryCall([self fd_reloadData];);
}

- (void)fd_insertSections {
    if (self.fd_indexPathSizeCache.automaticallyInvalidateEnabled) {
        [self.fd_indexPathSizeCache enumerateAllOrientationsUsingBlock:^(FDIndexPathSizesBySection *sizesBySection) {
            [sizesBySection removeAllObjects];
        }];
    }
    FDPrimaryCall([self fd_reloadData];);
}

- (void)fd_insertSections:(NSIndexSet *)sections {
    if (self.fd_indexPathSizeCache.automaticallyInvalidateEnabled) {
        [sections enumerateIndexesUsingBlock:^(NSUInteger section, BOOL *stop) {
            [self.fd_indexPathSizeCache buildSectionsIfNeeded:section];
            [self.fd_indexPathSizeCache enumerateAllOrientationsUsingBlock:^(FDIndexPathSizesBySection *sizesBySection) {
                [sizesBySection insertObject:[NSMutableArray array] atIndex:section];
            }];
        }];
    }
    FDPrimaryCall([self fd_insertSections:sections];);
}

- (void)fd_deleteSections:(NSIndexSet *)sections {
    if (self.fd_indexPathSizeCache.automaticallyInvalidateEnabled) {
        [sections enumerateIndexesUsingBlock:^(NSUInteger section, BOOL *stop) {
            [self.fd_indexPathSizeCache buildSectionsIfNeeded:section];
            [self.fd_indexPathSizeCache enumerateAllOrientationsUsingBlock:^(FDIndexPathSizesBySection *sizesBySection) {
                [sizesBySection removeObjectAtIndex:section];
            }];
        }];
    }
    FDPrimaryCall([self fd_deleteSections:sections];);
}

- (void)fd_reloadSections:(NSIndexSet *)sections {
    if (self.fd_indexPathSizeCache.automaticallyInvalidateEnabled) {
        [sections enumerateIndexesUsingBlock: ^(NSUInteger section, BOOL *stop) {
            [self.fd_indexPathSizeCache buildSectionsIfNeeded:section];
            [self.fd_indexPathSizeCache enumerateAllOrientationsUsingBlock:^(FDIndexPathSizesBySection *sizesBySection) {
                [sizesBySection[section] removeAllObjects];
            }];

        }];
    }
    FDPrimaryCall([self fd_reloadSections:sections];);
}

- (void)fd_moveSection:(NSInteger)section toSection:(NSInteger)newSection {
    if (self.fd_indexPathSizeCache.automaticallyInvalidateEnabled) {
        [self.fd_indexPathSizeCache buildSectionsIfNeeded:section];
        [self.fd_indexPathSizeCache buildSectionsIfNeeded:newSection];
        [self.fd_indexPathSizeCache enumerateAllOrientationsUsingBlock:^(FDIndexPathSizesBySection *sizesBySection) {
            [sizesBySection exchangeObjectAtIndex:section withObjectAtIndex:newSection];
        }];
    }
    FDPrimaryCall([self fd_moveSection:section toSection:newSection];);
}

- (void)fd_insertItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {
    if (self.fd_indexPathSizeCache.automaticallyInvalidateEnabled) {
        [self.fd_indexPathSizeCache buildCachesAtIndexPathsIfNeeded:indexPaths];
        [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath *indexPath, NSUInteger idx, BOOL *stop) {
            [self.fd_indexPathSizeCache enumerateAllOrientationsUsingBlock:^(FDIndexPathSizesBySection *sizesBySection) {
                [sizesBySection[indexPath.section] insertObject:@-1 atIndex:indexPath.row];
            }];
        }];
    }
    FDPrimaryCall([self fd_insertItemsAtIndexPaths:indexPaths];);
}

- (void)fd_deleteItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {
    if (self.fd_indexPathSizeCache.automaticallyInvalidateEnabled) {
        [self.fd_indexPathSizeCache buildCachesAtIndexPathsIfNeeded:indexPaths];
        
        NSMutableDictionary<NSNumber *, NSMutableIndexSet *> *mutableIndexSetsToRemove = [NSMutableDictionary dictionary];
        [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath *indexPath, NSUInteger idx, BOOL *stop) {
            NSMutableIndexSet *mutableIndexSet = mutableIndexSetsToRemove[@(indexPath.section)];
            if (!mutableIndexSet) {
                mutableIndexSet = [NSMutableIndexSet indexSet];
                mutableIndexSetsToRemove[@(indexPath.section)] = mutableIndexSet;
            }
            [mutableIndexSet addIndex:indexPath.row];
        }];
        
        [mutableIndexSetsToRemove enumerateKeysAndObjectsUsingBlock:^(NSNumber *key, NSIndexSet *indexSet, BOOL *stop) {
            [self.fd_indexPathSizeCache enumerateAllOrientationsUsingBlock:^(FDIndexPathSizesBySection *sizesBySection) {
                [sizesBySection[key.integerValue] removeObjectsAtIndexes:indexSet];
            }];
        }];
    }
    FDPrimaryCall([self fd_deleteItemsAtIndexPaths:indexPaths];);
}

- (void)fd_reloadItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {
    if (self.fd_indexPathSizeCache.automaticallyInvalidateEnabled) {
        [self.fd_indexPathSizeCache buildCachesAtIndexPathsIfNeeded:indexPaths];
        [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath *indexPath, NSUInteger idx, BOOL *stop) {
            [self.fd_indexPathSizeCache enumerateAllOrientationsUsingBlock:^(FDIndexPathSizesBySection *sizesBySection) {
                sizesBySection[indexPath.section][indexPath.row] = @-1;
            }];
        }];
    }
    FDPrimaryCall([self fd_reloadItemsAtIndexPaths:indexPaths];);
}

- (void)fd_moveItemAtIndexPath:(NSIndexPath *)indexPath toIndexPath:(NSIndexPath *)newIndexPath {
    if (self.fd_indexPathSizeCache.automaticallyInvalidateEnabled) {
        [self.fd_indexPathSizeCache buildCachesAtIndexPathsIfNeeded:@[indexPath, newIndexPath]];
        [self.fd_indexPathSizeCache enumerateAllOrientationsUsingBlock:^(FDIndexPathSizesBySection *sizesBySection) {
            NSMutableArray<NSValue *> *sourceItems = sizesBySection[indexPath.section];
            NSMutableArray<NSValue *> *destinationItems = sizesBySection[newIndexPath.section];
            NSValue *sourceValue = sourceItems[indexPath.item];
            NSValue *destinationValue = destinationItems[newIndexPath.item];
            sourceItems[indexPath.item] = destinationValue;
            destinationItems[newIndexPath.item] = sourceValue;
        }];
    }
    FDPrimaryCall([self fd_moveItemAtIndexPath:indexPath toIndexPath:newIndexPath];);
}

@end
