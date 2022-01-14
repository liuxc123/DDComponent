#import "UIView+DDComponentLayout.h"

@implementation UIView (DDComponentLayout)

- (CGSize)sizeThatFits:(CGSize)maxSize layoutSize:(DDComponentLayoutSize *)layoutSize
{
    NSAssert(layoutSize, @"Must set layoutSize!");
    
    CGSize effectiveSize = [layoutSize effectiveSizeForContentSize:maxSize];
    
    // Fixed effective frame
    CGRect originFrame = self.frame;
    CGRect frame = self.frame;
    frame.size = effectiveSize;
    self.frame = frame;
    
    // Fixed width
    if (!layoutSize.widthDimension.isEstimated && layoutSize.heightDimension.isEstimated) {
        NSLayoutConstraint *temp = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:maxSize.width];
        [self addConstraint:temp];
        effectiveSize = [self systemLayoutSizeFittingSize:effectiveSize];
        [self removeConstraint:temp];
    }
    
    // Fixed height
    if (layoutSize.widthDimension.isEstimated && !layoutSize.heightDimension.isEstimated) {
        NSLayoutConstraint *temp = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:maxSize.height];
        [self addConstraint:temp];
        effectiveSize = [self systemLayoutSizeFittingSize:effectiveSize];
        [self removeConstraint:temp];
    }
    
    // Dynamic size
    if (layoutSize.widthDimension.isEstimated && layoutSize.heightDimension.isEstimated) {
        effectiveSize = [self systemLayoutSizeFittingSize:effectiveSize];
    }
    
    NSLog(@"%@", [NSString stringWithFormat:@"calculate using system fitting size (AutoLayout) - %@", @(effectiveSize)]);
    
    // Restore origin frame
    self.frame = originFrame;
        
    return effectiveSize;
}

@end
