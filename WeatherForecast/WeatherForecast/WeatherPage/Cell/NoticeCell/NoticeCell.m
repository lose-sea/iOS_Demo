//
//  NoticeCell.m
//  WeatherForecast
//
//  Created by lose_sea on 2026/7/23.
//

#import "NoticeCell.h"

@implementation NoticeCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpInterface];
    }
    return self;
}

- (void) setUpInterface {
    self.backgroundColor = [UIColor clearColor];
    UIView* backView = [[UIView alloc] init];
    [self.contentView addSubview: backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView).insets(UIEdgeInsetsMake(10, 15, 10, 15));
    }];
    backView.backgroundColor = [UIColor colorWithWhite:0.4 alpha:0.5];
    backView.clipsToBounds = YES;
    backView.layer.cornerRadius = 15;
    
    UIImageView* imageView = [[UIImageView alloc] initWithImage: [UIImage systemImageNamed: @"exclamationmark.bubble.fill"]];
    [backView addSubview: imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(backView).offset(10);
        make.left.mas_equalTo(backView).offset(10);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(50);
    }];
    imageView.tintColor = [UIColor colorWithWhite: 0.9 alpha: 0.5];
    
    UILabel* titleLabel = [[UILabel alloc] init];
    [backView addSubview: titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(backView).offset(10);
        make.left.mas_equalTo(imageView.mas_right).offset(10);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(15);
    }];
//    titleLabel.backgroundColor = [UIColor systemRedColor];
    titleLabel.text = @"报告问题";
    titleLabel.font = [UIFont boldSystemFontOfSize: 18];
    
    UILabel* label = [[UILabel alloc] init];
    [backView addSubview: label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(imageView.mas_right).offset(10);
        make.top.mas_equalTo(titleLabel.mas_bottom);
        make.bottom.mas_equalTo(backView).offset(-10);
        make.right.mas_equalTo(backView).offset(-25);
    }];
//    label.backgroundColor = [UIColor systemCyanColor];
    label.text = @"你可以描述所在位置的当前天气状况, 协助改进天气预报";
    label.font = [UIFont systemFontOfSize: 15];
    label.numberOfLines = 2;
    
    
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
