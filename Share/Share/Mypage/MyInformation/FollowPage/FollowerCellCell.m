//
//  FollowerCellCell.m
//  Share
//
//  Created by lose_sea on 2026/6/2.
//

#import "FollowerCellCell.h"

@implementation FollowerCellCell


- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setInterface];
    }
    return self;
}

- (void) setInterface {
    self.avatarImageView = [[UIImageView alloc] init];
    self.nickLabel = [[UILabel alloc] init];
    self.followButton = [UIButton buttonWithType: UIButtonTypeSystem];
    
    [self.contentView addSubview: self.avatarImageView];
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(20);
        make.centerY.mas_equalTo(self.contentView);
        make.height.mas_equalTo(60);
        make.width.mas_equalTo(60);
    }];
    
    [self.contentView addSubview: self.nickLabel];
    [self.nickLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.avatarImageView.mas_right).offset(10);
            make.centerY.mas_equalTo(self.avatarImageView);
            make.width.mas_offset(100);
            make.height.mas_equalTo(40);
    }];
    
    
    [self.contentView addSubview: self.followButton];
    [self.followButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_right).offset(-90);
        make.centerY.mas_equalTo(self.contentView);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(30);
    }];
    [self.followButton addTarget: self action: @selector(pressFollowButton) forControlEvents: UIControlEventTouchUpInside];
}

- (void) pressFollowButton {
    self.follower.isFollow = !self.follower.isFollow;
    [self configWithFollow: self.follower];
}

- (void) configWithFollow:(Follower *)follow {
    self.avatarImageView.image = follow.avatar;
    self.nickLabel.text = follow.nickName;
    
    self.followButton.layer.masksToBounds = YES;
    self.followButton.layer.cornerRadius = 15;
    self.followButton.layer.borderWidth = 1;
    
    if (follow.isFollow == YES) {
        [self.followButton setTitle: @"已关注" forState: UIControlStateNormal];
        [self.followButton setTitleColor: [UIColor systemGrayColor] forState: UIControlStateNormal];
        self.followButton.tintColor = [UIColor systemGrayColor];
        self.followButton.layer.borderColor = [UIColor systemGrayColor].CGColor;


    } else {
        [self.followButton setTitle: @"+关注" forState: UIControlStateNormal];
        [self.followButton setTitleColor: [UIColor systemCyanColor] forState: UIControlStateNormal];
        
        self.followButton.layer.borderColor = [UIColor systemCyanColor].CGColor;
    }
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
