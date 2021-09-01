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

NS_ASSUME_NONNULL_BEGIN

@interface DDTableViewSectionGroupComponent : DDTableViewBaseComponent

@property (strong, nonatomic, nullable) NSArray<DDTableViewBaseComponent *> *subComponents;

- (__kindof DDTableViewBaseComponent * _Nullable)componentAtSection:(NSInteger)atSection;

@end

@interface DDTableViewRootComponent : DDTableViewSectionGroupComponent

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

/**
 Like
 '- (instancetype)initWithTableView:(UITableView *)tableView bind:(BOOL)bind;'
 And bind is YES.
 */
- (instancetype)initWithTableView:(UITableView *)tableView;

/**
 Attach to a table view. It will override its delegate and dataSource.
 But it will not override scroll delegate.

 @param tableView Bind to tableView.
 @param bind Yes will override delegate and dataSource.
 */
- (instancetype)initWithTableView:(UITableView *)tableView bind:(BOOL)bind;

@end

NS_ASSUME_NONNULL_END
