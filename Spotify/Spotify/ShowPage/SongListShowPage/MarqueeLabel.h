//
//  MarqueeLabel.h
//  Spotify
//
//  Created by lose_sea on 2026/9/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 跑马灯标签：文字宽度超出自身宽度时无限循环滚动，否则正常居中/靠左显示
@interface MarqueeLabel : UIView

@property (nonatomic, copy) NSString *text;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, assign) NSTextAlignment textAlignment;

/// 滚动速度，单位 pt/s，默认 30
@property (nonatomic, assign) CGFloat scrollSpeed;
/// 文字没超宽时是否也要滚动，默认 NO
@property (nonatomic, assign) BOOL alwaysScroll;

- (void)startMarquee;
- (void)stopMarquee;

@end

NS_ASSUME_NONNULL_END
