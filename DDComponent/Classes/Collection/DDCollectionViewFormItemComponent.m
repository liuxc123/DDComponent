#import "DDCollectionViewFormItemComponent.h"

@interface DDCollectionViewFormItemCell : UICollectionViewCell

@end

@implementation DDCollectionViewFormItemCell

- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    return [self dd_preferredLayoutAttributesFittingAttributes: layoutAttributes];
}

@end

@interface DDCollectionViewFormItemComponent ()

@property (nonatomic, strong, readwrite) UIView *itemView;
@property (nonatomic, strong, readonly) NSString *reuseIdentifier;

@end

@implementation DDCollectionViewFormItemComponent

- (instancetype)initWithItemView:(UIView *)itemView;
{
    self = [super init];
    if (self) {
        _itemView = itemView;
        _itemSize = [DDComponentLayoutSize sizeWithWidthDimension:[DDComponentLayoutDimension fractionalWidthDimension:1.0]
                                                  heightDimension:[DDComponentLayoutDimension absoluteDimension:44]];
        self.size = CGSizeMake(DDComponentAutomaticDimension, DDComponentAutomaticDimension);
    }
    return self;
}

- (void)prepareCollectionView {
    [super prepareCollectionView];
    [self.collectionView registerClass:[DDCollectionViewFormItemCell class] forCellWithReuseIdentifier:self.reuseIdentifier];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.itemView ? 1 : 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!self.itemView) {
        return nil;
    }
    
    DDCollectionViewFormItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.reuseIdentifier forIndexPath:indexPath];
    
    cell.layoutSize = self.itemSize;
        
    if ([self.itemView.superview isEqual: cell.contentView]) {
        return cell;
    }
    
    self.itemView.translatesAutoresizingMaskIntoConstraints = NO;
    cell.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [cell.contentView addSubview:self.itemView];
    
    NSLayoutConstraint *top = [self.itemView.topAnchor constraintEqualToAnchor:cell.contentView.topAnchor];
    NSLayoutConstraint *right = [self.itemView.rightAnchor constraintEqualToAnchor:cell.contentView.rightAnchor];
    NSLayoutConstraint *bottom = [self.itemView.bottomAnchor constraintEqualToAnchor:cell.contentView.bottomAnchor];
    NSLayoutConstraint *left = [self.itemView.leftAnchor constraintEqualToAnchor:cell.contentView.leftAnchor];
    
    top.identifier = @"component_form_item_top";
    right.identifier = @"component_form_item_right";
    bottom.identifier = @"component_form_item_bottom";
    left.identifier = @"component_form_item_left";

    [NSLayoutConstraint activateConstraints:@[top, right, bottom, left]];

    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!self.itemView) {
        return CGSizeZero;
    }
    
    CGSize size = [super collectionView:collectionView layout:collectionViewLayout sizeForItemAtIndexPath:indexPath];

    if (!self.itemSize) {
        return size;
    }
    
    return [self.itemView dd_sizeThatFits:size layoutSize:self.itemSize];
}

- (NSString *)reuseIdentifier {
    return [NSString stringWithFormat:@"%p", self.itemView];
}

@end




