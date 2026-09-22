//
//  HomeCircleArtistCell.h
//  Spotify
//
//  Created by lose_sea on 2026/9/22.
//

#import <UIKit/UIKit.h>

@class HomeCard;

NS_ASSUME_NONNULL_BEGIN

/// 圆形头像 + 名字（你最喜欢的艺人）
@interface HomeCircleArtistCell : UICollectionViewCell

+ (CGSize)cardSize;

- (void)configureWithCard:(HomeCard *)card;

@end

NS_ASSUME_NONNULL_END
