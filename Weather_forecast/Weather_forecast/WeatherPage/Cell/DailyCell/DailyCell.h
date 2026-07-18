//
//  DailyCell.h
//  Weather_forecast
//
//  Created by lose_sea on 2026/7/18.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>
NS_ASSUME_NONNULL_BEGIN

@interface DailyCell : UITableViewCell
@property (nonatomic, strong) UIView* backView; 

@property (nonatomic, strong) UILabel* timeLabel;
@property (nonatomic, strong) UIImageView* weatherView;
@property (nonatomic, strong) UILabel* weatherLabel; 
@property (nonatomic, strong) UILabel* minLabel;
@property (nonatomic, strong) UILabel* maxLabel;

@property (nonatomic, strong) UIProgressView* progressView; 

- (void)configWithDailyWeather:(NSDictionary *)dailyWeather atIndex:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
