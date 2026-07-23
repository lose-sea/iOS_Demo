//
//  CityPageViewController.h
//  Weather_forecast
//
//  Created by lose_sea on 2026/7/20.
//

#import <UIKit/UIKit.h>
#import "HomeController.h"
#import "WeatherController.h"
#import "CityModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface CityPageViewController : UIPageViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate>
@property (nonatomic, assign) NSInteger initialIndex;
@property (nonatomic, assign) NSInteger currentIndex;

@end

NS_ASSUME_NONNULL_END
