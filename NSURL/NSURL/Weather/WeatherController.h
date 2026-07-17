//
//  WeatherController.h
//  NSURL
//
//  Created by lose_sea on 2026/7/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WeatherController : UIViewController

// 外部传入的城市信息
@property (nonatomic, copy) NSString *cityName;
@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;

@end

NS_ASSUME_NONNULL_END
