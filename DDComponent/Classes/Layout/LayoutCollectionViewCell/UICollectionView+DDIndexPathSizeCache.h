#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDIndexPathSizeCache : NSObject

// Enable automatically if you're using index path driven size cache
@property (nonatomic, assign) BOOL automaticallyInvalidateEnabled;

// Size cache
- (BOOL)existsSizeAtIndexPath:(NSIndexPath *)indexPath;
- (void)cacheSize:(CGSize)size byIndexPath:(NSIndexPath *)indexPath;
- (CGSize)sizeForIndexPath:(NSIndexPath *)indexPath;
- (void)invalidateSizeAtIndexPath:(NSIndexPath *)indexPath;
- (void)invalidateAllSizeCache;

@end

@interface UICollectionView (DDIndexPathSizeCache)

/// Size cache by index path. Generally, you don't need to use it directly.
@property (nonatomic, strong, readonly) DDIndexPathSizeCache *dd_indexPathSizeCache;

@end

@interface UICollectionView (DDIndexPathSizeCacheInvalidation)
/// Call this method when you want to reload data but don't want to invalidate
/// all size cache by index path, for example, load more data at the bottom of
/// collection view.
- (void)dd_reloadDataWithoutInvalidateIndexPathSizeCache;
@end

NS_ASSUME_NONNULL_END
