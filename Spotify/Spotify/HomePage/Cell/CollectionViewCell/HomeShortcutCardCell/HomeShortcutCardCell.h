//
//  HomeShortcutCardCell.h
//  Spotify
//
//  Created by lose_sea on 2026/9/22.
//

#import <UIKit/UIKit.h>

@class HomeCard;

NS_ASSUME_NONNULL_BEGIN

/// 顶部快捷入口：左图右文小卡，一屏放两张
@interface HomeShortcutCardCell : UICollectionViewCell

+ (CGSize)cardSize;

- (void)configureWithCard:(HomeCard *)card;

@end

NS_ASSUME_NONNULL_END
