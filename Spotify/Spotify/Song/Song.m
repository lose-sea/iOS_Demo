//
//  Song.m
//  Spotify
//
//  Created by lose_sea on 2026/9/18.
//

#import "Song.h"
#import "Singer.h"

@implementation Song

- (instancetype)init {
    self = [super init];
    if (self) {

    }
    return self;
}

- (instancetype)initWithCoverURL:(NSString *)coverURL name:(NSString *)songName singer:(Singer *)singer {
    return [self initWithCoverURL:coverURL name:songName singer:singer audioURL:nil];
}

- (instancetype)initWithCoverURL:(NSString *)coverURL name:(NSString *)songName singer:(Singer *)singer audioURL:(NSString *)audioURL {
    self = [super init];
    if (self) {
        self.coverURL = coverURL;
        self.songName = songName;
        self.singer = singer;
        self.audioURL = audioURL;
    }
    return self;
}

#pragma mark - YYModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"songId"   : @"id",
        @"songName" : @"name",
        // 封面在专辑对象里：搜索接口叫 album.picUrl，详情接口叫 al.picUrl，都兜底
        @"coverURL" : @[@"al.picUrl", @"album.picUrl", @"album.blurPicUrl"],
    };
}

/// mapper 只能改 key，改不了值/类型，这些留给 transform 处理
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    // 网易图床部分接口下发 http 链接，会被 ATS 直接拦掉（Info.plist 没放行 music.126.net）；
    // 网易 CDN 同一地址支持 https，统一升级，封面才显示得出来
    self.coverURL = [Song secureURL:self.coverURL];

    // id 在网易云是数字，属性是字符串，强制转一下
    if (self.songId.length == 0) {
        id rawId = dic[@"id"];
        if (rawId) {
            self.songId = [rawId isKindOfClass:NSNumber.class] ? [rawId stringValue] : [rawId description];
        }
    }

    // 歌手：接口给的是数组（ar / artists），这里只取第一个
    NSArray *artists = dic[@"artists"] ?: dic[@"ar"];
    if ([artists isKindOfClass:NSArray.class] && artists.count > 0) {
        NSDictionary *a = artists.firstObject;
        if ([a isKindOfClass:NSDictionary.class]) {
            Singer *s = [[Singer alloc] init];
            id aid = a[@"id"];
            s.singerId = aid ? ([aid isKindOfClass:NSNumber.class] ? [aid stringValue] : [aid description]) : nil;
            s.singerName = a[@"name"];
            self.singer = s;
        }
    }

    // 时长：毫秒 → 秒
    NSNumber *duration = dic[@"dt"] ?: dic[@"duration"];
    if (duration) {
        self.duration = [duration doubleValue] / 1000.0;
    }

    // 付费 / 试听：fee —— 0 免费, 1 付费/VIP, 4 已购数字专辑, -1 下架不可播
    NSNumber *fee = dic[@"fee"] ?: dic[@"privilege.fee"];
    if (fee) {
        NSInteger f = [fee integerValue];
        self.canPlay     = (f != -1);
        self.needVip     = (f == 1 || f == 4);
        self.supportTrail = (f == 1);
    }

    return YES;
}

#pragma mark - 工具

+ (NSString *)secureURL:(NSString *)url {
    if ([url hasPrefix:@"http://"]) {
        return [@"https://" stringByAppendingString:[url substringFromIndex:@"http://".length]];
    }
    return url;
}

#pragma mark - Demo

+ (NSString *)demoAudioURLAtIndex:(NSUInteger)index {
    NSUInteger number = (index % 12) + 1;
    return [NSString stringWithFormat:@"https://www.soundhelix.com/examples/mp3/SoundHelix-Song-%lu.mp3", (unsigned long)number];
}

@end
