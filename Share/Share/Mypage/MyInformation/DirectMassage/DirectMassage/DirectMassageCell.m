//
//  DirectMassageCell.m
//  Share
//
//  Created by lose_sea on 2026/6/2.
//

#import "DirectMassageCell.h"

@implementation DirectMassageCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpInterface];
    }
    return self;
}


- (void) setUpInterface {
    self.avatarImageView = [[UIImageView alloc] init];
    self.nickLabel = [[UILabel alloc] init];
    self.massageLabel = [[UILabel alloc] init];
    self.timeLabel = [[UILabel alloc] init];
    
    [self.contentView addSubview: self.avatarImageView];
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(20);
        make.centerY.mas_equalTo(self.contentView);
        make.height.mas_equalTo(70);
        make.width.mas_equalTo(70);
    }];
    
    [self.contentView addSubview: self.nickLabel];
    [self.nickLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.avatarImageView.mas_right).offset(10);
        make.top.mas_equalTo(self.contentView).offset(10);
        make.width.mas_offset(100);
        make.height.mas_equalTo(40);
    }];
    
    [self.contentView addSubview: self.massageLabel];
    [self.massageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nickLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(self.nickLabel);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(20);
    }];
        self.massageLabel.font = [UIFont systemFontOfSize: 14];

    
    [self.contentView addSubview: self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(10);
        make.left.mas_equalTo(self.contentView.mas_right).offset(-80);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(20);
    }];
    self.timeLabel.textColor = [UIColor systemGrayColor];
    self.timeLabel.font = [UIFont systemFontOfSize: 13]; 
}

- (void) configWithFollower: (Follower*) follower {
    self.avatarImageView.image = follower.avatar;
    self.nickLabel.text = follower.nickName;
    self.massageLabel.text = follower.massage;
    self.timeLabel.text = @"今天 6:34";
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
