//
//  MessageSettingModel.m
//  Share
//
//  Created by lose_sea on 2026/6/8.
//

#import "MessageSettingModel.h"

@implementation MessageSettingModel
- (instancetype) init {
    self = [super init];
    if (self) {
        self.tags = [[NSMutableArray alloc] init];
    }
    return self;
}
@end
