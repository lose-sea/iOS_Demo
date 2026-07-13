//
//  SongListView.m
//  Music
//
//  Created by lose_sea on 2026/7/13.
//

#import "SongListView.h"

@implementation SongListView

- (instancetype) init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void) setUpInterface {
    self.coverView = [[UIImageView alloc] init];
    self.nameLabel = [[UILabel alloc] init];
    self.messageLabel = [[UILabel alloc] init];
    self.menuView = [[UIView alloc] init];
    self.tableView = [[UITableView alloc] init];
    self.playView = [[PlayView alloc] init];
    
    [self addSubview: self.coverView];
    [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(50);
        make.left.mas_equalTo(self).offset(30);
        make.width.height.mas_equalTo(60);
    }];
    
    self.nameLabel = [[UILabel alloc] init];
    [self addSubview: self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(
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
