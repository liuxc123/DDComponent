//
//  UIView+DDComponentLayout.m
//  DDComponent_Example
//
//  Created by mac on 2021/9/13.
//  Copyright © 2021 liuxc123. All rights reserved.
//

#import "UIView+DDComponentLayout.h"

@implementation UIView (DDComponentLayout)

- (CGSize)sizeThatFits:(CGSize)maxSize layoutSize:(DDComponentLayoutSize *)layoutSize
{
    NSAssert(layoutSize, @"Must set layoutSize!");
    
    CGSize effectiveSize = [self dd_effectiveSizeForContentSize:maxSize layoutSize:layoutSize];
    
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

- (CGSize)dd_effectiveSizeForContentSize:(CGSize)contentSize layoutSize:(DDComponentLayoutSize *)layoutSize  {
    CGSize effectiveSize = CGSizeZero;

    DDComponentLayoutDimension *widthDimension = layoutSize.widthDimension;
    DDComponentLayoutDimension *heightDimension = layoutSize.heightDimension;

    if (widthDimension.isFractionalWidth) {
        effectiveSize.width = contentSize.width * widthDimension.dimension;
    }
    if (widthDimension.isFractionalHeight) {
        effectiveSize.width = contentSize.height * widthDimension.dimension;
    }
    if (widthDimension.isAbsolute) {
        effectiveSize.width = widthDimension.dimension;
    }
    if (widthDimension.isEstimated) {
        effectiveSize.width = widthDimension.dimension;
    }

    if (heightDimension.isFractionalWidth) {
        effectiveSize.height = contentSize.width * heightDimension.dimension;
    }
    if (heightDimension.isFractionalHeight) {
        effectiveSize.height = contentSize.height * heightDimension.dimension;
    }
    if (heightDimension.isAbsolute) {
        effectiveSize.height = heightDimension.dimension;
    }
    if (heightDimension.isEstimated) {
        effectiveSize.height = heightDimension.dimension;
    }

    return effectiveSize;
}

@end
