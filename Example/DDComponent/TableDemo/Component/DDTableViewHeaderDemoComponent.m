//
//  DDTableViewHeaderDemoComponent.m
//  Component
//
//  Created by hzduanjiashun on 2018/11/19.
//  Copyright © 2018 Daniel. All rights reserved.
//

#import "DDTableViewHeaderDemoComponent.h"

@implementation DDTableViewHeaderDemoComponent

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSInteger gSection = section;
    NSInteger lSection = section;
    return [NSString stringWithFormat:@"Header (%zd),(%zd)", gSection, lSection];
}

@end
