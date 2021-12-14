#import <UIKit/UIKit.h>

extern const CGFloat DDComponentAutomaticDimension;

NS_ASSUME_NONNULL_BEGIN

@class DDTableViewRootComponent;
@protocol DDTableViewComponent <NSObject, UITableViewDelegate, UITableViewDataSource>

@end

@interface DDTableViewBaseComponent : NSObject <DDTableViewComponent>

@property (weak, nonatomic, nullable) DDTableViewBaseComponent *superComponent;
@property (weak, nonatomic, nullable) DDTableViewRootComponent *rootComponent;

/**
 The table host by component. It is nil before RootComponent attach to a tableView.
 */
@property (readonly, weak, nonatomic, nullable) UITableView *tableView;


/**
 Register cell should be here, and only for register! It may invoke many times.
 */
- (void)prepareTableView NS_REQUIRES_SUPER;

/**
 Reload tableView
 */
- (void)reloadData;

/**
 For ItemComponent, {item, section} is equal to indexPath.
 For SectionComponent, {item, section} is equal to first item's indexPath, or Zero.
 For SectionGroupComponent, item should always be 0, section is the first section in the component.
 */
@property (readonly, nonatomic) NSInteger row;
@property (readonly, nonatomic) NSInteger section;

/**
 Convert from Global
 */
- (NSInteger)convertFromGlobalSection:(NSInteger)section;
- (NSIndexPath *)convertFromGlobalIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
