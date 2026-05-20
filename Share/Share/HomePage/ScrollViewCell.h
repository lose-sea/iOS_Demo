//
//  ScrollViewCell.h
//  Share
//
//  Created by lose_sea on 2026/5/20.
//

#import <UIKit/UIKit.h>
#import "HomepageModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ScrollViewCell : UITableViewCell
@property (nonatomic, strong) HomepageModel* homeModel; 
@property (nonatomic, strong) UIScrollView* scrollView;
@end

NS_ASSUME_NONNULL_END
