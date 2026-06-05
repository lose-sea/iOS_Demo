//
//  ChangePasswordView.m
//  Share
//
//  Created by lose_sea on 2026/6/5.
//

#import "ChangePasswordView.h"

@implementation ChangePasswordView
- (instancetype) init {
    self = [super init];
    if (self) {
        [self setUpData]; 
    }
    return self;
}

- (void)setUpData {
    self.tableView = [[UITableView alloc] init];
    self.commitButton = [UIButton buttonWithType: UIButtonTypeSystem];
    
    [self addSubview: self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self);
        make.height.mas_equalTo(400);
    }];
    
    
    [self addSubview: self.commitButton];
    [self.commitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tableView.mas_bottom).offset(30);
        make.centerX.mas_equalTo(self);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(40);
    }];
    [self.commitButton setTitle: @"提交" forState: UIControlStateNormal];
    self.commitButton.backgroundColor = [UIColor systemBlueColor];
    [self.commitButton setTitleColor: [UIColor labelColor] forState: UIControlStateNormal];
    
    [self.tableView registerClass: [ChangePasswordCell class] forCellReuseIdentifier: @"ChangePasswordCellID"]; 
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
