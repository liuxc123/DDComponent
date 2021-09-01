//
//  DDTableComponentDemoViewController.m
//  Component
//
//  Created by daniel on 2018/11/17.
//  Copyright © 2018 Daniel. All rights reserved.
//

#import "DDTableComponentDemoViewController.h"
#import "DDTableViewItemDemoComponent.h"
#import "DDTableViewComponent.h"
#import "DDTableViewHeaderFooterSectionDemoComponent.h"
#import "DDTableViewHeaderDemoComponent.h"
#import "DDTableViewFooterDemoComponent.h"

@interface DDTableComponentDemoViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) DDTableViewRootComponent *rootComponent;

@end

@implementation DDTableComponentDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"DDTableDemo";
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.tableView];
    
    self.rootComponent = [[DDTableViewRootComponent alloc] initWithTableView:self.tableView];
    
    DDTableViewItemGroupComponent *section0 = [DDTableViewItemGroupComponent componentWithSubComponents:
                                                   @[
                                                     [DDTableViewItemDemoComponent new],
                                                     [DDTableViewItemDemoComponent new]
                                                     ]];
    section0.headerComponent = [DDTableViewHeaderDemoComponent new];
    section0.footerComponent = [DDTableViewFooterDemoComponent new];
    
    DDTableViewHeaderFooterSectionDemoComponent *section1 = [DDTableViewHeaderFooterSectionDemoComponent componentWithData:@[@"AAA", @"BBB", @"CCC"]];
    section1.headerComponent = [DDTableViewHeaderDemoComponent new];
    section1.footerComponent = [DDTableViewFooterDemoComponent new];
    
    DDTableViewSectionGroupComponent *sectionGroup = [DDTableViewSectionGroupComponent componentWithSubComponents:
                                                      @[
                                                          section0,
                                                          section1,
                                                          [DDTableViewItemGroupComponent componentWithSubComponents:
                                                         @[
                                                           [DDTableViewItemDemo1Component new],
                                                           [DDTableViewItemDemoComponent new]
                                                           ]],
                                                        [DDTableViewHeaderFooterSectionDemoComponent componentWithData:@[@"AAA", @"BBB", @"CCC", @"DDD", @"EEE"]],
                                                        [DDTableViewHeaderFooterSectionDemoComponent  componentWithData:@[@"111", @"222", @"333", @"444", @"555", @"666", @"777", @"888", @"999"]]
                                                        ]];
    
    DDTableViewStatusComponent *status = [DDTableViewStatusComponent componentWithComponents: @{ @"normal": sectionGroup }];
    status.currentState = @"normal";

    self.rootComponent.subComponents = @[status];
    
    [self.tableView reloadData];
}

+ (NSArray<NSString *> *)catalogBreadcrumbs {
  return @[ @"DDTableDemo" ];
}

@end
