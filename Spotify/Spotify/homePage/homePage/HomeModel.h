//
//  HomeModel.h
//  Spotify
//
//  Created by lose_sea on 2026/9/2.
//

#import <Foundation/Foundation.h>
#import "Song.h"
#import "HomeSection.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomeModel : NSObject

/// 占位数据，构造一批 Song 对象（内部 Singer* 也一并构造）
+ (NSArray<Song *> *)sampleSongs;

/// 首页各横向分区数据
+ (NSArray<HomeSection *> *)sampleSections;

/// 用网络歌曲构造「今日推荐」分区（每张卡片带上 song，点击即可播放）
+ (HomeSection *)todaySectionWithSongs:(NSArray<Song *> *)songs;

@end

NS_ASSUME_NONNULL_END
