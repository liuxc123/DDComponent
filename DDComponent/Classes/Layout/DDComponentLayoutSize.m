//
//  DDComponentLayoutSize.m
//  DDComponent_Example
//
//  Created by mac on 2021/9/7.
//  Copyright © 2021 liuxc123. All rights reserved.
//

#import "DDComponentLayoutSize.h"
#import "DDComponentLayoutDimension.h"

@interface DDComponentLayoutSize()

@property (nonatomic, readwrite) DDComponentLayoutDimension *widthDimension;
@property (nonatomic, readwrite) DDComponentLayoutDimension *heightDimension;

@end

@implementation DDComponentLayoutSize

+ (instancetype)sizeWithWidthDimension:(DDComponentLayoutDimension *)width
                       heightDimension:(DDComponentLayoutDimension *)height {
    return [[self alloc] initWithWidthDimension:width heightDimension:height];
}

- (instancetype)initWithWidthDimension:(DDComponentLayoutDimension *)width
                       heightDimension:(DDComponentLayoutDimension *)height {
    self = [super init];
    if (self) {
        self.widthDimension = width;
        self.heightDimension = height;
    }
    return self;
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    return [DDComponentLayoutSize sizeWithWidthDimension:self.widthDimension heightDimension:self.heightDimension];
}

- (NSString *)widthSemantic {
    if (self.widthDimension.isFractionalWidth) {
        return @".containerWidthFactor";
    }
    if (self.widthDimension.isFractionalHeight) {
        return @".containerHeightFactor";
    }
    if (self.widthDimension.isAbsolute) {
        return @".absolute";
    }
    if (self.widthDimension.isEstimated) {
        return @".estimated";
    }
    return nil;
}

- (NSString *)heightSemantic {
    if (self.heightDimension.isFractionalWidth) {
        return @".containerWidthFactor";
    }
    if (self.heightDimension.isFractionalHeight) {
        return @".containerHeightFactor";
    }
    if (self.heightDimension.isAbsolute) {
        return @".absolute";
    }
    if (self.heightDimension.isEstimated) {
        return @".estimated";
    }
    return nil;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<size=%@; widthSemantic=%@; heightSemantic=%@>", NSStringFromCGSize(CGSizeMake(self.widthDimension.dimension, self.heightDimension.dimension)), self.widthSemantic, self.heightSemantic];
}


@end
