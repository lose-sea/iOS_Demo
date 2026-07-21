//
//  SaveCell.m
//  Weather_forecast
//
//  Created by lose_sea on 2026/7/18.
//

#import "SaveCell.h"

@implementation SaveCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpInterface]; 
    }
    return self;
}
 

- (void) setUpInterface {
    self.backView = [[UIImageView alloc] init];
    self.cityLabel = [[UILabel alloc] init];
    self.weatherLabel = [[UILabel alloc] init];
    self.temperatureLabel = [[UILabel alloc] init];
    self.maxLabel = [[UILabel alloc] init];
    self.minLabel = [[UILabel alloc] init];
    
    self.backView = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"1.jpg"]];
    self.backView.clipsToBounds = YES;
    self.backView.layer.cornerRadius = 25;
    [self.contentView addSubview: self.backView];
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView).insets(UIEdgeInsetsMake(20, 0, 10, 10));
    }];
    self.backView.contentMode = UIViewContentModeScaleAspectFill;

    
    [self.backView addSubview: self.cityLabel];
    [self.cityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.backView).offset(10);
        make.left.mas_equalTo(self.backView).offset(15);
        make.width.mas_equalTo(270);
        make.height.mas_equalTo(40);
    }];
    self.cityLabel.text = @"西安 - 陕西省";
    self.cityLabel.font = [UIFont boldSystemFontOfSize: 26];
//    self.cityLabel.backgroundColor = [UIColor systemRedColor];
        
    self.temperatureLabel = [[UILabel alloc] init];
    [self.backView  addSubview: self.temperatureLabel];
    [self.temperatureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.cityLabel);
        make.left.mas_equalTo(self.cityLabel.mas_right).offset(10);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(60);
    }];
    self.temperatureLabel.text = @"37°";
    self.temperatureLabel.textAlignment = NSTextAlignmentCenter;
    self.temperatureLabel.font = [UIFont boldSystemFontOfSize: 35];
//    self.temperatureLabel.backgroundColor = [UIColor systemRedColor];
    
    self.weatherLabel = [[UILabel alloc] init];
    [self.backView addSubview: self.weatherLabel];
    [self.weatherLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.backView).offset(-10); 
        make.left.mas_equalTo(self.cityLabel);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(30);
    }];
    self.weatherLabel.text = @"晴";
    self.weatherLabel.font = [UIFont boldSystemFontOfSize: 22];
//    self.weatherLabel.backgroundColor = [UIColor systemRedColor];
    
    
    UILabel* maxLabel = [[UILabel alloc] init];
    [self.contentView addSubview: maxLabel];
    [maxLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.weatherLabel);
        make.left.mas_equalTo(self.weatherLabel.mas_right).offset(40);
        make.width.mas_equalTo(20);
    }];
    maxLabel.textAlignment = NSTextAlignmentCenter;
    maxLabel.numberOfLines = 2;
    maxLabel.text = @"最高";
    maxLabel.font = [UIFont boldSystemFontOfSize: 12];
//    maxLabel.backgroundColor = [UIColor systemRedColor];

    
    self.maxLabel = [[UILabel alloc] init];
    [self.contentView addSubview: self.maxLabel];
    [self.maxLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(maxLabel);
        make.left.mas_equalTo(maxLabel.mas_right);
//        make.height.mas_equalTo(60);
    }];
    self.maxLabel.textAlignment = NSTextAlignmentCenter;
    self.maxLabel.font = [UIFont systemFontOfSize: 20];
    self.maxLabel.text = @"37°";
//    self.maxLabel.backgroundColor = [UIColor systemCyanColor];

    
    
    UILabel* minLabel = [[UILabel alloc] init];
    [self.contentView addSubview: minLabel];
    [minLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.maxLabel);
        make.left.mas_equalTo(self.maxLabel.mas_right);
        make.width.mas_equalTo(20);
    }];
    minLabel.textAlignment = NSTextAlignmentCenter;
    minLabel.numberOfLines = 2;
    minLabel.text = @"最低";
    minLabel.font = [UIFont boldSystemFontOfSize: 12];
//    minLabel.backgroundColor = [UIColor systemRedColor];

    
    self.minLabel = [[UILabel alloc] init];
    [self.contentView addSubview: self.minLabel];
    [self.minLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(minLabel);
        make.left.mas_equalTo(minLabel.mas_right);
//        make.width.mas_equalTo(70);
//        make.height.mas_equalTo(60);
    }];
    self.minLabel.textAlignment = NSTextAlignmentCenter;
    self.minLabel.font = [UIFont systemFontOfSize: 20];
    self.minLabel.text = @"24°";
//    self.minLabel.backgroundColor = [UIColor systemCyanColor];
}


- (void) configWithName: (NSString*) name dict: (NSDictionary*) dict {
    NSDictionary* currentWeather = dict[@"current"];
    NSDictionary* dailyWeather = dict[@"daily"];
    
    [self configWithName: name CurrentWeather: currentWeather dailyWeather: dailyWeather];
}


- (void) configWithName: (NSString*) name CurrentWeather: (NSDictionary*) currentWeather dailyWeather:(NSDictionary*)dailyWeather{
    self.cityLabel.text = name;
    
    CGFloat temperature = [currentWeather[@"temperature_2m"] doubleValue];
    self.temperatureLabel.text = [NSString stringWithFormat: @"%.0f°", temperature];
    
    NSArray *maxTempArr = dailyWeather[@"temperature_2m_max"];
    NSNumber *maxNum = maxTempArr[0];
    CGFloat maxTemperature = [maxNum doubleValue];
    self.maxLabel.text = [NSString stringWithFormat: @"%.0f°", maxTemperature];
    
    NSArray *minTempArr = dailyWeather[@"temperature_2m_min"];
    NSNumber *minNum = minTempArr[0];
    CGFloat minTemperature = [minNum doubleValue];
    self.minLabel.text = [NSString stringWithFormat: @"%.0f°", minTemperature];

    NSInteger weather_code = [currentWeather[@"weather_code"] integerValue];
    self.weatherLabel.text = [WeatherTool descriptionForWeatherCode: weather_code];
    self.backView.image = [WeatherTool backImageForWeatherCode: weather_code];
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
