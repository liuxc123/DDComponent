#import <UIKit/UIKit.h>
#import "DDComponentLayoutSize.h"
#import "DDComponentLayoutDimension.h"

NS_ASSUME_NONNULL_BEGIN

@class DDComponentLayoutDimension;

@interface UIView (DDComponentLayout)

- (CGSize)sizeThatFits:(CGSize)maxSize layoutSize:(DDComponentLayoutSize *)layoutSize;

@end

NS_ASSUME_NONNULL_END
