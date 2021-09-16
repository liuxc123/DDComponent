//
//  DDTableViewStatusComponent.h
//  DDComponent_Example
//
//  Created by liuxc on 2021/8/30.
//  Copyright © 2021 liuxc123. All rights reserved.
//

#import "DDTableViewComponent.h"
#import "DDTableViewSectionComponent.h"
#import "DDTableViewSectionGroupComponent.h"

NS_ASSUME_NONNULL_BEGIN

/**
 This component is for status changing.
 For example, a request should has 'Loading', 'Error', 'Empty Data', 'Normal Data'.
 And the component should show 'Loading' when request is loading.
 */
@interface DDTableViewStatusComponent : DDTableViewBaseComponent

/**
 You can change the state by this property.
 You must reloadData by yourself after currentState changed!
 */
@property (strong, nonatomic, nullable) NSString *currentState;
@property (readonly, nonatomic, nullable) DDTableViewBaseComponent *currentComponent;

- (nullable DDTableViewBaseComponent *)componentForState:(NSString *)state;
- (void)setComponent:(nullable DDTableViewBaseComponent *)comp forState:(NSString *)state;

@end

/**
 Like DDTableViewStatusComponent, but the header and footer will use statusComponent properties,
 not the subComponent's properties.
 */
@interface DDTableViewHeaderFooterStatusComponent : DDTableViewStatusComponent

@property (strong, nonatomic, nullable) __kindof DDTableViewSectionComponent *headerComponent;
@property (strong, nonatomic, nullable) __kindof DDTableViewSectionComponent *footerComponent;
@property (strong, nonatomic, nullable) __kindof DDTableViewSectionComponent *headerFooterComponent;

@end

NS_ASSUME_NONNULL_END
