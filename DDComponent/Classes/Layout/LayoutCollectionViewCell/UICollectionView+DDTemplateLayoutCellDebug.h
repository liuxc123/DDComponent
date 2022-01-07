#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UICollectionView (DDTemplateLayoutCellDebug)

/// Helps to debug or inspect what is this "DDTemplateLayoutCell" extention doing,
/// turning on to print logs when "creating", "calculating", "precaching" or "hitting cache".
///
/// Default to NO, log by NSLog.
///
@property (nonatomic, assign) BOOL dd_debugLogEnabled;

/// Debug log controlled by "dd_debugLogEnabled".
- (void)dd_debugLog:(NSString *)message;

@end

NS_ASSUME_NONNULL_END
