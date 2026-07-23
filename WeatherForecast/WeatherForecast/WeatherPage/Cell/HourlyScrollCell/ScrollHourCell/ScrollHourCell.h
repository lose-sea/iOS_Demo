//
//  ScrollHourCell.h
//  Weather_forecast
//
//  Created by lose_sea on 2026/7/17.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>
#import "HourlyCell.h"
#import "ScrollHourCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface ScrollHourCell : UITableViewCell
@property (nonatomic, strong) UICollectionView* collectionView;

@end

NS_ASSUME_NONNULL_END
