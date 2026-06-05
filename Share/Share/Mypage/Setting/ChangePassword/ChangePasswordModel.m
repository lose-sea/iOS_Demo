//
//  ChangePasswordModel.m
//  Share
//
//  Created by lose_sea on 2026/6/5.
//

#import "ChangePasswordModel.h"

@implementation ChangePasswordModel
- (instancetype) init {
    self = [super init];
    if (self) {
        self.tags = [[NSMutableArray alloc] init];
        self.user = [[UserModel alloc] init];

    }
    return self;
}
@end
