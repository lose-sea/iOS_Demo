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
        [self setUpSegmentedControl];
        
        [self setUpScrollView];
        
        [self setUpTableView];
    }
    return self;
}

- (void) setUpSegmentedControl {
    self.segmentedControl = [[UISegmentedControl alloc] init];
    [self.segmentedControl insertSegmentWithTitle: @"精选文章" atIndex: 0 animated: YES];
    [self.segmentedControl insertSegmentWithTitle: @"热门推荐" atIndex: 1 animated: YES];
    [self.segmentedControl insertSegmentWithTitle: @"全部文章" atIndex: 2 animated: YES];
    
    self.segmentedControl.selectedSegmentIndex = 0;
    [self addSubview: self.segmentedControl];
    [self.segmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(120); 
        make.left.right.mas_equalTo(self);
        make.height.mas_equalTo(40);
    }];
    self.segmentedControl.selectedSegmentTintColor = [UIColor systemPinkColor];
}

- (void)setUpScrollView {
    self.scrollView = [[UIScrollView alloc] init];
    [self addSubview: self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.segmentedControl.mas_bottom).offset(5);
        make.left.right.bottom.mas_equalTo(self);
    }];
    
    self.scrollView.pagingEnabled = YES; 
    
//    self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width * 3,  self.scrollView.bounds.size.height);
//    // 0.000000, 0.000000
//    NSLog(@"%f, %f", self.scrollView.bounds.size.width,  self.scrollView.bounds.size.height);
}

- (void)setUpTableView {
    self.featuredTableView = [[UITableView alloc] init];
    self.hotTableView = [[UITableView alloc] init];
    self.allTableView = [[UITableView alloc] init];
    
    [self.scrollView addSubview: self.featuredTableView];
    [self.scrollView addSubview: self.hotTableView];
    [self.scrollView addSubview: self.allTableView];
    
    [self.featuredTableView registerClass:[CustomCell class] forCellReuseIdentifier:@"TableViewCellID"];
    [self.hotTableView registerClass:[CustomCell class] forCellReuseIdentifier:@"TableViewCellID"];
    [self.allTableView registerClass:[CustomCell class] forCellReuseIdentifier:@"TableViewCellID"];
}


- (void) layoutSubviews {
    [super layoutSubviews];
    CGFloat width = self.scrollView.bounds.size.width;
    CGFloat height = self.scrollView.bounds.size.height;
    
    self.scrollView.contentSize =  CGSizeMake(width * 3,  height);
    
    self.featuredTableView.frame = CGRectMake(0, 0, width, height);
    self.hotTableView.frame = CGRectMake(width, 0, width, height);
    self.allTableView.frame = CGRectMake(width * 2, 0, width, height);
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
