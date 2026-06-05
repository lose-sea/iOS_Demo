//
//  AvatarCell.m
//  Share
//
//  Created by lose_sea on 2026/6/4.
//

#import "AvatarCell.h"

@implementation AvatarCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpData];
    }
    return self;
}

- (void) setUpData {
    self.tagLabel = [[UILabel alloc] init];
    self.avatarImageView = [[UIImageView alloc] init];
    
    self.tagLabel.text = @"头像";
    
    [self.contentView addSubview: self.tagLabel];
    [self.tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(20);
        make.centerY.mas_equalTo(self.contentView);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(30);
    }];
    
    [self.contentView addSubview: self.avatarImageView];
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(10);
        make.left.mas_equalTo(self.tagLabel.mas_right).offset(20);
        make.width.height.mas_equalTo(75);
    }];
    
    self.avatarImageView.clipsToBounds = YES;
    self.contentMode = UIViewContentModeScaleAspectFill; 
}

- (void)configWithUser:(UserModel *)user {
    self.avatarImageView.image = user.avatar; 
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
