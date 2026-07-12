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
    
    
    self.scrollView = [[UIScrollView alloc] init];
    [self addSubview: self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    self.scrollView.contentSize = CGSizeMake(self.bounds.size.width * 3, self.bounds.size.height);
    NSLog(@"%f, %f", self.bounds.size.width * 3, self.bounds.size.height);
    
    
    self.tableView = [[UITableView alloc] init];
    [self addSubview: self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
        make.bottom.mas_equalTo(self).offset(-140); 
    }];
    
//    self.tableView.backgroundColor = [[UIColor clearColor] colorWithAlphaComponent: 0.8];
    
    [self.tableView registerClass: [RecommendTableViewCell class] forCellReuseIdentifier: @"RecommendTableViewCellID"];
    [self.tableView registerClass: [HotSongTableViewCell class] forCellReuseIdentifier: @"HotSongTableViewCellID"];
    
    
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


@end



