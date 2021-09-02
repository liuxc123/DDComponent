//
//  DDTableViewComponent+Private.h
//  Pods
//
//  Created by hzduanjiashun on 2017/6/12.
//
//

#ifndef DDTableViewComponent_Private_h
#define DDTableViewComponent_Private_h

#import "DDTableViewComponent.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDTableViewBaseComponent()

@property (weak, nonatomic, nullable) UITableView *tableView;

/**
 For group component to caculate the indexPath.
 */
- (NSInteger)firstRowOfSubComponent:(id<DDTableViewComponent>)subComp;
- (NSInteger)firstSectionOfSubComponent:(id<DDTableViewComponent>)subComp;

@end

NS_ASSUME_NONNULL_END

#endif /* DDTableViewComponent_Private_h */
