//
//  Information.m
//  Share
//
//  Created by lose_sea on 2026/6/1.
//

#import "Information.h"

@implementation Information
- (instancetype) initWithName:(NSString *)name count:(NSInteger)count {
    self = [super init];
    if (self) {
        self.name = name;
        self.count = count;
    }
    return self;
}
@end
