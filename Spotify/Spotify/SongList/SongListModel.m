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

// 歌单/专辑字段 → 本地属性
// 歌单/专辑字段映射，网易云接口确认后补齐（如 name / picUrl / coverImgUrl）
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"playlistId"   : @"id",
             @"playlistName" : @"name"};
}

// 数组里元素的类型
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"songs" : Song.class};
}

@end
