//
//  SearchGuessSectionCell.h
//  Spotify
//
//  Created by lose_sea on 2026/9/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class SearchGuessSectionCell;

@protocol SearchGuessSectionCellDelegate <NSObject>

/// 点击了一个热搜词
- (void)guessSectionCell:(SearchGuessSectionCell *)cell didSelectWord:(NSString *)word;

@end

/// 「猜你喜欢」：标题 + 刷新按钮 + 多列网格（默认 3 列，改 SearchGuessSectionCell.m 里的 kColumnCount）
@interface SearchGuessSectionCell : UITableViewCell

@property (nonatomic, weak, nullable) id<SearchGuessSectionCellDelegate> delegate;

- (void)configureWithWords:(NSArray<NSString *> *)words;

/// 行高（按词数量算）
+ (CGFloat)heightForWordCount:(NSUInteger)wordCount;

@end

NS_ASSUME_NONNULL_END
