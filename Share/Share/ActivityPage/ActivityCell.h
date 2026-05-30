//
//  ActivityCell.h
//  Share
//
//  Created by lose_sea on 2026/5/28.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>
#import "Activity.h"
NS_ASSUME_NONNULL_BEGIN

@interface ActivityCell : UITableViewCell
@property (nonatomic, strong) UIImageView* iView;
@property (nonatomic, strong) UILabel* label;
@property (nonatomic, strong) UIImageView* stateView; 
@property (nonatomic, strong) Activity* activity;

- (void) configWithActivity: (Activity*) activity;
@end

NS_ASSUME_NONNULL_END
