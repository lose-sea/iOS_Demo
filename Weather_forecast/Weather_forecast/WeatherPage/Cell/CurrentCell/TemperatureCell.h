//
//  TemperatureCell.h
//  Weather_forecast
//
//  Created by lose_sea on 2026/7/17.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h> 
NS_ASSUME_NONNULL_BEGIN

@interface TemperatureCell : UITableViewCell
@property (nonatomic, strong) UILabel* nameLabel;
@property (nonatomic, strong) UILabel* temperatureLabel;
@property (nonatomic, strong) UILabel* maxLabel;
@property (nonatomic, strong) UILabel* minLabel; 
@property (nonatomic, strong) UILabel* weatherLabel;

- (void) configWithCurrentWeather: (NSDictionary*) currentWeather dailyWeather: (NSDictionary*) dailyWeather; 
@end

NS_ASSUME_NONNULL_END
