//
//  MenuView.m
//  Music
//
//  Created by lose_sea on 2026/6/16.
//

#import "MenuView.h"

@implementation MenuView

- (instancetype) init {
    self = [super init];
    if (self) {
        [self setUpInterface];
        self.backgroundColor = [[UIColor systemCyanColor] colorWithAlphaComponent: 0.2];
    }
    return self;
}

- (void)setUpInterface {
    self.avatarView = [[UIImageView alloc] init];
    self.nickNameLabel = [[UILabel alloc] init];
    self.tableView = [[UITableView alloc] init];
    self.VIPView = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"VIP.jpg"]];
    
    [self addSubview: self.avatarView];
    [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(20);
        make.top.mas_equalTo(self).offset(80);
        make.width.height.mas_equalTo(50);
    }];
    self.avatarView.clipsToBounds = YES;
    self.avatarView.layer.cornerRadius = 25;
    
    [self addSubview: self.nickNameLabel];
    [self.nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.avatarView);
        make.left.mas_equalTo(self.avatarView.mas_right).offset(20);
        make.width.mas_equalTo(130);
        make.height.mas_equalTo(50);
    }];
    //设置字体加粗
    self.nickNameLabel.font = [UIFont boldSystemFontOfSize: 20];
    
    
    [self addSubview: self.VIPView];
    [self.VIPView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.avatarView.mas_bottom).offset(20);
        make.left.mas_equalTo(self).offset(10);
        make.right.mas_equalTo(self).offset(-10);
        make.height.mas_equalTo(140);
    }];
    self.VIPView.clipsToBounds = YES;
    self.VIPView.layer.cornerRadius = 10;
    
    self.tableView = [[UITableView alloc] init];
    [self addSubview: self.tableView]; 
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.VIPView.mas_bottom).offset(20);
        make.bottom.mas_equalTo(self).offset(-80);
        make.left.right.mas_equalTo(self);
    }];
    [self.tableView registerClass: [MenuCell class] forCellReuseIdentifier: @"MenuCellID"];
    
    self.tableView.clipsToBounds = YES;
    self.tableView.layer.cornerRadius = 20; 
    
    self.setButton = [UIButton buttonWithType: UIButtonTypeSystem];
    [self.setButton setTitle: @"  设置" forState: UIControlStateNormal];
    self.setButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    self.moreButton = [UIButton buttonWithType: UIButtonTypeSystem];
    [self.moreButton setTitle: @"  更多" forState: UIControlStateNormal];
    self.moreButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview: self.setButton];
    [self.setButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tableView.mas_bottom).offset(20);
        make.left.mas_equalTo(self).offset(30);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(40);
    }];
    self.setButton.backgroundColor = [UIColor systemBackgroundColor];
    self.setButton.tintColor = [UIColor labelColor];
    self.setButton.clipsToBounds = YES;
    self.setButton.layer.cornerRadius = 20;

    
    [self addSubview: self.moreButton];
    [self.moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.setButton);
        make.left.mas_equalTo(self.setButton.mas_right).offset(20);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(40);
    }];
    self.moreButton.backgroundColor = [UIColor systemBackgroundColor];
    self.moreButton.tintColor = [UIColor labelColor];
    self.moreButton.clipsToBounds = YES;
    self.moreButton.layer.cornerRadius = 20;

}
   
- (void)configWithUser:(UserModel *)user {
    self.avatarView.image = user.avatar;
    self.nickNameLabel.text = user.nickName;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
