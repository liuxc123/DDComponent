#import "DDCollectionViewItemComponent.h"
#import "DDCollectionViewSectionGroupComponent.h"

@implementation DDCollectionViewItemComponent

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size = self.size;
    BOOL autoWidth = size.width == DDComponentAutomaticDimension;
    BOOL autoHeight = size.height == DDComponentAutomaticDimension;
    UIEdgeInsets contentInset = collectionView.contentInset;
    UIEdgeInsets sectionInset = UIEdgeInsetsZero;
    if (autoWidth || autoHeight) {
        sectionInset = [self.rootComponent collectionView:collectionView
                                                   layout:collectionViewLayout
                                   insetForSectionAtIndex:indexPath.section];
    }
    if (autoWidth) {
        size.width = MAX(collectionView.frame.size.width - sectionInset.left - sectionInset.right - contentInset.left - contentInset.right, 0);
    }
    if (autoHeight) {
        size.height = MAX(collectionView.frame.size.height - sectionInset.top - sectionInset.bottom - contentInset.top - contentInset.bottom, 0);
    }
    return size;
}

- (void)reloadData {
    if (self.collectionView) {
        NSInteger items = [self collectionView:self.collectionView numberOfItemsInSection:self.section];
        NSMutableArray *indexPaths = [NSMutableArray array];
        for (int i = 0 ; i < items; i++) {
            [indexPaths addObject:[NSIndexPath indexPathForRow:self.item + i inSection:self.section]];
        }
        [self.collectionView reloadItemsAtIndexPaths:indexPaths];
    }
}

@end
