#import "UIView+DDComponentLayout.h"
#import "UIView+DDComponentLayoutDebug.h"
#import <objc/runtime.h>

@implementation UIView (DDComponentLayout)

- (DDComponentLayoutSize *)layoutSize {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setLayoutSize:(DDComponentLayoutSize *)layoutSize {
    objc_setAssociatedObject(self, @selector(layoutSize), layoutSize, OBJC_ASSOCIATION_COPY_NONATOMIC);

}

- (CGSize)dd_sizeThatFits:(CGSize)size {
    if (self.layoutSize) {
        return [self dd_sizeThatFits:size layoutSize:self.layoutSize];
    }
    return size;
}

- (CGSize)dd_sizeThatFits:(CGSize)maxSize layoutSize:(DDComponentLayoutSize *)layoutSize
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
    
    [self dd_debugLog:[NSString stringWithFormat:@"calculate using system fitting size (AutoLayout) - %@", @(effectiveSize)]];
    
    // Restore origin frame
    self.frame = originFrame;
        
    return effectiveSize;
}

@end


@implementation UICollectionViewCell (DDComponentLayout)

- (UICollectionViewLayoutAttributes *)dd_preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    
    if (self.layoutSize) {
        [self setNeedsLayout];
        [self layoutIfNeeded];
        
        CGRect frame = layoutAttributes.frame;
        frame.size = [self dd_sizeThatFits:layoutAttributes.frame.size layoutSize:self.layoutSize];
        layoutAttributes.frame = frame;
    }
    
    return layoutAttributes;
}

@end

@implementation UICollectionReusableView (DDComponentLayout)

- (UICollectionViewLayoutAttributes *)dd_preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    
    if (self.layoutSize) {
        [self setNeedsLayout];
        [self layoutIfNeeded];
        
        CGRect frame = layoutAttributes.frame;
        frame.size = [self dd_sizeThatFits:layoutAttributes.frame.size layoutSize:self.layoutSize];
        layoutAttributes.frame = frame;
    }
    
    return layoutAttributes;
}

@end
