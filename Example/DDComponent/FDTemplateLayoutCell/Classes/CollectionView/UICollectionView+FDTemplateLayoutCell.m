//
//  UICollectionView+FDTemplateLayoutCell.m
//  Demo
//
//  Created by mac on 2021/9/14.
//  Copyright © 2021 forkingdog. All rights reserved.
//

#import "UICollectionView+FDTemplateLayoutCell.h"
#import <objc/runtime.h>

typedef NS_ENUM(NSUInteger, FDTemplateDynamicSizeCaculateType) {
    FDTemplateDynamicSizeCaculateTypeSize = 0,
    FDTemplateDynamicSizeCaculateTypeHeight,
    FDTemplateDynamicSizeCaculateTypeWidth
};

@implementation UICollectionView (FDTemplateLayoutCell)

- (CGSize)fd_systemFittingSizeForConfiguratedCell:(UICollectionViewCell *)cell
                                       fixedValue:(CGFloat)fixedValue
                                     caculateType:(FDTemplateDynamicSizeCaculateType)caculateType {
    CGSize fittingSize = CGSizeMake(fixedValue, fixedValue);
    
    if (caculateType != FDTemplateDynamicSizeCaculateTypeSize) {
        NSLayoutAttribute attribute = caculateType == FDTemplateDynamicSizeCaculateTypeWidth
        ? NSLayoutAttributeWidth
        : NSLayoutAttributeHeight;
        NSLayoutConstraint *tempConstraint =
          [NSLayoutConstraint constraintWithItem:cell
                                       attribute:attribute
                                       relatedBy:NSLayoutRelationEqual
                                          toItem:nil
                                       attribute:NSLayoutAttributeNotAnAttribute
                                      multiplier:1
                                        constant:fixedValue];
        [cell addConstraint:tempConstraint];
        fittingSize = [cell systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        [cell removeConstraint:tempConstraint];
    }
    else {
        fittingSize = [cell systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    }

    return fittingSize;
}

- (__kindof UICollectionViewCell *)fd_templateCellForReuseIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath {
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
        templateCell.fd_isTemplateLayoutCell = YES;
        templateCell.contentView.translatesAutoresizingMaskIntoConstraints = NO;
        templateCellsByIdentifiers[identifier] = templateCell;
        [self fd_debugLog:[NSString stringWithFormat:@"layout cell created - %@", identifier]];
    }
    
    return templateCell;
}

- (CGSize)fd_sizeForCellWithIdentifier:(NSString *)identifier
                             indexPath:(nonnull NSIndexPath *)indexPath
                         configuration:(void (^)(id _Nonnull))configuration {
    return [self fd_sizeForCellWithIdentifier:identifier
                                   fixedValue:0
                                 caculateType:FDTemplateDynamicSizeCaculateTypeSize
                                    indexPath:indexPath
                                configuration:configuration];
}

- (CGSize)fd_sizeForCellWithIdentifier:(NSString *)identifier
                            fixedWidth:(CGFloat)fixedWidth
                             indexPath:(nonnull NSIndexPath *)indexPath
                         configuration:(void (^)(id _Nonnull))configuration {
    return [self fd_sizeForCellWithIdentifier:identifier
                                   fixedValue:fixedWidth
                                 caculateType:FDTemplateDynamicSizeCaculateTypeWidth
                                    indexPath:indexPath
                                configuration:configuration];
}


- (CGSize)fd_sizeForCellWithIdentifier:(NSString *)identifier
                           fixedHeight:(CGFloat)fixedHeight
                             indexPath:(nonnull NSIndexPath *)indexPath
                         configuration:(void (^)(id _Nonnull))configuration {
    return [self fd_sizeForCellWithIdentifier:identifier
                                   fixedValue:fixedHeight
                                 caculateType:FDTemplateDynamicSizeCaculateTypeHeight
                                    indexPath:indexPath
                                configuration:configuration];
}


- (CGSize)fd_sizeForCellWithIdentifier:(NSString *)identifier
                           fixedValue:(CGFloat)fixedValue
                          caculateType:(FDTemplateDynamicSizeCaculateType)caculateType
                             indexPath:(nonnull NSIndexPath *)indexPath
                         configuration:(void (^)(id _Nonnull))configuration {
    if (!identifier) {
        return CGSizeZero;
    }
    
    UICollectionViewCell *templateLayoutCell = [self fd_templateCellForReuseIdentifier:identifier forIndexPath:indexPath];
    
    // Manually calls to ensure consistent behavior with actual cells. (that are displayed on screen)
    [templateLayoutCell prepareForReuse];
    
    // Customize and provide content for our template cell.
    if (configuration) {
        configuration(templateLayoutCell);
    }
    
    return [self fd_systemFittingSizeForConfiguratedCell:templateLayoutCell fixedValue:fixedValue caculateType:caculateType];
}

- (CGSize)fd_sizeForCellWithIdentifier:(NSString *)identifier
                      cacheByIndexPath:(NSIndexPath *)indexPath
                         configuration:(void (^)(id cell))configuration {
    return [self fd_sizeForCellWithIdentifier:identifier
                                   fixedValue:0
                                 caculateType:FDTemplateDynamicSizeCaculateTypeSize
                             cacheByIndexPath:indexPath
                                configuration:configuration];
}


- (CGSize)fd_sizeForCellWithIdentifier:(NSString *)identifier
                            fixedWidth:(CGFloat)fixedWidth
                      cacheByIndexPath:(NSIndexPath *)indexPath
                         configuration:(void (^)(id cell))configuration {
    return [self fd_sizeForCellWithIdentifier:identifier
                                   fixedValue:fixedWidth
                                 caculateType:FDTemplateDynamicSizeCaculateTypeWidth
                             cacheByIndexPath:indexPath
                                configuration:configuration];
}

- (CGSize)fd_sizeForCellWithIdentifier:(NSString *)identifier
                            fixedHeight:(CGFloat)fixedHeight
                      cacheByIndexPath:(NSIndexPath *)indexPath
                         configuration:(void (^)(id cell))configuration {
    return [self fd_sizeForCellWithIdentifier:identifier
                                   fixedValue:fixedHeight
                                 caculateType:FDTemplateDynamicSizeCaculateTypeHeight
                             cacheByIndexPath:indexPath
                                configuration:configuration];
}

- (CGSize)fd_sizeForCellWithIdentifier:(NSString *)identifier
                            fixedValue:(CGFloat)fixedValue
                          caculateType:(FDTemplateDynamicSizeCaculateType)caculateType
                      cacheByIndexPath:(NSIndexPath *)indexPath
                         configuration:(void (^)(id cell))configuration {
    if (!identifier || !indexPath) {
        return CGSizeZero;
    }
    
    // Hit cache
    if ([self.fd_indexPathSizeCache existsSizeAtIndexPath:indexPath]) {
        [self fd_debugLog:[NSString stringWithFormat:@"hit cache by index path[%@:%@] - %@", @(indexPath.section), @(indexPath.row), @([self.fd_indexPathSizeCache sizeForIndexPath:indexPath])]];
        return [self.fd_indexPathSizeCache sizeForIndexPath:indexPath];
    }
    
    CGSize size = [self fd_sizeForCellWithIdentifier:identifier fixedValue:fixedValue caculateType:caculateType indexPath:indexPath configuration:configuration];
    [self.fd_indexPathSizeCache cacheSize:size byIndexPath:indexPath];
    [self fd_debugLog:[NSString stringWithFormat: @"cached by index path[%@:%@] - w:%@ h:%@", @(indexPath.section), @(indexPath.row), @(size.width), @(size.height)]];
    
    return size;
}

- (CGSize)fd_sizeForCellWithIdentifier:(NSString *)identifier
                            cacheByKey:(id<NSCopying>)key
                             indexPath:(NSIndexPath *)indexPath
                         configuration:(void (^)(id cell))configuration {
    return [self fd_sizeForCellWithIdentifier:identifier
                                   fixedValue:0
                                 caculateType:FDTemplateDynamicSizeCaculateTypeSize
                                   cacheByKey:key
                                    indexPath:indexPath
                                configuration:configuration];
}

- (CGSize)fd_sizeForCellWithIdentifier:(NSString *)identifier
                            fixedWidth:(CGFloat)fixedWidth
                            cacheByKey:(id<NSCopying>)key
                             indexPath:(NSIndexPath *)indexPath
                         configuration:(void (^)(id cell))configuration {
    return [self fd_sizeForCellWithIdentifier:identifier
                                   fixedValue:fixedWidth
                                 caculateType:FDTemplateDynamicSizeCaculateTypeWidth
                                   cacheByKey:key
                                    indexPath:indexPath
                                configuration:configuration];
}


- (CGSize)fd_sizeForCellWithIdentifier:(NSString *)identifier
                           fixedHeight:(CGFloat)fixedHeight
                            cacheByKey:(id<NSCopying>)key
                             indexPath:(NSIndexPath *)indexPath
                         configuration:(void (^)(id cell))configuration {
    return [self fd_sizeForCellWithIdentifier:identifier
                                   fixedValue:fixedHeight
                                 caculateType:FDTemplateDynamicSizeCaculateTypeHeight
                                   cacheByKey:key
                                    indexPath:indexPath
                                configuration:configuration];
}

- (CGSize)fd_sizeForCellWithIdentifier:(NSString *)identifier
                            fixedValue:(CGFloat)fixedValue
                          caculateType:(FDTemplateDynamicSizeCaculateType)caculateType
                            cacheByKey:(id<NSCopying>)key
                             indexPath:(NSIndexPath *)indexPath
                         configuration:(void (^)(id cell))configuration {
    if (!identifier || !key) {
        return CGSizeZero;
    }
    
    // Hit cache
    if ([self.fd_keyedSizeCache existsSizeForKey:key]) {
        CGSize cachedSize = [self.fd_keyedSizeCache sizeForKey:key];
        [self fd_debugLog:[NSString stringWithFormat:@"hit cache by key[%@] - w:%@ h:%@", key, @(cachedSize.width), @(cachedSize.height)]];
        return cachedSize;
    }
    
    CGSize size = [self fd_sizeForCellWithIdentifier:identifier indexPath:indexPath configuration:configuration];
    [self.fd_keyedSizeCache cacheSize:size byKey:key];
    [self fd_debugLog:[NSString stringWithFormat:@"cached by key[%@] - w:%@ h:%@", key, @(size.width), @(size.height)]];
    
    return size;
}

@end

@implementation UICollectionView (FDTemplateLayoutReusableSupplementaryView)

- (__kindof UICollectionReusableView *)fd_templateReusableSupplementaryViewForKind:(NSString *)kind
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
        [self fd_debugLog:[NSString stringWithFormat:@"layout header footer view created - %@", identifier]];
    }
    
    return templateSupplementaryView;
}

- (CGFloat)fd_sizeForReusableSupplementaryViewWithKind:(NSString *)kind
                                            identifier:(NSString *)identifier
                                             indexPath:(NSIndexPath *)indexPath
                                         configuration:(void (^)(id))configuration {
    UICollectionReusableView *templateSupplementaryView = [self fd_templateReusableSupplementaryViewForKind:kind reuseIdentifier:identifier indexPath:indexPath];
    
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

@implementation UICollectionViewCell (FDTemplateLayoutCell)

- (BOOL)fd_isTemplateLayoutCell {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setFd_isTemplateLayoutCell:(BOOL)isTemplateLayoutCell {
    objc_setAssociatedObject(self, @selector(fd_isTemplateLayoutCell), @(isTemplateLayoutCell), OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)fd_enforceFrameLayout {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setFd_enforceFrameLayout:(BOOL)enforceFrameLayout {
    objc_setAssociatedObject(self, @selector(fd_enforceFrameLayout), @(enforceFrameLayout), OBJC_ASSOCIATION_RETAIN);
}

@end
