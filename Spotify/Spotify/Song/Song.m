//
//  Song.m
//  Spotify
//
//  Created by lose_sea on 2026/9/18.
//

#import "Song.h"

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

// 接口字段 → 本地属性（YYModel 支持 keypath，如 al.picUrl）
+ (NSDictionary *)modelCustomPropertyMapper {
    // TODO: 按网易云接口的字段名补齐映射（YYModel 支持 keypath，如 @"al.picUrl"）
    return @{@"songId"   : @"id",
             @"songName" : @"name"};
}

#pragma mark - Demo

+ (NSString *)demoAudioURLAtIndex:(NSUInteger)index {
    NSUInteger number = (index % 12) + 1;
    return [NSString stringWithFormat:@"https://www.soundhelix.com/examples/mp3/SoundHelix-Song-%lu.mp3", (unsigned long)number];
}

@end
