//
//  HourlyCell.m
//  Weather_forecast
//
//  Created by lose_sea on 2026/7/17.
//

#import "HourlyCell.h"

@implementation HourlyCell

- (instancetype) init {
    self = [super init];
    if (self) {
        [self setUpInterface];
    }
    return self;
}

- (void) setUpInterface {
    self.hourLabel = [[UILabel alloc] init];
    [self.contentView addSubview: self.hourLabel];
    [self.hourLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(5);
        make.left.right.mas_equalTo(self.contentView);
        make.height.mas_equalTo(50);
    }];
    
    self.weatherView = [[UIImageView alloc] init];
    [self.contentView addSubview: self.weatherView];
    [self.weatherView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.hourLabel.mas_bottom);
        make.centerX.mas_equalTo(self.contentView);
        make.width.height.mas_equalTo(60);
    }];
    
    self.hourTemperatureLabel = [[UILabel alloc] init];
    [self.contentView addSubview: self.hourTemperatureLabel];
    [self.hourTemperatureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.weatherView.mas_bottom);
        make.left.right.mas_equalTo(self.contentView);
    }];
}
 




- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
