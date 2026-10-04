//
//  CommentModel.h
//  Spotify
//
//  Created by lose_sea on 2026/10/4.
//

#import <Foundation/Foundation.h>
#import <YYModel/YYModel.h>

NS_ASSUME_NONNULL_BEGIN

/// 单条评论（含楼中楼回复）。字段名对齐网易云 /comment/music 接口。
@interface CommentModel : NSObject <YYModel>

#pragma mark - 服务端字段

/// 评论 id（接口下发为数字，统一转成字符串）
@property (nonatomic, copy) NSString *commentId;
/// 用户 id
@property (nonatomic, copy) NSString *userId;
/// 昵称
@property (nonatomic, copy) NSString *nickname;
/// 头像（接口下发 http，加载前统一升级 https）
@property (nonatomic, copy) NSString *avatarURL;
/// 正文
@property (nonatomic, copy) NSString *content;
/// 点赞数
@property (nonatomic, assign) NSInteger likedCount;
/// 本人是否已点赞
@property (nonatomic, assign) BOOL liked;
/// 发布时间（毫秒时间戳）
@property (nonatomic, assign) long long time;
/// 楼中楼回复（网易云字段名是 beReplied，这里改名 replies）
@property (nonatomic, copy) NSArray<CommentModel *> *replies;

#pragma mark - 视图态（非服务端字段，仅本地使用）

/// 是否展开楼中楼
@property (nonatomic, assign) BOOL isExpanded;
/// 是不是本人发的（本地乐观回复，没有真实服务端 id）
@property (nonatomic, assign) BOOL isMine;

/// 把接口返回的 comments / hotComments 数组解析成模型数组
+ (NSArray<CommentModel *> *)modelsFromArray:(NSArray *)array;

/// 毫秒时间戳 → 「刚刚 / x分钟前 / x小时前 / x天前 / yyyy-MM-dd」
+ (NSString *)relativeTimeFromMillis:(long long)millis;

/// 点赞数缩写：12345 → 1.2万
+ (NSString *)shortCount:(NSInteger)count;

@end

NS_ASSUME_NONNULL_END
