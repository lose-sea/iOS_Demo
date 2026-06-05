//
//  TextCell.m
//  Share
//
//  Created by lose_sea on 2026/6/4.
//

#import "TextCell.h"

@implementation TextCell
- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpData];
    }
    return self;
}
 

- (void)setUpData {
    self.tagLabel = [[UILabel alloc] init];
    
    [self.contentView addSubview: self.tagLabel];
    [self.tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(20);
        make.centerY.mas_equalTo(self.contentView);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(30);
    }];
    
    self.messageLabel = [[UILabel alloc] init];
    [self.contentView addSubview: self.messageLabel];
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tagLabel);
        make.left.mas_equalTo(self.tagLabel.mas_right).offset(10);
        make.right.mas_equalTo(self.contentView).offset(10);
        make.height.mas_equalTo(30);
    }];
}

- (void) configWithUser:(NSString *)string {
    self.messageLabel.text = string;
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
