//
//  SearchHotWordCell.m
//  Spotify
//
//  Created by lose_sea on 2026/9/24.
//

#import "SearchHotWordCell.h"
#import <Masonry/Masonry.h>

@implementation SearchHotWordCell

- (instancetype)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self setUpInterface];
    }
    return self;
}

- (void)setUpInterface {
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];

    UILabel *wordLabel = [[UILabel alloc] init];
    wordLabel.font = [UIFont systemFontOfSize:14.0];
    wordLabel.numberOfLines = 2;   // 多列时格子窄，允许换行避免截断
    wordLabel.lineBreakMode = NSLineBreakByCharWrapping;
    wordLabel.tag = 100;
    [self.contentView addSubview:wordLabel];

    [wordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.centerY.equalTo(self.contentView);
    }];
}

- (void)setWord:(NSString *)word {
    _word = word;
    [self refreshText];
}

- (void)setRank:(NSInteger)rank {
    _rank = rank;
    [self refreshText];
}

- (void)refreshText {
    UILabel *wordLabel = [self.contentView viewWithTag:100];
    if (!wordLabel) return;

    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] init];
    [text appendAttributedString:[[NSAttributedString alloc]
        initWithString:[NSString stringWithFormat:@"%ld ", (long)MAX(self.rank, 0)]
            attributes:@{NSFontAttributeName: [UIFont monospacedDigitSystemFontOfSize:14.0 weight:UIFontWeightBold],
                         NSForegroundColorAttributeName: (self.rank > 0 && self.rank <= 3
                                                          ? [UIColor systemRedColor]
                                                          : [UIColor secondaryLabelColor])}]];
    [text appendAttributedString:[[NSAttributedString alloc]
        initWithString:self.word ?: @""
            attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0],
                         NSForegroundColorAttributeName: [UIColor labelColor]}]];
    wordLabel.attributedText = text;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    UILabel *wordLabel = [self.contentView viewWithTag:100];
    wordLabel.attributedText = nil;
}

@end
