#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// When width or height is auto, it will use collectionView.size
// When inset lineSpacing itemSpacing is auto, it will use CollectionLayout's property.
extern const CGFloat DDComponentAutomaticDimension;

@class DDCollectionViewRootComponent;
@protocol DDCollectionViewComponent <NSObject, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>

@end

@interface DDCollectionViewBaseComponent : NSObject <DDCollectionViewComponent>

@property (weak, nonatomic, nullable) DDCollectionViewBaseComponent *superComponent;
@property (weak, nonatomic, nullable) DDCollectionViewRootComponent *rootComponent;

/**
 The collection host by component. It is nil before RootComponent attach to a collectionView.
 */
@property (readonly, weak, nonatomic, nullable) UICollectionView *collectionView;

/**
 Register cell should be here, and only for register! It may invoke many times.
 */
- (void)prepareCollectionView NS_REQUIRES_SUPER;

/**
 Reload collectionView
 */
- (void)reloadData;

/**
 For ItemComponent, {item, section} is equal to indexPath.
 For SectionComponent, {item, section} is equal to first item's indexPath, or Zero.
 For SectionGroupComponent, item should always be 0, section is the first section in the component.
 */
@property (readonly, nonatomic) NSInteger item;
@property (readonly, nonatomic) NSInteger section;

/**
 Convert from Global
 */
- (NSInteger)convertFromGlobalSection:(NSInteger)section;
- (NSIndexPath *)convertFromGlobalIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
