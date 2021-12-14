#ifndef DDCollectionViewComponent_Private_h
#define DDCollectionViewComponent_Private_h

#import "DDCollectionViewComponent.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDCollectionViewBaseComponent ()

@property (weak, nonatomic, nullable) UICollectionView *collectionView;

/**
 For group component to caculate the indexPath.
 */
- (NSInteger)firstItemOfSubComponent:(id<DDCollectionViewComponent>)subComp;
- (NSInteger)firstSectionOfSubComponent:(id<DDCollectionViewComponent>)subComp;
@end

NS_ASSUME_NONNULL_END

#endif /* DDCollectionViewComponent_Private_h */
