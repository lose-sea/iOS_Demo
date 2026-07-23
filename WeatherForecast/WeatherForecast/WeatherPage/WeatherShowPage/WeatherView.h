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
#import "PrecipitationWindCell.h"
#import "NoticeCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface WeatherView : UIView
@property (nonatomic, strong) UITableView* tableView;

@property (nonatomic, strong) UIButton* addButton;
@property (nonatomic, strong) UIButton* backButton;
@property (nonatomic, strong) UIButton* deleteButton; 

- (void) configWithCurrentWeather: (NSDictionary*) currentWeather; 
@end

NS_ASSUME_NONNULL_END
