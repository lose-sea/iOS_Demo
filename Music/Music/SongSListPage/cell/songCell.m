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
        make.width.height.mas_equalTo(50);
    }];
    
    self.nameLabel = [[UILabel alloc] init];
    [self.contentView addSubview: self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.coverView.mas_right).offset(10);
        make.top.mas_equalTo(self.contentView).offset(10);
        make.width.mas_equalTo(300);
        make.height.mas_equalTo(30);
    }];
    
    
    self.authorLabel = [[UILabel alloc] init];
    [self.contentView addSubview: self.authorLabel];
    self.authorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.)
    }
}

- (void) configWithSong:(Song *)song {
    
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
