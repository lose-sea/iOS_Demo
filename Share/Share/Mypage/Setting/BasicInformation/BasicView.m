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
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
