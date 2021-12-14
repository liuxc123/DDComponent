#import "DDTableViewItemComponent.h"

@implementation DDTableViewItemComponent

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.height == DDComponentAutomaticDimension ? tableView.rowHeight : self.height;
}

- (void)reloadData {
    [self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.row inSection:self.section]]
                          withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
}

@end
