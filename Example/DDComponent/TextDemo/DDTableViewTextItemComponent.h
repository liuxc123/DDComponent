//
//  DDTableViewTextItemComponent.h
//  DDComponent_Example
//
//  Created by mac on 2021/9/16.
//  Copyright © 2021 liuxc123. All rights reserved.
//

#import <DDComponent/DDComponent.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDTableViewTextItemComponent : DDTableViewItemComponent

@property (nonatomic, copy) void (^deleteAction)(DDTableViewTextItemComponent *item);

+ (instancetype)component:(NSString *)text;

@end

NS_ASSUME_NONNULL_END
