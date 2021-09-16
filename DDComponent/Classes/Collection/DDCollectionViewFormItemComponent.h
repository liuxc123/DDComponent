//
//  DDCollectionViewFormItemComponent.h
//  DDComponent_Example
//
//  Created by mac on 2021/9/7.
//  Copyright © 2021 liuxc123. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDCollectionViewItemComponent.h"
#import "UIView+DDComponentLayout.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDCollectionViewFormItemComponent : DDCollectionViewItemComponent

@property (nonatomic, strong, readonly) UIView *itemView;
@property (nonatomic, copy, readonly) DDComponentLayoutSize *itemSize;

- (instancetype)initWithItemView:(UIView *)itemview itemSize:(DDComponentLayoutSize *)itemSize;

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
