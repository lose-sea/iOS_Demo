//
//  PlayListCell.h
//  Music
//
//  Created by lose_sea on 2026/6/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PlayListCell : UITableViewCell
@property (nonatomic, strong) UIScrollView* scrollView;
@property (nonatomic, strong) UITableView* tableView;
@end

NS_ASSUME_NONNULL_END
