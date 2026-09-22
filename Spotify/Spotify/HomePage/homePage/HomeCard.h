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

/// 图片名（Assets / bundle 内资源）
@property (nonatomic, copy) NSString *imageName;
/// 主标题
@property (nonatomic, copy) NSString *title;
/// 副标题（歌手、描述等）
@property (nonatomic, copy) NSString *subtitle;
/// 卡片角标，如「电台」，可为空
@property (nonatomic, copy, nullable) NSString *badge;

@end

NS_ASSUME_NONNULL_END
