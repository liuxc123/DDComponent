#import "DDCollectionViewComponent.h"
#import "UIView+DDComponentLayout.h"

@interface DDCollectionViewItemComponent : DDCollectionViewBaseComponent

/**
 ItemSize. It will fit the collection height or width when use DDComponentAutomaticDimension.
 */
@property (nonatomic, assign) CGSize size;

/**
 LayoutSize.  It will fit the collection height or width when use DDComponentLayoutSize, default nil.
 UICollectionViewCell or UICollectionReuseableView function:

 
 - (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
     return [self dd_preferredLayoutAttributesFittingAttributes: layoutAttributes];
 }
 */
@property (nonatomic, copy) DDComponentLayoutSize *layoutSize;

@end
