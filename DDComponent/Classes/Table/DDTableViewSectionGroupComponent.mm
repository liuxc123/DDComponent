// MIT License
//
// Copyright (c) 2016 Daniel (djs66256@163.com)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

#import "DDTableViewSectionGroupComponent.h"
#import "DDTableViewComponent+Private.h"
#import "DDTableViewComponent+Cache.h"
#import <vector>

@implementation DDTableViewSectionGroupComponent {
    std::vector<NSInteger> _numberOfSectionCache;
}

#pragma mark - interface

- (void)setSubComponents:(NSArray *)subComponents {
    for (DDTableViewBaseComponent *comp in _subComponents) {
        if (comp.superComponent == self) {
            comp.superComponent = nil;
        }
    }
    _subComponents = subComponents;
    for (DDTableViewBaseComponent *comp in _subComponents) {
        comp.superComponent = self;
        if (self.tableView) {
            [comp prepareTableView];
        }
    }
}

- (void)setTableView:(UITableView *)tableView {
    [super setTableView:tableView];
    [_subComponents enumerateObjectsUsingBlock:^(__kindof DDTableViewBaseComponent * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj setTableView:tableView];
    }];
}

- (void)prepareTableView {
    [super prepareTableView];
    if (self.tableView) {
        for (DDTableViewBaseComponent *comp in _subComponents) {
            [comp prepareTableView];
        }
    }
}

- (NSInteger)firstSectionOfSubComponent:(id<DDTableViewComponent>)subComp {
    UITableView *tableView = self.tableView;
    if (tableView) {
        __block NSInteger section = self.section;
        __block BOOL matched = NO;
        [_subComponents enumerateObjectsUsingBlock:^(DDTableViewBaseComponent *comp, NSUInteger idx, BOOL *stop) {
            if (comp == subComp) {
                matched = YES;
                *stop = YES;
            }
            else {
                // When dataSourceCacheEnable = NO, _numberOfSectionCache.size == 0
                if (_numberOfSectionCache.size() > idx) {
                    section += _numberOfSectionCache[idx];
                }
                else {
                    section += [comp numberOfSectionsInTableView:tableView];
                }
            }
        }];
        if (matched) {
            return section;
        }
    }
    return 0;
}

- (DDTableViewBaseComponent *)componentAtSection:(NSInteger)atSection {
    UITableView *tableView = self.tableView;
    __block DDTableViewBaseComponent *component = nil;

    if (tableView) {
        __block NSInteger section = self.section;
        [_subComponents enumerateObjectsUsingBlock:^(DDTableViewBaseComponent *comp, NSUInteger idx, BOOL *stop) {
            NSInteger count = 0;
            // When dataSourceCacheEnable = NO, _numberOfSectionCache.size == 0
            if (_numberOfSectionCache.size() > idx) {
                count = _numberOfSectionCache[idx];
            }
            else {
                count += [comp numberOfSectionsInTableView:tableView];
            }
            if (section <= atSection && section+count > atSection) {
                component = comp;
                *stop = YES;
            }
            section += count;
        }];
    }
    return component;
}


- (void)reloadData {
    if (self.tableView) {
        [self.tableView beginUpdates];
        NSInteger sections = [self numberOfSectionsInTableView:self.tableView];
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(self.section, sections)];
        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger sections = 0;
    if (self.dataSourceCacheEnable) {
        _numberOfSectionCache.clear();
        _numberOfSectionCache.reserve(_subComponents.count);
        for (DDTableViewBaseComponent *comp in _subComponents) {
            NSInteger number = [comp numberOfSectionsInTableView:tableView];
            sections += number;
            _numberOfSectionCache.push_back(number);
        }
    }
    else {
        for (DDTableViewBaseComponent *comp in _subComponents) {
            sections += [comp numberOfSectionsInTableView:tableView];
        }
    }
    return sections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    DDTableViewBaseComponent *comp = [self componentAtSection:section];
    return [comp tableView:tableView numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DDTableViewBaseComponent *comp = [self componentAtSection:indexPath.section];
    return [comp tableView:tableView cellForRowAtIndexPath:indexPath];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    DDTableViewBaseComponent *comp = [self componentAtSection:section];
    if ([comp respondsToSelector:_cmd]) {
        return [comp tableView:tableView titleForHeaderInSection:section];
    }
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    DDTableViewBaseComponent *comp = [self componentAtSection:section];
    if ([comp respondsToSelector:_cmd]) {
        return [comp tableView:tableView titleForFooterInSection:section];
    }
    return nil;
}

// Editing

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    DDTableViewBaseComponent *comp = [self componentAtSection:indexPath.section];
    if ([comp respondsToSelector:_cmd]) {
        return [comp tableView:tableView canEditRowAtIndexPath:indexPath];
    }
    return NO;
}

