//
//  MyRecommendView.m
//  Share
//
//  Created by lose_sea on 2026/6/4.
//

#import "MyRecommendView.h"

@implementation MyRecommendView
- (instancetype) init {
    self = [super init];
    if (self) {
        [self setUpData]; 
    }
    return self;
}

- (void) setUpData {
    self.tableView = [[UITableView alloc] init];
    [self addSubview: self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
    }];
    
    [self.tableView registerClass: [CustomCell class] forCellReuseIdentifier: @"ArticleCellID"]; 
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
