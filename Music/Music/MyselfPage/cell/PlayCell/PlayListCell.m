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
    }];
    
}

- (void) configWithSong:(Song *)song {
    self.coverView.image = song.coverImage;
    self.nameLabel.text = song.name;
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
