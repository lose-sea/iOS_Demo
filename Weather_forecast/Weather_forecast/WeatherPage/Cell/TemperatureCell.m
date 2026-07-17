//
//  TemperatureCell.m
//  Weather_forecast
//
//  Created by lose_sea on 2026/7/17.
//

#import "TemperatureCell.h"

@implementation TemperatureCell
- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpInterface];
    }
    return self;
}

- (void) setUpInterface {
    self.backgroundColor = [UIColor clearColor];
//    self.contentView.backgroundColor = [UIColor clearColor];
    
    self.nameLabel = [[UILabel alloc] init];
    [self.contentView addSubview: self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(30);
        make.left.right.mas_equalTo(self.contentView);
    }];
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    self.nameLabel.text = @"西安市长安区";
    self.nameLabel.font = [UIFont systemFontOfSize: 27];
    
    
    self.temperatureLabel = [[UILabel alloc] init];
    [self.contentView addSubview: self.temperatureLabel];
    [self.temperatureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(10);
        make.left.right.mas_equalTo(self.contentView);
    }];
    self.temperatureLabel.textAlignment = NSTextAlignmentCenter;
    self.temperatureLabel.text = @"37°";
    self.temperatureLabel.font = [UIFont systemFontOfSize: 100];
    
    UILabel* maxLabel = [[UILabel alloc] init];
    [self.contentView addSubview: maxLabel];
    [maxLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.temperatureLabel.mas_bottom);
        make.left.mas_equalTo(100);
        make.width.mas_equalTo(20);
    }];
//    maxLabel.backgroundColor = [UIColor systemRedColor];
    maxLabel.textAlignment = NSTextAlignmentCenter;
    maxLabel.numberOfLines = 2;
    maxLabel.text = @"最高";
    maxLabel.font = [UIFont systemFontOfSize: 14];
    
    self.maxLabel = [[UILabel alloc] init];
    [self.contentView addSubview: self.maxLabel];
    [self.maxLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(maxLabel);
        make.left.mas_equalTo(maxLabel.mas_right);
//        make.height.mas_equalTo(60);
    }];
//    self.maxLabel.backgroundColor = [UIColor systemCyanColor];
    self.maxLabel.textAlignment = NSTextAlignmentCenter;
    self.maxLabel.font = [UIFont systemFontOfSize: 30];
    self.maxLabel.text = @"37°";
    
    
    UILabel* minLabel = [[UILabel alloc] init];
    [self.contentView addSubview: minLabel];
    [minLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.maxLabel);
        make.left.mas_equalTo(self.maxLabel.mas_right).offset(50);
        make.width.mas_equalTo(20);
    }];
//    minLabel.backgroundColor = [UIColor systemRedColor];
    minLabel.textAlignment = NSTextAlignmentCenter;
    minLabel.numberOfLines = 2;
    minLabel.text = @"最低";
    minLabel.font = [UIFont systemFontOfSize: 14];
    
    self.minLabel = [[UILabel alloc] init];
    [self.contentView addSubview: self.minLabel];
    [self.minLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(minLabel);
        make.left.mas_equalTo(minLabel.mas_right);
//        make.width.mas_equalTo(70);
//        make.height.mas_equalTo(60);
    }];
//    self.minLabel.backgroundColor = [UIColor systemCyanColor];
    self.minLabel.textAlignment = NSTextAlignmentCenter;
    self.minLabel.font = [UIFont systemFontOfSize: 30];
    self.minLabel.text = @"24°";

    self.weatherLabel = [[UILabel alloc] init];
    [self.contentView addSubview: self.weatherLabel];
    [self.weatherLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.maxLabel.mas_bottom);
        make.left.right.mas_equalTo(self.contentView);
    }];
    self.weatherLabel.text = @"晴";
    self.weatherLabel.textAlignment = NSTextAlignmentCenter;
    self.weatherLabel.font = [UIFont systemFontOfSize: 25];
    


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
