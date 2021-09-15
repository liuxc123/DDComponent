//
//  UICollectionView+FDTemplateLayoutCellDebug.h
//  Demo
//
//  Created by mac on 2021/9/14.
//  Copyright © 2021 forkingdog. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UICollectionView (FDTemplateLayoutCellDebug)

/// Helps to debug or inspect what is this "FDTemplateLayoutCell" extention doing,
/// turning on to print logs when "creating", "calculating", "precaching" or "hitting cache".
///
/// Default to NO, log by NSLog.
///
@property (nonatomic, assign) BOOL fd_debugLogEnabled;

/// Debug log controlled by "fd_debugLogEnabled".
- (void)fd_debugLog:(NSString *)message;

@end

NS_ASSUME_NONNULL_END
