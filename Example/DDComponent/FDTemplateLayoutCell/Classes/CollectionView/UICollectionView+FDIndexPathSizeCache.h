//
//  UICollectionView+FDIndexPathSizeCache.h
//  Demo
//
//  Created by mac on 2021/9/14.
//  Copyright © 2021 forkingdog. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FDIndexPathSizeCache : NSObject

// Enable automatically if you're using index path driven size cache
@property (nonatomic, assign) BOOL automaticallyInvalidateEnabled;

// Size cache
- (BOOL)existsSizeAtIndexPath:(NSIndexPath *)indexPath;
- (void)cacheSize:(CGSize)size byIndexPath:(NSIndexPath *)indexPath;
- (CGSize)sizeForIndexPath:(NSIndexPath *)indexPath;
- (void)invalidateSizeAtIndexPath:(NSIndexPath *)indexPath;
- (void)invalidateAllSizeCache;

@end

@interface UICollectionView (FDIndexPathSizeCache)

/// Size cache by index path. Generally, you don't need to use it directly.
@property (nonatomic, strong, readonly) FDIndexPathSizeCache *fd_indexPathSizeCache;

@end

@interface UICollectionView (FDIndexPathSizeCacheInvalidation)
/// Call this method when you want to reload data but don't want to invalidate
/// all size cache by index path, for example, load more data at the bottom of
/// collection view.
- (void)fd_reloadDataWithoutInvalidateIndexPathSizeCache;
@end

NS_ASSUME_NONNULL_END
