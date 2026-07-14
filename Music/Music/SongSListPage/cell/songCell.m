//
//  songCell.m
//  Music
//
//  Created by lose_sea on 2026/7/13.
//

#import "songCell.h"

@implementation songCell
- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpInterface]; 
    }
    return self;
}


- (void) setUpInterface {
    self.coverView = [[UIImageView alloc] init];
    [self.contentView addSubview: self.coverView];
    [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.contentView).offset(20);
        make.width.height.mas_equalTo(55);
    }];
    
    self.nameLabel = [[UILabel alloc] init];
    [self.contentView addSubview: self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.coverView.mas_right).offset(10);
        make.top.mas_equalTo(self.contentView).offset(20);
        make.width.mas_equalTo(300);
        make.height.mas_equalTo(30);
    }];
    self.nameLabel.font = [UIFont systemFontOfSize: 19];
    
    UILabel* label = [[UILabel alloc] init];
    [self.contentView addSubview: label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel);
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(5);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(70);
    }];
    label.font = [UIFont systemFontOfSize: 15];
    label.text = @"超清母带";
    label.textAlignment = NSTextAlignmentCenter;
//    [UIColor colorWithRed:212.0/255.0 green:168.0/255.0 blue:72.0/255.0 alpha:1.0].CGColor

    label.textColor = [UIColor colorWithRed:212.0/255.0 green:168.0/255.0 blue:72.0/255.0 alpha:1.0];
    label.layer.borderWidth = 1;
    label.layer.borderColor = [UIColor colorWithRed:212.0/255.0 green:168.0/255.0 blue:72.0/255.0 alpha:1.0].CGColor;
    
    self.authorLabel = [[UILabel alloc] init];
    [self.contentView addSubview: self.authorLabel];
    [self.authorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(label.mas_right).offset(10);
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(5);
        make.width.mas_equalTo(300);
        make.height.mas_equalTo(15);
    }];
    self.authorLabel.font = [UIFont systemFontOfSize: 16];
    self.authorLabel.textColor = [UIColor systemGrayColor];
}

- (void) configWithSong:(Song *)song {
    self.coverView.image = song.coverImage;
    self.nameLabel.text = song.name;
    self.authorLabel.text = song.artist; 
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
