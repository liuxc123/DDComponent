//
//  DDTableComponentFormDemoViewController.m
//  DDComponent_Example
//
//  Created by mac on 2021/9/13.
//  Copyright © 2021 liuxc123. All rights reserved.
//

#import "DDTableComponentFormDemoViewController.h"
#import "DDTableViewFormItemComponent.h"

@interface DDTableComponentFormDemoViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) DDTableViewRootComponent *rootComponent;

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UILabel *label2;
@property (nonatomic, strong) UILabel *label3;

@property (nonatomic, strong) DDTableViewItemGroupComponent *group;

@end

@implementation DDTableComponentFormDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"DDTableFormDemo";

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Refresh" style:UIBarButtonItemStylePlain target:self action:@selector(refreshAction)];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.backgroundColor = UIColor.whiteColor;
    self.tableView.tableFooterView = [UIView new];
    [self.view addSubview:self.tableView];

    self.rootComponent = [[DDTableViewRootComponent alloc] initWithTableView:self.tableView];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大";
    label.numberOfLines = 0;
    label.backgroundColor = UIColor.yellowColor;
    self.label = label;
    
    DDTableViewFormItemComponent *item = [[DDTableViewFormItemComponent alloc] initWithItemView:label];
    item.height = UITableViewAutomaticDimension;
    
    UILabel *label2 = [[UILabel alloc] init];
    label2.text = @"大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大";
    label2.numberOfLines = 0;
    label2.backgroundColor = UIColor.redColor;
    self.label2 = label2;
    
    DDTableViewFormItemComponent *item2 = [[DDTableViewFormItemComponent alloc] initWithItemView:label2];
    item2.height = UITableViewAutomaticDimension;

    DDTableViewItemGroupComponent *group = [DDTableViewItemGroupComponent componentWithSubComponents:@[
        item,
        item2
    ]];
    self.group = group;
    
    self.rootComponent.subComponents = @[group];
    [self.rootComponent reloadData];
}

- (void)refreshAction {
    self.label.text = @"大叔大婶大所大所大所大所大";
    self.label2.text = @"大叔大婶大所大所大所大所大";
    [self.tableView reloadData];
}

+ (NSArray<NSString *> *)catalogBreadcrumbs {
  return @[ @"DDTableFormDemo" ];
}


@end
