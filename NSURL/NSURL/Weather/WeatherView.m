//
//  WeatherView.m
//  NSURL
//
//  Created by lose_sea on 2026/7/15.
//

#import "WeatherView.h"

@implementation WeatherView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
        [self setupConstraints];
    }
    return self;
}

- (void)setupSubviews {
    // 城市标签
    self.cityLabel = [[UILabel alloc] init];
    self.cityLabel.font = [UIFont boldSystemFontOfSize:28];
    self.cityLabel.textColor = [UIColor whiteColor];
    self.cityLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.cityLabel];

    // 天气图标（可先用系统图标占位，后续可替换为网络图片）
    self.weatherImageView = [[UIImageView alloc] init];
    self.weatherImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.weatherImageView.image = [UIImage systemImageNamed:@"cloud.sun.fill"]; // 默认图标
    self.weatherImageView.tintColor = [UIColor whiteColor];
    [self addSubview:self.weatherImageView];

    // 温度标签
    self.tempLabel = [[UILabel alloc] init];
    self.tempLabel.font = [UIFont systemFontOfSize:48 weight:UIFontWeightThin];
    self.tempLabel.textColor = [UIColor whiteColor];
    self.tempLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.tempLabel];

    // 天气状况描述
    self.weatherLabel = [[UILabel alloc] init];
    self.weatherLabel.font = [UIFont systemFontOfSize:20];
    self.weatherLabel.textColor = [UIColor whiteColor];
    self.weatherLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.weatherLabel];

    // 最高/最低温度
    self.maxMinLabel = [[UILabel alloc] init];
    self.maxMinLabel.font = [UIFont systemFontOfSize:18];
    self.maxMinLabel.textColor = [UIColor whiteColor];
    self.maxMinLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.maxMinLabel];

    // 设置背景色（可改成渐变色或自定义）
    self.backgroundColor = [UIColor systemBlueColor];
}

- (void)setupConstraints {
    // 城市标签：顶部留白，水平居中
    [self.cityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_safeAreaLayoutGuideTop).offset(40);
        make.centerX.equalTo(self);
        make.leading.greaterThanOrEqualTo(self).offset(20);
        make.trailing.lessThanOrEqualTo(self).offset(-20);
    }];

    // 天气图标：位于城市标签下方，大小适中
    [self.weatherImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cityLabel.mas_bottom).offset(30);
        make.centerX.equalTo(self);
        make.width.height.mas_equalTo(80);
    }];

    // 温度标签：在图标下方
    [self.tempLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.weatherImageView.mas_bottom).offset(20);
        make.centerX.equalTo(self);
    }];

    // 天气状况描述：温度下方
    [self.weatherLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tempLabel.mas_bottom).offset(10);
        make.centerX.equalTo(self);
    }];

    // 最高/最低温度：天气描述下方
    [self.maxMinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.weatherLabel.mas_bottom).offset(10);
        make.centerX.equalTo(self);
        make.bottom.lessThanOrEqualTo(self.mas_safeAreaLayoutGuideBottom).offset(-40);
    }];
}

// 可选：提供更新数据的方法，便于 Controller 调用
- (void)updateWithModel:(WeatherModel *)model {
    self.cityLabel.text = model.cityName ?: @"未知城市";
    self.tempLabel.text = [NSString stringWithFormat:@"%.1f°", model.temperature];
    self.weatherLabel.text = model.weatherDescription ?: @"--";
    self.maxMinLabel.text = [NSString stringWithFormat:@"最高 %.1f°  最低 %.1f°", model.maxTemp, model.minTemp];
    
    // 根据天气代码更换图标（示例，后续可替换为自定义图片）
    NSString *symbolName = @"cloud.sun.fill"; // 默认
    switch (model.weatherCode) {
        case 0: symbolName = @"sun.max.fill"; break;
        case 1: case 2: case 3: symbolName = @"cloud.fill"; break;
        case 45: case 48: symbolName = @"cloud.fog.fill"; break;
        case 61: case 63: case 65: symbolName = @"cloud.rain.fill"; break;
        case 71: case 73: case 75: symbolName = @"cloud.snow.fill"; break;
        case 95: case 96: case 99: symbolName = @"cloud.bolt.fill"; break;
        default: break;
    }
    self.weatherImageView.image = [UIImage systemImageNamed:symbolName];
    self.weatherImageView.tintColor = [UIColor whiteColor];
}

@end
