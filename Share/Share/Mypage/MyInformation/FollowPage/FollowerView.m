//
//  FollowerView.m
//  Share
//
//  Created by lose_sea on 2026/6/2.
//

#import "FollowerView.h"

@implementation FollowerView
- (instancetype) init {
    self = [super init];
    if (self) {
        [self setUpTableView];
    }
    return self;
}

- (void) setUpTableView {
    self.tableView = [[UITableView alloc] init];
    [self addSubview: self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    [self.tableView registerClass: [FollowerCellCell class] forCellReuseIdentifier: @"FollowCellID"];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
