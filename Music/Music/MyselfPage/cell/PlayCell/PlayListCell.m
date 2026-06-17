//
//  PlayListCell.m
//  Music
//
//  Created by lose_sea on 2026/6/17.
//

#import "PlayListCell.h"

@implementation PlayListCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)setUpInterface {
    self.songView = [[UIImageView alloc] init];
    self.songName = [[UILabel alloc] init];
    self.messageLabel = [[UILabel alloc] init];
    
    [self.contentView addSubview: self.songView];
    [self.songView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.contentView).offset(10);
        make.width.height.mas_equalTo(50);
    }];
    
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
