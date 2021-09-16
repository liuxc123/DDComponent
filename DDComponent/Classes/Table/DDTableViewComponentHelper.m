//
//  DDTableViewComponentHelper.m
//  DDComponent_Example
//
//  Created by liuxc on 2021/8/30.
//  Copyright © 2021 liuxc123. All rights reserved.
//

#import "DDTableViewComponentHelper.h"

@implementation DDTableViewHeaderFooterSectionComponent (Helper)

+ (instancetype)componentWithHeader:(DDTableViewSectionComponent *)header
                             footer:(DDTableViewSectionComponent *)footer {
    DDTableViewHeaderFooterSectionComponent *comp = [self new];
    comp.headerComponent = header;
    comp.footerComponent = footer;
    return comp;
}

@end

@implementation DDTableViewItemGroupComponent (Helper)

+ (instancetype)componentWithHeader:(DDTableViewSectionComponent *)header
                             footer:(DDTableViewSectionComponent *)footer
                      subComponents:(NSArray<DDTableViewItemComponent *> *)subComponents {
    DDTableViewItemGroupComponent *comp = [self componentWithHeader:header footer:footer];
    comp.subComponents = subComponents;
    return comp;
}

+ (instancetype)componentWithSubComponents:(NSArray<DDTableViewItemComponent *> *)subComponents {
    DDTableViewItemGroupComponent *comp = [self new];
    comp.subComponents = subComponents;
    return comp;
}

@end

@implementation DDTableViewSectionGroupComponent (Helper)

+ (instancetype)componentWithSubComponents:(NSArray<DDTableViewSectionComponent *> *)subComponents {
    DDTableViewSectionGroupComponent *comp = [self new];
    comp.subComponents = subComponents;
    return comp;
}

@end

@implementation DDTableViewRootComponent (Helper)

+ (instancetype)componentWithTableView:(UITableView *)tableView
                         subComponents:(NSArray<DDTableViewSectionComponent *> *)subComponents {
    DDTableViewRootComponent *comp = [[self alloc] initWithTableView:tableView];
    comp.subComponents = subComponents;
    return comp;
}

@end

@implementation DDTableViewStatusComponent (Helper)

+ (instancetype)componentWithComponents:(NSDictionary<NSString *, DDTableViewSectionComponent *> *)components {
    DDTableViewStatusComponent *comp = [self new];
    [components enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, DDTableViewSectionComponent * _Nonnull obj, BOOL * _Nonnull stop) {
        [comp setComponent:obj forState:key];
    }];
    return comp;
}

@end

