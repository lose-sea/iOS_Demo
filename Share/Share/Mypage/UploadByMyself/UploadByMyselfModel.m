//
//  UploadByMyselfModel.m
//  Share
//
//  Created by lose_sea on 2026/5/31.
//

#import "UploadByMyselfModel.h"

@implementation UploadByMyselfModel
- (instancetype) init {
    self = [super init];
    if (self) {
        self.articlesOfTime = [[NSMutableArray alloc] init];
        self.articlesOfRecommend = [[NSMutableArray alloc] init];
        self.articlesOfShare = [[NSMutableArray alloc] init];
    }
    return self;
}


@end
