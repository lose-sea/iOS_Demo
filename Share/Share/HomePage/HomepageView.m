//
//  HomepageView.m
//  Share
//
//  Created by lose_sea on 2026/5/20.
//

#import "HomepageView.h"

@interface HomepageView ()

@end

@implementation HomepageView
- (void) setTableView {
    self.tableView = [[UITableView alloc] init];
    [self.tableView registerClass: [CustomCell class] forCellReuseIdentifier: @"customCellID"];
    [self.tableView registerClass: [ScrollViewCell class] forCellReuseIdentifier: @"scrollViewCellID"];
    [self addSubview: self.tableView]; 
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
