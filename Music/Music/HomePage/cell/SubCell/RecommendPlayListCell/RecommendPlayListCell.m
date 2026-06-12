//
//  RecommendPlayListCell.m
//  Music
//
//  Created by lose_sea on 2026/6/12.
//

#import "RecommendPlayListCell.h"

@implementation RecommendPlayListCell
- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame: frame];
    if (self) {
        [self setUpInterface];
    }
    return self;
}

- (void) setUpInterface {
    self.iView = [[UIImageView alloc] init];
    [self.contentView addSubview: self.iView];
    [self.iView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView).offset(-40);
    }];
    self.iView.clipsToBounds = YES;
    self.iView.contentMode = UIViewContentModeScaleAspectFill;
    
    self.label = [[UILabel alloc] init];
    [self.contentView addSubview: self.label];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.iView.mas_bottom);
        make.left.right.bottom.mas_equalTo(self.contentView);
    }];
    
    
    self.playButton = [UIButton buttonWithType: UIButtonTypeCustom];
    [self.playButton setImage: [UIImage systemImageNamed: @"play.fill"] forState: UIControlStateNormal];
    [self.contentView addSubview: self.playButton];
    [self.playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.label.mas_top).offset(10);
        make.right.mas_equalTo(self.contentView);
        make.width.height.mas_equalTo(40);
    }];
    self.playButton.imageView.tintColor = [UIColor systemBackgroundColor];
    self.playButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    
    self.label.backgroundColor = [[UIColor labelColor] colorWithAlphaComponent: 0.1];
    self.label.textColor = [UIColor labelColor];
    self.label.backgroundColor = [UIColor systemBackgroundColor];
    
    self.label.numberOfLines = 0;
    self.label.adjustsFontSizeToFitWidth = YES;   // 允许字体自动缩小以适应宽度
//    label.minimumScaleFactor = 0.5;          // 最小可缩小到原字体的 0.5 倍（即最大缩小一半）
//    label.numberOfLines = 1;                 // 单行时效果最明显
}




- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
