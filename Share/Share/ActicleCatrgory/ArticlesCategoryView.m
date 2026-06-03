//
//  ArticlesCategoryView.m
//  Share
//
//  Created by lose_sea on 2026/5/28.
//

#import "ArticlesCategoryView.h"

@implementation ArticlesCategoryView
- (instancetype) init {
    self = [super init];
    if (self) {
        [self setSegmentedControl];
        [self setTableView];
    }
    return self;
}




- (void) setSegmentedControl {
    self.segmentedControl = [[UISegmentedControl alloc] init];
    [self.segmentedControl insertSegmentWithTitle: @"精选文章" atIndex: 0 animated: YES];
    [self.segmentedControl insertSegmentWithTitle: @"热门推荐" atIndex: 1 animated: YES];
    [self.segmentedControl insertSegmentWithTitle: @"全部文章" atIndex: 2 animated: YES];
    
    self.segmentedControl.selectedSegmentIndex = 0;
    [self addSubview: self.segmentedControl];
    [self.segmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self);
        make.left.right.mas_equalTo(self);
        make.height.mas_equalTo(40);
    }];
    self.segmentedControl.selectedSegmentTintColor = [UIColor systemPinkColor];
    
}


- (void) setTableView {
    self.tableView = [[UITableView alloc] init];
    [self addSubview: self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.segmentedControl.mas_bottom).offset(10);
        make.left.right.mas_equalTo(self);
        make.bottom.mas_equalTo(self).offset(-40);
    }];
//    self.tableView.backgroundColor = [UIColor systemCyanColor];
    
    [self.tableView registerClass: [CustomCell class] forCellReuseIdentifier: @"CustemCellID"];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
