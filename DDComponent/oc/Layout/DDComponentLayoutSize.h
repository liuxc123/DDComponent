//
//  DDComponentLayoutSize.h
//  DDComponent_Example
//
//  Created by mac on 2021/9/7.
//  Copyright © 2021 liuxc123. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DDComponentLayoutDimension;

NS_ASSUME_NONNULL_BEGIN

@interface DDComponentLayoutSize : NSObject<NSCopying>

+ (instancetype)sizeWithWidthDimension:(DDComponentLayoutDimension *)width
                       heightDimension:(DDComponentLayoutDimension *)height;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@property (nonatomic, readonly) DDComponentLayoutDimension *widthDimension;
@property (nonatomic, readonly) DDComponentLayoutDimension *heightDimension;

@end

NS_ASSUME_NONNULL_END
