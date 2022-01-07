#import "UICollectionView+DDTemplateLayoutCellDebug.h"
#import <objc/runtime.h>

@implementation UICollectionView (DDTemplateLayoutCellDebug)

- (BOOL)dd_debugLogEnabled {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setDd_debugLogEnabled:(BOOL)debugLogEnabled {
    objc_setAssociatedObject(self, @selector(dd_debugLogEnabled), @(debugLogEnabled), OBJC_ASSOCIATION_RETAIN);
}

- (void)dd_debugLog:(NSString *)message {
    if (self.dd_debugLogEnabled) {
        NSLog(@"** DDTemplateLayoutCell ** %@", message);
    }
}

@end
