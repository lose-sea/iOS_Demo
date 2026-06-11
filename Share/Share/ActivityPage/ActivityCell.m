//
//  ActivityCell.m
//  Share
//
//  Created by lose_sea on 2026/5/28.
//

#import "ActivityCell.h"

@implementation ActivityCell
- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setIView];
        [self setLabel];
        [self setStateView];
    }
    return self;
}

- (void) setIView {
    self.iView = [[UIImageView alloc] init];
    [self.contentView addSubview: self.iView];
    [self.iView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 0, 40, 0));
    }];
    self.iView.contentMode = UIViewContentModeScaleAspectFill;
    self.iView.clipsToBounds = YES;
}


- (void) setLabel {
    self.label = [[UILabel alloc] init];
    self.label.textColor = [UIColor labelColor]; 
    [self.contentView addSubview: self.label];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView.mas_bottom).offset(-40);
            make.left.right.mas_equalTo(self.contentView);
            make.bottom.mas_equalTo(self.contentView).offset(-20);
    }];
    self.label.backgroundColor = [UIColor systemBackgroundColor];
}

- (void) setStateView {
    self.stateView = [[UIImageView alloc] init];
    [self.contentView addSubview: self.stateView];
    [self.stateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.contentView.mas_right).offset(-50);
        make.right.mas_equalTo(self.contentView).offset(-10);
        make.height.mas_equalTo(50);
    }];
    if (self.activity.isEnd == YES) {
        UIImage* image = [UIImage imageNamed: @"end.png"];
        self.stateView.image = image;
    } else if (self.activity.isEnd == NO) {
        UIImage* image = [UIImage imageNamed: @"start.png"];
        self.stateView.image = image;
    }
}

- (void) configWithActivity:(Activity *)activity {
    self.iView.image = activity.image;
    self.label.text = activity.massage;
    self.label.textColor = [UIColor labelColor];
    if (self.activity.isEnd == YES) {
        UIImage* image = [UIImage imageNamed: @"end.png"];
        self.stateView.image = image;
    } else if (self.activity.isEnd == NO) {
        UIImage* image = [UIImage imageNamed: @"start.png"];
        self.stateView.image = image;
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
