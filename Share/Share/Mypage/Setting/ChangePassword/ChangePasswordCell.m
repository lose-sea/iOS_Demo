//
//  ChangePasswordCell.m
//  Share
//
//  Created by lose_sea on 2026/6/5.
//

#import "ChangePasswordCell.h"

@implementation ChangePasswordCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpData]; 
    }
    return self;
}

- (void)setUpData {
    self.tagLabel = [[UILabel alloc] init];
    self.textField = [[UITextField alloc] init];
    self.warnLabel = [[UILabel alloc] init];
    
    [self.contentView addSubview: self.tagLabel];
    [self.tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(10);
        make.left.mas_equalTo(self.contentView).offset(20);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(30);
    }];
    
    [self.contentView addSubview: self.textField];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(5);
        make.left.mas_equalTo(self.tagLabel.mas_right).offset(10);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(35);
    }];
    
//    self.textField.borderStyle = UITextBorderStyleLine;
    
    [self.contentView addSubview: self.warnLabel];
    [self.warnLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.textField);
        make.top.mas_equalTo(self.textField.mas_bottom).offset(5);
        make.width.mas_equalTo(260);
        make.height.mas_equalTo(15);
    }];
    self.warnLabel.font = [UIFont systemFontOfSize: 15];
    self.warnLabel.text = @"密码由6 - 10位字母或数字组成";
    self.warnLabel.textColor = [UIColor systemRedColor];
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
