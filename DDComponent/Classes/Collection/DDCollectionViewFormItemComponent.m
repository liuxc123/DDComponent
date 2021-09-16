//
//  DDCollectionViewFormItemComponent.m
//  DDComponent_Example
//
//  Created by mac on 2021/9/7.
//  Copyright © 2021 liuxc123. All rights reserved.
//

#import "DDCollectionViewFormItemComponent.h"

@interface DDCollectionViewFormItemCell : UICollectionViewCell

@property (nonatomic, copy) DDComponentLayoutSize *itemSize;

@end

@implementation DDCollectionViewFormItemCell

- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    
    [self layoutIfNeeded];
    [self setNeedsLayout];
    
    CGRect frame = layoutAttributes.frame;
    frame.size = [self.contentView sizeThatFits:frame.size layoutSize:self.itemSize];
    layoutAttributes.frame = frame;
    
    return layoutAttributes;
}

@end

@interface DDCollectionViewFormItemComponent ()

@property (nonatomic, strong, readwrite) UIView *itemView;
@property (nonatomic, strong, readwrite) NSString *reuseIdentifier;
@property (nonatomic, copy, readwrite) DDComponentLayoutSize *itemSize;

@end

@implementation DDCollectionViewFormItemComponent

- (instancetype)initWithItemView:(UIView *)itemview itemSize:(DDComponentLayoutSize *)itemSize;
{
    self = [super init];
    if (self) {
        self.itemView = itemview;
        self.itemSize = itemSize;
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

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.itemView) {
        return nil;
    }
    
    DDCollectionViewFormItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.reuseIdentifier forIndexPath:indexPath];
    
    cell.itemSize = self.itemSize;
    
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




