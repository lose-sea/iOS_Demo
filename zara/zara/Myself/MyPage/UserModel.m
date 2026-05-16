//
//  Model.m
//  zara
//
//  Created by lose_sea on 2026/5/14.
//

#import "UserModel.h"

@implementation UserModel
static UserModel* instance;
+ (instancetype) shareinstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[super allocWithZone: nil] init];
        [instance setupDefaultData];
    });
    return instance;
}



// 设置默认数据
- (void) setupDefaultData {
    instance.avatar = [UIImage imageNamed: @"1.jpg"];
    instance.NickName = @"在下雨";
    instance.account = @"xtzytpl0508nrnd";
    instance.signature = @"这个家伙很懒, 什么也没留下";
    instance.pictures = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < 40; i++) {
        NSString* imageName = [NSString stringWithFormat: @"%d", i + 1];
        UIImage* image = [UIImage imageNamed: imageName];
        [self.pictures addObject: image];
    }
    
}

+ (instancetype) allocWithZone: (struct _NSZone*) zone {
    return [self shareinstance];
}

- (id) copyWithZone: (NSZone*) zone {
    return self;
}

- (id) mutableCopy: (NSZone*) zone {
    return self; 
}

@end
