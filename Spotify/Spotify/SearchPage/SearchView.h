//
//  SearchView.h
//  Spotify
//
//  Created by lose_sea on 2026/9/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SearchView : UIView

/// 搜索页内容列表（搜索记录 / 猜你喜欢 / 排行榜）
@property (nonatomic, strong, readonly) UITableView *tableView;

@end

NS_ASSUME_NONNULL_END
