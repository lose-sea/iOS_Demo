//
//  HourlyCell.h
//  Weather_forecast
//
//  Created by lose_sea on 2026/7/17.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>
#import "WeatherTool.h"

NS_ASSUME_NONNULL_BEGIN

@interface HourlyCell : UICollectionViewCell

@property (nonatomic, strong) UILabel* timeLabel;
@property (nonatomic, strong) UIImageView* weatherView;
@property (nonatomic, strong) UILabel* weatherLabel; 
@property (nonatomic, strong) UILabel* hourTemperatureLabel;

- (void) configWithHourlyWeather: (NSDictionary*) hourlyWeather withIndex: (NSInteger)item; 
@end

NS_ASSUME_NONNULL_END
