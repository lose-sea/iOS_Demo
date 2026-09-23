//
//  MarqueeLabel.m
//  Spotify
//
//  Created by lose_sea on 2026/9/23.
//

#import "MarqueeLabel.h"

static NSString * const kMarqueeAnimationKey = @"marquee";
static const CGFloat kLabelGap = 40.0;   // 两份文字之间的间隔
static const CGFloat kDefaultSpeed = 30.0;

@interface MarqueeLabel ()

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *mainLabel;
@property (nonatomic, strong) UILabel *duplicateLabel;
@property (nonatomic, assign) BOOL isScrolling;
@property (nonatomic, assign) CGFloat textWidth;

@end

@implementation MarqueeLabel

- (instancetype)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self setUpInterface];
    }
    return self;
}

- (void)setUpInterface {
    self.clipsToBounds = YES;
    self.scrollSpeed = kDefaultSpeed;
    self.textAlignment = NSTextAlignmentLeft;

    self.contentView = [[UIView alloc] init];
    [self addSubview:self.contentView];

    self.mainLabel = [self makeLabel];
    self.duplicateLabel = [self makeLabel];
    self.duplicateLabel.hidden = YES;
    [self.contentView addSubview:self.mainLabel];
    [self.contentView addSubview:self.duplicateLabel];
}

- (UILabel *)makeLabel {
    UILabel *label = [[UILabel alloc] init];
    label.font = self.font ?: [UIFont systemFontOfSize:17.0];
    label.textColor = self.textColor ?: [UIColor labelColor];
    label.textAlignment = self.textAlignment;
    return label;
}

#pragma mark - 属性

- (void)setText:(NSString *)text {
    _text = [text copy];
    self.mainLabel.text = _text;
    self.duplicateLabel.text = _text;
    [self setNeedsLayout];
}

- (void)setFont:(UIFont *)font {
    _font = font;
    self.mainLabel.font = font;
    self.duplicateLabel.font = font;
    [self setNeedsLayout];
}

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    self.mainLabel.textColor = textColor;
    self.duplicateLabel.textColor = textColor;
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment {
    _textAlignment = textAlignment;
    self.mainLabel.textAlignment = textAlignment;
    self.duplicateLabel.textAlignment = textAlignment;
}

#pragma mark - 布局

- (void)layoutSubviews {
    [super layoutSubviews];

    self.contentView.frame = self.bounds;
    CGFloat height = CGRectGetHeight(self.bounds);
    CGFloat visibleWidth = CGRectGetWidth(self.bounds);
    if (height <= 0 || visibleWidth <= 0) return;

    [self.mainLabel sizeToFit];
    self.textWidth = CGRectGetWidth(self.mainLabel.bounds);

    BOOL needScroll = self.alwaysScroll || (self.textWidth > visibleWidth);
    if (!needScroll) {
        [self stopMarquee];
        self.duplicateLabel.hidden = YES;
        self.mainLabel.frame = CGRectMake(0, 0, visibleWidth, height);
        return;
    }

    // 两份文字首尾相接，滚完一份立刻接上，视觉上无限循环
    self.duplicateLabel.hidden = NO;
    self.mainLabel.frame = CGRectMake(0, 0, self.textWidth, height);
    self.duplicateLabel.frame = CGRectMake(self.textWidth + kLabelGap, 0, self.textWidth, height);

    [self restartMarqueeIfNeeded];
}

#pragma mark - 滚动

- (void)restartMarqueeIfNeeded {
    if (self.isScrolling) return;

    CGFloat distance = self.textWidth + kLabelGap;
    CGFloat duration = distance / MAX(self.scrollSpeed, 1.0);

    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    animation.fromValue = @0;
    animation.toValue = @(-distance);
    animation.duration = duration;
    animation.repeatCount = HUGE_VALF;
    animation.removedOnCompletion = NO;
    [self.contentView.layer addAnimation:animation forKey:kMarqueeAnimationKey];

    self.isScrolling = YES;
}

- (void)startMarquee {
    [self stopMarquee];
    [self restartMarqueeIfNeeded];
}

- (void)stopMarquee {
    [self.contentView.layer removeAnimationForKey:kMarqueeAnimationKey];
    self.isScrolling = NO;
}

@end
