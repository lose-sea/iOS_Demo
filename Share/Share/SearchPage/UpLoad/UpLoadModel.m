//
//  UpLoadModel.m
//  Share
//
//  Created by lose_sea on 2026/5/26.
//

#import "UpLoadModel.h"

@implementation UpLoadModel
- (instancetype) init {
    self = [super init];
    if (self) {
        self.tags = [[NSMutableArray alloc] init];
        self.categorys = [[NSMutableArray alloc] init];
        self.isFold = YES;
        self.agreeDownLoad = YES;
    }
    return self; 
}
@end
