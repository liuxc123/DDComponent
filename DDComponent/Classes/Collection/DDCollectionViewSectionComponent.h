#import "DDCollectionViewComponent.h"
#import "UIView+DDComponentLayout.h"

@interface DDCollectionViewSectionComponent : DDCollectionViewBaseComponent

/**
 It will fit the collection height or width when use DDComponentAutomaticDimension.
 */
@property (assign, nonatomic) CGSize headerSize;
@property (assign, nonatomic) CGSize footerSize;
@property (assign, nonatomic) CGSize size;

/**
 It will fit the collection height or width when use DDComponentLayoutSize. default nil.
 UICollectionViewCell or UICollectionReuseableView function:
 
 - (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
     return [self dd_preferredLayoutAttributesFittingAttributes: layoutAttributes];
 }
 */
@property (copy, nonatomic, nullable) DDComponentLayoutSize *headerLayoutSize;
@property (copy, nonatomic, nullable) DDComponentLayoutSize *footerLayoutSize;
@property (copy, nonatomic, nullable) DDComponentLayoutSize *layoutSize;

/**
 It will use FlowLayout's properties if DDComponentAutomaticDimension.
 */
@property (assign, nonatomic) CGFloat lineSpacing;
@property (assign, nonatomic) CGFloat itemSpacing;
@property (assign, nonatomic) UIEdgeInsets sectionInset;

@end


@interface DDCollectionViewHeaderFooterSectionComponent : DDCollectionViewSectionComponent

@property (strong, nonatomic, nullable) __kindof DDCollectionViewSectionComponent *headerComponent;
@property (strong, nonatomic, nullable) __kindof DDCollectionViewSectionComponent *footerComponent;
@property (strong, nonatomic, nullable) __kindof DDCollectionViewSectionComponent *headerFooterComponent;

@end

@interface DDCollectionViewItemGroupComponent : DDCollectionViewHeaderFooterSectionComponent

@property (strong, nonatomic, nullable) NSArray<__kindof DDCollectionViewBaseComponent *> *subComponents;

- (__kindof DDCollectionViewBaseComponent * _Nullable)componentAtItem:(NSInteger)atItem;

@end
