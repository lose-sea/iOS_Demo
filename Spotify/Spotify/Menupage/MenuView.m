//
//  MenuView.m
//  Spotify
//
//  Created by lose_sea on 2026/9/16.
//

#import "MenuView.h"
#import "UserModel.h"
#import "UIImageView+Spotify.h"
#import <Masonry/Masonry.h>

@interface MenuView ()

// 头部
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *nicknameLabel;
@property (nonatomic, strong) UILabel *accountLabel;

// 菜单列表
@property (nonatomic, strong) UIStackView *rowsStackView;

// 底部
@property (nonatomic, strong) UIButton *settingButton;
@property (nonatomic, strong) UIButton *nightModeButton;
@property (nonatomic, assign) BOOL isNightMode;

@end

@implementation MenuView

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self setUpInterface];
    }
    return self;
}

- (void)setUpInterface {
    self.backgroundColor = [UIColor systemBackgroundColor];

    [self setUpHeader];
    [self setUpRows];
    [self setUpBottomBar];
}

#pragma mark - 头部

- (void)setUpHeader {
    self.avatarImageView = [[UIImageView alloc] init];
    self.avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.avatarImageView.clipsToBounds = YES;
    self.avatarImageView.layer.cornerRadius = 32.0;
    self.avatarImageView.backgroundColor = [UIColor tertiarySystemFillColor];
    [self addSubview:self.avatarImageView];

    self.nicknameLabel = [[UILabel alloc] init];
    self.nicknameLabel.font = [UIFont systemFontOfSize:22.0 weight:UIFontWeightBold];
    self.nicknameLabel.textColor = [UIColor labelColor];
    [self addSubview:self.nicknameLabel];

    self.accountLabel = [[UILabel alloc] init];
    self.accountLabel.font = [UIFont systemFontOfSize:15.0];
    self.accountLabel.textColor = [UIColor secondaryLabelColor];
    [self addSubview:self.accountLabel];

    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(70.0);
        make.left.equalTo(self).offset(16.0);
        make.size.mas_equalTo(CGSizeMake(64.0, 64.0));
    }];

    [self.nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarImageView.mas_right).offset(16.0);
        make.right.equalTo(self).offset(-16.0);
        make.top.equalTo(self.avatarImageView).offset(6.0);
        make.height.mas_equalTo(28.0);
    }];

    [self.accountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.nicknameLabel);
        make.top.equalTo(self.nicknameLabel.mas_bottom).offset(4.0);
        make.height.mas_equalTo(20.0);
    }];
}

#pragma mark - 菜单列表

- (void)setUpRows {
    self.rowsStackView = [[UIStackView alloc] initWithArrangedSubviews:@[
        [self menuRowWithIcon:@"plus"                    title:@"添加帐号"],
        [self menuRowWithIcon:@"chart.xyaxis.line"       title:@"收听统计信息"],
        [self menuRowWithIcon:@"clock.arrow.circlepath"  title:@"最近播放"],
        [self menuRowWithIcon:@"megaphone"               title:@"你的更新"],
        [self menuRowWithIcon:@"gearshape"               title:@"设置和隐私"]
    ]];
    self.rowsStackView.axis = UILayoutConstraintAxisVertical;
    self.rowsStackView.spacing = 8.0;
    [self addSubview:self.rowsStackView];

    [self.rowsStackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatarImageView.mas_bottom).offset(24.0);
        make.left.equalTo(self).offset(8.0);
        make.right.equalTo(self).offset(-8.0);
    }];
}

- (UIButton *)menuRowWithIcon:(NSString *)iconName title:(NSString *)title {
    UIButton *row = [self buttonWithConfigurationIcon:iconName
                                                title:title
                                            pointSize:22.0
                                                 font:[UIFont systemFontOfSize:18.0]
                                            imagePadding:16.0
                                          contentInsets:NSDirectionalEdgeInsetsMake(0, 16, 0, 8)];
    row.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [row addTarget:self action:@selector(pressMenuRow:) forControlEvents:UIControlEventTouchUpInside];

    [row mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(52.0);
    }];
    return row;
}

