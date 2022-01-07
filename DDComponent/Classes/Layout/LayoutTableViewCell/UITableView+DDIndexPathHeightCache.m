#import "UITableView+DDIndexPathHeightCache.h"
#import <objc/runtime.h>

typedef NSMutableArray<NSMutableArray<NSNumber *> *> FDIndexPathHeightsBySection;

@interface DDIndexPathHeightCache ()
@property (nonatomic, strong) FDIndexPathHeightsBySection *heightsBySectionForPortrait;
@property (nonatomic, strong) FDIndexPathHeightsBySection *heightsBySectionForLandscape;
@end

@implementation DDIndexPathHeightCache

- (instancetype)init {
    self = [super init];
    if (self) {
        _heightsBySectionForPortrait = [NSMutableArray array];
        _heightsBySectionForLandscape = [NSMutableArray array];
    }
    return self;
}

- (FDIndexPathHeightsBySection *)heightsBySectionForCurrentOrientation {
    return UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation) ? self.heightsBySectionForPortrait: self.heightsBySectionForLandscape;
}

- (void)enumerateAllOrientationsUsingBlock:(void (^)(FDIndexPathHeightsBySection *heightsBySection))block {
    block(self.heightsBySectionForPortrait);
    block(self.heightsBySectionForLandscape);
}

- (BOOL)existsHeightAtIndexPath:(NSIndexPath *)indexPath {
    [self buildCachesAtIndexPathsIfNeeded:@[indexPath]];
    NSNumber *number = self.heightsBySectionForCurrentOrientation[indexPath.section][indexPath.row];
    return ![number isEqualToNumber:@-1];
}

- (void)cacheHeight:(CGFloat)height byIndexPath:(NSIndexPath *)indexPath {
    self.automaticallyInvalidateEnabled = YES;
    [self buildCachesAtIndexPathsIfNeeded:@[indexPath]];
    self.heightsBySectionForCurrentOrientation[indexPath.section][indexPath.row] = @(height);
}

- (CGFloat)heightForIndexPath:(NSIndexPath *)indexPath {
    [self buildCachesAtIndexPathsIfNeeded:@[indexPath]];
    NSNumber *number = self.heightsBySectionForCurrentOrientation[indexPath.section][indexPath.row];
#if CGFLOAT_IS_DOUBLE
    return number.doubleValue;
#else
    return number.floatValue;
#endif
}

- (void)invalidateHeightAtIndexPath:(NSIndexPath *)indexPath {
    [self buildCachesAtIndexPathsIfNeeded:@[indexPath]];
    [self enumerateAllOrientationsUsingBlock:^(FDIndexPathHeightsBySection *heightsBySection) {
        heightsBySection[indexPath.section][indexPath.row] = @-1;
    }];
}

- (void)invalidateAllHeightCache {
    [self enumerateAllOrientationsUsingBlock:^(FDIndexPathHeightsBySection *heightsBySection) {
        [heightsBySection removeAllObjects];
    }];
}

- (void)buildCachesAtIndexPathsIfNeeded:(NSArray *)indexPaths {
    // Build every section array or row array which is smaller than given index path.
    [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath *indexPath, NSUInteger idx, BOOL *stop) {
        [self buildSectionsIfNeeded:indexPath.section];
        [self buildRowsIfNeeded:indexPath.row inExistSection:indexPath.section];
    }];
}

- (void)buildSectionsIfNeeded:(NSInteger)targetSection {
    [self enumerateAllOrientationsUsingBlock:^(FDIndexPathHeightsBySection *heightsBySection) {
        for (NSInteger section = 0; section <= targetSection; ++section) {
            if (section >= heightsBySection.count) {
                heightsBySection[section] = [NSMutableArray array];
            }
        }
    }];
}

- (void)buildRowsIfNeeded:(NSInteger)targetRow inExistSection:(NSInteger)section {
    [self enumerateAllOrientationsUsingBlock:^(FDIndexPathHeightsBySection *heightsBySection) {
        NSMutableArray<NSNumber *> *heightsByRow = heightsBySection[section];
        for (NSInteger row = 0; row <= targetRow; ++row) {
            if (row >= heightsByRow.count) {
                heightsByRow[row] = @-1;
            }
        }
    }];
}

@end

@implementation UITableView (DDIndexPathHeightCache)

