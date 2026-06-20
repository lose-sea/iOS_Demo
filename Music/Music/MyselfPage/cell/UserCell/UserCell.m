//
//  UserCell.m
//  Music
//
//  Created by lose_sea on 2026/6/17.
//

#import "UserCell.h"

@implementation UserCell
- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        self.backgroundColor = [UIColor systemCyanColor];
        [self setUpInterface];
    }
    return self;
}

- (void)setUpInterface {
    self.avatarView = [[UIImageView alloc] init];
    self.nickLabel = [[UILabel alloc] init];
    self.followLabel = [[UILabel alloc] init];
    self.followerLabel = [[UILabel alloc] init];
    self.levelLabel = [[UILabel alloc] init];
    self.hourLabel = [[UILabel alloc] init];
    
    [self.contentView addSubview: self.avatarView];
    [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(15);
        make.centerX.mas_equalTo(self.contentView);
        make.width.height.mas_equalTo(80);
    }];
    
    self.avatarView.backgroundColor = [UIColor systemRedColor];
    self.avatarView.clipsToBounds = YES;
    self.avatarView.layer.cornerRadius = 40;
    
    [self.contentView addSubview: self.nickLabel];
    [self.nickLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.avatarView.mas_bottom).offset(5);
        make.centerX.mas_equalTo(self.contentView).offset(-35);
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(30);
    }];
    self.nickLabel.font = [UIFont boldSystemFontOfSize: 20];
    
    UIImageView* myVIPView = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"MyVIP.png"]];
    [self.contentView addSubview: myVIPView];
    [myVIPView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.nickLabel);
        make.left.mas_equalTo(self.nickLabel.mas_right).offset(10);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(20);
    }];
    myVIPView.clipsToBounds = YES;
    myVIPView.layer.cornerRadius = 10;
    
    
    [self.contentView addSubview: self.followLabel];
    [self.followLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nickLabel.mas_bottom);
        make.left.mas_equalTo(self.contentView).offset(70);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(40);
    }];
    
    [self.contentView addSubview: self.followerLabel];
    [self.followerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.followLabel);
        make.left.mas_equalTo(self.followLabel.mas_right).offset(10);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(40);
    }];
    
    [self.contentView addSubview: self.levelLabel];
    [self.levelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.followerLabel);
        make.left.mas_equalTo(self.followerLabel.mas_right).offset(10);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(40);
    }];
    self.levelLabel.text = @"Lv.5";
    
    [self.contentView addSubview: self.hourLabel];
    [self.hourLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.levelLabel);
        make.left.mas_equalTo(self.levelLabel.mas_right).offset(15);
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(40);
    }];
    self.hourLabel.text = @"25 小时";
    
    
    UIButton* recentButton = [UIButton buttonWithType: UIButtonTypeSystem];
    [self.contentView addSubview: recentButton];
    [recentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.followLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(self.contentView).offset(10);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(30);
    }];
    [recentButton setImage:[UIImage systemImageNamed:@"clock.fill"] forState:UIControlStateNormal];
    [recentButton setTitle: @"最近" forState: UIControlStateNormal];
    
    recentButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);    // 图片向右偏移10pt，即间距增大
    recentButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);    // 文字向左偏移10pt，两者之间多出20pt
    recentButton.tintColor = [UIColor labelColor];
    recentButton.backgroundColor = [[UIColor systemCyanColor] colorWithAlphaComponent: 0.15];
    recentButton.clipsToBounds = YES;
    recentButton.layer.cornerRadius = 20;
    
    UIButton* localButton = [UIButton buttonWithType: UIButtonTypeSystem];
    [self.contentView addSubview: localButton];
    [localButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(recentButton);
        make.left.mas_equalTo(recentButton.mas_right).offset(10);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(30);
    }];
    [localButton setImage:[UIImage systemImageNamed:@"square.and.arrow.down.fill"] forState:UIControlStateNormal];
    [localButton setTitle: @"本地" forState: UIControlStateNormal];
    
    localButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);    // 图片向右偏移10pt，即间距增大
    localButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);    // 文字向左偏移10pt，两者之间多出20pt
    localButton.tintColor = [UIColor labelColor];
    localButton.backgroundColor = [[UIColor systemCyanColor] colorWithAlphaComponent: 0.15];
    localButton.clipsToBounds = YES;
    localButton.layer.cornerRadius = 20;
    
    UIButton* cloudButton = [UIButton buttonWithType: UIButtonTypeSystem];
    [self.contentView addSubview: cloudButton];
    [cloudButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(localButton);
        make.left.mas_equalTo(localButton.mas_right).offset(10);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(30);
    }];
    [cloudButton setImage:[UIImage systemImageNamed:@"icloud.and.arrow.up.fill"] forState:UIControlStateNormal];
    [cloudButton setTitle: @"网盘" forState: UIControlStateNormal];
    
    cloudButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);    // 图片向右偏移10pt，即间距增大
    cloudButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);    // 文字向左偏移10pt，两者之间多出20pt
    cloudButton.tintColor = [UIColor labelColor];
    cloudButton.backgroundColor = [[UIColor systemCyanColor] colorWithAlphaComponent: 0.15];
    cloudButton.clipsToBounds = YES;
    cloudButton.layer.cornerRadius = 20;
    
    
    UIButton* dressButton = [UIButton buttonWithType: UIButtonTypeSystem];
    [self.contentView addSubview: dressButton];
    [dressButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(cloudButton);
        make.left.mas_equalTo(cloudButton.mas_right).offset(10);
        make.width.mas_equalTo(80);  
        make.height.mas_equalTo(30);
    }];
    [dressButton setImage:[UIImage systemImageNamed:@"tshirt.fill"] forState:UIControlStateNormal];
    [dressButton setTitle: @"装扮" forState: UIControlStateNormal];
    
    cloudButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);    // 图片向右偏移10pt，即间距增大
    dressButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);    // 文字向左偏移10pt，两者之间多出20pt
    dressButton.tintColor = [UIColor labelColor];
    dressButton.backgroundColor = [[UIColor systemCyanColor] colorWithAlphaComponent: 0.15];
    dressButton.clipsToBounds = YES;
    dressButton.layer.cornerRadius = 20;
    
    UIButton* moreButton = [UIButton buttonWithType: UIButtonTypeSystem];
    [self.contentView addSubview: moreButton];
    [moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(dressButton);
        make.left.mas_equalTo(dressButton.mas_right).offset(10);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
    }];
    [moreButton setImage:[UIImage systemImageNamed:@"square.grid.2x2.fill"] forState:UIControlStateNormal];
    
    moreButton.tintColor = [UIColor labelColor];
    moreButton.backgroundColor = [[UIColor systemCyanColor] colorWithAlphaComponent: 0.15];
    moreButton.clipsToBounds = YES;
    moreButton.layer.cornerRadius = 8;
}

- (void) configWithUser:(UserModel *)user {
    self.avatarView.image = user.avatar;
    self.nickLabel.text = user.nickName;
    
    self.followLabel.text = [NSString stringWithFormat: @"%ld 关注", self.user.followCount];
    self.followerLabel.text = [NSString stringWithFormat: @"%ld 粉丝", self.user.followerCount];
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
