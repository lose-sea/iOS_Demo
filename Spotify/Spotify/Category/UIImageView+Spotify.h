//
//  UIImageView+Spotify.h
//  Spotify
//
//  Created by lose_sea on 2026/9/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImageView (Spotify)

/// 统一图片加载入口：source 以 http 开头走 SDWebImage，否则当本地资源名
/// @param source 网络 URL 或本地资源名
/// @param placeholderName 占位图资源名，可为空
- (void)sp_setImageWithSource:(nullable NSString *)source
                  placeholder:(nullable NSString *)placeholderName;

@end

NS_ASSUME_NONNULL_END
