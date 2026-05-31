//
//  MyPageModel.m
//  Share
//
//  Created by lose_sea on 2026/5/30.
//

#import "MyPageModel.h"

@implementation MyPageModel
- (instancetype) init {
    self = [super init];
    if (self) {
        [self setData];
    }
    return self;
}

- (void) setData {
    self.avatar = [UIImage imageNamed: @"53.jpg"];
    self.nickName = @"share小张";
    self.massage = @"计算机/网络爱好者";
    self.signature = @"开心了就笑, 不开心了就过会再笑";
    self.likeCount = 130;
    self.saveCount = 39;
    self.viewCount = 850;
}
@end
