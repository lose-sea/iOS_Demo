//
//  HomePlayListCardCell.h
//  Spotify
//
//  Created by lose_sea on 2026/9/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 方形封面 + 歌单名 + 描述，两行文字
@interface HomePlayListCardCell : UICollectionViewCell

+ (CGSize)cardSize;
/// dict: image(图片名) / title(歌单名) / desc(描述)
- (void)configureWithData:(NSDictionary *)data;

@end

NS_ASSUME_NONNULL_END
