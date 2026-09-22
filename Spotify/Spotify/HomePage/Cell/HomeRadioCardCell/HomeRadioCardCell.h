//
//  HomeRadioCardCell.h
//  Spotify
//
//  Created by lose_sea on 2026/9/22.
//

#import <UIKit/UIKit.h>

@class HomeCard;

NS_ASSUME_NONNULL_BEGIN

/// 彩色封面 + 「电台」角标 + 标题（推荐电台）
@interface HomeRadioCardCell : UICollectionViewCell

+ (CGSize)cardSize;

- (void)configureWithCard:(HomeCard *)card;

@end

NS_ASSUME_NONNULL_END
