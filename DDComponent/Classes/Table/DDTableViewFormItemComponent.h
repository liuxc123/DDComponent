#import <UIKit/UIKit.h>
#import "DDTableViewItemComponent.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDTableViewFormItemComponent : DDTableViewItemComponent

@property (nonatomic, strong, readonly) UIView *itemView;

- (instancetype)initWithItemView:(UIView *)itemView;

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