/// iOS 15+ 用 UIButtonConfiguration 代替已废弃的 imageEdgeInsets / contentEdgeInsets
- (UIButton *)buttonWithConfigurationIcon:(NSString *)iconName
                                    title:(NSString *)title
                                pointSize:(CGFloat)pointSize
                                     font:(UIFont *)font
                             imagePadding:(CGFloat)imagePadding
                            contentInsets:(NSDirectionalEdgeInsets)contentInsets {
    UIImage *icon = [UIImage systemImageNamed:iconName
                            withConfiguration:[UIImageSymbolConfiguration configurationWithPointSize:pointSize]];

    UIButtonConfiguration *config = [UIButtonConfiguration plainButtonConfiguration];
    config.image = icon;
    config.attributedTitle = [[NSAttributedString alloc] initWithString:title
                                                             attributes:@{NSFontAttributeName: font,
                                                                          NSForegroundColorAttributeName: [UIColor labelColor]}];
    config.imagePadding = imagePadding;
    config.contentInsets = contentInsets;
    config.baseForegroundColor = [UIColor labelColor];

    return [UIButton buttonWithConfiguration:config primaryAction:nil];
}

#pragma mark - 底部按钮

- (void)setUpBottomBar {
    self.settingButton = [self bottomButtonWithIcon:@"gearshape" title:@"设置"];
    // 应用默认深色，按钮先显示“可切换到的目标”图标：太阳
    self.isNightMode = YES;
    self.nightModeButton = [self bottomButtonWithIcon:@"sun.max.fill" title:@"夜间模式"];

    UIStackView *bottomBar = [[UIStackView alloc] initWithArrangedSubviews:@[
        self.settingButton, self.nightModeButton
    ]];
    bottomBar.axis = UILayoutConstraintAxisHorizontal;
    bottomBar.distribution = UIStackViewDistributionFillEqually;
    bottomBar.spacing = 12.0;
    [self addSubview:bottomBar];

    [bottomBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(16.0);
        make.right.equalTo(self).offset(-16.0);
        make.bottom.equalTo(self).offset(-24.0);
        make.height.mas_equalTo(52.0);
    }];
}

- (UIButton *)bottomButtonWithIcon:(NSString *)iconName title:(NSString *)title {
    UIButton *button = [self buttonWithConfigurationIcon:iconName
                                                   title:title
                                               pointSize:16.0
                                                    font:[UIFont systemFontOfSize:15.0 weight:UIFontWeightMedium]
                                            imagePadding:6.0
                                           contentInsets:NSDirectionalEdgeInsetsZero];
    button.backgroundColor = [UIColor secondarySystemBackgroundColor];
    button.layer.cornerRadius = 26.0;
    button.layer.borderWidth = 1.0;
    button.layer.borderColor = [UIColor separatorColor].CGColor;

    [button addTarget:self action:@selector(pressBottomButton:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

#pragma mark - Public

- (void)configureWithUser {
    UserModel* user = [UserModel sharedInstance];
    [self.avatarImageView sp_setImageWithSource:user.avatarURL placeholder:nil];
    self.nicknameLabel.text = user.user_name;
    self.accountLabel.text = user.email;
}

#pragma mark - 事件

- (void)pressMenuRow:(UIButton *)sender {
    NSLog(@"点击菜单项：%@", sender.configuration.title);
}




- (void)pressBottomButton:(UIButton *)sender {
    if (sender == self.nightModeButton) {
        [self toggleNightMode];
        return;
    }
//        UIWindow *window = self.window;
//        if (!window) return;
//
//        BOOL currentlyDark = (window.overrideUserInterfaceStyle != UIUserInterfaceStyleLight);
//        window.overrideUserInterfaceStyle = currentlyDark ? UIUserInterfaceStyleLight : UIUserInterfaceStyleDark;

    // 正确的读取方式：从 configuration 中获取 title
    NSString *title = sender.configuration.title;
    NSLog(@"点击了：%@", title);
}


// 切换太阳/月亮图标，并通知外部切换主题
- (void)toggleNightMode {
    self.isNightMode = !self.isNightMode;

    NSString *iconName = self.isNightMode ? @"sun.max.fill" : @"moon.fill";
    NSString *title = self.isNightMode ? @"夜间模式" : @"日间模式";
    UIImage *icon = [UIImage systemImageNamed:iconName
                            withConfiguration:[UIImageSymbolConfiguration configurationWithPointSize:16.0]];

    UIButtonConfiguration *config = self.nightModeButton.configuration;
    config.image = icon;
    config.attributedTitle = [[NSAttributedString alloc] initWithString:title
                                                             attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15.0 weight:UIFontWeightMedium],
                                                                          NSForegroundColorAttributeName: [UIColor labelColor]}];
    self.nightModeButton.configuration = config;

    if (self.onNightModeToggle) {
        self.onNightModeToggle(self.isNightMode);
    }
}

@end