// Moving/reordering

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    DDTableViewBaseComponent *comp = [self componentAtSection:indexPath.section];
    if ([comp respondsToSelector:_cmd]) {
        return [comp tableView:tableView canMoveRowAtIndexPath:indexPath];
    }
    return NO;
}

// Data manipulation - insert and delete support

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    DDTableViewBaseComponent *comp = [self componentAtSection:indexPath.section];
    if ([comp respondsToSelector:_cmd]) {
        return [comp tableView:tableView commitEditingStyle:editingStyle forRowAtIndexPath:indexPath];
    }
}

// Data manipulation - reorder / moving support

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    DDTableViewBaseComponent *comp = [self componentAtSection:sourceIndexPath.section];
    if ([comp respondsToSelector:_cmd]) {
        return [comp tableView:tableView moveRowAtIndexPath:sourceIndexPath toIndexPath:destinationIndexPath];
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    DDTableViewBaseComponent *comp = [self componentAtSection:indexPath.section];
    if ([comp respondsToSelector:_cmd]) {
        [comp tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    DDTableViewBaseComponent *comp = [self componentAtSection:section];
    if ([comp respondsToSelector:_cmd]) {
        [comp tableView:tableView willDisplayHeaderView:view forSection:section];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    DDTableViewBaseComponent *comp = [self componentAtSection:section];
    if ([comp respondsToSelector:_cmd]) {
        [comp tableView:tableView willDisplayFooterView:view forSection:section];
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    DDTableViewBaseComponent *comp = [self componentAtSection:indexPath.section];
    if ([comp respondsToSelector:_cmd]) {
        [comp tableView:tableView didEndDisplayingCell:cell forRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section {
    DDTableViewBaseComponent *comp = [self componentAtSection:section];
    if ([comp respondsToSelector:_cmd]) {
        [comp tableView:tableView didEndDisplayingHeaderView:view forSection:section];
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingFooterView:(UIView *)view forSection:(NSInteger)section {
    DDTableViewBaseComponent *comp = [self componentAtSection:section];
    if ([comp respondsToSelector:_cmd]) {
        [comp tableView:tableView didEndDisplayingFooterView:view forSection:section];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    DDTableViewBaseComponent *comp = [self componentAtSection:indexPath.section];
    if ([comp respondsToSelector:_cmd]) {
        return [comp tableView:tableView heightForRowAtIndexPath:indexPath];
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    DDTableViewBaseComponent *comp = [self componentAtSection:section];
    if ([comp respondsToSelector:_cmd]) {
        return [comp tableView:tableView heightForHeaderInSection:section];
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    DDTableViewBaseComponent *comp = [self componentAtSection:section];
    if ([comp respondsToSelector:_cmd]) {
        return [comp tableView:tableView heightForFooterInSection:section];
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    DDTableViewBaseComponent *comp = [self componentAtSection:indexPath.section];
    if ([comp respondsToSelector:_cmd]) {
        return [comp tableView:tableView estimatedHeightForRowAtIndexPath:indexPath];
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section {
    DDTableViewBaseComponent *comp = [self componentAtSection:section];
    if ([comp respondsToSelector:_cmd]) {
        return [comp tableView:tableView estimatedHeightForHeaderInSection:section];
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section {
    DDTableViewBaseComponent *comp = [self componentAtSection:section];
    if ([comp respondsToSelector:_cmd]) {
        return [comp tableView:tableView estimatedHeightForHeaderInSection:section];
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    DDTableViewBaseComponent *comp = [self componentAtSection:section];
    if ([comp respondsToSelector:_cmd]) {
        return [comp tableView:tableView viewForHeaderInSection:section];
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    DDTableViewBaseComponent *comp = [self componentAtSection:section];
    if ([comp respondsToSelector:_cmd]) {
        return [comp tableView:tableView viewForFooterInSection:section];
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    DDTableViewBaseComponent *comp = [self componentAtSection:indexPath.section];
    if ([comp respondsToSelector:_cmd]) {
        [comp tableView:tableView accessoryButtonTappedForRowWithIndexPath:indexPath];
    }
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    DDTableViewBaseComponent *comp = [self componentAtSection:indexPath.section];
    if ([comp respondsToSelector:_cmd]) {
        return [comp tableView:tableView shouldHighlightRowAtIndexPath:indexPath];
    }
    return YES;
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    DDTableViewBaseComponent *comp = [self componentAtSection:indexPath.section];
    if ([comp respondsToSelector:_cmd]) {
        [comp tableView:tableView didHighlightRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    DDTableViewBaseComponent *comp = [self componentAtSection:indexPath.section];
    if ([comp respondsToSelector:_cmd]) {
        [comp tableView:tableView didUnhighlightRowAtIndexPath:indexPath];
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DDTableViewBaseComponent *comp = [self componentAtSection:indexPath.section];
    if ([comp respondsToSelector:_cmd]) {
        return [comp tableView:tableView willSelectRowAtIndexPath:indexPath];
    }
    return indexPath;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    DDTableViewBaseComponent *comp = [self componentAtSection:indexPath.section];
    if ([comp respondsToSelector:_cmd]) {
        return [comp tableView:tableView willDeselectRowAtIndexPath:indexPath];
    }
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DDTableViewBaseComponent *comp = [self componentAtSection:indexPath.section];
    if ([comp respondsToSelector:_cmd]) {
        [comp tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    DDTableViewBaseComponent *comp = [self componentAtSection:indexPath.section];
    if ([comp respondsToSelector:_cmd]) {
        [comp tableView:tableView didDeselectRowAtIndexPath:indexPath];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    DDTableViewBaseComponent *comp = [self componentAtSection:indexPath.section];
    if ([comp respondsToSelector:_cmd]) {
        return [comp tableView:tableView editingStyleForRowAtIndexPath:indexPath];
    }
    return UITableViewCellEditingStyleNone;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    DDTableViewBaseComponent *comp = [self componentAtSection:indexPath.section];
    if ([comp respondsToSelector:_cmd]) {
        return [comp tableView:tableView titleForDeleteConfirmationButtonForRowAtIndexPath:indexPath];
    }
    return nil;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    DDTableViewBaseComponent *comp = [self componentAtSection:indexPath.section];
    if ([comp respondsToSelector:_cmd]) {
        return [comp tableView:tableView editActionsForRowAtIndexPath:indexPath];
    }
    return nil;
}

- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView leadingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath  API_AVAILABLE(ios(11.0)) {
    DDTableViewBaseComponent *comp = [self componentAtSection:indexPath.section];
    if ([comp respondsToSelector:_cmd]) {
        return [comp tableView:tableView leadingSwipeActionsConfigurationForRowAtIndexPath:indexPath];
    }
    return nil;
}

- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath  API_AVAILABLE(ios(11.0)) {
    DDTableViewBaseComponent *comp = [self componentAtSection:indexPath.section];
    if ([comp respondsToSelector:_cmd]) {
        return [comp tableView:tableView trailingSwipeActionsConfigurationForRowAtIndexPath:indexPath];
    }
    return nil;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    DDTableViewBaseComponent *comp = [self componentAtSection:indexPath.section];
    if ([comp respondsToSelector:_cmd]) {
        return [comp tableView:tableView shouldIndentWhileEditingRowAtIndexPath:indexPath];
    }
    return YES;
}

- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    DDTableViewBaseComponent *comp = [self componentAtSection:indexPath.section];
    if ([comp respondsToSelector:_cmd]) {
        [comp tableView:tableView willBeginEditingRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    DDTableViewBaseComponent *comp = [self componentAtSection:indexPath.section];
    if ([comp respondsToSelector:_cmd]) {
        [comp tableView:tableView didEndEditingRowAtIndexPath:indexPath];
    }
}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath {
    DDTableViewBaseComponent *comp = [self componentAtSection:indexPath.section];
    if ([comp respondsToSelector:_cmd]) {
        return [comp tableView:tableView indentationLevelForRowAtIndexPath: indexPath];
    }
    return 0;
}

- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath {
    DDTableViewBaseComponent *comp = [self componentAtSection:indexPath.section];
    if ([comp respondsToSelector:_cmd]) {
        return [comp tableView:tableView shouldShowMenuForRowAtIndexPath: indexPath];
    }
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
    DDTableViewBaseComponent *comp = [self componentAtSection:indexPath.section];
    if ([comp respondsToSelector:_cmd]) {
        return [comp tableView:tableView canPerformAction:action forRowAtIndexPath:indexPath withSender:sender];
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
    DDTableViewBaseComponent *comp = [self componentAtSection:indexPath.section];
    if ([comp respondsToSelector:_cmd]) {
        [comp tableView:tableView performAction:action forRowAtIndexPath:indexPath withSender:sender];
    }
}

- (NSString *)debugDescription {
    NSMutableString *desc = [[NSMutableString alloc] initWithString:self.description];
    if (self.subComponents.count > 0) {
        [desc appendString:@"\n  [SubComponents]"];
        for (DDTableViewBaseComponent *comp in self.subComponents) {
            [desc appendString:@"\n    "];
            NSArray *descs = [comp.debugDescription componentsSeparatedByString:@"\n"];
            [desc appendString:[descs componentsJoinedByString:@"\n    "]];
        }
    }
    return desc;
}

@end

@interface DDTableViewRootComponent ()

@property (nonatomic, weak) id<UIScrollViewDelegate> scrollDelegate;

@end


@implementation DDTableViewRootComponent
@synthesize tableView = _tableView;

- (void)dealloc
{
    _tableView.delegate = nil;
    _tableView.dataSource = nil;
    _scrollDelegate = nil;
}

- (instancetype)initWithTableView:(UITableView *)tableView {
    return [self initWithTableView:tableView bind:YES];
}

- (instancetype)initWithTableView:(UITableView *)tableView bind:(BOOL)bind
{
    self = [super init];
    if (self) {
        self.tableView = tableView;
        if (bind) {
            self.scrollDelegate = tableView.delegate;
            tableView.dataSource = self;
            tableView.delegate = self;
        }
    }
    return self;
}

- (DDTableViewBaseComponent *)superComponent {
    return nil;
}

- (DDTableViewRootComponent *)rootComponent {
    return self;
}

- (NSInteger)section {
    return 0;
}

- (NSInteger)row {
    return 0;
}

- (void)reloadData {
    [self.tableView reloadData];
}

#pragma mark - ScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([_scrollDelegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [_scrollDelegate scrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if ([_scrollDelegate respondsToSelector:@selector(scrollViewWillBeginDragging:)]) {
        [_scrollDelegate scrollViewWillBeginDragging:scrollView];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if ([_scrollDelegate respondsToSelector:@selector(scrollViewWillEndDragging:withVelocity:targetContentOffset:)]) {
        [_scrollDelegate scrollViewWillEndDragging:scrollView withVelocity:velocity targetContentOffset:targetContentOffset];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if ([_scrollDelegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)]) {
        [_scrollDelegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    if ([_scrollDelegate respondsToSelector:@selector(scrollViewWillBeginDecelerating:)]) {
        [_scrollDelegate scrollViewWillBeginDecelerating:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ([_scrollDelegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)]) {
        [_scrollDelegate scrollViewDidEndDecelerating:scrollView];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if ([_scrollDelegate respondsToSelector:@selector(scrollViewDidEndScrollingAnimation:)]) {
        [_scrollDelegate scrollViewDidEndScrollingAnimation:scrollView];
    }
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
    if ([_scrollDelegate respondsToSelector:@selector(scrollViewShouldScrollToTop:)]) {
        return [_scrollDelegate scrollViewShouldScrollToTop:scrollView];
    }
    return YES;
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    if ([_scrollDelegate respondsToSelector:@selector(scrollViewDidScrollToTop:)]) {
        [_scrollDelegate scrollViewDidScrollToTop:scrollView];
    }
}

@end
