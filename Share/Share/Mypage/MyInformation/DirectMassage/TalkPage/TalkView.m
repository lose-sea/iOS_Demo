//
//  TalkView.m
//  Share
//
//  Created by lose_sea on 2026/6/3.
//

#import "TalkView.h"

@implementation TalkView
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
        make.edges.equalTo(self.mas_bottom).offset(-50);
    }];
    self.textView = [[UITextView alloc] init];
    [self.tableView registerClass: [TalkCell class] forCellReuseIdentifier: @"TalkCellID"];
    
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
