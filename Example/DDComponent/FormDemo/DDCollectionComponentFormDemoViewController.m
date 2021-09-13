//
//  DDCollectionComponentFormDemoViewController.m
//  DDComponent_Example
//
//  Created by mac on 2021/9/7.
//  Copyright © 2021 liuxc123. All rights reserved.
//

#import "DDCollectionComponentFormDemoViewController.h"
#import "DDCollectionViewFormItemComponent.h"

@interface DDCollectionComponentFormDemoViewController ()

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) DDCollectionViewRootComponent *rootComponent;

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UILabel *label2;
@property (nonatomic, strong) UILabel *label3;

@property (nonatomic, strong) DDCollectionViewItemGroupComponent *group;

@end

@implementation DDCollectionComponentFormDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"DDCollectionFormDemo";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Refresh" style:UIBarButtonItemStylePlain target:self action:@selector(refreshAction)];
    
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.estimatedItemSize = CGSizeMake(self.view.frame.size.width, 60);
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout: layout];
    self.collectionView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.collectionView];

    self.rootComponent = [[DDCollectionViewRootComponent alloc] initWithCollectionView:self.collectionView];
    
    /// item1

    UILabel *label = [[UILabel alloc] init];
    label.text = @"大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大";
    label.numberOfLines = 0;
    label.backgroundColor = UIColor.yellowColor;
    self.label = label;

    
    DDComponentLayoutSize *itemSize = [DDComponentLayoutSize
                                        sizeWithWidthDimension:[DDComponentLayoutDimension fractionalWidthDimension:1.0]
                                        heightDimension:[DDComponentLayoutDimension estimatedDimension:60]];
    
    DDCollectionViewFormItemComponent *item = [[DDCollectionViewFormItemComponent alloc] initWithItemView:label itemSize:itemSize];
    item.size = CGSizeMake(DDComponentAutomaticDimension, DDComponentAutomaticDimension);
    
    
    /// item2
    UILabel *label2 = [[UILabel alloc] init];
    label2.text = @"大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大\n大叔大婶大所大所大所大所大";
    label2.numberOfLines = 0;
    label2.backgroundColor = UIColor.redColor;
    self.label2 = label2;
    
    DDCollectionViewFormItemComponent *item2 = [[DDCollectionViewFormItemComponent alloc] initWithItemView:label2 itemSize:itemSize];
    item2.size = CGSizeMake(DDComponentAutomaticDimension, DDComponentAutomaticDimension);
    
    
    /// Group
    DDCollectionViewItemGroupComponent *group = [DDCollectionViewItemGroupComponent componentWithSubComponents:@[
        item,
        item2
    ]];
    group.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    self.group = group;
    
    self.rootComponent.subComponents = @[group];
    [self.rootComponent reloadData];
}

- (void)refreshAction {
    self.label.text = @"大叔大婶大所大所大所大所大";
    self.label2.text = @"大叔大婶大所大所大所大所大";
    [UIView animateWithDuration:0.5 animations:^{
        [self.collectionView.collectionViewLayout invalidateLayout];
    }];
}

+ (NSArray<NSString *> *)catalogBreadcrumbs {
  return @[ @"DDCollectionFormDemo" ];
}

@end
