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
//    self.contentView.backgroundColor = [UIColor systemCyanColor];

    self.tagLabel = [[UILabel alloc] init];
    self.tagLabel.text = @"性别";
   
    self.maleButton = [UIButton buttonWithType: UIButtonTypeSystem];
    self.maleLabel = [[UILabel alloc] init];
    self.femaleButton = [UIButton buttonWithType: UIButtonTypeSystem];
    self.femaleLabel = [[UILabel alloc] init];
//    UIImage* maleImage = [UIImage systemImageNamed:@"mars.circle"];
//    UIImage* femaleImage = [UIImage systemImageNamed:@"venus.circle"];


//    [self.maleButton setImage: maleImage forState: UIControlStateNormal];
//    [self.femaleButton setImage: femaleImage forState: UIControlStateNormal];
    
    [self.maleButton setTitle:@"♂" forState:UIControlStateNormal];
    [self.femaleButton setTitle:@"♀" forState:UIControlStateNormal];
    
    // 设置加粗字体
//    self.maleButton.titleLabel.font = [UIFont boldSystemFontOfSize: 22];
//    self.femaleButton.titleLabel.font = [UIFont boldSystemFontOfSize: 22];
    
    self.maleButton.titleLabel.font = [UIFont systemFontOfSize: 23 weight:UIFontWeightBold];
    self.femaleButton.titleLabel.font = [UIFont systemFontOfSize: 23 weight:UIFontWeightBold];
    
    self.femaleButton.tintColor = [UIColor systemGrayColor];
    self.maleButton.tintColor = [UIColor systemBlueColor];
    
    [self.contentView addSubview: self.tagLabel];
    [self.tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(20);
        make.centerY.mas_equalTo(self.contentView);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(30);
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
            make.left.mas_equalTo(self.maleButton.mas_right);
            make.width.mas_equalTo(30);
            make.height.mas_equalTo(30);
    }];
    self.maleLabel.text = @"男";
    self.maleLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.contentView addSubview: self.femaleButton];
    [self.femaleButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.maleLabel).offset(5);
            make.left.mas_equalTo(self.maleLabel.mas_right).offset(20);
            make.width.height.mas_equalTo(20);
    }];
    
    [self.contentView addSubview: self.femaleLabel];
    [self.femaleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.femaleButton).offset(-5);
        make.left.mas_equalTo(self.femaleButton.mas_right);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
    }];
    self.femaleLabel.text = @"女";
    self.femaleLabel.textAlignment = NSTextAlignmentCenter;
    
}

- (void) configWithUser: (UserModel*) user {
    if ([user.gender isEqualToString: @"男"]) {
        self.femaleButton.tintColor = [UIColor systemGrayColor];
        self.maleButton.tintColor = [UIColor systemBlueColor];
    } else {
        self.maleButton.tintColor = [UIColor systemGrayColor];
        self.femaleButton.tintColor = [UIColor systemBlueColor];
    }
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


//vector<vector<int>> (n, vector<int>());
