//
//  SongList.h
//  Spotify
//
//  Created by lose_sea on 2026/9/21.
//

#import <Foundation/Foundation.h>
#import "Song.h"
NS_ASSUME_NONNULL_BEGIN

@interface SongListModel : NSObject
@property (nonatomic, copy) NSString *playlistName;
/// 封面地址：网络 URL 或本地资源名
@property (nonatomic, copy) NSString *coverURL;
@property (nonatomic, strong) NSArray<Song *> *songs;
@end

NS_ASSUME_NONNULL_END
