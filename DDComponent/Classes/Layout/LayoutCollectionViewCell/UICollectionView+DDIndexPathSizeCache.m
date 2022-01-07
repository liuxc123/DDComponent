#import "UICollectionView+DDIndexPathSizeCache.h"
#import <objc/runtime.h>

typedef NSMutableArray<NSMutableArray<NSValue *> *> FDIndexPathSizesBySection;

@interface DDIndexPathSizeCache ()
@property (nonatomic, strong) FDIndexPathSizesBySection *sizesBySectionForPortrait;
@property (nonatomic, strong) FDIndexPathSizesBySection *sizesBySectionForLandscape;
@end

@implementation DDIndexPathSizeCache

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


@implementation UICollectionView (DDIndexPathSizeCache)

- (DDIndexPathSizeCache *)dd_indexPathSizeCache {
    DDIndexPathSizeCache *cache = objc_getAssociatedObject(self, _cmd);
    if (!cache) {
        cache = [DDIndexPathSizeCache new];
        objc_setAssociatedObject(self, _cmd, cache, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return cache;
}

@end

// We just forward primary call, in crash report, top most method in stack maybe FD's,
// but it's really not our bug, you should check whether your table view's data source and
// displaying cells are not matched when reloading.
static void __DD_TEMPLATE_LAYOUT_CELL_PRIMARY_CALL_IF_CRASH_NOT_OUR_BUG__(void (^callout)(void)) {
    callout();
}
#define DDPrimaryCall(...) do {__DD_TEMPLATE_LAYOUT_CELL_PRIMARY_CALL_IF_CRASH_NOT_OUR_BUG__(^{__VA_ARGS__});} while(0)

@implementation UICollectionView (DDIndexPathSizeCacheInvalidation)

- (void)dd_reloadDataWithoutInvalidateIndexPathSizeCache {
    DDPrimaryCall([self dd_reloadData];);
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
        SEL swizzledSelector = NSSelectorFromString([@"dd_" stringByAppendingString:NSStringFromSelector(originalSelector)]);
        Method originalMethod = class_getInstanceMethod(self, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(self, swizzledSelector);
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

- (void)dd_reloadData {
    if (self.dd_indexPathSizeCache.automaticallyInvalidateEnabled) {
        [self.dd_indexPathSizeCache enumerateAllOrientationsUsingBlock:^(FDIndexPathSizesBySection *sizesBySection) {
            [sizesBySection removeAllObjects];
        }];
    }
    DDPrimaryCall([self dd_reloadData];);
}

- (void)dd_insertSections {
    if (self.dd_indexPathSizeCache.automaticallyInvalidateEnabled) {
        [self.dd_indexPathSizeCache enumerateAllOrientationsUsingBlock:^(FDIndexPathSizesBySection *sizesBySection) {
            [sizesBySection removeAllObjects];
        }];
    }
    DDPrimaryCall([self dd_reloadData];);
}

- (void)dd_insertSections:(NSIndexSet *)sections {
    if (self.dd_indexPathSizeCache.automaticallyInvalidateEnabled) {
        [sections enumerateIndexesUsingBlock:^(NSUInteger section, BOOL *stop) {
            [self.dd_indexPathSizeCache buildSectionsIfNeeded:section];
            [self.dd_indexPathSizeCache enumerateAllOrientationsUsingBlock:^(FDIndexPathSizesBySection *sizesBySection) {
                [sizesBySection insertObject:[NSMutableArray array] atIndex:section];
            }];
        }];
    }
    DDPrimaryCall([self dd_insertSections:sections];);
}

- (void)dd_deleteSections:(NSIndexSet *)sections {
    if (self.dd_indexPathSizeCache.automaticallyInvalidateEnabled) {
        [sections enumerateIndexesUsingBlock:^(NSUInteger section, BOOL *stop) {
            [self.dd_indexPathSizeCache buildSectionsIfNeeded:section];
            [self.dd_indexPathSizeCache enumerateAllOrientationsUsingBlock:^(FDIndexPathSizesBySection *sizesBySection) {
                [sizesBySection removeObjectAtIndex:section];
            }];
        }];
    }
    DDPrimaryCall([self dd_deleteSections:sections];);
}

- (void)dd_reloadSections:(NSIndexSet *)sections {
    if (self.dd_indexPathSizeCache.automaticallyInvalidateEnabled) {
        [sections enumerateIndexesUsingBlock: ^(NSUInteger section, BOOL *stop) {
            [self.dd_indexPathSizeCache buildSectionsIfNeeded:section];
            [self.dd_indexPathSizeCache enumerateAllOrientationsUsingBlock:^(FDIndexPathSizesBySection *sizesBySection) {
                [sizesBySection[section] removeAllObjects];
            }];

        }];
    }
    DDPrimaryCall([self dd_reloadSections:sections];);
}

- (void)dd_moveSection:(NSInteger)section toSection:(NSInteger)newSection {
    if (self.dd_indexPathSizeCache.automaticallyInvalidateEnabled) {
        [self.dd_indexPathSizeCache buildSectionsIfNeeded:section];
        [self.dd_indexPathSizeCache buildSectionsIfNeeded:newSection];
        [self.dd_indexPathSizeCache enumerateAllOrientationsUsingBlock:^(FDIndexPathSizesBySection *sizesBySection) {
            [sizesBySection exchangeObjectAtIndex:section withObjectAtIndex:newSection];
        }];
    }
    DDPrimaryCall([self dd_moveSection:section toSection:newSection];);
}

- (void)dd_insertItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {
    if (self.dd_indexPathSizeCache.automaticallyInvalidateEnabled) {
        [self.dd_indexPathSizeCache buildCachesAtIndexPathsIfNeeded:indexPaths];
        [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath *indexPath, NSUInteger idx, BOOL *stop) {
            [self.dd_indexPathSizeCache enumerateAllOrientationsUsingBlock:^(FDIndexPathSizesBySection *sizesBySection) {
                [sizesBySection[indexPath.section] insertObject:@-1 atIndex:indexPath.row];
            }];
        }];
    }
    DDPrimaryCall([self dd_insertItemsAtIndexPaths:indexPaths];);
}

- (void)dd_deleteItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {
    if (self.dd_indexPathSizeCache.automaticallyInvalidateEnabled) {
        [self.dd_indexPathSizeCache buildCachesAtIndexPathsIfNeeded:indexPaths];
        
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
            [self.dd_indexPathSizeCache enumerateAllOrientationsUsingBlock:^(FDIndexPathSizesBySection *sizesBySection) {
                [sizesBySection[key.integerValue] removeObjectsAtIndexes:indexSet];
            }];
        }];
    }
    DDPrimaryCall([self dd_deleteItemsAtIndexPaths:indexPaths];);
}

- (void)dd_reloadItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {
    if (self.dd_indexPathSizeCache.automaticallyInvalidateEnabled) {
        [self.dd_indexPathSizeCache buildCachesAtIndexPathsIfNeeded:indexPaths];
        [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath *indexPath, NSUInteger idx, BOOL *stop) {
            [self.dd_indexPathSizeCache enumerateAllOrientationsUsingBlock:^(FDIndexPathSizesBySection *sizesBySection) {
                sizesBySection[indexPath.section][indexPath.row] = @-1;
            }];
        }];
    }
    DDPrimaryCall([self dd_reloadItemsAtIndexPaths:indexPaths];);
}

- (void)dd_moveItemAtIndexPath:(NSIndexPath *)indexPath toIndexPath:(NSIndexPath *)newIndexPath {
    if (self.dd_indexPathSizeCache.automaticallyInvalidateEnabled) {
        [self.dd_indexPathSizeCache buildCachesAtIndexPathsIfNeeded:@[indexPath, newIndexPath]];
        [self.dd_indexPathSizeCache enumerateAllOrientationsUsingBlock:^(FDIndexPathSizesBySection *sizesBySection) {
            NSMutableArray<NSValue *> *sourceItems = sizesBySection[indexPath.section];
            NSMutableArray<NSValue *> *destinationItems = sizesBySection[newIndexPath.section];
            NSValue *sourceValue = sourceItems[indexPath.item];
            NSValue *destinationValue = destinationItems[newIndexPath.item];
            sourceItems[indexPath.item] = destinationValue;
            destinationItems[newIndexPath.item] = sourceValue;
        }];
    }
    DDPrimaryCall([self dd_moveItemAtIndexPath:indexPath toIndexPath:newIndexPath];);
}

@end
