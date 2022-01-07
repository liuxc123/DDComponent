#import <UIKit/UIKit.h>

@interface UITableView (DDTemplateLayoutCellDebug)

/// Helps to debug or inspect what is this "DDTemplateLayoutCell" extention doing,
/// turning on to print logs when "creating", "calculating", "precaching" or "hitting cache".
///
/// Default to NO, log by NSLog.
///
@property (nonatomic, assign) BOOL dd_debugLogEnabled;

/// Debug log controlled by "dd_debugLogEnabled".
- (void)dd_debugLog:(NSString *)message;

@end
