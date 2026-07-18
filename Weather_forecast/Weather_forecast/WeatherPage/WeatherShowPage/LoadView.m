//
//  LoadView.m
//  Weather_forecast
//
//  Created by lose_sea on 2026/7/18.
//

#import "LoadView.h"

@implementation LoadView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype) init {
    self = [super init];
    if (self) {
        [self setUpInterface];
    }
    return self;
}

- (void) setUpInterface {
    self.backgroundColor = [UIColor systemCyanColor]; 
    
    self.label = [[UILabel alloc] init];
    [self addSubview: self.label];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self).offset(-240);
        make.left.right.mas_equalTo(self);
        make.height.mas_equalTo(50);
    }];
    
    self.label.text = @"-- --";
    self.label.font = [UIFont systemFontOfSize: 40];
    self.label.textAlignment = NSTextAlignmentCenter;
}

@end
