//
//  WeatherView.h
//  NSURL
//
//  Created by lose_sea on 2026/7/15.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>
#import "WeatherModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WeatherView : UIView
@property(nonatomic,strong)UILabel *cityLabel;

@property(nonatomic,strong)UILabel *tempLabel;

@property(nonatomic,strong)UILabel *weatherLabel;

@property(nonatomic,strong)UILabel *maxMinLabel;

@property(nonatomic,strong)UIImageView *weatherImageView;

- (void)updateWithModel:(WeatherModel *)model; 
@end

NS_ASSUME_NONNULL_END
