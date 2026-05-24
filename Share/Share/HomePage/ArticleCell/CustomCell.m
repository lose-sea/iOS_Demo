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
    
    self.likeButton = [UIButton buttonWithType: UIButtonTypeCustom];
    self.saveButton = [UIButton buttonWithType: UIButtonTypeCustom];
    
    UIImage* like01 = [UIImage systemImageNamed: @"heart"];
    UIImage* like02 = [UIImage systemImageNamed: @"heart.fill"];
    if (self.article.isLike == NO) {
        [self.likeButton setImage: like01 forState: UIControlStateNormal];
    } else {
        [self.likeButton setImage: like02 forState: UIControlStateNormal];
    }
    self.viewImageView = [[UIImageView alloc] initWithImage: [UIImage systemImageNamed: @"eye"]];
    UIImage* save01 = [UIImage systemImageNamed: @"star"];
    UIImage* save02 = [UIImage systemImageNamed: @"star.fill"];
    if (self.article.isSave == YES) {
        [self.saveButton setImage: save01 forState: UIControlStateNormal];
    } else {
        [self.saveButton setImage: save02 forState: UIControlStateNormal];
    }
    
    [self.likeButton addTarget: self action: @selector(pressLikeButton) forControlEvents: UIControlEventTouchUpInside];
    [self.saveButton addTarget: self action: @selector(pressSaveButton) forControlEvents: UIControlEventTouchUpInside];
    
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
    
    [self.contentView addSubview: self.likeButton];
    [self.likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.massageLabel.mas_bottom);
            make.left.mas_equalTo(self.iView.mas_right).offset(20);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(20);
    }];
    
    [self.contentView addSubview: self.likeLabel];
    self.likeLabel.font = [UIFont systemFontOfSize:14];
    [self.likeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.massageLabel.mas_bottom);
        make.left.mas_equalTo(self.likeButton.mas_right).offset(10);
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
    
    [self.contentView addSubview: self.saveButton];
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.massageLabel.mas_bottom);
            make.left.mas_equalTo(self.viewLabel.mas_right).offset(20);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(20);
    }];

    [self.contentView addSubview: self.saveLabel];
    self.saveLabel.font = [UIFont systemFontOfSize:14];
    [self.saveLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.massageLabel.mas_bottom);
        make.left.mas_equalTo(self.saveButton.mas_right).offset(10);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(20);
    }];
}

- (void) pressLikeButton {
    NSLog(@"点击likeButton");
    self.article.isLike = !self.article.isLike;
    if (self.article.isLike == YES) {
        self.article.likeCount++;
    } else {
        self.article.likeCount--;
    }
    [self configureWithArticle: self.article];
}


- (void) pressSaveButton {
    NSLog(@"点击saveButton");
    self.article.isSave = !self.article.isSave;
    if (self.article.isSave == YES) {
        self.article.saveCount++;
    } else {
        self.article.saveCount--;
    }
    [self configureWithArticle: self.article];
}



- (void) configureWithArticle:(article *)article {
    self.iView.image = article.image;
    self.titleLabel.text = article.name;
    self.authorLabel.text = article.author;
    self.massageLabel.text = article.massage;
    UIImage* like01 = [UIImage systemImageNamed: @"heart"];
    UIImage* like02 = [UIImage systemImageNamed: @"heart.fill"];
    if (self.article.isLike == NO) {
        [self.likeButton setImage: like01 forState: UIControlStateNormal];
    } else {
//        self.article.likeCount++;
        [self.likeButton setImage: like02 forState: UIControlStateNormal];
    }
    
    UIImage* save01 = [UIImage systemImageNamed: @"star"];
    UIImage* save02 = [UIImage systemImageNamed: @"star.fill"];
    if (self.article.isSave == NO) {
        [self.saveButton setImage: save01 forState: UIControlStateNormal];
    } else {
//        self.article.saveCount++;
        [self.saveButton setImage: save02 forState: UIControlStateNormal];
    }
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
