//
//  Activitiy.m
//  Share
//
//  Created by lose_sea on 2026/5/30.
//

#import "Activity.h"

@implementation Activity
- (instancetype) initWithImage:(UIImage *)image massage:(NSString *)massage {
    self.image = image;
    self.massage = massage;
    self.isEnd = YES; 
    return self;
}
@end
