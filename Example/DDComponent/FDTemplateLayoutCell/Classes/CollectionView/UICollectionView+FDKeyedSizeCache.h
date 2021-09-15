//
//  UICollectionView+FDKeyedSizeCache.h
//  Demo
//
//  Created by mac on 2021/9/14.
//  Copyright © 2021 forkingdog. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FDKeyedSizeCache : NSObject

- (BOOL)existsSizeForKey:(id<NSCopying>)key;
- (void)cacheSize:(CGSize)size byKey:(id<NSCopying>)key;
- (CGSize)sizeForKey:(id<NSCopying>)key;

// Invalidation
- (void)invalidateSizeForKey:(id<NSCopying>)key;
- (void)invalidateAllSizeCache;
@end

@interface UICollectionView (FDKeyedSizeCache)

/// Size cache by key. Generally, you don't need to use it directly.
@property (nonatomic, strong, readonly) FDKeyedSizeCache *fd_keyedSizeCache;

@end

NS_ASSUME_NONNULL_END
