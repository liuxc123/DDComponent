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
    DDComponentLayoutSize *itemSize = [DDComponentLayoutSize
                                        sizeWithWidthDimension:[DDComponentLayoutDimension fractionalWidthDimension:1.0]
                                        heightDimension:[DDComponentLayoutDimension estimatedDimension:60]];
    
    DDCollectionViewFormItemComponent *item = [[DDCollectionViewFormItemComponent alloc] initWithItemView:self.label itemSize:itemSize];
    item.size = CGSizeMake(DDComponentAutomaticDimension, DDComponentAutomaticDimension);
    
    
    /// item2
    DDCollectionViewFormItemComponent *item2 = [[DDCollectionViewFormItemComponent alloc] initWithItemView:self.label2 itemSize:itemSize];
    item2.size = CGSizeMake(DDComponentAutomaticDimension, DDComponentAutomaticDimension);
    
    /// item3
    DDCollectionViewFormItemComponent *item3 = [[DDCollectionViewFormItemComponent alloc] initWithItemView:self.label3 itemSize:itemSize];
    item3.size = CGSizeMake(DDComponentAutomaticDimension, DDComponentAutomaticDimension);
    
    /// Group
    DDCollectionViewItemGroupComponent *group = [DDCollectionViewItemGroupComponent componentWithSubComponents:@[
        item,
        item2
    ]];
    group.lineSpacing = 0;
    group.itemSpacing = 0;
    group.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    self.group = group;
    
    /// Group2
    DDCollectionViewItemGroupComponent *group2 = [DDCollectionViewItemGroupComponent componentWithSubComponents:@[
        item3
    ]];
    group2.lineSpacing = 0;
    group2.itemSpacing = 0;
    group2.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
    self.rootComponent.subComponents = @[group, group2];
    [self.rootComponent reloadData];
}

- (void)refreshAction {
//    self.label.text = @"大叔大婶大所大所大所大所大";
//    self.label2.text = @"大叔大婶大所大所大所大所大";
//    self.label3.text = @"大叔大婶大所大所大所大所大";
//
//
//    [self.collectionView performBatchUpdates:^{
//        [self animateCollection];
//    } completion:^(BOOL finished) {
//
//    }];
//    [self animateCollection];
}

-(void)animateCollection{
    NSArray *cells = _collectionView.visibleCells;
    CGFloat collectionHeight = _collectionView.bounds.size.height;
    for (UICollectionViewCell *cell in cells.objectEnumerator) {
        cell.alpha = 1.0f;
        cell.transform = CGAffineTransformMakeTranslation(0, collectionHeight);
        NSUInteger index = [cells indexOfObject:cell];
        [UIView animateWithDuration:0.7f delay:0.05*index usingSpringWithDamping:0.8 initialSpringVelocity:0 options:0 animations:^{
            cell.transform =  CGAffineTransformMakeTranslation(0, 0);
        } completion:nil];
    }
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
  return @[ @"DDCollectionFormDemo" ];
}

@end
