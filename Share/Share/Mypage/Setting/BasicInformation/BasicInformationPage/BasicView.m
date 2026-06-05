//
//  BasicView.m
//  Share
//
//  Created by lose_sea on 2026/6/4.
//

#import "BasicView.h"

@implementation BasicView
- (instancetype) init {
    self = [super init];
    if (self) {
        [self setUpTableView];
    }
    
    return self;
}

- (void) setUpTableView {
    self.tableView = [[UITableView alloc] init];
    [self addSubview: self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
    }];
    
    [self.tableView registerClass: [AvatarCell class] forCellReuseIdentifier: @"AvatarCellID"];
    [self.tableView registerClass: [GenderCell class] forCellReuseIdentifier: @"GenderCellID"];
    [self.tableView registerClass: [TextCell class] forCellReuseIdentifier: @"TextCellID"];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
