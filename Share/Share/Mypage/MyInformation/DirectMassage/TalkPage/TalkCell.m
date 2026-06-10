//
//  TalkCell.m
//  Share
//
//  Created by lose_sea on 2026/6/3.
//

#import "TalkCell.h"

@implementation TalkCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpInterface];
    }
    return self;
}

- (void) setUpInterface {
    self.avatarImageView = [[UIImageView alloc] init];
    self.backView = [[UIView alloc] init];
    self.messageLabel = [[UILabel alloc] init];
    
    self.messageLabel.numberOfLines = 0;
    self.messageLabel.font = [UIFont systemFontOfSize: 16];
    
    [self.contentView addSubview: self.avatarImageView];
    [self.contentView addSubview: self.backView];
    [self.backView addSubview: self.messageLabel];
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.backView).insets(UIEdgeInsetsMake(10, 10, 10, 10));
    }];
}
 
- (void) configWithFollower: (Follower*) follower Message: (NSString*) message isMyself: (BOOL)isMyself {
    self.avatarImageView.image = follower.avatar;
    self.messageLabel.text = message;
    
    self.backView.layer.masksToBounds = YES;
    self.backView.layer.cornerRadius = 5; 

    if (isMyself) {
        // 头像靠右
        [self.avatarImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(10);
            make.right.equalTo(self.contentView).offset(-15);
            make.width.height.mas_equalTo(40);
        }];
        
        [self.backView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(30);
            make.right.equalTo(self.avatarImageView.mas_left).offset(-10);
            make.left.greaterThanOrEqualTo(self.contentView).offset(60);  // 最小左边距，防止过宽
            make.bottom.equalTo(self.contentView).offset(-10);
            // 关键：设置最大宽度（屏幕宽度的 70%）
            make.width.lessThanOrEqualTo(self.contentView).multipliedBy(0.7);
        }];
        
        self.backView.backgroundColor = [UIColor systemGreenColor];
        self.messageLabel.textAlignment = NSTextAlignmentLeft;
        self.messageLabel.backgroundColor = [UIColor clearColor];

        
    } else {
        [self.avatarImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView).offset(15);
            make.top.mas_equalTo(self.contentView).offset(10);
            make.width.height.mas_equalTo(40);
        }];
        
        [self.backView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(30);
            make.left.equalTo(self.avatarImageView.mas_right).offset(10);
            make.right.lessThanOrEqualTo(self.contentView).offset(-60); // 最小右边距
            make.bottom.equalTo(self.contentView).offset(-10);
            make.width.lessThanOrEqualTo(self.contentView).multipliedBy(0.7);
        }];
        
        self.backView.backgroundColor = [UIColor systemGrayColor];
        self.messageLabel.textAlignment = NSTextAlignmentLeft;
        self.messageLabel.backgroundColor = [UIColor clearColor];
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
