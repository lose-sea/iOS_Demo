//
//  MyPageView.m
//  Share
//
//  Created by lose_sea on 2026/5/30.
//

#import "MyPageView.h"

@implementation MyPageView
- (instancetype) init {
    self = [super init];
    if (self) {
        [self setTableView];
    }
    return self;
}
- (void) setTableView {
    self.tableView = [[UITableView alloc] init];
    [self addSubview: self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(120); 
        make.left.right.mas_equalTo(self);
        make.bottom.mas_equalTo(self).offset(-0);
    }];
    [self.tableView registerClass: [UserCell class] forCellReuseIdentifier: @"UserCellID"];
    [self.tableView registerClass: [UITableViewCell class] forCellReuseIdentifier: @"UITableViewCellID"]; 
}



@end
