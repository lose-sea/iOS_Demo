//
//  MenuView.m
//  Spotify
//
//  Created by lose_sea on 2026/9/16.
//

#import "MenuView.h"

@implementation MenuView

- (instancetype) init {
    self = [super init];
    if (self) {
        [self setUpInterface]; 
    }
    return self;
}


- (void) setUpInterface {
    self.backgroundColor = [UIColor systemBackgroundColor]; 
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
@end
