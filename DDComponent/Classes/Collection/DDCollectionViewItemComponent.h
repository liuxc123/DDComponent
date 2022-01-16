#import "DDCollectionViewComponent.h"
#import "UIView+DDComponentLayout.h"

@interface DDCollectionViewItemComponent : DDCollectionViewBaseComponent

/**
 ItemSize. It will fit the collection height or width when use DDComponentAutomaticDimension.
 */
@property (nonatomic, assign) CGSize size;

/**
 LayoutSize. use to UICollectionViewCell or UICollectionReuseableView function, default nil.
 
 - (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
 */
@property (nonatomic, copy) DDComponentLayoutSize *layoutSize;

@end
