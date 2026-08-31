//
//  View.m
//  WCDB test
//
//  Created by lose_sea on 2026/8/8.
//

#import "View.h"

@interface View ()
@property (nonatomic, strong) UIButton* button;
@end

@implementation View
- (instancetype) init {
    self = [super init];
    if (self) {
        
    }
    return self;
}


- (void) setUpInterface {
    self.button = [UIButton buttonWithType: UIButtonTypeSystem];
    [self addSubview: self.button];
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.width.height.mas_equalTo(50);
    }];
    
    
    
}

@end
