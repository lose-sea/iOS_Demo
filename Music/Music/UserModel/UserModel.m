//
//  UserModel.m
//  Music
//
//  Created by lose_sea on 2026/6/11.
//

#import "UserModel.h"

@implementation UserModel
static UserModel* instance = nil;
+ (instancetype) shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[super allocWithZone: nil] init];
        instance.avatar = [UIImage imageNamed: @"51.jpg"];
        instance.nickName = @"缘起.执迷";
        
        instance.songImage = [UIImage imageNamed: @"46.jpg"];
        instance.songName = @"这世界有那么多人";
        instance.singerName = @"筷子兄弟";
        instance.isPlay = NO;
    });
    return instance;
}

+ (instancetype) allocWithZone: (struct _NSZone*) zone {
    return [self shareInstance];
}

- (id) initWithZone: (NSZone*) zone {
    return self;
}

- (id) copyWithZone: (NSZone*) zone {
    return self;
}

- (id) mutableCopyWithZone: (NSZone*) zone {
    return self;
}

@end
