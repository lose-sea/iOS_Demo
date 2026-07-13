//
//  PlayListCell.m
//  Music
//
//  Created by lose_sea on 2026/6/17.
//

#import "PlayListCell.h"

@implementation PlayListCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpInterface];
    }
    return self;
}

- (void)setUpInterface {
    self.coverView = [[UIImageView alloc] init];
    self.nameLabel = [[UILabel alloc] init];
    self.messageLabel = [[UILabel alloc] init];
    
    [self.contentView addSubview: self.coverView];
    [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.contentView).offset(10);
        make.width.height.mas_equalTo(50);
    }];
    
    [self.contentView addSubview: self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(10);
        make.left.mas_equalTo(self.coverView.mas_right).offset(10);
        make.width.mas_equalTo(300);
        make.height.mas_equalTo(30);
    }];
    self.nameLabel.font = [UIFont boldSystemFontOfSize: 18];
    
    [self.contentView addSubview: self.messageLabel];
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel);
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(5);
        make.width.mas_equalTo(300);
        make.height.mas_equalTo(15);
    }];
    self.messageLabel.font = [UIFont systemFontOfSize: 14];
    self.messageLabel.textColor = [UIColor systemGrayColor];
    
    self.accessoryView = [[UIImageView alloc] initWithImage: [UIImage systemImageNamed: @"ellipsis.circle"]];
    
}

- (void) configWithSongList:(SongList *)songList {
    self.coverView.image = songList.coverImage;
    self.nameLabel.text = songList.name;
    self.messageLabel.text = songList.message;
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
