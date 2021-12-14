#import "DDCollectionViewComponent.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDCollectionViewSectionGroupComponent : DDCollectionViewBaseComponent

@property (strong, nonatomic, nullable) NSArray<__kindof DDCollectionViewBaseComponent *> *subComponents;

- (__kindof DDCollectionViewBaseComponent * _Nullable)componentAtSection:(NSInteger)atSection;
@end

@interface DDCollectionViewRootComponent : DDCollectionViewSectionGroupComponent

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;


/**
 Like
 '- (instancetype)initWithCollectionView:(UICollectionView *)collectionView bind:(BOOL)bind;'
 And bind is YES.
 */
- (instancetype)initWithCollectionView:(UICollectionView *)collectionView;

/**
 Attach to a collection view. It will override its delegate and dataSource.
 But it will not override scroll delegate.

 @param collectionView Bind to collectionView.
 @param bind Yes will override delegate and dataSource.
 */
- (instancetype)initWithCollectionView:(UICollectionView *)collectionView bind:(BOOL)bind;

@end

NS_ASSUME_NONNULL_END
