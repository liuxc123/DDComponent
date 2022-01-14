#import "UICollectionView+DDTemplateLayoutCell.h"
#import <objc/runtime.h>

typedef NS_ENUM(NSUInteger, DDTemplateDynamicSizeCaculateType) {
    DDTemplateDynamicSizeCaculateTypeSize = 0,
    DDTemplateDynamicSizeCaculateTypeHeight,
    DDTemplateDynamicSizeCaculateTypeWidth
};

@implementation UICollectionView (DDTemplateLayoutCell)

- (CGSize)dd_systemFittingSizeForConfiguratedCell:(UICollectionViewCell *)cell
                                       fixedValue:(CGFloat)fixedValue
                                     caculateType:(DDTemplateDynamicSizeCaculateType)caculateType {
    
    CGSize fittingSize = CGSizeZero;
    
    if (!cell.dd_enforceFrameLayout) {
        
        if (caculateType != DDTemplateDynamicSizeCaculateTypeSize) {
            
            // update cell frame
            CGRect frame = cell.frame;
            if (caculateType == DDTemplateDynamicSizeCaculateTypeWidth) {
                frame.size.width = fixedValue;
            }
            if (caculateType == DDTemplateDynamicSizeCaculateTypeHeight) {
                frame.size.height = fixedValue;
            }
            cell.frame = frame;
            
            // update fitting size
            fittingSize = cell.bounds.size;
            
            if (caculateType == DDTemplateDynamicSizeCaculateTypeWidth) {
                fittingSize.width = fixedValue;
            }
            if (caculateType == DDTemplateDynamicSizeCaculateTypeHeight) {
                fittingSize.height = fixedValue;
            }
            
            NSLayoutAttribute attribute = caculateType == DDTemplateDynamicSizeCaculateTypeWidth
            ? NSLayoutAttributeWidth
            : NSLayoutAttributeHeight;
            NSLayoutConstraint *tempConstraint =
              [NSLayoutConstraint constraintWithItem:cell.contentView
                                           attribute:attribute
                                           relatedBy:NSLayoutRelationEqual
                                              toItem:nil
                                           attribute:NSLayoutAttributeNotAnAttribute
                                          multiplier:1
                                            constant:fixedValue];
            [cell.contentView addConstraint:tempConstraint];
            [cell.contentView setNeedsUpdateConstraints];
            [cell.contentView updateConstraintsIfNeeded];
            fittingSize = [cell.contentView systemLayoutSizeFittingSize:fittingSize];
            [cell.contentView removeConstraint:tempConstraint];
        }
        else {
            fittingSize = [cell.contentView systemLayoutSizeFittingSize:fittingSize];
        }
        
        [self dd_debugLog:[NSString stringWithFormat:@"calculate using system fitting size (AutoLayout) - %@", @(fittingSize)]];
    }
    
    else {
        
#if DEBUG
        // Warn if using AutoLayout but get zero height.
        if (cell.contentView.constraints.count > 0) {
            if (!objc_getAssociatedObject(self, _cmd)) {
                NSLog(@"[DDTemplateLayoutCell] Warning once only: Cannot get a proper cell size (now zero) from '- systemFittingSize:'(AutoLayout). You should check how constraints are built in cell, making it into 'self-sizing' cell.");
                objc_setAssociatedObject(self, _cmd, @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
        }
#endif
                
        if (caculateType == DDTemplateDynamicSizeCaculateTypeWidth) {
            fittingSize.width = fixedValue;
        }
        if (caculateType == DDTemplateDynamicSizeCaculateTypeHeight) {
            fittingSize.height = fixedValue;
        }
        
        // Try '- sizeThatFits:' for frame layout.
        fittingSize = [cell sizeThatFits:fittingSize];
        
        [self dd_debugLog:[NSString stringWithFormat:@"calculate using sizeThatFits - %@", @(fittingSize)]];
    }

    return fittingSize;
}

- (__kindof UICollectionViewCell *)dd_templateCellForReuseIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath {
    NSAssert(identifier.length > 0, @"Expect a valid identifier - %@", identifier);
    
    NSMutableDictionary<NSString *, UICollectionViewCell *> *templateCellsByIdentifiers = objc_getAssociatedObject(self, _cmd);
    if (!templateCellsByIdentifiers) {
        templateCellsByIdentifiers = @{}.mutableCopy;
        objc_setAssociatedObject(self, _cmd, templateCellsByIdentifiers, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    UICollectionViewCell *templateCell = templateCellsByIdentifiers[identifier];
        
    if (!templateCell) {
        templateCell = [self dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        NSAssert(templateCell != nil, @"Cell must be registered to table view for identifier - %@", identifier);
        templateCell.dd_isTemplateLayoutCell = YES;
        templateCell.contentView.translatesAutoresizingMaskIntoConstraints = NO;
        templateCellsByIdentifiers[identifier] = templateCell;
        [self dd_debugLog:[NSString stringWithFormat:@"layout cell created - %@", identifier]];
    }
    
    return templateCell;
}

- (CGSize)dd_sizeForCellWithIdentifier:(NSString *)identifier
                             indexPath:(nonnull NSIndexPath *)indexPath
                         configuration:(void (^)(id _Nonnull))configuration {
    return [self dd_sizeForCellWithIdentifier:identifier
                                   fixedValue:0
                                 caculateType:DDTemplateDynamicSizeCaculateTypeSize
                                    indexPath:indexPath
                                configuration:configuration];
}

- (CGSize)dd_sizeForCellWithIdentifier:(NSString *)identifier
                            fixedWidth:(CGFloat)fixedWidth
                             indexPath:(nonnull NSIndexPath *)indexPath
                         configuration:(void (^)(id _Nonnull))configuration {
    return [self dd_sizeForCellWithIdentifier:identifier
                                   fixedValue:fixedWidth
                                 caculateType:DDTemplateDynamicSizeCaculateTypeWidth
                                    indexPath:indexPath
                                configuration:configuration];
}


- (CGSize)dd_sizeForCellWithIdentifier:(NSString *)identifier
                           fixedHeight:(CGFloat)fixedHeight
                             indexPath:(nonnull NSIndexPath *)indexPath
                         configuration:(void (^)(id _Nonnull))configuration {
    return [self dd_sizeForCellWithIdentifier:identifier
                                   fixedValue:fixedHeight
                                 caculateType:DDTemplateDynamicSizeCaculateTypeHeight
                                    indexPath:indexPath
                                configuration:configuration];
}


- (CGSize)dd_sizeForCellWithIdentifier:(NSString *)identifier
                           fixedValue:(CGFloat)fixedValue
                          caculateType:(DDTemplateDynamicSizeCaculateType)caculateType
                             indexPath:(nonnull NSIndexPath *)indexPath
                         configuration:(void (^)(id _Nonnull))configuration {
    if (!identifier) {
        return CGSizeZero;
    }
    
    UICollectionViewCell *templateLayoutCell = [self dd_templateCellForReuseIdentifier:identifier forIndexPath:indexPath];
    
    // Manually calls to ensure consistent behavior with actual cells. (that are displayed on screen)
    [templateLayoutCell prepareForReuse];
    
    // Customize and provide content for our template cell.
    if (configuration) {
        configuration(templateLayoutCell);
    }
    
    return [self dd_systemFittingSizeForConfiguratedCell:templateLayoutCell fixedValue:fixedValue caculateType:caculateType];
}

- (CGSize)dd_sizeForCellWithIdentifier:(NSString *)identifier
                      cacheByIndexPath:(NSIndexPath *)indexPath
                         configuration:(void (^)(id cell))configuration {
    return [self dd_sizeForCellWithIdentifier:identifier
                                   fixedValue:0
                                 caculateType:DDTemplateDynamicSizeCaculateTypeSize
                             cacheByIndexPath:indexPath
                                configuration:configuration];
}


- (CGSize)dd_sizeForCellWithIdentifier:(NSString *)identifier
                            fixedWidth:(CGFloat)fixedWidth
                      cacheByIndexPath:(NSIndexPath *)indexPath
                         configuration:(void (^)(id cell))configuration {
    return [self dd_sizeForCellWithIdentifier:identifier
                                   fixedValue:fixedWidth
                                 caculateType:DDTemplateDynamicSizeCaculateTypeWidth
                             cacheByIndexPath:indexPath
                                configuration:configuration];
}

- (CGSize)dd_sizeForCellWithIdentifier:(NSString *)identifier
                            fixedHeight:(CGFloat)fixedHeight
                      cacheByIndexPath:(NSIndexPath *)indexPath
                         configuration:(void (^)(id cell))configuration {
    return [self dd_sizeForCellWithIdentifier:identifier
                                   fixedValue:fixedHeight
                                 caculateType:DDTemplateDynamicSizeCaculateTypeHeight
                             cacheByIndexPath:indexPath
                                configuration:configuration];
}

- (CGSize)dd_sizeForCellWithIdentifier:(NSString *)identifier
                            fixedValue:(CGFloat)fixedValue
                          caculateType:(DDTemplateDynamicSizeCaculateType)caculateType
                      cacheByIndexPath:(NSIndexPath *)indexPath
                         configuration:(void (^)(id cell))configuration {
    if (!identifier || !indexPath) {
        return CGSizeZero;
    }
    
    // Hit cache
    if ([self.dd_indexPathSizeCache existsSizeAtIndexPath:indexPath]) {
        [self dd_debugLog:[NSString stringWithFormat:@"hit cache by index path[%@:%@] - %@", @(indexPath.section), @(indexPath.row), @([self.dd_indexPathSizeCache sizeForIndexPath:indexPath])]];
        return [self.dd_indexPathSizeCache sizeForIndexPath:indexPath];
    }
    
    CGSize size = [self dd_sizeForCellWithIdentifier:identifier fixedValue:fixedValue caculateType:caculateType indexPath:indexPath configuration:configuration];
    [self.dd_indexPathSizeCache cacheSize:size byIndexPath:indexPath];
    [self dd_debugLog:[NSString stringWithFormat: @"cached by index path[%@:%@] - w:%@ h:%@", @(indexPath.section), @(indexPath.row), @(size.width), @(size.height)]];
    
    return size;
}

- (CGSize)dd_sizeForCellWithIdentifier:(NSString *)identifier
                            cacheByKey:(id<NSCopying>)key
                             indexPath:(NSIndexPath *)indexPath
                         configuration:(void (^)(id cell))configuration {
    return [self dd_sizeForCellWithIdentifier:identifier
                                   fixedValue:0
                                 caculateType:DDTemplateDynamicSizeCaculateTypeSize
                                   cacheByKey:key
                                    indexPath:indexPath
                                configuration:configuration];
}

- (CGSize)dd_sizeForCellWithIdentifier:(NSString *)identifier
                            fixedWidth:(CGFloat)fixedWidth
                            cacheByKey:(id<NSCopying>)key
                             indexPath:(NSIndexPath *)indexPath
                         configuration:(void (^)(id cell))configuration {
    return [self dd_sizeForCellWithIdentifier:identifier
                                   fixedValue:fixedWidth
                                 caculateType:DDTemplateDynamicSizeCaculateTypeWidth
                                   cacheByKey:key
                                    indexPath:indexPath
                                configuration:configuration];
}


- (CGSize)dd_sizeForCellWithIdentifier:(NSString *)identifier
                           fixedHeight:(CGFloat)fixedHeight
                            cacheByKey:(id<NSCopying>)key
                             indexPath:(NSIndexPath *)indexPath
                         configuration:(void (^)(id cell))configuration {
    return [self dd_sizeForCellWithIdentifier:identifier
                                   fixedValue:fixedHeight
                                 caculateType:DDTemplateDynamicSizeCaculateTypeHeight
                                   cacheByKey:key
                                    indexPath:indexPath
                                configuration:configuration];
}

- (CGSize)dd_sizeForCellWithIdentifier:(NSString *)identifier
                            fixedValue:(CGFloat)fixedValue
                          caculateType:(DDTemplateDynamicSizeCaculateType)caculateType
                            cacheByKey:(id<NSCopying>)key
                             indexPath:(NSIndexPath *)indexPath
                         configuration:(void (^)(id cell))configuration {
    if (!identifier || !key) {
        return CGSizeZero;
    }
    
    // Hit cache
    if ([self.dd_keyedSizeCache existsSizeForKey:key]) {
        CGSize cachedSize = [self.dd_keyedSizeCache sizeForKey:key];
        [self dd_debugLog:[NSString stringWithFormat:@"hit cache by key[%@] - w:%@ h:%@", key, @(cachedSize.width), @(cachedSize.height)]];
        return cachedSize;
    }
    
    CGSize size = [self dd_sizeForCellWithIdentifier:identifier fixedValue:fixedValue caculateType:caculateType indexPath:indexPath configuration:configuration];
    [self.dd_keyedSizeCache cacheSize:size byKey:key];
    [self dd_debugLog:[NSString stringWithFormat:@"cached by key[%@] - w:%@ h:%@", key, @(size.width), @(size.height)]];
    
    return size;
}

@end

@implementation UICollectionView (DDTemplateLayoutReusableSupplementaryView)

- (__kindof UICollectionReusableView *)dd_templateReusableSupplementaryViewForKind:(NSString *)kind
                                                                   reuseIdentifier:(NSString *)identifier
                                                                         indexPath:(NSIndexPath *)indexPath {
    NSAssert(identifier.length > 0, @"Expect a valid identifier - %@", identifier);
    
    NSMutableDictionary<NSString *, UICollectionReusableView *> *templateSupplementaryViews = objc_getAssociatedObject(self, _cmd);
    if (!templateSupplementaryViews) {
        templateSupplementaryViews = @{}.mutableCopy;
        objc_setAssociatedObject(self, _cmd, templateSupplementaryViews, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    UICollectionReusableView *templateSupplementaryView = templateSupplementaryViews[identifier];
    
    if (!templateSupplementaryView) {
        templateSupplementaryView = [self dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:identifier forIndexPath:indexPath];
        NSAssert(templateSupplementaryView != nil, @"ReusableSupplementaryView must be registered to collection view for identifier - %@", identifier);
        templateSupplementaryView.translatesAutoresizingMaskIntoConstraints = NO;
        templateSupplementaryViews[identifier] = templateSupplementaryView;
        [self dd_debugLog:[NSString stringWithFormat:@"layout header footer view created - %@", identifier]];
    }
    
    return templateSupplementaryView;
}

- (CGFloat)dd_sizeForReusableSupplementaryViewWithKind:(NSString *)kind
                                            identifier:(NSString *)identifier
                                             indexPath:(NSIndexPath *)indexPath
                                         configuration:(void (^)(id))configuration {
    UICollectionReusableView *templateSupplementaryView = [self dd_templateReusableSupplementaryViewForKind:kind reuseIdentifier:identifier indexPath:indexPath];
    
    NSLayoutConstraint *widthFenceConstraint = [NSLayoutConstraint constraintWithItem:templateSupplementaryView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:CGRectGetWidth(self.frame)];
    [templateSupplementaryView addConstraint:widthFenceConstraint];
    CGFloat fittingHeight = [templateSupplementaryView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    [templateSupplementaryView removeConstraint:widthFenceConstraint];
    
    if (fittingHeight == 0) {
        fittingHeight = [templateSupplementaryView sizeThatFits:CGSizeMake(CGRectGetWidth(self.frame), 0)].height;
    }
    
    return fittingHeight;
}

@end

@implementation UICollectionViewCell (DDTemplateLayoutCell)

- (BOOL)dd_isTemplateLayoutCell {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setDd_isTemplateLayoutCell:(BOOL)isTemplateLayoutCell {
    objc_setAssociatedObject(self, @selector(dd_isTemplateLayoutCell), @(isTemplateLayoutCell), OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)dd_enforceFrameLayout {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setDd_enforceFrameLayout:(BOOL)enforceFrameLayout {
    objc_setAssociatedObject(self, @selector(dd_enforceFrameLayout), @(enforceFrameLayout), OBJC_ASSOCIATION_RETAIN);
}

@end
