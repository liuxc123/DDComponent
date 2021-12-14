#import "DDTableViewComponent.h"
#import "DDTableViewComponent+Private.h"
#import "DDTableViewComponent+Cache.h"
#import "DDTableViewSectionGroupComponent.h"

@implementation DDTableViewBaseComponent
@synthesize tableView=_tableView;
@synthesize dataSourceCacheEnable=_dataSourceCacheEnable;
//@synthesize heightCacheEnable=_heightCacheEnable;

- (instancetype)init
{
    self = [super init];
    if (self) {
        _dataSourceCacheEnable = YES;
//        _heightCacheEnable = YES;
    }
    return self;
}

- (DDTableViewRootComponent *)rootComponent {
    return self.superComponent.rootComponent;
}

- (void)setSuperComponent:(DDTableViewBaseComponent *)superComponent {
    _superComponent = superComponent;
    self.tableView = _superComponent.tableView;
}

- (UITableView *)tableView {
    return _tableView ?: self.superComponent.tableView;
}

- (NSInteger)firstRowOfSubComponent:(id<DDTableViewComponent>)subComp {
    return 0;
}

- (NSInteger)firstSectionOfSubComponent:(id<DDTableViewComponent>)subComp {
    return 0;
}

- (void)prepareTableView {}

- (void)reloadData {}

- (void)clearDataSourceCache {}
- (void)clearSizeCache {}


- (NSInteger)row {
    return [self.superComponent firstRowOfSubComponent:self];
}

- (NSInteger)section {
    return [self.superComponent firstSectionOfSubComponent:self];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSAssert(false, @"MUST override!");
    return nil;
}

#pragma mark - convert

- (NSInteger)convertFromGlobalSection:(NSInteger)section {
    NSInteger differenceSection = ABS(section - self.section);
    return differenceSection;
}

- (NSIndexPath *)convertFromGlobalIndexPath:(NSIndexPath *)indexPath {
    NSInteger differenceSection = ABS(indexPath.section - self.section);
    NSInteger differenceRow = ABS(indexPath.row - self.row);
    return [NSIndexPath indexPathForRow:differenceRow inSection:differenceSection];
}

@end
