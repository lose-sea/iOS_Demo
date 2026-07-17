//
//  WeatherView.m
//  Weather_forecast
//
//  Created by lose_sea on 2026/7/16.
//

#import "WeatherView.h"

@implementation WeatherView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype) init{
    self = [super init];
    if (self) {
        [self setUpInterface];
    }
    return self;
}

- (void) setUpInterface {
//    self.backView = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"1.jpg"]];

//    [self addSubview: self.backView];
//    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(self);
//    }];
    
    self.tableView = [[UITableView alloc] init];
    [self addSubview: self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self);
        make.left.right.bottom.mas_equalTo(self);
    }];
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"3.jpg"]];
    self.tableView.backgroundColor = [UIColor clearColor]; 

    [self.tableView registerClass: [TemperatureCell class] forCellReuseIdentifier: @"TemperatureCellID"];
    
    self.backButton = [UIButton buttonWithType: UIButtonTypeSystem];
    [self addSubview: self.backButton];
    
    [self.backButton setImage:[UIImage systemImageNamed:@"chevron.left"] forState:UIControlStateNormal];

    self.backButton.backgroundColor = [UIColor colorWithWhite:1 alpha:0.3];
    
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(20);
        make.left.mas_equalTo(self).offset(20);
        make.width.height.mas_equalTo(40);
    }];
    self.backButton.layer.cornerRadius = 20;
    self.backButton.clipsToBounds = YES;
    
    
    self.addButton = [UIButton buttonWithType: UIButtonTypeSystem];
    [self addSubview: self.addButton];
    
    [self.addButton setImage:[UIImage systemImageNamed:@"plus"] forState:UIControlStateNormal];

    self.addButton.backgroundColor = [UIColor colorWithWhite:1 alpha:0.3];
    
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(20);
        make.right.mas_equalTo(self).offset(-20);
        make.width.height.mas_equalTo(40);
    }];
    self.addButton.layer.cornerRadius = 20;
    self.addButton.clipsToBounds = YES;
    
    
 
//    UILabel* label = [[UILabel alloc] init];
//    [self addSubview: label];
//    [label mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self).offset(50);
//        make.left.right.bottom.mas_equalTo(self);
//    }];
//    label.text = @"西安市长安区 \n 最高 37°C 最低 25°C";
//    label.numberOfLines = 0;
//    label.textAlignment = NSTextAlignmentCenter;
}

@end
