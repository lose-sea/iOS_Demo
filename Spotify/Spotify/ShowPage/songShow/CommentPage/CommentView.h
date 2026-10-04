//
//  CommentView.h
//  Spotify
//
//  Created by lose_sea on 2026/10/4.
//

#import <UIKit/UIKit.h>
#import "CommentModel.h"

NS_ASSUME_NONNULL_BEGIN

@class CommentView;

@protocol CommentViewDelegate <NSObject>
@optional
/// 点赞
- (void)commentView:(CommentView *)view didTapLike:(CommentModel *)comment;
/// 点「回复」
- (void)commentView:(CommentView *)view didTapReply:(CommentModel *)comment;
/// 展开 / 收起楼中楼
- (void)commentView:(CommentView *)view didToggleExpand:(CommentModel *)comment;
@end

/// 单条评论单元格（抖音评论区风格）：头像 / 昵称 / 正文 / 时间 + 点赞 + 回复，
/// 楼中楼回复可整体展开 / 收起。用外层垂直 stackView 撑高度，配合 UITableViewAutomaticDimension。
@interface CommentView : UITableViewCell

@property (nonatomic, weak) id<CommentViewDelegate> delegate;
@property (nonatomic, strong, readonly) CommentModel *comment;

- (void)configureWithComment:(CommentModel *)comment;

@end

NS_ASSUME_NONNULL_END
