#import "DDTableViewComponent.h"

// one section, many rows
@interface DDTableViewSectionComponent : DDTableViewBaseComponent

/**
 It will fit the table height  when use DDComponentAutomaticDimension.
 */
@property (assign, nonatomic) CGFloat headerHeight;
@property (assign, nonatomic) CGFloat footerHeight;
@property (assign, nonatomic) CGFloat height;

@end


@interface DDTableViewHeaderFooterSectionComponent : DDTableViewSectionComponent

@property (strong, nonatomic, nullable) __kindof DDTableViewSectionComponent *headerComponent;
@property (strong, nonatomic, nullable) __kindof DDTableViewSectionComponent *footerComponent;
@property (strong, nonatomic, nullable) __kindof DDTableViewSectionComponent *headerFooterComponent;

@end

@interface DDTableViewItemGroupComponent : DDTableViewHeaderFooterSectionComponent

@property (strong, nonatomic, nullable) NSArray<DDTableViewBaseComponent *> *subComponents;

- (__kindof DDTableViewBaseComponent * _Nullable)componentAtRow:(NSInteger)atRow;

@end
