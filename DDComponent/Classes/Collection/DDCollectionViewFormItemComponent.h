#import <UIKit/UIKit.h>
#import "DDCollectionViewItemComponent.h"
#import "UIView+DDComponentLayout.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDCollectionViewFormItemComponent : DDCollectionViewItemComponent

@property (nonatomic, strong, readonly) UIView *itemView;

- (instancetype)initWithItemView:(UIView *)itemView;

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
