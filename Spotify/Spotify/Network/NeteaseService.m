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

#pragma mark - ⚠️ 开放平台控制台里的三个值（内置客户端属于演示级做法，正式产品应由后端持有密钥签名）

static NSString * const kNeteaseAppID = @"";
static NSString * const kNeteaseAppSecret = @"";
static NSString * const kNeteasePrivateKey = @"";   // RSA 私钥，用于签名

#pragma mark - 接口

// 文档：http://openapi.music.163.com/openapi/music/basic/song/list/get/v2
static NSString * const kNeteaseBaseURL = @"https://openapi.music.163.com";
static NSString * const kSongListPath = @"/openapi/music/basic/song/list/get/v2";

static NSString * const kErrorDomain = @"com.spotify.netease.error";

@interface NeteaseService ()

/// accessToken：按文档的授权接口换取后填进来（TODO: 实现刷新逻辑）
@property (nonatomic, copy, nullable) NSString *accessToken;

@end

@implementation NeteaseService

+ (instancetype)sharedInstance {
    static NeteaseService *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

#pragma mark - 批量获取歌曲信息

- (void)fetchSongsWithIds:(NSArray<NSString *> *)songIds
              qualityFlag:(BOOL)qualityFlag
               completion:(void (^)(NSArray<Song *> *, NSError *))completion {
    if (songIds.count == 0) {
        if (completion) completion(@[], [self errorWithCode:1001 message:@"songIdList 为空"]);
        return;
    }
    if (songIds.count > 500) {
        NSLog(@"[Netease] 单次最多 500 个 id，超出部分会被截断");
        songIds = [songIds subarrayWithRange:NSMakeRange(0, 500)];
    }

    NSDictionary *bizContent = @{@"qualityFlag": @(qualityFlag),
                                 @"songIdList": songIds};
    NSDictionary *parameters = [self commonParametersWithBizContent:bizContent];
    NSString *urlString = [NSString stringWithFormat:@"%@%@", kNeteaseBaseURL, kSongListPath];

    [[NetworkManager sharedInstance] GETWithURLString:urlString
                                          parameters:parameters
                                             success:^(id responseObject) {
        NSError *apiError = [self errorFromResponse:responseObject];
        if (apiError) {
            NSLog(@"[Netease] 接口返回错误：code=%ld %@", (long)apiError.code, apiError.localizedDescription);
            if (completion) completion(@[], apiError);
            return;
        }

        NSArray *data = [responseObject objectForKey:@"data"];
        NSMutableArray<Song *> *songs = [NSMutableArray array];
        for (NSDictionary *dict in data) {
            Song *song = [self songFromDictionary:dict];
            if (song) [songs addObject:song];
        }
        NSLog(@"[Netease] 拿到 %lu 首歌曲信息", (unsigned long)songs.count);
        if (completion) completion([songs copy], nil);
    }
                                             failure:^(NSError *error) {
        if (completion) completion(@[], error);
    }];
}

#pragma mark - TODO 等文档补齐

- (void)searchSongsWithKeyword:(NSString *)keyword
                         limit:(NSInteger)limit
                    completion:(void (^)(NSArray<Song *> *, NSError *))completion {
    // TODO: 需要「搜索歌曲」那页文档（路径 + bizContent 参数）
    if (completion) {
        completion(@[], [self errorWithCode:-1 message:@"搜索接口尚未接入（缺文档）"]);
    }
}

- (void)fetchSongURLWithId:(NSString *)songId
                completion:(void (^)(NSString *, NSError *))completion {
    // TODO: 需要「歌曲播放地址」那页文档（文档里明确说 song/list/get 拿不到播放地址）
    if (completion) {
        completion(nil, [self errorWithCode:-1 message:@"播放地址接口尚未接入（缺文档）"]);
    }
}

- (void)fetchPlaylistDetailWithId:(NSString *)playlistId
                       completion:(void (^)(SongListModel *, NSError *))completion {
    if (completion) {
        completion(nil, [self errorWithCode:-1 message:@"歌单详情接口尚未接入（缺文档）"]);
    }
}

- (void)fetchLyricWithId:(NSString *)songId
              completion:(void (^)(NSString *, NSError *))completion {
    if (completion) {
        completion(nil, [self errorWithCode:-1 message:@"歌词接口尚未接入（缺文档）"]);
    }
}

#pragma mark - 公共参数

/// IOT 公共参数：appId / appSecret / accessToken / signType / device / timestamp / bizContent（+ sign）
- (NSDictionary *)commonParametersWithBizContent:(NSDictionary *)bizContent {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"appId"] = kNeteaseAppID;
    parameters[@"appSecret"] = kNeteaseAppSecret;
    parameters[@"accessToken"] = self.accessToken ?: @"";
    parameters[@"signType"] = @"RSA_SHA256";
    parameters[@"timestamp"] = [self currentTimestampString];
    parameters[@"device"] = [self deviceJSONString];
    parameters[@"bizContent"] = [self jsonStringFromObject:bizContent];

    NSString *sign = [self signWithParameters:parameters];
    if (sign.length > 0) {
        parameters[@"sign"] = sign;
    }
    return [parameters copy];
}

