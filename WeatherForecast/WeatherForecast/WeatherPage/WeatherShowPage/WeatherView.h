//
//  WeatherView.h
//  Weather_forecast
//
//  Created by lose_sea on 2026/7/16.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>
#import "TemperatureCell.h"
#import "ScrollHourCell.h"
#import "DailyCell.h"
#import "WeatherTool.h"
NS_ASSUME_NONNULL_BEGIN

@interface WeatherView : UIView
@property (nonatomic, strong) UITableView* tableView;


- (void) configWithCurrentWeather: (NSDictionary*) currentWeather; 
@end

NS_ASSUME_NONNULL_END
