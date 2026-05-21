//
//  CustomCell.m
//  Share
//
//  Created by lose_sea on 2026/5/19.
//

#import "CustomCell.h"

@implementation CustomCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle: style  reuseIdentifier: reuseIdentifier];
    if (self) {
        [self setUI];
    }
    return self;
}

- (void) setUI {
    // 图片
    self.iView = [[UIImageView alloc] init];
    self.titleLabel = [[UILabel alloc] init];
    self.massageLabel = [[UILabel alloc] init];
    self.authorLabel = [[UILabel alloc] init];
    
    self.likeImageView = [[UIImageView alloc] initWithImage: [UIImage systemImageNamed: @"heart"]];
    self.viewImageView = [[UIImageView alloc] initWithImage: [UIImage systemImageNamed: @"eye"]];
    self.saveImageView = [[UIImageView alloc] initWithImage: [UIImage systemImageNamed: @"star"]];
    
    self.likeLabel = [[UILabel alloc] init];
    self.viewLabel = [[UILabel alloc] init];
    self.saveLabel = [[UILabel alloc] init];
    
    [self.contentView addSubview: self.iView];
    [self.iView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(20);
        make.top.mas_equalTo(self.contentView).offset(20);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(110);
    }];
    
    [self.contentView addSubview: self.titleLabel];
    self.titleLabel.font = [UIFont systemFontOfSize:22];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(10);
        make.left.mas_equalTo(self.iView.mas_right).offset(20);
        make.height.mas_equalTo(25);
        make.right.mas_equalTo(self.contentView).offset(-20);
    }];
    
    [self.contentView addSubview: self.authorLabel];
    self.authorLabel.font = [UIFont systemFontOfSize:17];
    [self.authorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.titleLabel.mas_bottom);
            make.left.mas_equalTo(self.iView.mas_right).offset(20);
            make.height.mas_equalTo(30);
            make.right.mas_equalTo(self.contentView).offset(-20);
    }];
    
    [self.contentView addSubview: self.massageLabel];
    self.massageLabel.font = [UIFont systemFontOfSize:15];
    [self.massageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.authorLabel.mas_bottom);
            make.left.mas_equalTo(self.iView.mas_right).offset(20);
            make.height.mas_equalTo(60);
            make.right.mas_equalTo(self.contentView).offset(-20);
        }];
    
    [self.contentView addSubview: self.likeImageView];
    [self.likeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.massageLabel.mas_bottom);
            make.left.mas_equalTo(self.iView.mas_right).offset(20);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(20);
    }];
    
    [self.contentView addSubview: self.likeLabel];
    self.likeLabel.font = [UIFont systemFontOfSize:14];
    [self.likeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.massageLabel.mas_bottom);
        make.left.mas_equalTo(self.likeImageView.mas_right).offset(10);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(20);
    }];
    
    [self.contentView addSubview: self.viewImageView];
    [self.viewImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.massageLabel.mas_bottom);
            make.left.mas_equalTo(self.likeLabel.mas_right).offset(20);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(20);
    }];
    
    [self.contentView addSubview: self.viewLabel];
    self.viewLabel.font = [UIFont systemFontOfSize:14];
    [self.viewLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.massageLabel.mas_bottom);
        make.left.mas_equalTo(self.viewImageView.mas_right).offset(10);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(20);
    }];
    
    [self.contentView addSubview: self.saveImageView];
    [self.saveImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.massageLabel.mas_bottom);
            make.left.mas_equalTo(self.viewLabel.mas_right).offset(20);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(20);
    }];

    [self.contentView addSubview: self.saveLabel];
    self.saveLabel.font = [UIFont systemFontOfSize:14];
    [self.saveLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.massageLabel.mas_bottom);
        make.left.mas_equalTo(self.saveImageView.mas_right).offset(10);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(20);
    }];
}

- (void) configureWithArticle:(article *)article {
    self.iView.image = article.image;
    self.titleLabel.text = article.name;
    self.authorLabel.text = article.author;
    self.massageLabel.text = article.massage;
    self.likeLabel.text =  [NSString stringWithFormat: @"%ld", (long)article.likeCount];
    self.viewLabel.text =  [NSString stringWithFormat: @"%ld", (long)article.viewCount];
    self.saveLabel.text =  [NSString stringWithFormat: @"%ld", (long)article.saveCount];
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
