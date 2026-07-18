//
//  DailyCell.m
//  Weather_forecast
//
//  Created by lose_sea on 2026/7/18.
//

#import "DailyCell.h"

@implementation DailyCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUPInterface]; 
    }
    return self; 
}

- (void) setUPInterface {
    self.backgroundColor = [UIColor clearColor];
    
    UIView* backView = [[UIView alloc] init];
    [self.contentView addSubview: backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView).insets(UIEdgeInsetsMake(5, 10, 5, 10));
    }];
    backView.backgroundColor = [UIColor colorWithWhite:0.4 alpha:0.5];

    backView.clipsToBounds = YES;
    backView.layer.cornerRadius = 25;
    self.backView = backView;
    
    
    self.timeLabel = [[UILabel alloc] init];
    [self.contentView addSubview: self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.contentView).offset(20);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(30);
    }];
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
//    self.timeLabel.backgroundColor = [UIColor systemRedColor];
    
    self.weatherView = [[UIImageView alloc] init];
    [self.contentView addSubview: self.weatherView];
    [self.weatherView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.timeLabel.mas_right).offset(10);
        make.centerY.mas_equalTo(self.contentView);
        make.width.height.mas_equalTo(40);
    }];
//    self.weatherView.backgroundColor = [UIColor systemRedColor];
    
    self.minLabel = [[UILabel alloc] init];
    [self.contentView addSubview: self.minLabel];
    [self.minLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.weatherView.mas_right).offset(30);
        make.centerY.mas_equalTo(self.contentView);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(60);
    }];
    self.minLabel.textAlignment = NSTextAlignmentCenter;
//    self.minLabel.backgroundColor = [UIColor systemRedColor];
    
    self.maxLabel = [[UILabel alloc] init];
    [self.contentView addSubview: self.maxLabel];
    [self.maxLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.minLabel.mas_right).offset(100);
        make.centerY.mas_equalTo(self.contentView);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(60);
    }];
    self.maxLabel.textAlignment = NSTextAlignmentCenter;
//    self.maxLabel.backgroundColor = [UIColor systemRedColor];
    
    self.progressView = [[UIProgressView alloc] init];
    [self.contentView addSubview: self.progressView];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.minLabel.mas_right);
        make.right.mas_equalTo(self.maxLabel.mas_left);
        make.centerY.mas_equalTo(self.contentView);
        make.height.mas_equalTo(5);
    }];
    
    self.progressView.progressTintColor = [UIColor systemRedColor];
    self.progressView.trackTintColor = [UIColor systemGrayColor];
    
    self.progressView.progressViewStyle = UIProgressViewStyleDefault;
}


- (void)configWithDailyWeather:(NSDictionary *)dailyWeather atIndex:(NSInteger)index {
    NSString* timeStr = dailyWeather[@"time"][index];
    timeStr = [timeStr substringFromIndex: 5];
    if ([timeStr characterAtIndex: 0] == '0') {
        timeStr = [timeStr substringFromIndex: 1];
    }
    self.timeLabel.text = timeStr;
    
    NSInteger weather_code = [dailyWeather[@"weather_code"][index] intValue];
    self.weatherView.image = [self imageWithWeatherCode: weather_code];
    self.weatherView.tintColor = [UIColor labelColor];
    
    self.minLabel.text = [NSString stringWithFormat: @"%.0f°", [dailyWeather[@"temperature_2m_min"][index] doubleValue]];
    self.maxLabel.text = [NSString stringWithFormat: @"%.0f°", [dailyWeather[@"temperature_2m_max"][index] doubleValue]];
    
    self.progressView.progress = [dailyWeather[@"temperature_2m_max"][index] doubleValue] / 45;
}

- (UIImage*) imageWithWeatherCode: (NSInteger) weather_code {
    switch (weather_code) {
        case 0:
            return [UIImage systemImageNamed: @"sun.min.fill"];
        case 1:
        case 2:
        case 3:
            return [UIImage systemImageNamed: @"cloud.fill"];
        case 45:
        case 48:
            return [UIImage systemImageNamed: @"cloud.fog.fill"];
            
        case 51:
        case 52:
        case 53:
        case 54:
        case 55:
            return [UIImage systemImageNamed: @"cloud.sun.rain.fill"];

        case 56:
        case 57:
            return [UIImage systemImageNamed: @"cloud.sleet.fill"];

        case 61:
        case 62:
        case 63:
        case 64:
        case 65:
            return [UIImage systemImageNamed: @"cloud.heavyrain.fill"];

        case 66:
        case 67:
            return [UIImage systemImageNamed: @"cloud.sleet.fill"];

        case 71:
        case 72:
        case 73:
        case 74:
        case 75:
            return [UIImage systemImageNamed: @"cloud.snow.fill"];

        case 77:
            return [UIImage systemImageNamed: @"cloud.snow.fill"];

        case 80:
        case 81:
        case 82:
            return [UIImage systemImageNamed: @"cloud.bolt.rain"];

        case 85:
        case 86:
            return [UIImage systemImageNamed: @"cloud.snow.fill"];

        case 95:
        case 96:
        case 97:
        case 98:
        case 99:
            return [UIImage systemImageNamed: @"cloud.bolt.fill"];

        default:
            return [UIImage systemImageNamed: @"cloud.fog.fill"];

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
