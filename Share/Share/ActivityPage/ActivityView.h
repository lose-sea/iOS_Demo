//
//  ActivityView.h
//  Share
//
//  Created by lose_sea on 2026/5/28.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>
#import "ActivityCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface ActivityView : UIView <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView* tableViwe;
@end

NS_ASSUME_NONNULL_END
