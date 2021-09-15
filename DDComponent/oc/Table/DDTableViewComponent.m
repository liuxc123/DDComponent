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
//@synthesize heightCacheEnable=_heightCacheEnable;

- (instancetype)init
{
    self = [super init];
    if (self) {
        _dataSourceCacheEnable = YES;
//        _heightCacheEnable = YES;
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

- (NSInteger)firstRowOfSubComponent:(id<DDTableViewComponent>)subComp {
    return 0;
}

- (NSInteger)firstSectionOfSubComponent:(id<DDTableViewComponent>)subComp {
    return 0;
}

- (void)prepareTableView {}

- (void)reloadData {}

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

- (NSInteger)convertFromGlobalSection:(NSInteger)section {
    NSInteger differenceSection = ABS(section - self.section);
    return differenceSection;
}

- (NSIndexPath *)convertFromGlobalIndexPath:(NSIndexPath *)indexPath {
    NSInteger differenceSection = ABS(indexPath.section - self.section);
    NSInteger differenceRow = ABS(indexPath.row - self.row);
    return [NSIndexPath indexPathForRow:differenceRow inSection:differenceSection];
}

@end
