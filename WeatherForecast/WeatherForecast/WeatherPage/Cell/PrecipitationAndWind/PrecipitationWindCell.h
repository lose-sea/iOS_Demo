//
//  PrecipicationCell.h
//  WeatherForecast
//
//  Created by lose_sea on 2026/7/23.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h> 
NS_ASSUME_NONNULL_BEGIN

@interface PrecipitationWindCell : UITableViewCell

@property (nonatomic, strong) UILabel* precipitationLabel;

@property (nonatomic, strong) UILabel* windDirectionLabel;
@property (nonatomic, strong) UILabel* windSpeedLabel; 

- (void) configWithCurrentWeather: (NSDictionary*) currentWeather;
@end

NS_ASSUME_NONNULL_END
