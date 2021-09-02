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
    
    DDCollectionViewItemGroupComponent *section0 = [DDCollectionViewItemGroupComponent componentWithSubComponents:
                                                   @[
                                                     [DDCollectionViewItemDemoComponent new],
                                                     [DDCollectionViewItemDemoComponent new]
                                                     ]];
    section0.headerComponent = [DDCollectionViewHeaderComponent new];
    section0.footerComponent = [DDCollectionViewFooterComponent new];
    
    DDCollectionViewHeaderFooterSectionDemoComponent *section1 = [DDCollectionViewHeaderFooterSectionDemoComponent componentWithHeader:[DDCollectionViewHeaderComponent new]
                                                                                                                      footer:[DDCollectionViewFooterComponent new]];
    section1.demoData = @[@[@"123", @"456", @"789"]];

    DDCollectionViewHeaderFooterSectionDemoComponent *section2 = [DDCollectionViewHeaderFooterSectionDemoComponent componentWithHeader:[DDCollectionViewHeaderComponent new]
                                                                                                                                footer:[DDCollectionViewFooterComponent new]];
    section2.demoData = @[@[@"123", @"456", @"789"]];
    
    DDCollectionViewSectionGroupComponent *sectionGroup = [DDCollectionViewSectionGroupComponent componentWithSubComponents:
                                                      @[[DDCollectionViewItemGroupComponent componentWithSubComponents:
                                                         @[
                                                           [DDCollectionViewItemDemoComponent new],
                                                           [DDCollectionViewItemDemoComponent new],
                                                           [DDCollectionViewHeaderFooterSectionDemoComponent componentWithData:@[@[@"AA", @"BB"], @[@"aa", @"bb", @"cc"]]],
                                                           [DDCollectionViewHeaderFooterSectionDemoComponent  componentWithData:@[@[@"11", @"22"], @[@"111", @"222", @"333"], @[@"1111", @"2222", @"3333", @"4444"]]],
                                                           ]],
                                        
                                                        section0,
                                                        section1,
                                                        section2
                                                        ]];
    
    DDCollectionViewStatusComponent *status = [DDCollectionViewStatusComponent componentWithComponents:
                                          @{ @"normal": sectionGroup }];
    self.rootComponent.subComponents = @[sectionGroup];
    
    status.currentState = @"normal";
    
    [self.rootComponent reloadData];

    [self.rootComponent reloadData];
    
    NSLog(@"%@", [self.rootComponent debugDescription]);
    
    NSLog(@"section0 firstSection:%ld, firstItem:%ld", section0.section, section0.item);
    NSLog(@"section1 firstSection:%ld, firstItem:%ld", section1.section, section1.item);
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
