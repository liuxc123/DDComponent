//
//  UICollectionView+FDKeyedSizeCache.m
//  Demo
//
//  Created by mac on 2021/9/14.
//  Copyright © 2021 forkingdog. All rights reserved.
//

#import "UICollectionView+FDKeyedSizeCache.h"
#import <objc/runtime.h>

@interface FDKeyedSizeCache ()
@property (nonatomic, strong) NSMutableDictionary<id<NSCopying>, NSValue *> *mutableSizesByKeyForPortrait;
@property (nonatomic, strong) NSMutableDictionary<id<NSCopying>, NSValue *> *mutableSizesByKeyForLandscape;
@end

@implementation FDKeyedSizeCache

- (instancetype)init {
    self = [super init];
    if (self) {
        _mutableSizesByKeyForPortrait = [NSMutableDictionary dictionary];
        _mutableSizesByKeyForLandscape = [NSMutableDictionary dictionary];
    }
    return self;
}

- (NSMutableDictionary<id<NSCopying>, NSValue *> *)mutableSizesByKeyForCurrentOrientation {
    return UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation) ? self.mutableSizesByKeyForPortrait: self.mutableSizesByKeyForLandscape;
}

- (BOOL)existsSizeForKey:(id<NSCopying>)key {
    NSValue *value = self.mutableSizesByKeyForCurrentOrientation[key];
    return value && ![value isEqualToValue:[NSValue valueWithCGSize:CGSizeMake(-1, -1)]];
}

- (void)cacheSize:(CGSize)size byKey:(id<NSCopying>)key {
    self.mutableSizesByKeyForCurrentOrientation[key] = [NSValue valueWithCGSize:size];
}

- (CGSize)sizeForKey:(id<NSCopying>)key {
    return [self.mutableSizesByKeyForCurrentOrientation[key] CGSizeValue];
}

- (void)invalidateSizeForKey:(id<NSCopying>)key {
    [self.mutableSizesByKeyForPortrait removeObjectForKey:key];
    [self.mutableSizesByKeyForLandscape removeObjectForKey:key];
}

- (void)invalidateAllSizeCache {
    [self.mutableSizesByKeyForPortrait removeAllObjects];
    [self.mutableSizesByKeyForLandscape removeAllObjects];
}

@end

@implementation UICollectionView (FDKeyedSizeCache)

- (FDKeyedSizeCache *)fd_keyedSizeCache {
    FDKeyedSizeCache *cache = objc_getAssociatedObject(self, _cmd);
    if (!cache) {
        cache = [FDKeyedSizeCache new];
        objc_setAssociatedObject(self, _cmd, cache, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return cache;
}

@end
