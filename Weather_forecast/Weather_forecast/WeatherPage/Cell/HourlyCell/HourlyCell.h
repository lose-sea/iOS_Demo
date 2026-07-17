//
//  HourlyCell.h
//  Weather_forecast
//
//  Created by lose_sea on 2026/7/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HourlyCell : UICollectionViewCell

@property (nonatomic, strong) UILabel* hourLabel;
@property (nonatomic, strong) UIImageView* weatherView;
@property (nonatomic, strong) UILabel* hourWeatherLabel; 

@end

NS_ASSUME_NONNULL_END
