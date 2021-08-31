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

#import "DDTableViewComponent.h"
#import "DDTableViewComponent+Private.h"
#import "DDTableViewComponent+Cache.h"
#import "DDTableViewSectionGroupComponent.h"

@implementation DDTableViewBaseComponent
@synthesize tableView=_tableView;
@synthesize dataSourceCacheEnable=_dataSourceCacheEnable;
@synthesize sizeCacheEnable=_sizeCacheEnable;

- (instancetype)init
{
    self = [super init];
    if (self) {
        _dataSourceCacheEnable = YES;
        _sizeCacheEnable = YES;
    }
    return self;
}

- (DDTableViewRootComponent *)rootComponent {
    return self.superComponent.rootComponent;
}

- (void)setSuperComponent:(DDTableViewBaseComponent *)superComponent {
    _superComponent = superComponent;
    self.tableView = _superComponent.tableView;
}

- (UITableView *)tableView {
    return _tableView ?: self.superComponent.tableView;
}

- (NSInteger)firstRowOfSubComponent:(id<DDTableViewComponent>)comp {
    return 0;
}

- (NSInteger)firstSectionOfSubComponent:(id<DDTableViewComponent>)comp {
    return 0;
}

- (void)prepareTableView {}

- (void)clearDataSourceCache {}
- (void)clearSizeCache {}

- (NSInteger)row {
    return [self.superComponent firstRowOfSubComponent:self];
}

- (NSInteger)section {
    return [self.superComponent firstSectionOfSubComponent:self];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSAssert(false, @"MUST override!");
    return nil;
}

#pragma mark - convert

- (NSInteger)convertSection:(NSInteger)section toSuperComponent:(DDTableViewBaseComponent *)comp {
    if (self == comp) return section;
    return [self.superComponent convertSection:section fromComponent:self toSuperComponent:comp];
}

- (NSInteger)convertSection:(NSInteger)section fromComponent:(DDTableViewBaseComponent *)from toSuperComponent:(DDTableViewBaseComponent *)comp {
    return [self convertSection:section toSuperComponent:comp];
}

- (NSInteger)convertSection:(NSInteger)section toSubComponent:(DDTableViewBaseComponent *)comp {
    if (self == comp) return section;
    return NSNotFound;
}

- (NSInteger)convertToGlobalSection:(NSInteger)section {
    DDTableViewRootComponent *root = self.rootComponent;
    if (root) {
        return [self convertSection:section toSuperComponent:root];
    }
    else {
        return NSNotFound;
    }
}

- (NSInteger)convertFromGlobalSection:(NSInteger)section {
    DDTableViewRootComponent *root = self.rootComponent;
    if (root) {
        return [root convertSection:section toSubComponent:self];
    }
    else {
        return NSNotFound;
    }
}

- (NSIndexPath *)convertIndexPath:(NSIndexPath *)indexPath toSuperComponent:(DDTableViewBaseComponent *)comp {
    if (self == comp) {
        return indexPath;
    }
    else {
        return [self.superComponent convertIndexPath:indexPath fromComponent:self toSuperComponent:comp];
    }
}

- (NSIndexPath *)convertIndexPath:(NSIndexPath *)indexPath fromComponent:(DDTableViewBaseComponent *)from toSuperComponent:(DDTableViewBaseComponent *)comp {
    return [self convertIndexPath:indexPath toSuperComponent:comp];
}

- (NSIndexPath *)convertIndexPath:(NSIndexPath *)indexPath toSubComponent:(DDTableViewBaseComponent *)comp {
    if (self == comp) {
        return indexPath;
    }
    else {
        return nil;
    }
}

- (NSIndexPath *)convertToGlobalIndexPath:(NSIndexPath *)indexPath {
    return [self convertIndexPath:indexPath toSuperComponent:self.rootComponent];
}

- (NSIndexPath *)convertFromGlobalIndexPath:(NSIndexPath *)indexPath {
    return [self.rootComponent convertIndexPath:indexPath toSubComponent:self];
}

- (DDTableViewBaseComponent *)componentAtIndexPath:(NSIndexPath *)indexPath {
    return self;
}

@end
