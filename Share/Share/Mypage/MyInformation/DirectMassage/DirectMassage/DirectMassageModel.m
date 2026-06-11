//
//  DirectMassageModel.m
//  Share
//
//  Created by lose_sea on 2026/6/2.
//

#import "DirectMassageModel.h"

@implementation DirectMassageModel
- (instancetype) init {
    self = [super init];
    if (self) {
        self.followers = [[NSMutableArray alloc] init]; 
    }
    return self;
}
@end
