//
//  UserModel.m
//  Share
//
//  Created by lose_sea on 2026/5/17.
//

#import "UserModel.h"

@implementation UserModel
static UserModel* instance;
+ (instancetype) shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[super allocWithZone: nil] init];
        instance.account = nil;
        instance.password = nil;
    });
    return instance;
}

+ (instancetype) allocWithZone: (struct _NSZone*) zone {
    return [self shareInstance];
}

- (id) copyWithZone: (NSZone*) zone {
    return self;
}

- (id) mutableCopyWithZone: (NSZone*) zone {
    return self;
}
@end
