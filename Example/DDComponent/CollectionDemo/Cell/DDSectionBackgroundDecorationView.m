//
//  DDSectionBackgroundDecorationView.m
//  DDComponent_Example
//
//  Created by mac on 2021/8/31.
//  Copyright © 2021 liuxc123. All rights reserved.
//

#import "DDSectionBackgroundDecorationView.h"

@implementation DDSectionBackgroundDecorationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor.lightGrayColor colorWithAlphaComponent:0.5];
        self.layer.borderColor = [[UIColor blackColor] CGColor];
        self.layer.borderWidth = 1.0;
        self.layer.cornerRadius = 12;
    }
    return self;
}

@end
