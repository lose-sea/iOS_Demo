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
        self.messagesOfMe = [[NSMutableArray alloc] init];
        self.messageOfOther = [[NSMutableArray alloc] init]; 
    }
    return self;
}

@end
