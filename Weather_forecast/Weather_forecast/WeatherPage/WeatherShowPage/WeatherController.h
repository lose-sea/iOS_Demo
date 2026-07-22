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
#import "LoadView.h"
#import "HomeController.h"
#import "CityModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface WeatherController : UIViewController <UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) WeatherModel* weatherModel;
@property (nonatomic, strong) WeatherView* weatherView;
@property (nonatomic, strong) NSString* cityName;

@property (nonatomic, assign) CGFloat latitude;
@property (nonatomic, assign) CGFloat longitude;

@property (nonatomic, assign) NSInteger index;

- (void) setUpData;

- (void) configWithDict: (NSDictionary*) dict; 
@end

NS_ASSUME_NONNULL_END
