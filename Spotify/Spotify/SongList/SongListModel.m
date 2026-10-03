//
//  SongList.m
//  Spotify
//
//  Created by lose_sea on 2026/9/21.
//

#import "SongListModel.h"

@implementation SongListModel

- (instancetype) init {
    self = [super init];
    if (self) {

    }
    return self;
}

#pragma mark - YYModel

// 歌单/专辑字段 → 本地属性（网易云接口字段）
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"playlistId"   : @"id",
             @"playlistName" : @"name",
             // 歌单封面叫 coverImgUrl，电台/专辑分别叫 picUrl / blurPicUrl，都兜底
             @"coverURL"     : @[@"coverImgUrl", @"picUrl", @"blurPicUrl"],
             // 歌单里的歌曲列表叫 tracks
             @"songs"        : @"tracks"};
}

// 数组里元素的类型
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"songs" : Song.class};
}

/// 歌单 / 电台 / 专辑封面同样可能被 ATS 拦掉，统一升级成 https
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    self.coverURL = [Song secureURL:self.coverURL];
    return YES;
}

@end
