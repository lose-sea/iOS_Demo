//
//  ImageShowModel.m
//  Share
//
//  Created by lose_sea on 2026/5/26.
//

#import "ImageShowModel.h"

@implementation ImageShowModel
- (instancetype) init {
    self = [super init];
    if (self) {
        self.images = [[NSMutableArray alloc] init];
    }
    return self;
}
@end
