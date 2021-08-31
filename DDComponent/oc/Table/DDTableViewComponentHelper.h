//
//  DDTableViewComponentHelper.h
//  DDComponent_Example
//
//  Created by liuxc on 2021/8/30.
//  Copyright © 2021 liuxc123. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDTableViewItemComponent.h"
#import "DDTableViewSectionComponent.h"
#import "DDTableViewSectionGroupComponent.h"
#import "DDTableViewStatusComponent.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDTableViewHeaderFooterSectionComponent (Helper)

+ (instancetype)componentWithHeader:(DDTableViewSectionComponent *)header
                             footer:(DDTableViewSectionComponent *)footer;

@end

@interface DDTableViewItemGroupComponent (Helper)

+ (instancetype)componentWithHeader:(DDTableViewSectionComponent *)header
                             footer:(DDTableViewSectionComponent *)footer
                      subComponents:(NSArray<DDTableViewItemComponent *> *)subComponents;

+ (instancetype)componentWithSubComponents:(NSArray<DDTableViewItemComponent *> *)subComponents;

@end

@interface DDTableViewSectionGroupComponent (Helper)

+ (instancetype)componentWithSubComponents:(NSArray<DDTableViewSectionComponent *> *)subComponents;

@end

@interface DDTableViewRootComponent (Helper)

+ (instancetype)componentWithTableView:(UITableView *)tableView
                         subComponents:(NSArray<DDTableViewSectionComponent *> *)subComponents;

@end

@interface DDTableViewStatusComponent (Helper)

+ (instancetype)componentWithComponents:(NSDictionary<NSString *, DDTableViewSectionComponent *> *)components;

@end

NS_ASSUME_NONNULL_END
