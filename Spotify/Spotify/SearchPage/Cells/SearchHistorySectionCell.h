//
//  SearchHistorySectionCell.h
//  Spotify
//
//  Created by lose_sea on 2026/9/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class SearchHistorySectionCell;

@protocol SearchHistorySectionCellDelegate <NSObject>

/// 点击了某个历史词
- (void)historySectionCell:(SearchHistorySectionCell *)cell didSelectWord:(NSString *)word;
/// 删除某个历史词
- (void)historySectionCell:(SearchHistorySectionCell *)cell didDeleteWordAtIndex:(NSInteger)index;

@end

/// 搜索记录：横向滑动的胶囊列表（省空间，一屏能放下好几条）
@interface SearchHistorySectionCell : UITableViewCell

@property (nonatomic, weak, nullable) id<SearchHistorySectionCellDelegate> delegate;

- (void)configureWithWords:(NSArray<NSString *> *)words;

+ (CGFloat)height;

@end

NS_ASSUME_NONNULL_END
