//
//  Singer.m
//  Spotify
//
//  Created by lose_sea on 2026/9/18.
//

#import "Singer.h"
#import "Song.h"

@implementation Singer
- (instancetype) init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (instancetype) initWithSingerName: (NSString*) name {
    self = [self init];
    if (self) {
        self.singerName = name;
    }
    return self; 
}

#pragma mark - YYModel

// 歌手字段映射（网易云接口字段）
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"singerId"   : @"id",
             @"singerName" : @"name",
             // 头像：搜索接口给 img1v1Url，详情接口可能给 picUrl，都兜底
             @"avatarURL"  : @[@"img1v1Url", @"picUrl"]};
}

// 数组里元素的类型
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"songs" : Song.class};
}

/// 歌手头像同样可能被 ATS 拦掉，统一升级成 https
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    self.avatarURL = [Song secureURL:self.avatarURL];
    return YES;
}

@end
