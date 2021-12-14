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
    
    DDTableViewFormItemComponent *item = [[DDTableViewFormItemComponent alloc] initWithItemView:self.label];
    item.height = UITableViewAutomaticDimension;
    
    DDTableViewFormItemComponent *item2 = [[DDTableViewFormItemComponent alloc] initWithItemView:self.label2];
    item2.height = UITableViewAutomaticDimension;
    
    DDTableViewFormItemComponent *item3 = [[DDTableViewFormItemComponent alloc] initWithItemView:self.label3];
    item3.height = UITableViewAutomaticDimension;

    DDTableViewItemGroupComponent *group = [DDTableViewItemGroupComponent componentWithSubComponents:@[
        item,
        item2,
        item3
    ]];
    self.group = group;
    
    self.rootComponent.subComponents = @[group];
    [self.rootComponent reloadData];
}

- (void)refreshAction {
    self.label.text = @"大叔大婶大所大所大所大所大";
    self.label2.text = @"大叔大婶大所大所大所大所大";
    self.label3.text = @"大叔大婶大所大所大所大所大";
    [self.rootComponent reloadData];
}

- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.text = @"大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大";
        _label.numberOfLines = 0;
        _label.backgroundColor = UIColor.yellowColor;
    }
    return _label;
}

- (UILabel *)label2 {
    if (!_label2) {
        _label2 = [[UILabel alloc] init];
        _label2.text = @"大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大";
        _label2.numberOfLines = 0;
        _label2.backgroundColor = UIColor.redColor;
    }
    return _label2;
}

- (UILabel *)label3 {
    if (!_label3) {
        _label3 = [[UILabel alloc] init];
        _label3.text = @"大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大";
        _label3.numberOfLines = 0;
        _label3.backgroundColor = UIColor.grayColor;
    }
    return _label3;
}

+ (NSArray<NSString *> *)catalogBreadcrumbs {
  return @[ @"DDTableFormDemo" ];
}


@end
