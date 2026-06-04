//
//  GenderCell.m
//  Share
//
//  Created by lose_sea on 2026/6/4.
//

#import "GenderCell.h"

@implementation GenderCell
- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpData];
    }
    return self;
}

- (void)setUpData {
    self.tagLabel = [[UILabel alloc] init];
   
    self.maleButton = [UIButton buttonWithType: UIButtonTypeCustom];
    self.maleLabel = [[UILabel alloc] init];
    self.femaleButton = [UIButton buttonWithType: UIButtonTypeCustom];
    UIImage* maleImage = [UIImage systemImageNamed: @"mars"];
    self.femaleLabel = [[UILabel alloc] init];
    UIImage* femaleImage = [UIImage systemImageNamed: @"venus"];
    [self.contentView addSubview: self.tagLabel];
    [self.tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(5);
        make.left.mas_equalTo(self.contentView).offset(10);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(40);
    }];
    
    
    [self.contentView addSubview: self.maleButton];
    [self.maleButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.tagLabel);
            make.left.mas_equalTo(self.tagLabel.mas_right).offset(20);
            make.width.mas_equalTo(30);
            make.height.mas_equalTo(30);
    }];
    
    [self.contentView addSubview: self.maleLabel];
    [self.maleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.maleButton);
            make.left.mas_equalTo(self.maleButton.mas_right).offset(10);
            make.width.mas_equalTo(50);
            make.height.mas_equalTo(30);
    }];
    self.maleLabel.text = @"男";
    self.maleLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.contentView addSubview: self.femaleButton];
    [self.femaleButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.maleLabel);
            make.left.mas_equalTo(self.maleLabel.mas_right).offset(10);
            make.width.height.mas_equalTo(30);
    }];
    
    [self.contentView addSubview: self.femaleLabel];
    [self.femaleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.femaleButton);
        make.left.mas_equalTo(self.femaleButton.mas_right);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(30);
    }];
    self.femaleLabel.text = @"女";
    self.femaleLabel.textAlignment = NSTextAlignmentCenter;
    
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
