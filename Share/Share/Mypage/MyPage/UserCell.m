//
//  UserCell.m
//  Share
//
//  Created by lose_sea on 2026/5/31.
//

#import "UserCell.h"

@implementation UserCell
- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setInterface];
        [self configWithUser: self.mypageModel];
    }
    return self;
}

- (void) setInterface {

    // 图片
    self.avatarView = [[UIImageView alloc] init];
    self.nickLabel = [[UILabel alloc] init];
    self.signatureLabel = [[UILabel alloc] init];
    self.massageLabel = [[UILabel alloc] init];
    
    

    self.likeButton = [UIButton buttonWithType: UIButtonTypeCustom];
    self.saveButton = [UIButton buttonWithType: UIButtonTypeCustom];
    
    UIImage* like = [UIImage systemImageNamed: @"heart.fill"];
    [self.likeButton setImage: like forState: UIControlStateNormal];

    self.viewImageView = [[UIImageView alloc] initWithImage: [UIImage systemImageNamed: @"eye"]];
    
    UIImage* save = [UIImage systemImageNamed: @"doc.on.doc.fill"];
    [self.saveButton setImage: save forState: UIControlStateNormal];
    
    self.likeLabel = [[UILabel alloc] init];
    self.viewLabel = [[UILabel alloc] init];
    self.saveLabel = [[UILabel alloc] init];
    
    self.avatarView.contentMode = UIViewContentModeScaleAspectFill;
    self.avatarView.clipsToBounds = YES; 
    
    [self.contentView addSubview: self.avatarView];
    [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(20);
        make.top.mas_equalTo(self.contentView).offset(20);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(110);
    }];
    
    [self.contentView addSubview: self.nickLabel];
    self.nickLabel.font = [UIFont systemFontOfSize:22];
    [self.nickLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(10);
        make.left.mas_equalTo(self.avatarView.mas_right).offset(20);
        make.height.mas_equalTo(25);
        make.right.mas_equalTo(self.contentView).offset(-20);
    }];
    
    [self.contentView addSubview: self.massageLabel];
    self.massageLabel.font = [UIFont systemFontOfSize:17];
    [self.massageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.nickLabel.mas_bottom);
            make.left.mas_equalTo(self.avatarView.mas_right).offset(20);
            make.height.mas_equalTo(30);
            make.right.mas_equalTo(self.contentView).offset(-20);
    }];
    
    [self.contentView addSubview: self.signatureLabel];
    self.signatureLabel.font = [UIFont systemFontOfSize:15];
    [self.signatureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.massageLabel.mas_bottom);
            make.left.mas_equalTo(self.avatarView.mas_right).offset(20);
            make.height.mas_equalTo(60);
            make.right.mas_equalTo(self.contentView).offset(-20);
        }];
    
    [self.contentView addSubview: self.likeButton];
    [self.likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.signatureLabel.mas_bottom);
            make.left.mas_equalTo(self.avatarView.mas_right).offset(20);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(20);
    }];
    
    [self.contentView addSubview: self.likeLabel];
    self.likeLabel.font = [UIFont systemFontOfSize:14];
    [self.likeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.signatureLabel.mas_bottom);
        make.left.mas_equalTo(self.likeButton.mas_right).offset(10);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(20);
    }];
    
    [self.contentView addSubview: self.viewImageView];
    [self.viewImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.signatureLabel.mas_bottom);
            make.left.mas_equalTo(self.likeLabel.mas_right).offset(10);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(20);
    }];
    
    [self.contentView addSubview: self.viewLabel];
    self.viewLabel.font = [UIFont systemFontOfSize:14];
    [self.viewLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.signatureLabel.mas_bottom);
        make.left.mas_equalTo(self.viewImageView.mas_right).offset(10);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(20);
    }];
    
    [self.contentView addSubview: self.saveButton];
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.signatureLabel.mas_bottom);
            make.left.mas_equalTo(self.viewLabel.mas_right).offset(10);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(20);
    }];

    [self.contentView addSubview: self.saveLabel];
    self.saveLabel.font = [UIFont systemFontOfSize:14];
    [self.saveLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.signatureLabel.mas_bottom);
        make.left.mas_equalTo(self.saveButton.mas_right).offset(10);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(20);
    }];
}

- (void) configWithUser: (UserModel*) User {
    self.avatarView.image = User.avatar;
    self.nickLabel.text = [NSString stringWithFormat: @"%@", User.nickName];
    self.massageLabel.text = [NSString stringWithFormat: @"%@", User.massage];
    self.signatureLabel.text = [NSString stringWithFormat: @"%@", User.signature];
    self.likeLabel.text = [NSString stringWithFormat: @"%ld", User.likeCount];
    self.saveLabel.text = [NSString stringWithFormat: @"%ld", User.saveCount];
    self.viewLabel.text = [NSString stringWithFormat: @"%ld", User.viewCount];
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
