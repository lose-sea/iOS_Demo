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
        instance.account = @"111";
        instance.password = @"111";
        
        instance.avatar = [UIImage imageNamed: @"53.jpg"];
        instance.gender = @"男";
        instance.nickName = @"share小张";
        instance.massage = @"计算机/网络爱好者";
        instance.signature = @"开心了就笑, 不开心了就过会再笑";
        instance.email = @"losesea4@gmail.com"; 
        
        instance.likeCount = 130;
        instance.saveCount = 39;
        instance.viewCount = 850;
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
