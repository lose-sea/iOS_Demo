//
//  SearchRankSectionCell.h
//  Spotify
//
//  Created by lose_sea on 2026/9/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class SearchRankSectionCell;
@class SearchRankCard;

@protocol SearchRankSectionCellDelegate <NSObject>

/// 点击榜单里的某个词（由控制器发起搜索）
- (void)rankSectionCell:(SearchRankSectionCell *)cell didSelectWord:(NSString *)word;

@end

/// 「排行榜」：标题 + 横向滑动的榜单卡片
@interface SearchRankSectionCell : UITableViewCell

@property (nonatomic, weak, nullable) id<SearchRankSectionCellDelegate> delegate;

- (void)configureWithCards:(NSArray<SearchRankCard *> *)cards;

/// 固定行高
+ (CGFloat)height;

@end

NS_ASSUME_NONNULL_END
