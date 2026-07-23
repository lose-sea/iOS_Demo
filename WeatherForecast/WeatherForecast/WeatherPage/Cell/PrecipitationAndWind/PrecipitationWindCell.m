//
//  PrecipicationCell.m
//  WeatherForecast
//
//  Created by lose_sea on 2026/7/23.
//

#import "PrecipitationWindCell.h"

@interface PrecipitationWindCell ()
@property (nonatomic, strong) UIView* precipitationView;
@property (nonatomic, strong) UIView* windView; 
@end

@implementation PrecipitationWindCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpInterface];
    }
    return self; 
}

- (void) setUpInterface {
    self.backgroundColor = [UIColor clearColor];
    
    self.precipitationView = [[UIView alloc] init];
    [self.contentView addSubview: self.precipitationView];
    [self.precipitationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.centerX.mas_equalTo(self.contentView).offset(-100);
        make.width.height.mas_equalTo(180);
    }];
    self.precipitationView.backgroundColor = [UIColor colorWithWhite:0.4 alpha:0.3];
    self.precipitationView.clipsToBounds = YES;
    self.precipitationView.layer.cornerRadius = 20;
    
    UILabel* precipicationTag = [[UILabel alloc] init];
    [self.precipitationView addSubview: precipicationTag];
    [precipicationTag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.precipitationView).offset(40);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(20);
    }];
    precipicationTag.text = @"降水";
    precipicationTag.font = [UIFont systemFontOfSize: 14];
    precipicationTag.textColor = [[UIColor labelColor] colorWithAlphaComponent: 0.7];
    //    precipicationTag.backgroundColor = [UIColor systemRedColor];
    
    
    
    self.windView = [[UIView alloc] init];
    [self.contentView addSubview: self.windView];
    [self.windView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.centerX.mas_equalTo(self.contentView).offset(100);
        make.width.height.mas_equalTo(180);
    }];
    self.windView.backgroundColor = [UIColor colorWithWhite:0.4 alpha:0.3];
    self.windView.clipsToBounds = YES;
    self.windView.layer.cornerRadius = 20;
    
    UILabel* windTag = [[UILabel alloc] init];
    [self.windView addSubview: windTag];
    [windTag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.windView).offset(40);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(20);
    }];
    windTag.text = @"风速";
    windTag.font = [UIFont systemFontOfSize: 14];
    windTag.textColor = [[UIColor labelColor] colorWithAlphaComponent: 0.7];
    
    self.precipitationLabel = [[UILabel alloc] init];
    [self.precipitationView addSubview: self.precipitationLabel];
    [self.precipitationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(precipicationTag.mas_bottom).offset(10);
        make.left.mas_equalTo(self.precipitationView).offset(20);
        make.right.mas_equalTo(self.precipitationView);
        make.height.mas_equalTo(60);
    }];
//    self.precipicationLabel.backgroundColor = [UIColor systemRedColor];
    self.precipitationLabel.font = [UIFont systemFontOfSize: 30];
    self.precipitationLabel.text = @"0  毫米";
    
    
    UILabel* todayLabel = [[UILabel alloc] init];
    [self.precipitationView addSubview: todayLabel];
    [todayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.precipitationLabel.mas_bottom);
        make.left.mas_equalTo(self.precipitationLabel);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(30);
    }];
//    todayLabel.backgroundColor = [UIColor systemRedColor];
    todayLabel.font = [UIFont systemFontOfSize: 24];
    todayLabel.text = @"今天";
    
    self.windDirectionLabel = [[UILabel alloc] init];
    [self.windView addSubview: self.windDirectionLabel];
    [self.windDirectionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(windTag.mas_bottom).offset(10);
        make.left.mas_equalTo(self.windView).offset(20);
        make.right.mas_equalTo(self.windView);
        make.height.mas_equalTo(80);
    }];
    self.windDirectionLabel.font = [UIFont systemFontOfSize: 36];
    self.windDirectionLabel.text = @"北风";
    
    
    self.windSpeedLabel = [[UILabel alloc] init];
    [self.windView addSubview: self.windSpeedLabel];
    [self.windSpeedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.windDirectionLabel.mas_bottom);
        make.left.mas_equalTo(self.windDirectionLabel);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(30);
    }];
    self.windSpeedLabel.font = [UIFont systemFontOfSize: 24];
    self.windSpeedLabel.text = @"0.9 km/h";
}

- (void) configWithCurrentWeather: (NSDictionary*) currentWeather {
    CGFloat precipication = [currentWeather[@"precipitation"] doubleValue];
    self.precipitationLabel.text = [NSString stringWithFormat: @"%.1f 毫米", precipication];
    
    CGFloat windSpeed = [currentWeather[@"wind_speed_10m"] doubleValue];
    self.windSpeedLabel.text = [NSString stringWithFormat: @"%.1f km.h", windSpeed]; 
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
