//
//  TalkModel.m
//  Share
//
//  Created by lose_sea on 2026/6/3.
//

#import "TalkModel.h"

@implementation TalkModel
- (instancetype) init {
    self = [super init];
    if (self) {
        
        [self setUpMessages];
    }
    return self;
}

- (void) setUpMessages {
    self.messages = [[NSMutableArray alloc] init];
    
    [self.messages addObjectsFromArray: @[@"你好", @"谢谢", @"知道了", @"hello", @"我很喜欢你的作品", @"标准UITableViewCell的textLabel、detailTextLabel等可以设置颜色、对齐等基本属性，但不足以实现聊天气泡的左右对齐和不同背景色。用户可能以为通过标准cell就可以做"]];
}
@end
