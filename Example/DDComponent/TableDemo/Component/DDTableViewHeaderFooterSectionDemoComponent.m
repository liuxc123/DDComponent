//
//  DDTableViewHeaderFooterSectionDemoComponent.m
//  Component
//
//  Created by daniel on 2018/11/17.
//  Copyright © 2018 Daniel. All rights reserved.
//

#import "DDTableViewHeaderFooterSectionDemoComponent.h"
#import "DDComponentDemoTableViewCell.h"

@implementation DDTableViewHeaderFooterSectionDemoComponent

+ (instancetype)componentWithData:(NSArray *)demoData {
    DDTableViewHeaderFooterSectionDemoComponent *comp = [self new];
    comp.demoData = demoData;
    return comp;
}

- (void)prepareTableView {
    [super prepareTableView];
    printf("%s\n", sel_getName(_cmd));
    [self.tableView registerClass:[DDComponentDemoTableViewCell class]
      forCellReuseIdentifier:@"DDComponentDemoTableViewCell"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.demoData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.demoData[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    printf("%s\n", sel_getName(_cmd));
    DDComponentDemoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DDComponentDemoTableViewCell"];
    cell.contentView.backgroundColor = arc4random()%100 > 50 ? UIColor.redColor : UIColor.greenColor;
    cell.textLabel.text = [NSString stringWithFormat:@"%@, section:%ld, row:%ld, firstSection:%ld, firstRow:%ld", self.demoData[indexPath.section][indexPath.row], indexPath.section, indexPath.row, self.section, self.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    printf("%s\n", sel_getName(_cmd));
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSIndexPath *global = indexPath;
    NSIndexPath *fix = indexPath;
    NSString *str = [NSString stringWithFormat:@"%@\n%@\n%@\n", indexPath, global, fix];
    printf("%s\n", [str cStringUsingEncoding:NSUTF8StringEncoding]);
    
    NSInteger globalS = indexPath.section;
    NSInteger fixS = indexPath.section;
    printf("%zd, %zd, %zd\n", indexPath.section, globalS, fixS);
}

@end
