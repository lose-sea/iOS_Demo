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
    self.contentView.backgroundColor = [UIColor clearColor];
    
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
        make.left.mas_equalTo(85);
        make.width.mas_equalTo(20);
    }];
//    maxLabel.backgroundColor = [UIColor systemRedColor];
    maxLabel.textAlignment = NSTextAlignmentCenter;
    maxLabel.numberOfLines = 2;
    maxLabel.text = @"最高";
    maxLabel.font = [UIFont boldSystemFontOfSize: 14];
    
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
    minLabel.font = [UIFont boldSystemFontOfSize: 14];
    
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


- (void) configWithCurrentWeather:(NSDictionary *)currentWeather dailyWeather:(nonnull NSDictionary *)dailyWeather {
    CGFloat temperature = [currentWeather[@"temperature_2m"] doubleValue];
    self.temperatureLabel.text = [NSString stringWithFormat: @"%.1f°", temperature];
    
    NSArray *maxTempArr = dailyWeather[@"temperature_2m_max"];
    NSNumber *maxNum = maxTempArr[0];
    CGFloat maxTemperature = [maxNum doubleValue];
    self.maxLabel.text = [NSString stringWithFormat: @"%.1f°", maxTemperature];
    
    NSArray *minTempArr = dailyWeather[@"temperature_2m_min"];
    NSNumber *minNum = minTempArr[0];
    CGFloat minTemperature = [minNum doubleValue];
    self.minLabel.text = [NSString stringWithFormat: @"%.1f°", minTemperature];
    
    NSInteger weather_code = [currentWeather[@"weather_code"] integerValue];
    self.weatherLabel.text = [self descriptionForWeatherCode: weather_code];
    
}


- (NSString *)descriptionForWeatherCode:(NSInteger)code {
    // 0: 晴天
    if (code == 0) return @"晴";
    // 1,2,3: 多云
    if (code >= 1 && code <= 3) return @"多云";
    // 45,48: 雾
    if (code == 45 || code == 48) return @"雾";
    // 51,53,55: 毛毛雨
    if (code >= 51 && code <= 55) return @"毛毛雨";
    // 56,57: 冻毛毛雨
    if (code == 56 || code == 57) return @"冻毛毛雨";
    // 61,63,65: 雨
    if (code >= 61 && code <= 65) return @"雨";
    // 66,67: 冻雨
    if (code == 66 || code == 67) return @"冻雨";
    // 71,73,75: 雪
    if (code >= 71 && code <= 75) return @"雪";
    // 77: 雪粒
    if (code == 77) return @"雪粒";
    // 80,81,82: 阵雨
    if (code >= 80 && code <= 82) return @"阵雨";
    // 85,86: 阵雪
    if (code == 85 || code == 86) return @"阵雪";
    // 95,96,99: 雷暴
    if (code >= 95 && code <= 99) return @"雷暴";
    return @"未知天气";
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
