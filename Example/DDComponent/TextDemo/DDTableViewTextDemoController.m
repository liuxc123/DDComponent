//
//  DDTableViewTextDemoController.m
//  DDComponent_Example
//
//  Created by mac on 2021/9/16.
//  Copyright © 2021 liuxc123. All rights reserved.
//

#import "DDTableViewTextDemoController.h"
#import "DDTableViewTextItemComponent.h"

@interface DDTableViewTextDemoController () <UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) DDTableViewRootComponent *rootComponent;

@end

@implementation DDTableViewTextDemoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.backgroundColor = UIColor.whiteColor;
    self.tableView.tableFooterView = [UIView new];
    [self.view addSubview:self.tableView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                                                                           target:self
                                                                                           action:@selector(edit:)];
    
    self.rootComponent = [[DDTableViewRootComponent alloc] initWithTableView:self.tableView];
    
    DDTableViewItemGroupComponent *group = [DDTableViewItemGroupComponent new];
    
    NSMutableArray *components = [NSMutableArray array];
    
    DDTableViewTextItemComponent *item = [DDTableViewTextItemComponent component:@"Text Cell"];
    item.height = 44;
    item.deleteAction = ^(DDTableViewTextItemComponent * _Nonnull item) {
        [components removeObject:item];
        group.subComponents = components;
        [self.rootComponent reloadData];
    };
    [components addObject:item];
    
    DDTableViewTextItemComponent *item2 = [DDTableViewTextItemComponent component:@"Text Cell"];
    item2.height = 44;
    [components addObject:item2];
    item2.deleteAction = ^(DDTableViewTextItemComponent * _Nonnull item) {
        [components removeObject:item];
        group.subComponents = components;
        [self.rootComponent reloadData];
    };

    
    DDTableViewTextItemComponent *item3 = [DDTableViewTextItemComponent component:@"Text Cell"];
    item3.height = 44;
    [components addObject:item3];
    item3.deleteAction = ^(DDTableViewTextItemComponent * _Nonnull item) {
        [components removeObject:item];
        group.subComponents = components;
        [self.rootComponent reloadData];
    };

    group.subComponents = components;
    
    self.rootComponent.subComponents = @[group];
    [self.rootComponent reloadData];
}

- (void)edit:(id)sender
{
    UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"编辑"
                                                                message:nil
                                                         preferredStyle:UIAlertControllerStyleActionSheet];
    NSArray *actions = @[
        [self cancelAction]
    ];
    
    for(UIAlertAction *action in actions)
    {
        [vc addAction:action];
    }
    [self presentViewController:vc
                       animated:YES
                     completion:nil];
    
}

#pragma mark - action
- (UIAlertAction *)cancelAction
{
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消"
                                                     style:UIAlertActionStyleCancel
                                                   handler:nil];
    return action;
}


+ (NSArray<NSString *> *)catalogBreadcrumbs {
    return @[ @"DDTableTextDemo" ];
}

@end
