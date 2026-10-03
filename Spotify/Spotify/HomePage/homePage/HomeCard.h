//
//  HomeCard.h
//  Spotify
//
//  Created by lose_sea on 2026/9/22.
//

#import <Foundation/Foundation.h>

@class Song;

NS_ASSUME_NONNULL_BEGIN

/// 卡片的数据来源：决定点进去之后怎么取歌曲
typedef NS_ENUM(NSUInteger, HomeCardSource) {
    /// 纯展示，没有可播放内容
    HomeCardSourceNone = 0,
    /// 已带 song，直接播（今日推荐）
    HomeCardSourceSong,
    /// 歌单 / 榜单 → /playlist/detail?id=
    HomeCardSourcePlaylist,
    /// 艺人 → /artists?id= 取热门歌曲
    HomeCardSourceArtist,
    /// 专辑 → /album?id= 取专辑歌曲
    HomeCardSourceAlbum,
    /// 关键字搜索（电台这类没有歌曲列表的对象，用卡片标题搜）
    HomeCardSourceKeyword
};

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

/// 卡片对应的歌曲：网络数据才有，本地占位卡片为 nil。
/// 有值时点卡片会用它所在的分区歌曲当播放列表，并直接播放这首歌
@property (nonatomic, strong, nullable) Song *song;

/// 歌曲来源类型
@property (nonatomic, assign) HomeCardSource source;
/// 对应 source 的 id（歌单 / 艺人 / 专辑 id）；HomeCardSourceKeyword 用 title 当关键字，这里为 nil
@property (nonatomic, copy, nullable) NSString *sourceId;

@end

NS_ASSUME_NONNULL_END
