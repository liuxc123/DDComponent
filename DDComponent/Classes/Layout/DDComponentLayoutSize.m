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

- (CGSize)effectiveSizeForContentSize:(CGSize)contentSize {
    CGSize effectiveSize = CGSizeZero;

    DDComponentLayoutDimension *widthDimension = self.widthDimension;
    DDComponentLayoutDimension *heightDimension = self.heightDimension;

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
