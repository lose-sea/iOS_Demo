//
//  View.m
//  MVC
//
//  Created by lose_sea on 2026/8/4.
//

#import "View.h"

@interface View ()

@end

@implementation View


- (instancetype) init {
    self = [super init];
    if (self) {
        [self setUpInterface]; 
    }
    return self;
}

- (void) setUpInterface {
    self.label.translatesAutoresizingMaskIntoConstraints = NO;
    self.label = [[UILabel alloc] init];
    [self addSubview: self.label];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self).insets(UIEdgeInsetsMake(300, 50, 300, 50));
    }];
    self.label.text = @"练习MVC"; 
    self.label.backgroundColor = [UIColor systemCyanColor];
    
    self.button = [UIButton buttonWithType: UIButtonTypeSystem];
    [self addSubview: self.button];
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.label.mas_bottom).offset(100);
        make.left.width.height.mas_equalTo(self.label);
    }];
    self.button.backgroundColor = [UIColor systemRedColor]; 
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
