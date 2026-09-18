//
//  HomeModel.h
//  Spotify
//
//  Created by lose_sea on 2026/9/2.
//

#import <Foundation/Foundation.h>
#import "Song.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomeModel : NSObject

/// 占位数据，构造一批 Song 对象（内部 Singer* 也一并构造）
+ (NSArray<Song *> *)sampleSongs;

/// Section 0 横向歌单卡片数据（暂时用 NSDictionary 占位，后续再补 Playlist 模型）
+ (NSArray<NSDictionary *> *)samplePlaylistCards;

@end

NS_ASSUME_NONNULL_END
