//
//  DDTableViewStatusComponent.m
//  DDComponent_Example
//
//  Created by liuxc on 2021/8/30.
//  Copyright © 2021 liuxc123. All rights reserved.
//

#import "DDTableViewStatusComponent.h"
#import "DDTableViewComponent+Private.h"

@implementation DDTableViewStatusComponent {
    NSMutableDictionary<NSString *, DDTableViewBaseComponent *> *_componentDict;
@protected
    NSUInteger _numberOfSections; // cache
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _componentDict = [NSMutableDictionary new];
    }
    return self;
}

- (NSInteger)firstRowOfSubComponent:(id<DDTableViewComponent>)subComp {
    return self.row;
}

- (NSInteger)firstSectionOfSubComponent:(id<DDTableViewComponent>)subComp {
    return self.section;
}


- (void)setTableView:(UITableView *)tableView {
    [super setTableView:tableView];
    [_componentDict enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, DDTableViewBaseComponent * _Nonnull obj, BOOL * _Nonnull stop) {
        [obj setTableView:tableView];
    }];
}

- (void)prepareTableView {
    [super prepareTableView];
    if (self.tableView) {
        [_componentDict enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, DDTableViewBaseComponent * _Nonnull obj, BOOL * _Nonnull stop) {
            [obj prepareTableView];
        }];
    }
}

- (DDTableViewBaseComponent *)currentComponent {
    return [self componentForState:self.currentState];
}

- (void)setComponent:(DDTableViewBaseComponent *)comp forState:(NSString *)state {
    if (state) {
        DDTableViewBaseComponent *oldComp = _componentDict[state];
        if (comp) {
            if (oldComp.superComponent == self) _componentDict[state].superComponent = nil;
            comp.superComponent = self;
            [_componentDict setObject:comp forKey:state];
            if (self.tableView) {
                [comp prepareTableView];
            }
        }
        else {
            if (oldComp.superComponent == self) _componentDict[state].superComponent = nil;
            [_componentDict removeObjectForKey:state];
        }
    }
}

- (DDTableViewBaseComponent *)componentForState:(NSString *)state {
    if (state) {
        DDTableViewBaseComponent *comp = [_componentDict objectForKey:state];
        return comp;
    }
    return nil;
}

#pragma mark - convert

- (NSInteger)convertFromGlobalSection:(NSInteger)section {
    return [self.currentComponent convertFromGlobalSection:section];
}

- (NSIndexPath *)convertFromGlobalIndexPath:(NSIndexPath *)indexPath {
    return [self.currentComponent convertFromGlobalIndexPath:indexPath];
}

#pragma mark - dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    _numberOfSections = [self.currentComponent numberOfSectionsInTableView:tableView];
    return _numberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.currentComponent tableView:tableView numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.currentComponent tableView:tableView cellForRowAtIndexPath:indexPath];
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    DDTableViewBaseComponent *comp = self.currentComponent;
    if ([comp respondsToSelector:_cmd]) {
        return [comp tableView:tableView titleForHeaderInSection:section];
    }
    return nil;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    DDTableViewBaseComponent *comp = self.currentComponent;
    if ([comp respondsToSelector:_cmd]) {
        return [comp tableView:tableView titleForFooterInSection:section];
    }
    return nil;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    DDTableViewBaseComponent *comp = self.currentComponent;
    if ([comp respondsToSelector:_cmd]) {
        return [comp tableView:tableView canEditRowAtIndexPath:indexPath];
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    DDTableViewBaseComponent *comp = self.currentComponent;
    if ([comp respondsToSelector:_cmd]) {
        [comp tableView:tableView commitEditingStyle:editingStyle forRowAtIndexPath:indexPath];
    }
}

