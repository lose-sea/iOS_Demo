//
//  UpLoadView.m
//  Share
//
//  Created by lose_sea on 2026/5/26.
//

#import "UpLoadView.h"

@implementation UpLoadView
- (instancetype) init {
    self = [super init];
    if (self) {
        [self setInterface]; 
    }
    return self;
}

- (void) setInterface {
    [self setCoverView];
    [self setLocationView];
    [self setTagTableView];
}

- (void) setCoverView {
    self.coverViewButton = [UIButton buttonWithType: UIButtonTypeCustom];
    self.coverViewButton.titleLabel.font = [UIFont systemFontOfSize: 24];
    [self.coverViewButton setTitle: @"选择照片" forState: UIControlStateNormal];
    [self.coverViewButton setTitleColor: [UIColor blackColor] forState: UIControlStateNormal];
    self.coverViewButton.backgroundColor = [UIColor systemGrayColor];
    [self addSubview: self.coverViewButton];
    [self.coverViewButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(20);
            make.width.mas_equalTo(220);
            make.height.mas_equalTo(160);
    }];
}

- (void) setLocationView {
    self.locationView = [[UIImageView alloc] init];
    [self addSubview: self.locationView];
    [self.locationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.coverViewButton.mas_top).offset(10);
        make.left.mas_equalTo(self.coverViewButton.mas_right).offset(10);
        make.width.mas_equalTo(140);
        make.height.mas_equalTo(30);
    }];
    UIImageView* iView = [[UIImageView alloc] initWithImage: [UIImage systemImageNamed: @"location.fill"]];
    [self.locationView addSubview: iView];
    [iView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.locationView).offset(5);
        make.top.mas_equalTo(self.locationView).offset(5);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(20);
    }];
    UILabel* label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor systemCyanColor];
    label.font = [UIFont systemFontOfSize: 15];
    label.text = @"陕西省,西安市";
    label.textColor = [UIColor whiteColor];
    [self.locationView addSubview: label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.locationView).offset(5);
            make.left.mas_equalTo(self.locationView).offset(30);
            make.width.mas_equalTo(100);
            make.height.mas_equalTo(20);
    }];
}

- (void) setTagTableView {
    self.tagTableView = [[UITableView alloc] init];
    [self addSubview: self.tagTableView];
    [self.tagTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.coverViewButton.mas_right).offset(20);
        make.top.mas_equalTo(self.locationView.mas_bottom).offset(10);
        make.width.mas_equalTo(130);
        make.height.mas_equalTo(110);
    }];
//    self.tagTableView.backgroundColor = [UIColor systemRedColor]; 
    [self.tagTableView registerClass: [UITableViewCell class] forCellReuseIdentifier: @"tagTableViewCellID"];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
