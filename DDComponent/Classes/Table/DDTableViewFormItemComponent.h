//
//  DDTableViewFormItemComponent.h
//  DDComponent_Example
//
//  Created by mac on 2021/9/13.
//  Copyright © 2021 liuxc123. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDTableViewItemComponent.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDTableViewFormItemComponent : DDTableViewItemComponent

@property (nonatomic, strong, readonly) UIView *itemView;

- (instancetype)initWithItemView:(UIView *)itemview;

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
