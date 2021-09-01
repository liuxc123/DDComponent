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
#import "DDSectionBackgroundDecorationView.h"
#import "DDCollectionViewHeaderComponent.h"
#import "DDCollectionViewFooterComponent.h"

@interface DDCollectionComponentDemoViewController ()

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) DDCollectionViewRootComponent *rootComponent;

@end

@implementation DDCollectionComponentDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"DDCollectionDemo";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Refresh" style:UIBarButtonItemStylePlain target:self action:@selector(refreshAction)];

    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:[self createLayout]];
    self.collectionView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.collectionView];

    self.rootComponent = [[DDCollectionViewRootComponent alloc] initWithCollectionView:self.collectionView];
    
    DDCollectionViewHeaderFooterSectionDemoComponent *section0 = [DDCollectionViewHeaderFooterSectionDemoComponent componentWithData:@[@"AAA", @"BBB", @"CCC", @"DDD", @"EEE"]];
    section0.headerComponent = [DDCollectionViewHeaderComponent new];
    section0.footerComponent = [DDCollectionViewFooterComponent new];
    
    
    DDCollectionViewHeaderFooterSectionDemoComponent *section1 = [DDCollectionViewHeaderFooterSectionDemoComponent componentWithData:@[@"AAA", @"BBB", @"CCC", @"DDD", @"EEE"]];
    section1.headerComponent = [DDCollectionViewHeaderComponent new];
    section1.footerComponent = [DDCollectionViewFooterComponent new];
    
    self.rootComponent.subComponents = @[
        [DDCollectionViewSectionGroupComponent componentWithSubComponents: @[
            [DDCollectionViewItemGroupComponent componentWithSubComponents:@[
                [DDCollectionViewItemDemoComponent new],
                [DDCollectionViewItemDemoComponent new],
                [DDCollectionViewItemDemoComponent new]
            ]],
            [DDCollectionViewItemGroupComponent componentWithSubComponents:@[
                [DDCollectionViewItemDemoComponent new],
                [DDCollectionViewItemDemoComponent new],
                [DDCollectionViewItemDemoComponent new]
            ]],
            section0,
            section1
        ]]
    ];

    
    [self.rootComponent reloadData];
    
}

- (UICollectionViewLayout *)createLayout {
    
    NSCollectionLayoutSize *itemSize = [NSCollectionLayoutSize
                                        sizeWithWidthDimension:[NSCollectionLayoutDimension fractionalWidthDimension:1.0]
                                        heightDimension:[NSCollectionLayoutDimension absoluteDimension:60]];
    NSCollectionLayoutItem *item = [NSCollectionLayoutItem itemWithLayoutSize:itemSize];
    
    
    NSCollectionLayoutSize *groupSize = [NSCollectionLayoutSize
                                        sizeWithWidthDimension:[NSCollectionLayoutDimension fractionalWidthDimension:1.0]
                                        heightDimension:[NSCollectionLayoutDimension absoluteDimension:60]];
    NSCollectionLayoutGroup *group = [NSCollectionLayoutGroup horizontalGroupWithLayoutSize:groupSize subitems:@[item]];
    
    NSCollectionLayoutSection *section = [NSCollectionLayoutSection sectionWithGroup:group];
    section.interGroupSpacing = 5;
    section.contentInsets = NSDirectionalEdgeInsetsMake(10, 10, 10, 10);
    
    /// section background
    NSCollectionLayoutDecorationItem *sectionBackgroundDecoration = [NSCollectionLayoutDecorationItem backgroundDecorationItemWithElementKind:@"DDSectionBackgroundDecorationView"];
    sectionBackgroundDecoration.contentInsets = NSDirectionalEdgeInsetsMake(5, 5, 5, 5);
    section.decorationItems = @[sectionBackgroundDecoration];

    /// layout
    UICollectionViewCompositionalLayout *layout = [[UICollectionViewCompositionalLayout alloc] initWithSection:section];
    [layout registerClass:[DDSectionBackgroundDecorationView class] forDecorationViewOfKind:@"DDSectionBackgroundDecorationView"];
    return layout;
}

- (UICollectionViewLayout *)createFlowLayout {
    return [UICollectionViewFlowLayout new];
}

- (void)refreshAction {
    if ([self.collectionView.collectionViewLayout isKindOfClass:[UICollectionViewFlowLayout class]]) {
        self.collectionView.collectionViewLayout = [self createLayout];
    }
    else {
        self.collectionView.collectionViewLayout = [self createFlowLayout];
    }
    [self.collectionView.collectionViewLayout invalidateLayout];
}

+ (NSArray<NSString *> *)catalogBreadcrumbs {
  return @[ @"DDCollectionDemo" ];
}

@end
