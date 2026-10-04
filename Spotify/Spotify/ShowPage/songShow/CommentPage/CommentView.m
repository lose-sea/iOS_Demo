//
//  CommentView.m
//  Spotify
//
//  Created by lose_sea on 2026/10/4.
//

#import "CommentView.h"
#import "UIImageView+Spotify.h"
#import <Masonry/Masonry.h>
#import <SDWebImage/SDWebImage.h>

static const CGFloat kAvatarSize = 36.0;
static const CGFloat kContentInset = 12.0;

@interface CommentView ()

@property (nonatomic, strong, readwrite) CommentModel *comment;

@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIButton *likeButton;
@property (nonatomic, strong) UILabel *likeCountLabel;
@property (nonatomic, strong) UIButton *replyButton;
@property (nonatomic, strong) UIButton *expandButton;
/// 楼中楼容器（只在展开时填充并显示）
@property (nonatomic, strong) UIStackView *repliesStack;

/// 外层垂直 stack，作为 cell 内容的唯一高度来源
@property (nonatomic, strong) UIStackView *rootStack;

@end

@implementation CommentView

#pragma mark - 生命周期

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor systemBackgroundColor];
        [self buildSubviews];
    }
    return self;
}

- (void)buildSubviews {
    // —— 头像 ——
    self.avatarImageView = [[UIImageView alloc] init];
    self.avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.avatarImageView.layer.cornerRadius = kAvatarSize / 2.0;
    self.avatarImageView.clipsToBounds = YES;
    self.avatarImageView.backgroundColor = [UIColor secondarySystemFillColor];

    // —— 昵称 ——
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    self.nameLabel.textColor = [UIColor secondaryLabelColor];
    self.nameLabel.numberOfLines = 1;

    // —— 正文 ——
    self.contentLabel = [[UILabel alloc] init];
    self.contentLabel.font = [UIFont systemFontOfSize:15];
    self.contentLabel.textColor = [UIColor labelColor];
    self.contentLabel.numberOfLines = 0;

    // —— 时间 ——
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.font = [UIFont systemFontOfSize:12];
    timeLabel.textColor = [UIColor tertiaryLabelColor];
    timeLabel.tag = 1001;

    // —— 点赞 ——
    self.likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.likeButton setImage:[UIImage systemImageNamed:@"heart"] forState:UIControlStateNormal];
    self.likeButton.tintColor = [UIColor secondaryLabelColor];
    [self.likeButton addTarget:self action:@selector(onLike) forControlEvents:UIControlEventTouchUpInside];

    self.likeCountLabel = [[UILabel alloc] init];
    self.likeCountLabel.font = [UIFont systemFontOfSize:12];
    self.likeCountLabel.textColor = [UIColor tertiaryLabelColor];

    // —— 回复 ——
    self.replyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.replyButton setTitle:@"回复" forState:UIControlStateNormal];
    [self.replyButton setTitleColor:[UIColor tertiaryLabelColor] forState:UIControlStateNormal];
    self.replyButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.replyButton addTarget:self action:@selector(onReply) forControlEvents:UIControlEventTouchUpInside];

    // 底部一行：时间 … 回复  点赞数 ♥
    UIStackView *bottomRow = [[UIStackView alloc] initWithArrangedSubviews:@[
        timeLabel, self.replyButton, self.likeCountLabel, self.likeButton]];
    bottomRow.axis = UILayoutConstraintAxisHorizontal;
    bottomRow.spacing = 8;
    bottomRow.alignment = UIStackViewAlignmentCenter;
    [bottomRow setCustomSpacing:16 afterView:timeLabel]; // 时间后留大点空隙

    // —— 展开 / 收起按钮 ——
    self.expandButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.expandButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.expandButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.expandButton setTitleColor:[UIColor systemBlueColor] forState:UIControlStateNormal];
    [self.expandButton addTarget:self action:@selector(onToggleExpand) forControlEvents:UIControlEventTouchUpInside];

    // —— 楼中楼容器 ——
    self.repliesStack = [[UIStackView alloc] init];
    self.repliesStack.axis = UILayoutConstraintAxisVertical;
    self.repliesStack.spacing = 6;
    self.repliesStack.layoutMargins = UIEdgeInsetsMake(8, 10, 8, 10);
    self.repliesStack.layoutMarginsRelativeArrangement = YES;
    self.repliesStack.backgroundColor = [UIColor secondarySystemFillColor];
    self.repliesStack.layer.cornerRadius = 8;
    self.repliesStack.clipsToBounds = YES;

    // —— 头部一行：头像 + 昵称 ——
    UIStackView *headerStack = [[UIStackView alloc] initWithArrangedSubviews:@[self.avatarImageView, self.nameLabel]];
    headerStack.axis = UILayoutConstraintAxisHorizontal;
    headerStack.spacing = 8;
    headerStack.alignment = UIStackViewAlignmentCenter;
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kAvatarSize, kAvatarSize));
    }];

    // —— 根 stack ——
    self.rootStack = [[UIStackView alloc] initWithArrangedSubviews:@[
        headerStack, self.contentLabel, bottomRow, self.expandButton, self.repliesStack]];
    self.rootStack.axis = UILayoutConstraintAxisVertical;
    self.rootStack.spacing = 6;
    [self.contentView addSubview:self.rootStack];
    [self.rootStack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(kContentInset);
        make.left.equalTo(self.contentView).offset(kContentInset);
        make.right.equalTo(self.contentView).offset(-kContentInset);
        make.bottom.equalTo(self.contentView).offset(-kContentInset);
    }];
}

