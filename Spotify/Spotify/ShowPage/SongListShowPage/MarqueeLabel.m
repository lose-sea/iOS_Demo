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

@property (nonatomic, strong) UIView *contentView;        // 滚动容器
@property (nonatomic, strong) UILabel *mainLabel;         // 主文字
@property (nonatomic, strong) UILabel *duplicateLabel;    // 副本文字
@property (nonatomic, assign) BOOL isScrolling;           // 是否正在滚动
@property (nonatomic, assign) CGFloat textWidth;          // 文字宽度

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
 
    // 让视图根据内容自动调衡到合适大小
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
    // 如果已经在滚动，就不需要重新开始动画了
    if (self.isScrolling) return;

    /// KLabelGap 是两份文字之间的间隔，distance 是滚动的总距离（文字宽度 + 间隔）
    CGFloat distance = self.textWidth + kLabelGap;
    // 滚动时长, 距离 / 速度
    CGFloat duration = distance / MAX(self.scrollSpeed, 1.0);

    // 创建动画: 沿着 x 轴平移
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    animation.fromValue = @0;
    // 终点
    animation.toValue = @(-distance);
    // 时长
    animation.duration = duration;
    // 重复次数: 无穷大
    animation.repeatCount = HUGE_VALF;
    // 动画结束后不自动从 layer 移除。
    // 默认 YES —— 动画结束后 —— layer 回到"模型值"（transform 是 identity） —— 视图"跳回"原位。
    animation.removedOnCompletion = NO;
    [self.contentView.layer addAnimation:animation forKey:kMarqueeAnimationKey];

    // 更新状态
    self.isScrolling = YES;
}

// 启动动画
- (void)startMarquee {
    [self stopMarquee];
    [self restartMarqueeIfNeeded];
}

// 停止动画
- (void)stopMarquee {
    [self.contentView.layer removeAnimationForKey:kMarqueeAnimationKey];
    self.isScrolling = NO;
}

@end
