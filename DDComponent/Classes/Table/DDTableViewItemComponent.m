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
    if (self.tableView) {
        [self.tableView beginUpdates];
        NSInteger rows = [self tableView:self.tableView numberOfRowsInSection:self.section];
        NSMutableArray *indexPaths = [NSMutableArray array];
        for (int i = 0 ; i < rows; i++) {
            [indexPaths addObject:[NSIndexPath indexPathForRow:self.row + i inSection:self.section]];
        }
        [self.tableView reloadRowsAtIndexPaths:indexPaths
                              withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
    }
}

@end
