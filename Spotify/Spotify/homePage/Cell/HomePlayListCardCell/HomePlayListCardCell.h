//
//  HomePlayListCardCell.h
//  Spotify
//
//  Created by lose_sea on 2026/9/21.
//

#import <UIKit/UIKit.h>

@class HomeCard;

NS_ASSUME_NONNULL_BEGIN

/// 方形封面 + 标题 + 描述，两行文字（今日推荐 / 专辑）
@interface HomePlayListCardCell : UICollectionViewCell

/// 卡片固定尺寸（宽 150）
+ (CGSize)cardSize;

- (void)configureWithCard:(HomeCard *)card;

@end

NS_ASSUME_NONNULL_END
