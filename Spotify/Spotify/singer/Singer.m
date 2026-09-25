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

// 歌手字段映射，网易云接口确认后补齐
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"singerId"   : @"id",
             @"singerName" : @"name"};
}

// 数组里元素的类型
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"songs" : Song.class};
}

@end
