//
//  SeachView.m
//  Weather_forecast
//
//  Created by lose_sea on 2026/7/16.
//

#import "SearchView.h"

@implementation SearchView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype) init {
    self = [super init];
    if (self) {
        [self setUpInterface]; 
    }
    return self;
}

- (void) setUpInterface {
    self.tableView = [[UITableView alloc] init];
    [self addSubview: self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    [self.tableView registerClass: [UITableViewCell class] forCellReuseIdentifier: @"UITableViewCellID"]; 
}

@end
