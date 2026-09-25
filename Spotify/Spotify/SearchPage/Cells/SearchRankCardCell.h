//
//  SearchRankCardCell.h
//  Spotify
//
//  Created by lose_sea on 2026/9/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - 数据模型

/// 榜单里的一行
@interface SearchRankItem : NSObject

@property (nonatomic, assign) NSInteger rank;      // 排名（1 开始）
@property (nonatomic, copy) NSString *title;       // 歌名 / 关键字
/// 角标文案，如「爆」「热」「↑」，可为空
@property (nonatomic, copy, nullable) NSString *tag;
/// YES：红底白字（爆/热）；NO：绿色文字（↑ 上升）
@property (nonatomic, assign) BOOL tagHighlighted;

@end

/// 一张榜单卡片（热搜榜 / 热歌榜）
@interface SearchRankCard : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSArray<SearchRankItem *> *items;

+ (instancetype)cardWithTitle:(NSString *)title items:(NSArray<SearchRankItem *> *)items;

@end

#pragma mark - 卡片 Cell

@interface SearchRankCardCell : UICollectionViewCell

/// 点击榜单里的某个词
@property (nonatomic, copy, nullable) void (^onSelectWord)(NSString *word);

- (void)configureWithCard:(SearchRankCard *)card;

/// 卡片固定高度（按最多显示 8 行算）
+ (CGFloat)cardHeight;

@end

NS_ASSUME_NONNULL_END
