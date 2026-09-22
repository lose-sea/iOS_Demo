//
//  HomeCard.h
//  Spotify
//
//  Created by lose_sea on 2026/9/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 首页卡片数据（一张封面 + 主标题 + 副标题）
@interface HomeCard : NSObject

/// 封面地址：网络 URL 或本地资源名（由 View 层用 sp_setImageWithSource: 决定怎么加载）
@property (nonatomic, copy) NSString *imageURL;
/// 主标题
@property (nonatomic, copy) NSString *title;
/// 副标题（歌手、描述等）
@property (nonatomic, copy) NSString *subtitle;
/// 卡片角标，如「电台」，可为空
@property (nonatomic, copy, nullable) NSString *badge;

@end

NS_ASSUME_NONNULL_END
