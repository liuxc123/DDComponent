#import <UIKit/UIKit.h>
#import "UICollectionView+DDKeyedSizeCache.h"
#import "UICollectionView+DDIndexPathSizeCache.h"
#import "UICollectionView+DDTemplateLayoutCellDebug.h"

NS_ASSUME_NONNULL_BEGIN

@interface UICollectionView (DDTemplateLayoutCell)

/// Access to internal template layout cell for given reuse identifier.
/// Generally, you don't need to know these template layout cells.
///
/// @param identifier Reuse identifier for cell which must be registered.
///
- (__kindof UICollectionViewCell *)dd_templateCellForReuseIdentifier:(NSString *)identifier
                                                        forIndexPath:(NSIndexPath *)indexPath;

/// Returns height of cell of type specifed by a reuse identifier and configured
/// by the configuration block.
///
/// The cell would be layed out on a fixed-width, vertically expanding basis with
/// respect to its dynamic content, using auto layout. Thus, it is imperative that
/// the cell was set up to be self-satisfied, i.e. its content always determines
/// its height given the width is equal to the tableview's.
///
/// @param identifier A string identifier for retrieving and maintaining template
///        cells with system's "-dequeueReusableCellWithIdentifier:" call.
/// @param configuration An optional block for configuring and providing content
///        to the template cell. The configuration should be minimal for scrolling
///        performance yet sufficient for calculating cell's height.
///
- (CGSize)dd_sizeForCellWithIdentifier:(NSString *)identifier
                             indexPath:(NSIndexPath *)indexPath
                         configuration:(void (^)(id cell))configuration;

- (CGSize)dd_sizeForCellWithIdentifier:(NSString *)identifier
                            fixedWidth:(CGFloat)fixedWidth
                             indexPath:(NSIndexPath *)indexPath
                         configuration:(void (^)(id cell))configuration;

- (CGSize)dd_sizeForCellWithIdentifier:(NSString *)identifier
                           fixedHeight:(CGFloat)fixedHeight
                             indexPath:(NSIndexPath *)indexPath
                         configuration:(void (^)(id cell))configuration;


/// This method does what "-dd_heightForCellWithIdentifier:configuration" does, and
/// calculated height will be cached by its index path, returns a cached height
/// when needed. Therefore lots of extra height calculations could be saved.
///
/// No need to worry about invalidating cached heights when data source changes, it
/// will be done automatically when you call "-reloadData" or any method that triggers
/// UITableView's reloading.
///
/// @param indexPath where this cell's height cache belongs.
///
- (CGSize)dd_sizeForCellWithIdentifier:(NSString *)identifier
                      cacheByIndexPath:(NSIndexPath *)indexPath
                         configuration:(void (^)(id cell))configuration;

- (CGSize)dd_sizeForCellWithIdentifier:(NSString *)identifier
                            fixedWidth:(CGFloat)fixedWidth
                      cacheByIndexPath:(NSIndexPath *)indexPath
                         configuration:(void (^)(id cell))configuration;

- (CGSize)dd_sizeForCellWithIdentifier:(NSString *)identifier
                           fixedHeight:(CGFloat)fixedHeight
                      cacheByIndexPath:(NSIndexPath *)indexPath
                         configuration:(void (^)(id cell))configuration;

/// This method caches height by your model entity's identifier.
/// If your model's changed, call "-invalidateHeightForKey:(id <NSCopying>)key" to
/// invalidate cache and re-calculate, it's much cheaper and effective than "cacheByIndexPath".
///
/// @param key model entity's identifier whose data configures a cell.
///
- (CGSize)dd_sizeForCellWithIdentifier:(NSString *)identifier
                            cacheByKey:(id<NSCopying>)key
                             indexPath:(NSIndexPath *)indexPath
                         configuration:(void (^)(id cell))configuration;

- (CGSize)dd_sizeForCellWithIdentifier:(NSString *)identifier
                            fixedWidth:(CGFloat)fixedWidth
                            cacheByKey:(id<NSCopying>)key
                             indexPath:(NSIndexPath *)indexPath
                         configuration:(void (^)(id cell))configuration;

- (CGSize)dd_sizeForCellWithIdentifier:(NSString *)identifier
                           fixedHeight:(CGFloat)fixedHeight
                            cacheByKey:(id<NSCopying>)key
                             indexPath:(NSIndexPath *)indexPath
                         configuration:(void (^)(id cell))configuration;

@end

@interface UICollectionView (DDTemplateLayoutReusableSupplementaryView)

/// Returns header or footer view's height that registered in table view with reuse identifier.
///
/// Use it after calling "-[UITableView registerNib/Class:forHeaderFooterViewReuseIdentifier]",
/// same with "-dd_heightForCellWithIdentifier:configuration:", it will call "-sizeThatFits:" for
/// subclass of UITableViewHeaderFooterView which is not using Auto Layout.
///
- (CGFloat)dd_sizeForReusableSupplementaryViewWithKind:(NSString *)kind
                                            identifier:(NSString *)identifier
                                             indexPath:(NSIndexPath *)indexPath
                                         configuration:(void (^)(id))configuration;

@end

@interface UICollectionViewCell (DDTemplateLayoutCell)

/// Indicate this is a template layout cell for calculation only.
/// You may need this when there are non-UI side effects when configure a cell.
/// Like:
///   - (void)configureCell:(FooCell *)cell atIndexPath:(NSIndexPath *)indexPath {
///       cell.entity = [self entityAtIndexPath:indexPath];
///       if (!cell.dd_isTemplateLayoutCell) {
///           [self notifySomething]; // non-UI side effects
///       }
///   }
///
@property (nonatomic, assign) BOOL dd_isTemplateLayoutCell;

/// Enable to enforce this template layout cell to use "frame layout" rather than "auto layout",
/// and will ask cell's height by calling "-sizeThatFits:", so you must override this method.
/// Use this property only when you want to manually control this template layout cell's height
/// calculation mode, default to NO.
///
@property (nonatomic, assign) BOOL dd_enforceFrameLayout;

@end

NS_ASSUME_NONNULL_END
