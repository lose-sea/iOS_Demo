//
//  MyView.m
//  Music
//
//  Created by lose_sea on 2026/6/11.
//

#import "MyView.h"

@implementation MyView

- (instancetype) init {
    self = [super init];
    if (self) {
        [self setUpInterface];
    }
    return self;
}


- (void) setUpInterface {
    self.tableView = [[UITableView alloc] init];
//    self.tableView.backgroundColor = [UIColor systemBlueColor]; 
    
    [self addSubview: self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    [self.tableView registerClass: [UserCell class] forCellReuseIdentifier: @"UserCellID"];
    [self.tableView registerClass: [PlayListCell class] forCellReuseIdentifier: @"PlayListCellID"];
    [self.tableView registerClass: [ScrollViewCell class] forCellReuseIdentifier: @"ScrollViewCellID"];
    
    self.playView = [[PlayView alloc] init];
    [self addSubview: self.playView];
    [self.playView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_bottom).offset(-90);
        make.left.mas_equalTo(self).offset(10);
        make.right.mas_equalTo(self).offset(-10);
        make.height.mas_equalTo(50);
    }];
    
    self.playView.clipsToBounds = YES;
    self.playView.layer.cornerRadius = 25;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
