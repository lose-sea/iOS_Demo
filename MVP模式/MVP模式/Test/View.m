//
//  View.m
//  MVC
//
//  Created by lose_sea on 2026/8/4.
//

#import "View.h"

@interface View ()
@property (nonatomic, strong) UILabel* label;
@property (nonatomic, strong) UIButton* button;
@property (nonatomic, strong) UIActivityIndicatorView* loadingIndicator;
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
        make.left.width.mas_equalTo(self.label);
        make.height.mas_equalTo(40); 
    }];
    self.button.backgroundColor = [UIColor systemRedColor];
    
    self.loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleLarge];
    self.loadingIndicator.hidesWhenStopped = YES;
    [self addSubview: self.loadingIndicator];
    
    [self.loadingIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
    }];
    
    
}


- (void) setButtonTarget:(id)target action:(SEL)action {
    [self.button addTarget: target action: action forControlEvents: UIControlEventTouchUpInside];
}



- (void) displayText:(NSString *)text {
    self.label.text = text;
}

- (void) showLoading {
    [self.loadingIndicator startAnimating];
    self.button.enabled = NO;
}

- (void) hideLoading {
    [self.loadingIndicator stopAnimating];
    self.button.enabled = YES;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
