//
//  SaveCell.h
//  Weather_forecast
//
//  Created by lose_sea on 2026/7/18.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>
#import "WeatherTool.h"

NS_ASSUME_NONNULL_BEGIN

@interface SaveCell : UITableViewCell
@property (nonatomic, strong) UIImageView* backView; 
@property (nonatomic, strong) UILabel* cityLabel;
@property (nonatomic, strong) UILabel* weatherLabel;
@property (nonatomic, strong) UILabel* temperatureLabel;
@property (nonatomic, strong) UILabel* maxLabel;
@property (nonatomic, strong) UILabel* minLabel;

- (void) configWithName: (NSString*) name dict: (NSDictionary*) dict;


@end

NS_ASSUME_NONNULL_END
