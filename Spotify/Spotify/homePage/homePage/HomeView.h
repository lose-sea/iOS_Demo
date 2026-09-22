//
//  HomeView.h
//  Spotify
//
//  Created by lose_sea on 2026/9/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeView : UIView

/// 首页列表：一行一个横向滑动分区
@property (nonatomic, strong, readonly) UITableView *tableView;

@end

NS_ASSUME_NONNULL_END
