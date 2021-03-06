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
        self.itemView = itemView;
        self.size = CGSizeMake(DDComponentAutomaticDimension, DDComponentAutomaticDimension);
        self.layoutSize = [DDComponentLayoutSize sizeWithWidthDimension:[DDComponentLayoutDimension fractionalWidthDimension:1.0]
                                                        heightDimension:[DDComponentLayoutDimension absoluteDimension:44]];
    }
    return self;
}

- (void)prepareCollectionView {
    [super prepareCollectionView];
    [self.collectionView registerClass:[DDCollectionViewFormItemCell class] forCellWithReuseIdentifier:self.reuseIdentifier];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    NSAssert(self.itemView, @"Must set itemView!");
    
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSAssert(self.itemView, @"Must set itemView!");
    
    DDCollectionViewFormItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.reuseIdentifier forIndexPath:indexPath];
    
    // set up layout size
    cell.layoutSize = self.layoutSize;
        
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

- (NSString *)reuseIdentifier {
    return [NSString stringWithFormat:@"%p", self.itemView];
}

@end




