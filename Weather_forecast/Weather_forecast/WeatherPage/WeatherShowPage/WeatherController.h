//
//  WeatherController.h
//  Weather_forecast
//
//  Created by lose_sea on 2026/7/16.
//

#import <UIKit/UIKit.h>
#import "WeatherView.h"
#import "WeatherModel.h"
#import "TemperatureCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface WeatherController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) WeatherModel* weatherModel;
@property (nonatomic, strong) WeatherView* weatherView;
@property (nonatomic, strong) NSString* cityName;

@property (nonatomic, assign) CGFloat latitude;
@property (nonatomic, assign) CGFloat longitude;
@end

NS_ASSUME_NONNULL_END
