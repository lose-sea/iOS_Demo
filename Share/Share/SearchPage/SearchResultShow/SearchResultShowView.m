//
//  SearchResultShowView.m
//  Share
//
//  Created by lose_sea on 2026/5/25.
//

#import "SearchResultShowView.h"

@implementation SearchResultShowView

- (void) setTableView {
    self.tableView = [[UITableView alloc] init];
    [self.tableView registerClass: [CustomCell class] forCellReuseIdentifier: @"customCellID"];
    [self addSubview: self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.mas_equalTo(self);
    }];
}

- (instancetype) init {
    self = [super init];
    if (self) {
        [self setTableView];
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
