//
//  DrawerView.m
//  Music
//
//  Created by lose_sea on 2026/6/14.
//

#import "DrawerView.h"

@implementation DrawerView
- (instancetype) init {
    self = [super init];
    if (self) {
        [self setUpInterface];
    }
    return self;
}

- (void) setUpInterface {
    self.backView = [[UIView alloc] init];
    self.backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent: 0.3];
    [self addSubview: self.backView];
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end



