#import "DDTableViewComponent.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDTableViewSectionGroupComponent : DDTableViewBaseComponent

@property (strong, nonatomic, nullable) NSArray<DDTableViewBaseComponent *> *subComponents;

- (__kindof DDTableViewBaseComponent * _Nullable)componentAtSection:(NSInteger)atSection;

@end

@interface DDTableViewRootComponent : DDTableViewSectionGroupComponent

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

/**
 Like
 '- (instancetype)initWithTableView:(UITableView *)tableView bind:(BOOL)bind;'
 And bind is YES.
 */
- (instancetype)initWithTableView:(UITableView *)tableView;

/**
 Attach to a table view. It will override its delegate and dataSource.
 But it will not override scroll delegate.

 @param tableView Bind to tableView.
 @param bind Yes will override delegate and dataSource.
 */
- (instancetype)initWithTableView:(UITableView *)tableView bind:(BOOL)bind;

@end

NS_ASSUME_NONNULL_END
