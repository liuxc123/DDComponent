//
//  DDTableViewFormItemComponent.m
//  DDComponent_Example
//
//  Created by mac on 2021/9/13.
//  Copyright © 2021 liuxc123. All rights reserved.
//

#import "DDTableViewFormItemComponent.h"

@interface DDTableViewFormItemComponent ()

@property (nonatomic, strong, readwrite) UIView *itemView;
@property (nonatomic, strong, readwrite) NSString *reuseIdentifier;

@end

@implementation DDTableViewFormItemComponent

- (instancetype)initWithItemView:(UIView *)itemview
{
    self = [super init];
    if (self) {
        self.itemView = itemview;
    }
    return self;
}

- (void)prepareTableView {
    [super prepareTableView];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:self.reuseIdentifier];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.itemView ? 1 : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.itemView) {
        return nil;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.reuseIdentifier];
        
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
