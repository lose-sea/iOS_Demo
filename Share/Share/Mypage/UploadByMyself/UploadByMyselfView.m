//
//  UploadByMyselfView.m
//  Share
//
//  Created by lose_sea on 2026/5/31.
//

#import "UploadByMyselfView.h"

@implementation UploadByMyselfView
- (instancetype) init {
    self = [super init];
    if (self) {
        [self setUpsegmentedControl];
        [self setUpScrollView];
//        [self setUpcontentSize]; 
//        self.backgroundColor = [UIColor systemCyanColor];
        [self setUpTableView];
        
    }
    return self;
}

- (void) setUpsegmentedControl {
    self.segmentedControl = [[UISegmentedControl alloc] init];
    [self.segmentedControl insertSegmentWithTitle: @"上传时间" atIndex: 0 animated: YES];
    [self.segmentedControl insertSegmentWithTitle: @"推荐最多" atIndex: 1 animated: YES];
    [self.segmentedControl insertSegmentWithTitle: @"分享最多" atIndex: 2 animated: YES];
    
    self.segmentedControl.selectedSegmentIndex = 0;
    
    self.segmentedControl.selectedSegmentTintColor = [UIColor systemRedColor];
    
//    self.segmentedControl.backgroundColor = [UIColor systemYellowColor];
    
    [self addSubview: self.segmentedControl];
    [self.segmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self).offset(120);
        make.height.mas_equalTo(40);
    }];
    
}

- (void) setUpScrollView {
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.backgroundColor = [UIColor systemCyanColor];
    
    self.scrollView.pagingEnabled = YES;
    self.scrollView.bounces = NO;
    
    [self addSubview: self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.segmentedControl.mas_bottom);
        make.left.right.bottom.mas_equalTo(self);
    }];
//    self.scrollView.backgroundColor = [UIColor systemYellowColor];
    [self.scrollView layoutIfNeeded];
}

- (void)setUpTableView {
    self.tableViewOfTime = [[UITableView alloc] init];
    self.tableViewOfRecommend = [[UITableView alloc] init];
    self.tableViewOfShare = [[UITableView alloc] init];
    
    [self.scrollView addSubview:self.tableViewOfTime];
    [self.scrollView addSubview:self.tableViewOfRecommend];
    [self.scrollView addSubview:self.tableViewOfShare];
    

    
    [self.tableViewOfTime registerClass:[CustomCell class] forCellReuseIdentifier:@"TableViewCellID"];
    [self.tableViewOfRecommend registerClass:[CustomCell class] forCellReuseIdentifier:@"TableViewCellID"];
    [self.tableViewOfShare registerClass:[CustomCell class] forCellReuseIdentifier:@"TableViewCellID"];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width = self.scrollView.bounds.size.width;
    CGFloat height = self.scrollView.bounds.size.height;
    
    self.scrollView.contentSize = CGSizeMake(width * 3, height);

    // 此时 scrollView 已有真实尺寸
    self.tableViewOfTime.frame = CGRectMake(0, 0, width, height);
    self.tableViewOfRecommend.frame = CGRectMake(width, 0, width, height);
    self.tableViewOfShare.frame = CGRectMake(width * 2, 0, width, height);
    
}




//- (void) setUpcontentSize {
//    self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width * 3,  self.scrollView.bounds.size.height);
//
//}
//
//
//- (void) setUpTableView {
//    
//    self.tableViewOfTime = [[UITableView alloc] init];
//    self.tableViewOfRecommend = [[UITableView alloc] init];
//    self.tableViewOfShare = [[UITableView alloc] init];
//    
//    [self.scrollView addSubview: self.tableViewOfTime];
//    [self.tableViewOfTime mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(self.scrollView);
//    }];
//    NSLog(@"%f, %f", self.scrollView.contentSize.width, self.scrollView.contentSize.height);
//    self.tableViewOfTime.backgroundColor = [UIColor systemRedColor];
//    
//    [self.scrollView addSubview: self.tableViewOfRecommend];
//    [self.tableViewOfRecommend mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.tableViewOfTime.mas_right);
//        make.top.width.height.mas_equalTo(self.tableViewOfTime);
//    }];
//    
//    [self.scrollView addSubview: self.tableViewOfShare];
//    [self.tableViewOfShare mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.tableViewOfRecommend.mas_right);
//        make.top.height.width.mas_equalTo(self.tableViewOfRecommend);
//    }];
//    
//
//    [self.tableViewOfTime registerClass: [CustomCell class] forCellReuseIdentifier: @"TableViewCellID"];
//    [self.tableViewOfRecommend registerClass: [CustomCell class] forCellReuseIdentifier: @"TableViewCellID"];
//    [self.tableViewOfShare registerClass: [CustomCell class] forCellReuseIdentifier: @"TableViewCellID"];
//}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
