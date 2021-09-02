//
//  DDComponentDemoCollectionViewCell.m
//  DDComponent_Example
//
//  Created by mac on 2021/8/31.
//  Copyright © 2021 liuxc123. All rights reserved.
//

#import "DDComponentDemoCollectionViewCell.h"

@interface DDComponentDemoCollectionViewCell ()


@end

@implementation DDComponentDemoCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.textLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.textLabel.frame = self.contentView.frame;
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [UILabel new];
    }
    return _textLabel;
}

@end
