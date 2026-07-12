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
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
