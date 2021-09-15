//
//  UIView+DDComponentLayout.h
//  DDComponent_Example
//
//  Created by mac on 2021/9/13.
//  Copyright © 2021 liuxc123. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDComponentLayoutDimension.h"
#import "DDComponentLayoutSize.h"

NS_ASSUME_NONNULL_BEGIN

@class DDComponentLayoutDimension;

@interface UIView (DDComponentLayout)

- (CGSize)sizeThatFits:(CGSize)maxSize layoutSize:(DDComponentLayoutSize *)layoutSize;

@end

NS_ASSUME_NONNULL_END
