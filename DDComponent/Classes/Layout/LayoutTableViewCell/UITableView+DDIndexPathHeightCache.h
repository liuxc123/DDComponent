#import <UIKit/UIKit.h>

@interface DDIndexPathHeightCache : NSObject

// Enable automatically if you're using index path driven height cache
@property (nonatomic, assign) BOOL automaticallyInvalidateEnabled;

// Height cache
- (BOOL)existsHeightAtIndexPath:(NSIndexPath *)indexPath;
- (void)cacheHeight:(CGFloat)height byIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)heightForIndexPath:(NSIndexPath *)indexPath;
- (void)invalidateHeightAtIndexPath:(NSIndexPath *)indexPath;
- (void)invalidateAllHeightCache;

@end

@interface UITableView (DDIndexPathHeightCache)
/// Height cache by index path. Generally, you don't need to use it directly.
@property (nonatomic, strong, readonly) DDIndexPathHeightCache *dd_indexPathHeightCache;
@end

@interface UITableView (DDIndexPathHeightCacheInvalidation)
/// Call this method when you want to reload data but don't want to invalidate
/// all height cache by index path, for example, load more data at the bottom of
/// table view.
- (void)dd_reloadDataWithoutInvalidateIndexPathHeightCache;
@end
