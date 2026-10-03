//
//  HomeModel.h
//  Spotify
//
//  Created by lose_sea on 2026/9/2.
//

#import <Foundation/Foundation.h>
#import "Song.h"
#import "HomeSection.h"
#import "SongListModel.h"
#import "Singer.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomeModel : NSObject

/// 占位数据，构造一批 Song 对象（内部 Singer* 也一并构造）
+ (NSArray<Song *> *)sampleSongs;

/// 首页各横向分区数据
+ (NSArray<HomeSection *> *)sampleSections;

/// 用网络歌曲构造「今日推荐」分区（每张卡片带上 song，点击即可播放）
+ (HomeSection *)todaySectionWithSongs:(NSArray<Song *> *)songs;

/// 用官方榜单构造快捷入口分区（左图右文小卡）
+ (HomeSection *)shortcutSectionWithPlaylists:(NSArray<SongListModel *> *)playlists;
/// 用热门歌手构造「你喜欢的艺人」
+ (HomeSection *)artistSectionWithSingers:(NSArray<Singer *> *)singers;
/// 用热门歌手构造「你最喜欢的艺人」（圆形头像）
+ (HomeSection *)circleSectionWithSingers:(NSArray<Singer *> *)singers;
/// 用热门电台构造「推荐电台」（电台没有歌曲列表，点进去按名字搜歌）
+ (HomeSection *)radioSectionWithRadios:(NSArray<SongListModel *> *)radios;
/// 用最新专辑构造「收录你喜爱歌曲的专辑」
+ (HomeSection *)albumSectionWithAlbums:(NSArray<SongListModel *> *)albums;

@end

NS_ASSUME_NONNULL_END
