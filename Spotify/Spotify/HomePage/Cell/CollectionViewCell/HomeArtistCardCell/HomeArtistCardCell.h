//
//  HomeArtistCardCell.h
//  Spotify
//
//  Created by lose_sea on 2026/9/22.
//

#import <UIKit/UIKit.h>

@class HomeCard;

NS_ASSUME_NONNULL_BEGIN

/// 封面 + 中间横幅名字 + 下方描述（你喜欢的艺人）
@interface HomeArtistCardCell : UICollectionViewCell

+ (CGSize)cardSize;

- (void)configureWithCard:(HomeCard *)card;

@end

NS_ASSUME_NONNULL_END
