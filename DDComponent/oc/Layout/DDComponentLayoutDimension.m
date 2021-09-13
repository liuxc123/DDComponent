//
//  DDComponentLayoutDimension.m
//  DDComponent_Example
//
//  Created by mac on 2021/9/7.
//  Copyright © 2021 liuxc123. All rights reserved.
//

#import "DDComponentLayoutDimension.h"

typedef NS_ENUM(NSUInteger, DDComponentLayoutDimensionSemantic) {
    DDComponentLayoutDimensionSemanticFractionalWidth,
    DDComponentLayoutDimensionSemanticFractionalHeight,
    DDComponentLayoutDimensionSemanticAbsolute,
    DDComponentLayoutDimensionSemanticEstimated,
};

@interface DDComponentLayoutDimension()

@property (nonatomic, readwrite) CGFloat dimension;
@property (nonatomic) DDComponentLayoutDimensionSemantic semantic;

@end

@implementation DDComponentLayoutDimension

+ (instancetype)fractionalWidthDimension:(CGFloat)fractionalWidth {
    return [self dimensionWithDimension:fractionalWidth semantic:DDComponentLayoutDimensionSemanticFractionalWidth];
}

+ (instancetype)fractionalHeightDimension:(CGFloat)fractionalHeight {
    return [self dimensionWithDimension:fractionalHeight semantic:DDComponentLayoutDimensionSemanticFractionalHeight];
}

+ (instancetype)absoluteDimension:(CGFloat)absoluteDimension {
    return [self dimensionWithDimension:absoluteDimension semantic:DDComponentLayoutDimensionSemanticAbsolute];
}

+ (instancetype)estimatedDimension:(CGFloat)estimatedDimension {
    return [self dimensionWithDimension:estimatedDimension semantic:DDComponentLayoutDimensionSemanticEstimated];
}

+ (instancetype)dimensionWithDimension:(CGFloat)dimension semantic:(DDComponentLayoutDimensionSemantic)semantic {
    return [[self alloc] initWithDimension:dimension semantic:semantic];
}

- (instancetype)initWithDimension:(CGFloat)dimension semantic:(DDComponentLayoutDimensionSemantic)semantic {
    self = [super init];
    if (self) {
        self.dimension = dimension;
        self.semantic = semantic;
    }
    return self;
}

- (BOOL)isFractionalWidth {
    return self.semantic == DDComponentLayoutDimensionSemanticFractionalWidth;
}

- (BOOL)isFractionalHeight {
    return self.semantic == DDComponentLayoutDimensionSemanticFractionalHeight;
}

- (BOOL)isAbsolute {
    return self.semantic == DDComponentLayoutDimensionSemanticAbsolute;
}

- (BOOL)isEstimated {
    return self.semantic == DDComponentLayoutDimensionSemanticEstimated;
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    return [DDComponentLayoutDimension dimensionWithDimension:self.dimension semantic:self.semantic];
}

@end
