//
//  Message.m
//  Share
//
//  Created by lose_sea on 2026/6/8.
//

#import "Message.h"

@implementation Message
- (instancetype) initWithName:(NSString *)name {
    self = [super init];
    if (self) {
        self.name = name;
        self.isSelected = NO;
    }
    return self;
}
@end
