#import <UIKit/UIKit.h>
#import "DDComponentLayoutSize.h"
#import "DDComponentLayoutDimension.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIView (DDComponentLayout)

@property (nonatomic, copy, nullable) DDComponentLayoutSize *layoutSize;

- (CGSize)dd_sizeThatFits:(CGSize)size;

- (CGSize)dd_sizeThatFits:(CGSize)size layoutSize:(DDComponentLayoutSize *)layoutSize;

@end

@interface UICollectionViewCell (DDComponentLayout)

- (UICollectionViewLayoutAttributes *)dd_preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes;

@end

@interface UICollectionReusableView (DDComponentLayout)

- (UICollectionViewLayoutAttributes *)dd_preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes;

@end

NS_ASSUME_NONNULL_END
