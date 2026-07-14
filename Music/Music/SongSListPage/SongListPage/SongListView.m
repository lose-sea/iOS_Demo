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
        [self setUpInterface]; 
    }
    return self;
}

- (void) setUpInterface {
    self.coverView = [[UIImageView alloc] init];
    self.nameLabel = [[UILabel alloc] init];
    self.authorLabel = [[UILabel alloc] init];
    self.menuView = [[UIView alloc] init];
    self.tableView = [[UITableView alloc] init];
    self.playView = [[PlayView alloc] init];
    
    
    [self addSubview: self.coverView];
    [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(150);
        make.left.mas_equalTo(self).offset(30);
        make.width.height.mas_equalTo(90);
    }];
    self.coverView.clipsToBounds = YES;
    self.coverView.layer.cornerRadius = 20; 
    
    self.nameLabel = [[UILabel alloc] init];
    [self addSubview: self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.coverView);
        make.left.mas_equalTo(self.coverView.mas_right).offset(10);
        make.right.mas_equalTo(self).offset(-20);
    }];
    self.nameLabel.font = [UIFont boldSystemFontOfSize: 18];
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    self.nameLabel.numberOfLines = 0;
//    self.coverView.backgroundColor = [UIColor systemRedColor];
    
    
    self.tableView = [[UITableView alloc] init];
    [self addSubview: self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
       
    }];
    
    [self.tableView registerClass: [songCell class] forCellReuseIdentifier: @"SongCellID"]; 
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
