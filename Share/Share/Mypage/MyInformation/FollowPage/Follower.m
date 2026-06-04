//
//  Follower.m
//  Share
//
//  Created by lose_sea on 2026/6/2.
//

#import "Follower.h"

@implementation Follower
- (instancetype) initWithAvatar:(UIImage *)avatar nickName:(NSString *)nickName {
    self = [super init];
    if (self) {
        self.avatar = avatar;
        self.nickName = nickName;
        self.massage = @"这个家伙很懒, 什么也没有留下"; 
        self.isFollow = NO;
    }
    return self;
}

- (instancetype) initWithUser:(UserModel *)user {
    self = [super init];
    if (self) {
        self.avatar = user.avatar;
        self.nickName = user.nickName;
        self.massage = user.massage;
        self.isFollow = NO;
    }
    return self;
}

@end
