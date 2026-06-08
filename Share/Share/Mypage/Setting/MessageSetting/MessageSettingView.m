//
//  MessageSettingView.m
//  Share
//
//  Created by lose_sea on 2026/6/8.
//

#import "MessageSettingView.h"

@implementation MessageSettingView
- (instancetype) init {
    self = [super init];
    if (self) {
        [self setUpInterface];
    }
    return self;
}

- (void)setUpInterface {
    self.tableView = [[UITableView alloc] init];
    [self addSubview: self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    [self.tableView registerClass: [MessageSettingCell class] forCellReuseIdentifier: @"MessageSettingCellID"]; 
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
