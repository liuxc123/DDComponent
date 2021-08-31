//
//  DDCollectionViewHeaderFooterSectionDemoComponent.h
//  DDComponent_Example
//
//  Created by mac on 2021/8/31.
//  Copyright © 2021 liuxc123. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDCollectionViewHeaderFooterSectionDemoComponent : DDCollectionViewHeaderFooterSectionComponent

@property (nonatomic, strong) NSArray<NSString *> *demoData;

+ (instancetype)componentWithData:(NSArray<NSString *> *)demoData;

@end

NS_ASSUME_NONNULL_END