#pragma mark - 配置

- (void)configureWithComment:(CommentModel *)comment {
    self.comment = comment;
    if (!comment) return;

    [self.avatarImageView sp_setImageWithSource:comment.avatarURL placeholder:nil];
    self.nameLabel.text = comment.nickname.length ? comment.nickname : @"匿名用户";
    self.contentLabel.text = comment.content.length ? comment.content : @"";

    UILabel *timeLabel = [self.contentView viewWithTag:1001];
    timeLabel.text = [CommentModel relativeTimeFromMillis:comment.time];

    [self updateLikeUI];
    [self updateExpandUI];
    [self buildReplies];
}

- (void)updateLikeUI {
    self.likeCountLabel.text = [CommentModel shortCount:self.comment.likedCount];
    UIImage *img = self.comment.liked ? [UIImage systemImageNamed:@"heart.fill"] : [UIImage systemImageNamed:@"heart"];
    [self.likeButton setImage:img forState:UIControlStateNormal];
    self.likeButton.tintColor = self.comment.liked ? [UIColor systemPinkColor] : [UIColor secondaryLabelColor];
}

- (void)updateExpandUI {
    BOOL hasReplies = self.comment.replies.count > 0;
    self.expandButton.hidden = !hasReplies;
    if (hasReplies) {
        if (self.comment.isExpanded) {
            [self.expandButton setTitle:[NSString stringWithFormat:@"收起 %@ 条回复",
                                         @(self.comment.replies.count)] forState:UIControlStateNormal];
        } else {
            [self.expandButton setTitle:[NSString stringWithFormat:@"展开 %@ 条回复 ▾",
                                         @(self.comment.replies.count)] forState:UIControlStateNormal];
        }
    }
}

/// 重建楼中楼：展开时填充每条回复，收起时清空隐藏
- (void)buildReplies {
    // 先清空旧的
    while (self.repliesStack.arrangedSubviews.count > 0) {
        [self.repliesStack.arrangedSubviews.firstObject removeFromSuperview];
    }

    BOOL show = self.comment.isExpanded && self.comment.replies.count > 0;
    self.repliesStack.hidden = !show;
    if (!show) return;

    for (CommentModel *reply in self.comment.replies) {
        [self.repliesStack addArrangedSubview:[self replyRowForModel:reply]];
    }
}

/// 单条楼中楼：昵称（高亮）+ 正文，多行
- (UIView *)replyRowForModel:(CommentModel *)reply {
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:13];
    label.numberOfLines = 0;

    NSString *name = reply.nickname.length ? reply.nickname : @"匿名用户";
    NSString *text = reply.content.length ? reply.content : @"";
    NSString *plain = [NSString stringWithFormat:@"%@：%@", name, text];

    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:plain];
    NSRange nameRange = NSMakeRange(0, name.length); // 昵称部分高亮
    if (nameRange.length <= plain.length) {
        UIColor *nameColor = reply.isMine ? [UIColor systemGreenColor] : [UIColor systemBlueColor];
        [attr addAttribute:NSForegroundColorAttributeName value:nameColor range:nameRange];
        [attr addAttribute:NSFontAttributeName
                     value:[UIFont systemFontOfSize:13 weight:UIFontWeightMedium]
                     range:nameRange];
    }
    label.attributedText = attr;
    return label;
}

#pragma mark - 事件

- (void)onLike {
    if ([self.delegate respondsToSelector:@selector(commentView:didTapLike:)]) {
        [self.delegate commentView:self didTapLike:self.comment];
    }
}

- (void)onReply {
    if ([self.delegate respondsToSelector:@selector(commentView:didTapReply:)]) {
        [self.delegate commentView:self didTapReply:self.comment];
    }
}

- (void)onToggleExpand {
    if ([self.delegate respondsToSelector:@selector(commentView:didToggleExpand:)]) {
        [self.delegate commentView:self didToggleExpand:self.comment];
    }
}

@end
