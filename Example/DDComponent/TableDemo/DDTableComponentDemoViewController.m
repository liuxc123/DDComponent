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
    
    DDTableViewHeaderFooterSectionDemoComponent *section1 = [DDTableViewHeaderFooterSectionDemoComponent componentWithHeader:[DDTableViewHeaderDemoComponent new]
                                                                                                                      footer:[DDTableViewFooterDemoComponent new]];
    section1.demoData = @[@[@"123", @"456", @"789"]];

    DDTableViewHeaderFooterSectionDemoComponent *section2 = [DDTableViewHeaderFooterSectionDemoComponent componentWithHeader:[DDTableViewHeaderDemoComponent new]
                                                                                                                      footer:[DDTableViewFooterDemoComponent new]];
    section2.demoData = @[@[@"123", @"456", @"789"]];
    
    DDTableViewSectionGroupComponent *sectionGroup = [DDTableViewSectionGroupComponent componentWithSubComponents:
                                                      @[[DDTableViewItemGroupComponent componentWithSubComponents:
                                                         @[
                                                           [DDTableViewItemDemo1Component new],
                                                           [DDTableViewItemDemoComponent new],
                                                           [DDTableViewHeaderFooterSectionDemoComponent componentWithData:@[@[@"AA", @"BB"], @[@"aa", @"bb", @"cc"]]],
                                                           [DDTableViewHeaderFooterSectionDemoComponent  componentWithData:@[@[@"11", @"22"], @[@"111", @"222", @"333"], @[@"1111", @"2222", @"3333", @"4444"]]],
                                                           ]],
                                        
                                                        section0,
                                                        section1,
                                                        section2
                                                        ]];
    
    DDTableViewStatusComponent *status = [DDTableViewStatusComponent componentWithComponents:
                                          @{ @"normal": sectionGroup }];
    self.rootComponent.subComponents = @[sectionGroup];
    
    status.currentState = @"normal";
    
    [self.rootComponent reloadData];
    
    NSLog(@"%@", [self.rootComponent debugDescription]);
    
    NSLog(@"section0 firstSection:%ld, firstRow:%ld", section0.section, section0.row);
    NSLog(@"section1 firstSection:%ld, firstRow:%ld", section1.section, section1.row);
    NSLog(@"section2 firstSection:%ld, firstRow:%ld", section2.section, section1.row);

    
}

+ (NSArray<NSString *> *)catalogBreadcrumbs {
  return @[ @"DDTableDemo" ];
}

@end
