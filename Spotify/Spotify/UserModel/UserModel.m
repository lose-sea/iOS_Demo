//
//  UserModel.m
//  Spotify
//
//  Created by lose_sea on 2026/9/16.
//

#import "UserModel.h"

@implementation UserModel


+ (instancetype) shareInstance {
    static UserModel* instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[super alloc] init];
    });
    return instance;
}

- (instancetype)init {
    return self;
}






@end