#pragma mark - delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    DDTableViewBaseComponent *comp = self.currentComponent;
    if ([comp respondsToSelector:_cmd]) {
        [comp tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section NS_AVAILABLE_IOS(6_0) {
    DDTableViewBaseComponent *comp = self.currentComponent;
    if ([comp respondsToSelector:_cmd]) {
        [comp tableView:tableView willDisplayHeaderView:view forSection:section];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section NS_AVAILABLE_IOS(6_0) {
    DDTableViewBaseComponent *comp = self.currentComponent;
    if ([comp respondsToSelector:_cmd]) {
        [comp tableView:tableView willDisplayFooterView:view forSection:section];
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath NS_AVAILABLE_IOS(6_0) {
    DDTableViewBaseComponent *comp = self.currentComponent;
    if ([comp respondsToSelector:_cmd]) {
        [comp tableView:tableView didEndDisplayingCell:cell forRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section NS_AVAILABLE_IOS(6_0) {
    DDTableViewBaseComponent *comp = self.currentComponent;
    if ([comp respondsToSelector:_cmd]) {
        [comp tableView:tableView didEndDisplayingHeaderView:view forSection:section];
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingFooterView:(UIView *)view forSection:(NSInteger)section NS_AVAILABLE_IOS(6_0) {
    DDTableViewBaseComponent *comp = self.currentComponent;
    if ([comp respondsToSelector:_cmd]) {
        [comp tableView:tableView didEndDisplayingFooterView:view forSection:section];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    DDTableViewBaseComponent *comp = self.currentComponent;
    if ([comp respondsToSelector:_cmd]) {
        return [comp tableView:tableView heightForRowAtIndexPath:indexPath];
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    DDTableViewBaseComponent *comp = self.currentComponent;
    if ([comp respondsToSelector:_cmd]) {
        return [comp tableView:tableView heightForHeaderInSection:section];
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    DDTableViewBaseComponent *comp = self.currentComponent;
    if ([comp respondsToSelector:_cmd]) {
        return [comp tableView:tableView heightForFooterInSection:section];
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(7_0) {
    DDTableViewBaseComponent *comp = self.currentComponent;
    if ([comp respondsToSelector:_cmd]) {
        return [comp tableView:tableView estimatedHeightForRowAtIndexPath:indexPath];
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section NS_AVAILABLE_IOS(7_0) {
    DDTableViewBaseComponent *comp = self.currentComponent;
    if ([comp respondsToSelector:_cmd]) {
        return [comp tableView:tableView estimatedHeightForHeaderInSection:section];
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section NS_AVAILABLE_IOS(7_0) {
    DDTableViewBaseComponent *comp = self.currentComponent;
    if ([comp respondsToSelector:_cmd]) {
        return [comp tableView:tableView estimatedHeightForFooterInSection:section];
    }
    return 0;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    DDTableViewBaseComponent *comp = self.currentComponent;
    if ([comp respondsToSelector:_cmd]) {
        return [comp tableView:tableView viewForHeaderInSection:section];
    }
    return nil;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    DDTableViewBaseComponent *comp = self.currentComponent;
    if ([comp respondsToSelector:_cmd]) {
        return [comp tableView:tableView viewForFooterInSection:section];
    }
    return nil;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(6_0) {
    DDTableViewBaseComponent *comp = self.currentComponent;
    if ([comp respondsToSelector:_cmd]) {
        return [comp tableView:tableView shouldHighlightRowAtIndexPath:indexPath];
    }
    return YES;
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(6_0) {
    DDTableViewBaseComponent *comp = self.currentComponent;
    if ([comp respondsToSelector:_cmd]) {
        [self.currentComponent tableView:tableView didHighlightRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(6_0) {
    DDTableViewBaseComponent *comp = self.currentComponent;
    if ([comp respondsToSelector:_cmd]) {
        [self.currentComponent tableView:tableView didUnhighlightRowAtIndexPath:indexPath];
    }
}

- (nullable NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DDTableViewBaseComponent *comp = self.currentComponent;
    if ([comp respondsToSelector:_cmd]) {
        return [comp tableView:tableView willSelectRowAtIndexPath:indexPath];
    }
    return indexPath;
}

- (nullable NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(3_0) {
    DDTableViewBaseComponent *comp = self.currentComponent;
    if ([comp respondsToSelector:_cmd]) {
        return [comp tableView:tableView willDeselectRowAtIndexPath:indexPath];
    }
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DDTableViewBaseComponent *comp = self.currentComponent;
    if ([comp respondsToSelector:_cmd]) {
        [self.currentComponent tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(3_0) {
    DDTableViewBaseComponent *comp = self.currentComponent;
    if ([comp respondsToSelector:_cmd]) {
        [self.currentComponent tableView:tableView didDeselectRowAtIndexPath:indexPath];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    DDTableViewBaseComponent *comp = self.currentComponent;
    if ([comp respondsToSelector:_cmd]) {
        return [comp tableView:tableView editingStyleForRowAtIndexPath:indexPath];
    }
    return UITableViewCellEditingStyleNone;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(3_0) __TVOS_PROHIBITED {
    DDTableViewBaseComponent *comp = self.currentComponent;
    if ([comp respondsToSelector:_cmd]) {
        return [comp tableView:tableView titleForDeleteConfirmationButtonForRowAtIndexPath:indexPath];
    }
    return nil;
}

- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(8_0) __TVOS_PROHIBITED {
    DDTableViewBaseComponent *comp = self.currentComponent;
    if ([comp respondsToSelector:_cmd]) {
        return [comp tableView:tableView editActionsForRowAtIndexPath:indexPath];
    }
    return nil;
}

- (nullable UISwipeActionsConfiguration *)tableView:(UITableView *)tableView leadingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath API_AVAILABLE(ios(11.0)) API_UNAVAILABLE(tvos) {
    DDTableViewBaseComponent *comp = self.currentComponent;
    if ([comp respondsToSelector:_cmd]) {
        return [comp tableView:tableView leadingSwipeActionsConfigurationForRowAtIndexPath:indexPath];
    }
    return nil;
}

- (nullable UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath API_AVAILABLE(ios(11.0)) API_UNAVAILABLE(tvos) {
    DDTableViewBaseComponent *comp = self.currentComponent;
    if ([comp respondsToSelector:_cmd]) {
        return [comp tableView:tableView trailingSwipeActionsConfigurationForRowAtIndexPath:indexPath];
    }
    return nil;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    DDTableViewBaseComponent *comp = self.currentComponent;
    if ([comp respondsToSelector:_cmd]) {
        return [comp tableView:tableView shouldIndentWhileEditingRowAtIndexPath:indexPath];
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath __TVOS_PROHIBITED {
    DDTableViewBaseComponent *comp = self.currentComponent;
    if ([comp respondsToSelector:_cmd]) {
        [self.currentComponent tableView:tableView willBeginEditingRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(nullable NSIndexPath *)indexPath __TVOS_PROHIBITED {
    DDTableViewBaseComponent *comp = self.currentComponent;
    if ([comp respondsToSelector:_cmd]) {
        return [comp tableView:tableView didEndEditingRowAtIndexPath:indexPath];
    }
}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath {
    DDTableViewBaseComponent *comp = self.currentComponent;
    if ([comp respondsToSelector:_cmd]) {
        return [comp tableView:tableView indentationLevelForRowAtIndexPath:indexPath];
    }
    return 0;
}

- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(5_0) {
    DDTableViewBaseComponent *comp = self.currentComponent;
    if ([comp respondsToSelector:_cmd]) {
        return [comp tableView:tableView shouldShowMenuForRowAtIndexPath:indexPath];
    }
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender NS_AVAILABLE_IOS(5_0) {
    DDTableViewBaseComponent *comp = self.currentComponent;
    if ([comp respondsToSelector:_cmd]) {
        return [comp tableView:tableView canPerformAction:action forRowAtIndexPath:indexPath withSender:sender];
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender NS_AVAILABLE_IOS(5_0) {
    DDTableViewBaseComponent *comp = self.currentComponent;
    if ([comp respondsToSelector:_cmd]) {
        [self.currentComponent tableView:tableView performAction:action forRowAtIndexPath:indexPath withSender:sender];
    }
}

// Focus

- (BOOL)tableView:(UITableView *)tableView canFocusRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(9_0) {
    DDTableViewBaseComponent *comp = self.currentComponent;
    if ([comp respondsToSelector:_cmd]) {
        return [comp tableView:tableView canFocusRowAtIndexPath:indexPath];
    }
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView shouldSpringLoadRowAtIndexPath:(NSIndexPath *)indexPath withContext:(id<UISpringLoadedInteractionContext>)context API_AVAILABLE(ios(11.0)) API_UNAVAILABLE(tvos, watchos) {
    DDTableViewBaseComponent *comp = self.currentComponent;
    if ([comp respondsToSelector:_cmd]) {
        return [comp tableView:tableView shouldSpringLoadRowAtIndexPath:indexPath withContext:context];
    }
    return NO;
}

- (NSString *)debugDescription {
    NSMutableString *desc = [[NSMutableString alloc] initWithString:self.description];
    if (_componentDict.count > 0) {
        [_componentDict enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, DDTableViewBaseComponent * _Nonnull obj, BOOL * _Nonnull stop) {
            [desc appendString:@"\n  "];
            [desc appendString:[key isEqualToString:self.currentState] ? @"*" : @"-"];
            [desc appendString:@"["];
            [desc appendString:key];
            [desc appendString:@"] "];
            [desc appendString:[[obj.debugDescription componentsSeparatedByString:@"\n"] componentsJoinedByString:@"\n    "]];
        }];
    }
    return desc;
}

@end


@implementation DDTableViewHeaderFooterStatusComponent

- (void)setHeaderComponent:(DDTableViewSectionComponent *)headerComponent {
    if (_headerComponent.superComponent == self) _headerComponent.superComponent = nil;
    _headerComponent = headerComponent;
    _headerComponent.superComponent = self;
    if (self.tableView) [_headerComponent prepareTableView];
}

- (void)setFooterComponent:(DDTableViewSectionComponent *)footerComponent {
    if (_footerComponent.superComponent == self) _footerComponent.superComponent = nil;
    _footerComponent = footerComponent;
    _footerComponent.superComponent = self;
    if (self.tableView) [_footerComponent prepareTableView];
}

- (void)setHeaderFooterComponent:(DDTableViewSectionComponent *)headerFooterComponent {
    if (_headerFooterComponent.superComponent == self) _headerFooterComponent.superComponent = nil;
    _headerFooterComponent = headerFooterComponent;
    _headerFooterComponent.superComponent = self;
    if (self.tableView) [_headerFooterComponent prepareTableView];
}

- (void)setTableView:(UITableView *)tableView {
    [super setTableView:tableView];
    self.headerComponent.tableView = tableView;
    self.footerComponent.tableView = tableView;
    self.headerFooterComponent.tableView = tableView;
}

- (void)prepareTableView {
    [super prepareTableView];
    if (self.tableView) {
        [_headerFooterComponent prepareTableView];
        [_headerComponent prepareTableView];
        [_footerComponent prepareTableView];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    // header appear at first component
    if (self.section == section) {
        DDTableViewSectionComponent *comp = self.headerComponent ?: self.headerFooterComponent;
        if ([comp respondsToSelector:_cmd]) {
            return [comp tableView:tableView heightForHeaderInSection:section];
        }
        else {
            return [super tableView:tableView heightForHeaderInSection:section];
        }
    }
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // footer appear at last component
    if (self.section + _numberOfSections - 1 == section) {
        DDTableViewSectionComponent *comp = self.footerComponent ?: self.headerFooterComponent;
        if ([comp respondsToSelector:_cmd]) {
            return [comp tableView:tableView heightForFooterInSection:section];
        }
        else {
            return [super tableView:tableView heightForFooterInSection:section];
        }
    }
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    DDTableViewSectionComponent *comp = self.headerComponent ?: self.headerFooterComponent;
    if ([comp respondsToSelector:_cmd]) {
        return [comp tableView:tableView viewForHeaderInSection:section];
    }
    else {
        return nil;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    DDTableViewSectionComponent *comp = self.footerComponent ?: self.headerFooterComponent;
    if ([comp respondsToSelector:_cmd]) {
        return [comp tableView:tableView viewForFooterInSection:section];
    }
    else {
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    DDTableViewSectionComponent *comp = self.headerComponent ?: self.headerFooterComponent;
    if ([comp respondsToSelector:_cmd]) {
        [comp tableView:tableView willDisplayHeaderView:view forSection:section];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    DDTableViewSectionComponent *comp = self.footerComponent ?: self.headerFooterComponent;
    if ([comp respondsToSelector:_cmd]) {
        [comp tableView:tableView willDisplayFooterView:view forSection:section];
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section {
    DDTableViewSectionComponent *comp = self.headerComponent ?: self.headerFooterComponent;
    if ([comp respondsToSelector:_cmd]) {
        [comp tableView:tableView didEndDisplayingHeaderView:view forSection:section];
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingFooterView:(UIView *)view forSection:(NSInteger)section {
    DDTableViewSectionComponent *comp = self.footerComponent ?: self.headerFooterComponent;
    if ([comp respondsToSelector:_cmd]) {
        [comp tableView:tableView didEndDisplayingFooterView:view forSection:section];
    }
}

- (NSString *)debugDescription {
    NSMutableString *desc = [[NSMutableString alloc] initWithString:[super debugDescription]];
    if (self.headerComponent) {
        [desc appendString:@"\n  [Header] "];
        [desc appendString:[[self.headerComponent.debugDescription componentsSeparatedByString:@"\n"] componentsJoinedByString:@"\n    "]];
    }
    if (self.footerComponent) {
        [desc appendString:@"\n  [Footer] "];
        [desc appendString:[[self.footerComponent.debugDescription componentsSeparatedByString:@"\n"] componentsJoinedByString:@"\n    "]];
    }
    if (self.headerFooterComponent) {
        [desc appendString:@"\n  [HeaderFooter] "];
        [desc appendString:[[self.headerFooterComponent.debugDescription componentsSeparatedByString:@"\n"] componentsJoinedByString:@"\n    "]];
    }
    return desc;
}

@end

