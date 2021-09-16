//
//  DDTableViewTextItemComponent.m
//  DDComponent_Example
//
//  Created by mac on 2021/9/16.
//  Copyright © 2021 liuxc123. All rights reserved.
//

#import "DDTableViewTextItemComponent.h"


@interface DDTableViewTextItemComponent ()
@property (nonatomic,copy)  NSString *text;
@end

@implementation DDTableViewTextItemComponent

+ (instancetype)component:(NSString *)text
{
    DDTableViewTextItemComponent *instance = [DDTableViewTextItemComponent new];
    instance.text = text;
    return instance;
}

- (void)prepareTableView {
    [super prepareTableView];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"text_cell"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"text_cell"];
    cell.textLabel.text = self.text;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    __weak typeof(self) weakSelf = self;
    UIContextualAction *delete = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"删除" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        __strong typeof(self) strongSelf = weakSelf;
        if (strongSelf.deleteAction) {
            strongSelf.deleteAction(strongSelf);
        }
    }];
    
    return [UISwipeActionsConfiguration configurationWithActions:@[delete]];
}

@end
