//
//  ActivityView.m
//  Share
//
//  Created by lose_sea on 2026/5/28.
//

#import "ActivityView.h"

@implementation ActivityView

- (instancetype) init {
    self = [super init];
    if (self) {
        [self setData];
    }
    return self;
}


- (void) setData {
    self.tableView = [[UITableView alloc] init];
    [self addSubview: self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
    }];
    [self.tableView registerClass: [ActivityCell class] forCellReuseIdentifier: @"ActivityCellID"];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
