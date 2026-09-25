//
//  SearchHotWordCell.h
//  Spotify
//
//  Created by lose_sea on 2026/9/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 「猜你喜欢」网格里的一项：序号 + 热搜词（可换行，不截断）
@interface SearchHotWordCell : UICollectionViewCell

@property (nonatomic, assign) NSInteger rank;
@property (nonatomic, copy) NSString *word;

@end

NS_ASSUME_NONNULL_END
