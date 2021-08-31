//
//  DDCollectionComponentDemoViewController.m
//  DDComponent_Example
//
//  Created by mac on 2021/8/31.
//  Copyright © 2021 liuxc123. All rights reserved.
//

#import "DDCollectionComponentDemoViewController.h"
#import "DDCollectionViewItemDemoComponent.h"
#import "DDCollectionViewHeaderFooterSectionDemoComponent.h"

@interface DDCollectionComponentDemoViewController ()

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) DDCollectionViewRootComponent *rootComponent;

@end

@implementation DDCollectionComponentDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"DDCollectionDemo";
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:[UICollectionViewFlowLayout new]];
    self.collectionView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.collectionView];

    self.rootComponent = [[DDCollectionViewRootComponent alloc] initWithCollectionView:self.collectionView];
    
    DDCollectionViewSectionGroupComponent *sectionGroup = [DDCollectionViewSectionGroupComponent componentWithSubComponents:
                                                      @[[DDCollectionViewItemGroupComponent componentWithSubComponents:
                                                         @[
                                                           [DDCollectionViewItemDemoComponent new]
                                                           ]],
                                                        [DDCollectionViewHeaderFooterSectionDemoComponent componentWithData:@[@[@"AAA", @"BBB"], @[@"CCC", @"DDD", @"EEE"]]],
                                                        [DDCollectionViewHeaderFooterSectionDemoComponent  componentWithData:@[@[@"111", @"222"], @[@"333", @"444", @"555"], @[@"666", @"777", @"888", @"999"]]]
                                                        ]];
        
    self.rootComponent.subComponents = @[sectionGroup];
    
    [self.collectionView reloadData];
}

+ (NSArray<NSString *> *)catalogBreadcrumbs {
  return @[ @"DDCollectionDemo" ];
}

@end
