//
//  HomeView.m
//  Music
//
//  Created by lose_sea on 2026/6/11.
//

#import "HomeView.h"

@implementation HomeView
- (instancetype) init {
    self = [super init];
    if (self) {
        [self setUpInterface];
    }
    return self;
}



- (void) setUpInterface {
    self.tableView = [[UITableView alloc] init];
    [self addSubview: self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
//    self.tableView.backgroundColor = [[UIColor clearColor] colorWithAlphaComponent: 0.8];
    
    [self.tableView registerClass: [RecommendTableViewCell class] forCellReuseIdentifier: @"RecommendTableViewCellID"];
    [self.tableView registerClass: [HotSongTableViewCell class] forCellReuseIdentifier: @"HotSongTableViewCellID"];
}

@end



