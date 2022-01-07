#import "UIView+DDComponentLayout.h"

@implementation UIView (DDComponentLayout)

- (CGSize)sizeThatFits:(CGSize)maxSize layoutSize:(DDComponentLayoutSize *)layoutSize
{
    NSAssert(layoutSize, @"Must set layoutSize!");
    
    CGSize effectiveSize = [layoutSize effectiveSizeForContentSize:maxSize];
    
    // Fixed width
    if (!layoutSize.widthDimension.isEstimated && layoutSize.heightDimension.isEstimated) {
        NSLayoutConstraint *temp = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:maxSize.width];
        [self addConstraint:temp];
        effectiveSize = [self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        [self removeConstraint:temp];
    }
    
    // Fixed height
    if (layoutSize.widthDimension.isEstimated && !layoutSize.heightDimension.isEstimated) {
        NSLayoutConstraint *temp = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:maxSize.height];
        [self addConstraint:temp];
        effectiveSize = [self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        [self removeConstraint:temp];
    }
    
    // Dynamic size
    if (layoutSize.widthDimension.isEstimated && layoutSize.heightDimension.isEstimated) {
        effectiveSize = [self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    }
        
    return effectiveSize;
}

@end
