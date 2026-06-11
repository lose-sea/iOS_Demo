//
//  ArticlePageView.m
//  Share
//
//  Created by lose_sea on 2026/6/8.
//

#import "ArticlePageView.h"

@implementation ArticlePageView
- (instancetype) init {
    self = [super init];
    if (self) {
        [self setUpData];
        [self setUpInterface];
    }
    return self;
}

- (void)setUpData {
    self.tableView = [[UITableView alloc] init];
    UIImageView* iView = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"37.jpg"]];
    self.tableView.backgroundView = iView; 
    [self addSubview: self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(40);
        make.left.right.mas_equalTo(self);
        make.height.mas_equalTo(220);
    }];
    
    [self.tableView registerClass: [CustomCell class] forCellReuseIdentifier: @"ArticleCellID"];
}

- (void)setUpInterface {
//    UIImageView* iView = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"37.jpg"]];
    self.backgroundColor = [UIColor systemBrownColor];
    self.alpha = 1; 
    UILabel* label = [[UILabel alloc] init];
    label.text = @"想在威尔湖的旁边,听风诉说你的思念\n我想在傍晚的暖风里\n将你慢慢遗忘";
    label.numberOfLines = 0;
    [self addSubview: label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tableView.mas_bottom);
        make.left.mas_equalTo(self).offset(5);
        make.right.mas_equalTo(self).offset(-5);
        make.height.mas_equalTo(70);
    }];
    
    UIImageView* iView1 = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"26.jpg"]];
    UIImageView* iView2 = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"29.jpg"]];
    UIImageView* iView3 = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"28.jpg"]];
    iView1.clipsToBounds = YES;
    iView2.clipsToBounds = YES;
    iView3.clipsToBounds = YES;
    iView1.contentMode = UIViewContentModeScaleAspectFill;
    iView2.contentMode = UIViewContentModeScaleAspectFill;
    iView3.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview: iView1];
    [self addSubview: iView2];
    [self addSubview: iView3];
    
    [iView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(label.mas_bottom);
        make.left.mas_equalTo(self).offset(10);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(200);
    }];
    
    [iView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(iView1.mas_right).offset(10);
        make.bottom.mas_equalTo(iView1);
        make.width.height.mas_equalTo(170);
    }];
    
    [iView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(iView1.mas_bottom).offset(10);
        make.left.mas_equalTo(self).offset(10);
        make.height.mas_equalTo(240);
        make.width.mas_equalTo(400);
    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
