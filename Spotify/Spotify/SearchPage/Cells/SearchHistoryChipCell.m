//
//  SearchHistoryChipCell.m
//  Spotify
//
//  Created by lose_sea on 2026/9/24.
//

#import "SearchHistoryChipCell.h"
#import <Masonry/Masonry.h>

static const CGFloat kChipHeight = 32.0;
static const CGFloat kChipPadding = 12.0;
static const CGFloat kDeleteButtonSide = 24.0;

@implementation SearchHistoryChipCell

+ (CGFloat)widthForWord:(NSString *)word {
    NSString *text = word ?: @"";
    CGFloat textWidth = [text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, kChipHeight)
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0]}
                                           context:nil].size.width;
    return ceil(textWidth) + kChipPadding * 2 + kDeleteButtonSide;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self setUpInterface];
    }
    return self;
}

- (void)setUpInterface {
    self.backgroundColor = [UIColor clearColor];

    UIView *capsuleView = [[UIView alloc] init];
    capsuleView.backgroundColor = [UIColor tertiarySystemBackgroundColor];
    capsuleView.layer.cornerRadius = kChipHeight / 2.0;
    capsuleView.clipsToBounds = YES;
    capsuleView.tag = 100;
    [self.contentView addSubview:capsuleView];

    UILabel *wordLabel = [[UILabel alloc] init];
    wordLabel.font = [UIFont systemFontOfSize:14.0];
    wordLabel.textColor = [UIColor labelColor];
    wordLabel.tag = 101;
    [capsuleView addSubview:wordLabel];

    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [deleteButton setImage:[UIImage systemImageNamed:@"xmark"] forState:UIControlStateNormal];
    deleteButton.tintColor = [UIColor secondaryLabelColor];
    [deleteButton addTarget:self action:@selector(pressDelete) forControlEvents:UIControlEventTouchUpInside];
    [capsuleView addSubview:deleteButton];

    [capsuleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];

    [wordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(capsuleView).offset(kChipPadding);
        make.centerY.equalTo(capsuleView);
    }];

    [deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wordLabel.mas_right).offset(4.0);
        make.right.equalTo(capsuleView).offset(-8.0);
        make.centerY.equalTo(capsuleView);
        make.size.mas_equalTo(CGSizeMake(kDeleteButtonSide, kDeleteButtonSide));
    }];
}

- (void)setWord:(NSString *)word {
    _word = word;
    UILabel *wordLabel = [self.contentView viewWithTag:101];
    wordLabel.text = word;
}

- (void)pressDelete {
    if (self.onDelete) self.onDelete();
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.onDelete = nil;
    UILabel *wordLabel = [self.contentView viewWithTag:101];
    wordLabel.text = nil;
}

@end
