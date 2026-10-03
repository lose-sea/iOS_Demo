//
//  NeteaseService.m
//  Spotify
//
//  Created by lose_sea on 2026/9/24.
//

#import "NeteaseService.h"
#import <UIKit/UIKit.h>
#import "NetworkManager.h"
#import "Song.h"
#import "Singer.h"
#import "SongListModel.h"
#import <YYModel/YYModel.h>

#pragma mark - 接口

/// 本地 Node 音乐服务（学长博客那套 NeteaseCloudMusicApi，默认占用 3000 端口）
/// 模拟器里 localhost 直连即可；真机需换成 Mac 的局域网 IP（如 http://192.168.x.x:3000）
static NSString * const kNeteaseBaseURL = @"http://localhost:3000";
static NSString * const kErrorDomain = @"com.spotify.netease.error";

@implementation NeteaseService

+ (instancetype)sharedInstance {
    static NeteaseService *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

#pragma mark - 搜索歌曲

- (void)searchSongsWithKeyword:(NSString *)keyword
                         limit:(NSInteger)limit
                    completion:(void (^)(NSArray<Song *> *, NSError * _Nullable))completion {
    if (keyword.length == 0) {
        if (completion) completion(@[], nil);
        return;
    }
    NSString *urlString = [NSString stringWithFormat:@"%@/search?keywords=%@&limit=%ld&offset=0",
                           kNeteaseBaseURL, [self URLEncoded:keyword], (long)limit];

    [[NetworkManager sharedInstance] GETWithURLString:urlString
                                          parameters:nil
                                             success:^(id responseObject) {
        NSArray *songs = [responseObject valueForKeyPath:@"result.songs"];
        if (![songs isKindOfClass:NSArray.class] || songs.count == 0) {
            if (completion) completion(@[], [self errorWithCode:404 message:@"未搜到结果"]);
            return;
        }
        // 搜索结果里专辑封面是空的（album 只有 picId），用 /song/detail 拿带封面的完整信息
        NSMutableArray<NSString *> *ids = [NSMutableArray array];
        for (NSDictionary *d in songs) {
            id rawId = d[@"id"];
            if (rawId) [ids addObject:[rawId isKindOfClass:NSNumber.class] ? [rawId stringValue] : [rawId description]];
        }
        [self fetchSongsWithIds:ids qualityFlag:NO completion:completion];
    }
                                             failure:^(NSError *error) {
        if (completion) completion(@[], error);
    }];
}

#pragma mark - 歌单详情（含歌曲列表）

- (void)fetchPlaylistDetailWithId:(NSString *)playlistId
                       completion:(void (^)(SongListModel * _Nullable, NSError * _Nullable))completion {
    if (playlistId.length == 0) {
        if (completion) completion(nil, [self errorWithCode:1001 message:@"playlistId 为空"]);
        return;
    }
    NSString *urlString = [NSString stringWithFormat:@"%@/playlist/detail?id=%@",
                           kNeteaseBaseURL, [self URLEncoded:playlistId]];

    [[NetworkManager sharedInstance] GETWithURLString:urlString
                                          parameters:nil
                                             success:^(id responseObject) {
        NSDictionary *playlist = [responseObject valueForKeyPath:@"playlist"];
        if ([playlist isKindOfClass:NSDictionary.class]) {
            SongListModel *model = [SongListModel yy_modelWithDictionary:playlist];
            if (completion) completion(model, nil);
        } else {
            if (completion) completion(nil, [self errorWithCode:404 message:@"歌单不存在"]);
        }
    }
                                             failure:^(NSError *error) {
        if (completion) completion(nil, error);
    }];
}

#pragma mark - 歌曲播放地址（有时效，建议播放前现取）

- (void)fetchSongURLWithId:(NSString *)songId
                completion:(void (^)(NSString * _Nullable, NSError * _Nullable))completion {
    if (songId.length == 0) {
        if (completion) completion(nil, [self errorWithCode:1001 message:@"songId 为空"]);
        return;
    }
    NSString *urlString = [NSString stringWithFormat:@"%@/song/url?id=%@",
                           kNeteaseBaseURL, [self URLEncoded:songId]];

    [[NetworkManager sharedInstance] GETWithURLString:urlString
                                          parameters:nil
                                             success:^(id responseObject) {
        NSArray *data = [responseObject valueForKeyPath:@"data"];
        NSString *url = nil;
        if ([data isKindOfClass:NSArray.class] && data.count > 0) {
            // 注意：JSON 里的 null 会被 AFNetworking 转成 NSNull，直接调 .length 会崩
            // （VIP / 已下架歌曲的 url 就是 null），必须先判断类型
            id raw = [data.firstObject valueForKey:@"url"];
            if ([raw isKindOfClass:NSString.class]) {
                // 音频地址同样是 http（m701/m801.music.126.net），ATS 会拦，统一升级成 https
                url = [Song secureURL:raw];
            }
        }
        if (url.length > 0) {
            if (completion) completion(url, nil);
        } else {
            if (completion) completion(nil, [self errorWithCode:404
                                                        message:@"该歌曲暂无可用播放地址（可能需 VIP 或已下架）"]);
        }
    }
                                             failure:^(NSError *error) {
        if (completion) completion(nil, error);
    }];
}

#pragma mark - 歌词

- (void)fetchLyricWithId:(NSString *)songId
              completion:(void (^)(NSString * _Nullable, NSError * _Nullable))completion {
    if (songId.length == 0) {
        if (completion) completion(nil, [self errorWithCode:1001 message:@"songId 为空"]);
        return;
    }
    NSString *urlString = [NSString stringWithFormat:@"%@/lyric?id=%@",
                           kNeteaseBaseURL, [self URLEncoded:songId]];

    [[NetworkManager sharedInstance] GETWithURLString:urlString
                                          parameters:nil
                                             success:^(id responseObject) {
        // 同上：null 会被转成 NSNull，先判类型再调 .length
        id raw = [responseObject valueForKeyPath:@"lrc.lyric"];
        NSString *lyric = [raw isKindOfClass:NSString.class] ? raw : nil;
        if (lyric.length > 0) {
            if (completion) completion(lyric, nil);
        } else {
            if (completion) completion(nil, [self errorWithCode:404 message:@"暂无歌词"]);
        }
    }
                                             failure:^(NSError *error) {
        if (completion) completion(nil, error);
    }];
}

#pragma mark - 批量歌曲详情（ID 列表 → 歌曲详情，不含播放地址）

- (void)fetchSongsWithIds:(NSArray<NSString *> *)songIds
              qualityFlag:(BOOL)qualityFlag
               completion:(void (^)(NSArray<Song *> *, NSError * _Nullable))completion {
    (void)qualityFlag;
    if (songIds.count == 0) {
        if (completion) completion(@[], [self errorWithCode:1001 message:@"songIdList 为空"]);
        return;
    }
    NSString *ids = [songIds componentsJoinedByString:@","];
    NSString *urlString = [NSString stringWithFormat:@"%@/song/detail?ids=%@",
                           kNeteaseBaseURL, [self URLEncoded:ids]];

    [[NetworkManager sharedInstance] GETWithURLString:urlString
                                          parameters:nil
                                             success:^(id responseObject) {
        NSArray *songs = [responseObject valueForKeyPath:@"songs"];
        if ([songs isKindOfClass:NSArray.class] && songs.count > 0) {
            NSArray<Song *> *list = [self songsFromArray:songs];
            if (completion) completion(list, nil);
        } else {
            if (completion) completion(@[], [self errorWithCode:404 message:@"未找到歌曲"]);
        }
    }
                                             failure:^(NSError *error) {
        if (completion) completion(@[], error);
    }];
}

#pragma mark - 首页分区

- (void)fetchToplistWithLimit:(NSInteger)limit
                   completion:(void (^)(NSArray<SongListModel *> *, NSError * _Nullable))completion {
    NSString *urlString = [NSString stringWithFormat:@"%@/toplist", kNeteaseBaseURL];
    [[NetworkManager sharedInstance] GETWithURLString:urlString
                                          parameters:nil
                                             success:^(id responseObject) {
        if (completion) completion([self playlistsFromArray:[responseObject valueForKeyPath:@"list"]
                                                     limit:limit], nil);
    }
                                             failure:^(NSError *error) {
        if (completion) completion(@[], error);
    }];
}

- (void)fetchTopArtistsWithLimit:(NSInteger)limit
                      completion:(void (^)(NSArray<Singer *> *, NSError * _Nullable))completion {
    NSString *urlString = [NSString stringWithFormat:@"%@/top/artists?limit=%ld",
                           kNeteaseBaseURL, (long)MAX(limit, 1)];
    [[NetworkManager sharedInstance] GETWithURLString:urlString
                                          parameters:nil
                                             success:^(id responseObject) {
        NSArray *artists = [responseObject valueForKeyPath:@"artists"];
        NSMutableArray<Singer *> *list = [NSMutableArray array];
        for (id item in artists) {
            if (![item isKindOfClass:NSDictionary.class]) continue;
            Singer *singer = [Singer yy_modelWithDictionary:item];
            if (singer.singerName.length > 0) [list addObject:singer];
            if ((NSInteger)list.count >= limit) break;
        }
        if (completion) completion([list copy], nil);
    }
                                             failure:^(NSError *error) {
        if (completion) completion(@[], error);
    }];
}

- (void)fetchHotRadiosWithLimit:(NSInteger)limit
                     completion:(void (^)(NSArray<SongListModel *> *, NSError * _Nullable))completion {
    NSString *urlString = [NSString stringWithFormat:@"%@/dj/hot?limit=%ld",
                           kNeteaseBaseURL, (long)MAX(limit, 1)];
    [[NetworkManager sharedInstance] GETWithURLString:urlString
                                          parameters:nil
                                             success:^(id responseObject) {
        NSArray<SongListModel *> *radios = [self playlistsFromArray:[responseObject valueForKeyPath:@"djRadios"]
                                                              limit:limit];
        // 副标题用分类 / 推荐语（rcmdtext 在接口里就是 desc）
        NSArray *raw = [responseObject valueForKeyPath:@"djRadios"];
        NSUInteger index = 0;
        for (SongListModel *radio in radios) {
            if (index >= raw.count) break;
            NSDictionary *d = raw[index];
            radio.subtitle = [d valueForKey:@"category"] ?: [d valueForKey:@"rcmdtext"];
            index++;
        }
        if (completion) completion(radios, nil);
    }
                                             failure:^(NSError *error) {
        if (completion) completion(@[], error);
    }];
}

- (void)fetchNewAlbumsWithLimit:(NSInteger)limit
                     completion:(void (^)(NSArray<SongListModel *> *, NSError * _Nullable))completion {
    NSString *urlString = [NSString stringWithFormat:@"%@/album/new?area=ALL&limit=%ld",
                           kNeteaseBaseURL, (long)MAX(limit, 1)];
    [[NetworkManager sharedInstance] GETWithURLString:urlString
                                          parameters:nil
                                             success:^(id responseObject) {
        NSArray<SongListModel *> *albums = [self playlistsFromArray:[responseObject valueForKeyPath:@"albums"]
                                                              limit:limit];
        // 副标题用专辑歌手名
        NSArray *raw = [responseObject valueForKeyPath:@"albums"];
        NSUInteger index = 0;
        for (SongListModel *album in albums) {
            if (index >= raw.count) break;
            NSArray *artists = [raw[index] valueForKey:@"artists"];
            album.subtitle = [artists.firstObject valueForKey:@"name"];
            index++;
        }
        if (completion) completion(albums, nil);
    }
                                             failure:^(NSError *error) {
        if (completion) completion(@[], error);
    }];
}

- (void)fetchArtistSongsWithId:(NSString *)artistId
                    completion:(void (^)(NSArray<Song *> *, NSError * _Nullable))completion {
    if (artistId.length == 0) {
        if (completion) completion(@[], [self errorWithCode:1001 message:@"artistId 为空"]);
        return;
    }
    NSString *urlString = [NSString stringWithFormat:@"%@/artists?id=%@",
                           kNeteaseBaseURL, [self URLEncoded:artistId]];
    [self fetchSongsFromURLString:urlString arrayKeyPath:@"hotSongs" completion:completion];
}

- (void)fetchAlbumSongsWithId:(NSString *)albumId
                   completion:(void (^)(NSArray<Song *> *, NSError * _Nullable))completion {
    if (albumId.length == 0) {
        if (completion) completion(@[], [self errorWithCode:1001 message:@"albumId 为空"]);
        return;
    }
    NSString *urlString = [NSString stringWithFormat:@"%@/album?id=%@",
                           kNeteaseBaseURL, [self URLEncoded:albumId]];
    [self fetchSongsFromURLString:urlString arrayKeyPath:@"songs" completion:completion];
}

#pragma mark - 工具

/// 把接口下发的歌曲字典数组转成 Song 模型数组（逐个用 YYModel 解析，跳过解析失败的）
- (NSArray<Song *> *)songsFromArray:(NSArray *)array {
    NSMutableArray<Song *> *list = [NSMutableArray array];
    for (id item in array) {
        if ([item isKindOfClass:NSDictionary.class]) {
            Song *song = [Song yy_modelWithDictionary:item];
            if (song) [list addObject:song];
        }
    }
    return [list copy];
}

/// 按 keyPath 取歌曲数组并解析（艺人 hotSongs / 专辑 songs 都走这里）
- (void)fetchSongsFromURLString:(NSString *)urlString
                  arrayKeyPath:(NSString *)keyPath
                    completion:(void (^)(NSArray<Song *> *, NSError * _Nullable))completion {
    [[NetworkManager sharedInstance] GETWithURLString:urlString
                                          parameters:nil
                                             success:^(id responseObject) {
        NSArray *raw = [responseObject valueForKeyPath:keyPath];
        if ([raw isKindOfClass:NSArray.class] && raw.count > 0) {
            if (completion) completion([self songsFromArray:raw], nil);
        } else {
            if (completion) completion(@[], [self errorWithCode:404 message:@"未找到歌曲"]);
        }
    }
                                             failure:^(NSError *error) {
        if (completion) completion(@[], error);
    }];
}

/// 榜单 / 电台 / 专辑这类「有 id+name+封面」的对象统一转成 SongListModel，最多取 limit 个
- (NSArray<SongListModel *> *)playlistsFromArray:(id)array limit:(NSInteger)limit {
    NSMutableArray<SongListModel *> *list = [NSMutableArray array];
    if (![array isKindOfClass:NSArray.class]) return @[];
    for (id item in array) {
        if (![item isKindOfClass:NSDictionary.class]) continue;
        SongListModel *model = [SongListModel yy_modelWithDictionary:item];
        if (model.playlistId.length > 0 && model.playlistName.length > 0) {
            [list addObject:model];
        }
        if ((NSInteger)list.count >= limit) break;
    }
    return [list copy];
}

- (NSString *)URLEncoded:(NSString *)string {
    if (!string) return @"";
    return [string stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]] ?: string;
}

- (NSError *)errorWithCode:(NSInteger)code message:(NSString *)message {
    return [NSError errorWithDomain:kErrorDomain
                              code:code
                          userInfo:@{NSLocalizedDescriptionKey: message}];
}

@end
