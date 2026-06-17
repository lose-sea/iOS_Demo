//
//  MenuCell.m
//  Music
//
//  Created by lose_sea on 2026/6/16.
//

#import "MenuCell.h"

@implementation MenuCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpInterface];
    }
    return self;
}


- (void)setUpInterface {
    self.tagView = [[UIImageView alloc] init];
    self.tagLabel = [[UILabel alloc] init];
    self.iView = [[UIView alloc] init];
    
    [self.contentView addSubview: self.tagView];
    [self.tagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.contentView).offset(20);
        make.width.height.mas_equalTo(30);
    }];
    
    [self.contentView addSubview: self.tagLabel];
    [self.tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.tagView.mas_right).offset(20);
        make.centerY.mas_equalTo(self.contentView);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(40);
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
