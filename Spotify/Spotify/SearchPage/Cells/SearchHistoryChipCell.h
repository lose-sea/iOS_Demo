//
//  SearchHistoryChipCell.h
//  Spotify
//
//  Created by lose_sea on 2026/9/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 横向搜索记录里的一个胶囊：词 + 删除按钮
@interface SearchHistoryChipCell : UICollectionViewCell

@property (nonatomic, copy) NSString *word;

/// 点击胶囊上的 ✕
@property (nonatomic, copy, nullable) void (^onDelete)(void);

/// 根据文字算胶囊宽度（+ 删除按钮的留白）
+ (CGFloat)widthForWord:(NSString *)word;

@end

NS_ASSUME_NONNULL_END