- (DDIndexPathHeightCache *)dd_indexPathHeightCache {
    DDIndexPathHeightCache *cache = objc_getAssociatedObject(self, _cmd);
    if (!cache) {
        cache = [DDIndexPathHeightCache new];
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

@implementation UITableView (DDIndexPathHeightCacheInvalidation)

- (void)dd_reloadDataWithoutInvalidateIndexPathHeightCache {
    DDPrimaryCall([self dd_reloadData];);
}

+ (void)load {
    // All methods that trigger height cache's invalidation
    SEL selectors[] = {
        @selector(reloadData),
        @selector(insertSections:withRowAnimation:),
        @selector(deleteSections:withRowAnimation:),
        @selector(reloadSections:withRowAnimation:),
        @selector(moveSection:toSection:),
        @selector(insertRowsAtIndexPaths:withRowAnimation:),
        @selector(deleteRowsAtIndexPaths:withRowAnimation:),
        @selector(reloadRowsAtIndexPaths:withRowAnimation:),
        @selector(moveRowAtIndexPath:toIndexPath:)
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
    if (self.dd_indexPathHeightCache.automaticallyInvalidateEnabled) {
        [self.dd_indexPathHeightCache enumerateAllOrientationsUsingBlock:^(FDIndexPathHeightsBySection *heightsBySection) {
            [heightsBySection removeAllObjects];
        }];
    }
    DDPrimaryCall([self dd_reloadData];);
}

- (void)dd_insertSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation {
    if (self.dd_indexPathHeightCache.automaticallyInvalidateEnabled) {
        [sections enumerateIndexesUsingBlock:^(NSUInteger section, BOOL *stop) {
            [self.dd_indexPathHeightCache buildSectionsIfNeeded:section];
            [self.dd_indexPathHeightCache enumerateAllOrientationsUsingBlock:^(FDIndexPathHeightsBySection *heightsBySection) {
                [heightsBySection insertObject:[NSMutableArray array] atIndex:section];
            }];
        }];
    }
    DDPrimaryCall([self dd_insertSections:sections withRowAnimation:animation];);
}

- (void)dd_deleteSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation {
    if (self.dd_indexPathHeightCache.automaticallyInvalidateEnabled) {
        [sections enumerateIndexesUsingBlock:^(NSUInteger section, BOOL *stop) {
            [self.dd_indexPathHeightCache buildSectionsIfNeeded:section];
            [self.dd_indexPathHeightCache enumerateAllOrientationsUsingBlock:^(FDIndexPathHeightsBySection *heightsBySection) {
                [heightsBySection removeObjectAtIndex:section];
            }];
        }];
    }
    DDPrimaryCall([self dd_deleteSections:sections withRowAnimation:animation];);
}

- (void)dd_reloadSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation {
    if (self.dd_indexPathHeightCache.automaticallyInvalidateEnabled) {
        [sections enumerateIndexesUsingBlock: ^(NSUInteger section, BOOL *stop) {
            [self.dd_indexPathHeightCache buildSectionsIfNeeded:section];
            [self.dd_indexPathHeightCache enumerateAllOrientationsUsingBlock:^(FDIndexPathHeightsBySection *heightsBySection) {
                [heightsBySection[section] removeAllObjects];
            }];

        }];
    }
    DDPrimaryCall([self dd_reloadSections:sections withRowAnimation:animation];);
}

- (void)dd_moveSection:(NSInteger)section toSection:(NSInteger)newSection {
    if (self.dd_indexPathHeightCache.automaticallyInvalidateEnabled) {
        [self.dd_indexPathHeightCache buildSectionsIfNeeded:section];
        [self.dd_indexPathHeightCache buildSectionsIfNeeded:newSection];
        [self.dd_indexPathHeightCache enumerateAllOrientationsUsingBlock:^(FDIndexPathHeightsBySection *heightsBySection) {
            [heightsBySection exchangeObjectAtIndex:section withObjectAtIndex:newSection];
        }];
    }
    DDPrimaryCall([self dd_moveSection:section toSection:newSection];);
}

- (void)dd_insertRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation {
    if (self.dd_indexPathHeightCache.automaticallyInvalidateEnabled) {
        [self.dd_indexPathHeightCache buildCachesAtIndexPathsIfNeeded:indexPaths];
        [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath *indexPath, NSUInteger idx, BOOL *stop) {
            [self.dd_indexPathHeightCache enumerateAllOrientationsUsingBlock:^(FDIndexPathHeightsBySection *heightsBySection) {
                [heightsBySection[indexPath.section] insertObject:@-1 atIndex:indexPath.row];
            }];
        }];
    }
    DDPrimaryCall([self dd_insertRowsAtIndexPaths:indexPaths withRowAnimation:animation];);
}

- (void)dd_deleteRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation {
    if (self.dd_indexPathHeightCache.automaticallyInvalidateEnabled) {
        [self.dd_indexPathHeightCache buildCachesAtIndexPathsIfNeeded:indexPaths];
        
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
            [self.dd_indexPathHeightCache enumerateAllOrientationsUsingBlock:^(FDIndexPathHeightsBySection *heightsBySection) {
                [heightsBySection[key.integerValue] removeObjectsAtIndexes:indexSet];
            }];
        }];
    }
    DDPrimaryCall([self dd_deleteRowsAtIndexPaths:indexPaths withRowAnimation:animation];);
}

- (void)dd_reloadRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation {
    if (self.dd_indexPathHeightCache.automaticallyInvalidateEnabled) {
        [self.dd_indexPathHeightCache buildCachesAtIndexPathsIfNeeded:indexPaths];
        [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath *indexPath, NSUInteger idx, BOOL *stop) {
            [self.dd_indexPathHeightCache enumerateAllOrientationsUsingBlock:^(FDIndexPathHeightsBySection *heightsBySection) {
                heightsBySection[indexPath.section][indexPath.row] = @-1;
            }];
        }];
    }
    DDPrimaryCall([self dd_reloadRowsAtIndexPaths:indexPaths withRowAnimation:animation];);
}

- (void)dd_moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    if (self.dd_indexPathHeightCache.automaticallyInvalidateEnabled) {
        [self.dd_indexPathHeightCache buildCachesAtIndexPathsIfNeeded:@[sourceIndexPath, destinationIndexPath]];
        [self.dd_indexPathHeightCache enumerateAllOrientationsUsingBlock:^(FDIndexPathHeightsBySection *heightsBySection) {
            NSMutableArray<NSNumber *> *sourceRows = heightsBySection[sourceIndexPath.section];
            NSMutableArray<NSNumber *> *destinationRows = heightsBySection[destinationIndexPath.section];
            NSNumber *sourceValue = sourceRows[sourceIndexPath.row];
            NSNumber *destinationValue = destinationRows[destinationIndexPath.row];
            sourceRows[sourceIndexPath.row] = destinationValue;
            destinationRows[destinationIndexPath.row] = sourceValue;
        }];
    }
    DDPrimaryCall([self dd_moveRowAtIndexPath:sourceIndexPath toIndexPath:destinationIndexPath];);
}

@end
