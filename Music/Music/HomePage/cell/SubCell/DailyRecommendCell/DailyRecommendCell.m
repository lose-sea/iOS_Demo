//
//  PlayListCell.m
//  Music
//
//  Created by lose_sea on 2026/6/11.
//

#import "DailyRecommendCell.h"

@implementation DailyRecommendCell

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
        make.edges.mas_equalTo(self.contentView);
    }];
    
    self.tagLabel = [[UILabel alloc] init];
    self.messageLabel = [[UILabel alloc] init];
    
    [self.contentView addSubview: self.tagLabel];
    [self.tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(self.contentView);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(30);
    }];
    self.tagLabel.backgroundColor = [[UIColor labelColor] colorWithAlphaComponent: 0.1];
    self.tagLabel.textColor = [UIColor systemBackgroundColor];
    self.tagLabel.clipsToBounds = YES;
    self.tagLabel.layer.cornerRadius = 5;
    self.tagLabel.text = @"每日推荐";


    [self.contentView addSubview: self.messageLabel];
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_equalTo(self.contentView);
        make.height.mas_equalTo(30);
    }];
    self.messageLabel.backgroundColor = [[UIColor labelColor] colorWithAlphaComponent: 0.1];
    self.messageLabel.textColor = [UIColor systemBackgroundColor];
    
    self.messageLabel.numberOfLines = 0;
    self.messageLabel.adjustsFontSizeToFitWidth = YES;   // 允许字体自动缩小以适应宽度
//    label.minimumScaleFactor = 0.5;          // 最小可缩小到原字体的 0.5 倍（即最大缩小一半）
//    label.numberOfLines = 1;                 // 单行时效果最明显
}

- (void)configWitSongList:(SongList *)songList {
    self.iView.image = songList.coverImage;
    self.messageLabel.text = songList.name; 
}



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
@end
