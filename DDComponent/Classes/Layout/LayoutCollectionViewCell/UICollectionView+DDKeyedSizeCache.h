#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDKeyedSizeCache : NSObject

- (BOOL)existsSizeForKey:(id<NSCopying>)key;
- (void)cacheSize:(CGSize)size byKey:(id<NSCopying>)key;
- (CGSize)sizeForKey:(id<NSCopying>)key;

// Invalidation
- (void)invalidateSizeForKey:(id<NSCopying>)key;
- (void)invalidateAllSizeCache;
@end

@interface UICollectionView (DDKeyedSizeCache)

/// Size cache by key. Generally, you don't need to use it directly.
@property (nonatomic, strong, readonly) DDKeyedSizeCache *dd_keyedSizeCache;

@end

NS_ASSUME_NONNULL_END
