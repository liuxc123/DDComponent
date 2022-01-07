#import <UIKit/UIKit.h>

@interface DDKeyedHeightCache : NSObject

- (BOOL)existsHeightForKey:(id<NSCopying>)key;
- (void)cacheHeight:(CGFloat)height byKey:(id<NSCopying>)key;
- (CGFloat)heightForKey:(id<NSCopying>)key;

// Invalidation
- (void)invalidateHeightForKey:(id<NSCopying>)key;
- (void)invalidateAllHeightCache;
@end

@interface UITableView (DDKeyedHeightCache)

/// Height cache by key. Generally, you don't need to use it directly.
@property (nonatomic, strong, readonly) DDKeyedHeightCache *dd_keyedHeightCache;
@end