- (NSString *)currentTimestampString {
    NSTimeInterval milliseconds = [[NSDate date] timeIntervalSince1970] * 1000.0;
    return [NSString stringWithFormat:@"%.0f", milliseconds];
}

/// device 参数：{"deviceType":"iOS","os":"iOS","appVer":"0.1","channel":"...","model":"...","deviceId":"...","brand":"Apple","osVer":"..."}
- (NSString *)deviceJSONString {
    NSDictionary *device = @{
        @"deviceType": @"iOS",
        @"os": @"iOS",
        @"appVer": @"0.1",
        @"channel": @"spotify-clone",
        @"model": [[UIDevice currentDevice] model],
        @"deviceId": [[[UIDevice currentDevice] identifierForVendor] UUIDString] ?: @"",
        @"brand": @"Apple",
        @"osVer": [[UIDevice currentDevice] systemVersion]
    };
    return [self jsonStringFromObject:device] ?: @"";
}

- (nullable NSString *)jsonStringFromObject:(id)object {
    if (!object) return nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:object options:0 error:nil];
    if (!data) return nil;
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

#pragma mark - 签名（TODO）

// TODO: 需要「IOT 公共参数 / 签名规则」那页文档才能写：
//   1. 哪些参数参与签名、按什么顺序拼接
//   2. 用 PrivateKey 做 RSA-SHA256（PKCS1？）后 Base64
//   3. accessToken 的换取与刷新接口
- (NSString *)signWithParameters:(NSDictionary *)parameters {
    NSLog(@"[Netease] 签名未实现，请求会缺少 sign 参数（需要签名规则文档）");
    return @"";
}

#pragma mark - 解析

/// 歌手是 artists 数组、专辑是嵌套对象，所以手工映射（YYModel 不好处理 duration/1000 这种换算）
- (nullable Song *)songFromDictionary:(NSDictionary *)dict {
    if (![dict isKindOfClass:NSDictionary.class]) return nil;

    NSString *songId = [dict objectForKey:@"id"];
    NSString *name = [dict objectForKey:@"name"];
    if (songId.length == 0 || name.length == 0) return nil;

    Song *song = [[Song alloc] init];
    song.songId = songId;
    song.songName = name;
    song.coverURL = [dict objectForKey:@"coverImgUrl"];

    // 文档里的 duration 单位是毫秒
    NSNumber *duration = [dict objectForKey:@"duration"];
    song.duration = duration ? ([duration doubleValue] / 1000.0) : 0;

    // 版权 / 付费信息：播放前要用
    song.canPlay = [[dict objectForKey:@"playFlag"] boolValue];
    song.needVip = [[dict objectForKey:@"vipPlayFlag"] boolValue];
    song.supportTrail = [[dict objectForKey:@"freeTrailFlag"] boolValue];

    NSDictionary *artist = [[dict objectForKey:@"artists"] firstObject];
    if ([artist isKindOfClass:NSDictionary.class]) {
        Singer *singer = [[Singer alloc] init];
        singer.singerId = [artist objectForKey:@"id"];
        singer.singerName = [artist objectForKey:@"name"];
        song.singer = singer;
    }

    return song;
}

/// {"code":200,"subCode":"200"} 才算成功；404 通常是 id 里有下架歌曲
- (nullable NSError *)errorFromResponse:(id)responseObject {
    if (![responseObject isKindOfClass:NSDictionary.class]) return nil;

    NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
    if (code == 200) return nil;

    NSString *message = [responseObject objectForKey:@"message"] ?: @"网易云接口返回错误";
    NSString *subCode = [responseObject objectForKey:@"subCode"];
    if (subCode.length > 0) {
        message = [NSString stringWithFormat:@"%@（subCode=%@）", message, subCode];
    }
    return [self errorWithCode:code message:message];
}

- (NSError *)errorWithCode:(NSInteger)code message:(NSString *)message {
    return [NSError errorWithDomain:kErrorDomain
                              code:code
                          userInfo:@{NSLocalizedDescriptionKey: message}];
}

@end
