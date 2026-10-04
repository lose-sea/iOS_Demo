//
//  CommentModel.m
//  Spotify
//
//  Created by lose_sea on 2026/10/4.
//

#import "CommentModel.h"
#import "Song.h"

@implementation CommentModel

#pragma mark - YYModel 映射

/// 楼中楼在网易云里叫 beReplied，这里把属性名 replies 映射到它
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{ @"replies": @"beReplied" };
}

/// 告诉 YYModel replies 数组里装的是 CommentModel（楼中楼递归解析）
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{ @"replies": CommentModel.class };
}

/// 接口字段类型杂乱（null → NSNull、id 是数字等），统一在这里兜底处理，
/// 避免后面直接调 .length / .stringValue 崩，也顺手把头像升级成 https
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    // —— user 子树：userId / nickname / avatarUrl ——
    id user = dic[@"user"];
    if ([user isKindOfClass:NSDictionary.class]) {
        NSDictionary *u = (NSDictionary *)user;
        id uid = u[@"userId"];
        if ([uid isKindOfClass:NSNumber.class])      _userId = [uid stringValue];
        else if ([uid isKindOfClass:NSString.class]) _userId = uid;

        id nm = u[@"nickname"];
        if ([nm isKindOfClass:NSString.class]) _nickname = nm;

        id av = u[@"avatarUrl"];
        if ([av isKindOfClass:NSString.class]) _avatarURL = [Song secureURL:av];
    }

    // —— 评论 id：数字转字符串 ——
    id cid = dic[@"commentId"];
    if ([cid isKindOfClass:NSNumber.class])      _commentId = [cid stringValue];
    else if ([cid isKindOfClass:NSString.class]) _commentId = cid;

    // —— 正文：null 直接转成空串，避免拿到 NSNull ——
    id c = dic[@"content"];
    _content = [c isKindOfClass:NSString.class] ? c : @"";

    // —— 点赞态 ——
    id lk = dic[@"liked"];
    if ([lk isKindOfClass:NSNumber.class]) _liked = [lk boolValue];

    id lc = dic[@"likedCount"];
    if ([lc isKindOfClass:NSNumber.class]) _likedCount = [lc integerValue];

    // —— 时间（毫秒）——
    id t = dic[@"time"];
    if ([t isKindOfClass:NSNumber.class]) _time = [t longLongValue];

    return YES;
}

#pragma mark - 解析辅助

+ (NSArray<CommentModel *> *)modelsFromArray:(NSArray *)array {
    if (![array isKindOfClass:NSArray.class]) return @[];
    NSArray *list = [NSArray yy_modelArrayWithClass:self json:array];
    return list ?: @[];
}

+ (NSString *)relativeTimeFromMillis:(long long)millis {
    if (millis <= 0) return @"";
    NSTimeInterval ts = millis / 1000.0;
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval diff = now - ts;
    if (diff < 0) diff = 0;
    if (diff < 60)        return @"刚刚";
    if (diff < 3600)      return [NSString stringWithFormat:@"%ld分钟前", (long)(diff / 60)];
    if (diff < 86400)     return [NSString stringWithFormat:@"%ld小时前", (long)(diff / 3600)];
    if (diff < 86400 * 30) return [NSString stringWithFormat:@"%ld天前",   (long)(diff / 86400)];
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    f.dateFormat = @"yyyy-MM-dd";
    return [f stringFromDate:[NSDate dateWithTimeIntervalSince1970:ts]];
}

+ (NSString *)shortCount:(NSInteger)count {
    if (count < 0) count = 0;
    if (count < 10000) return [NSString stringWithFormat:@"%ld", (long)count];
    double wan = count / 10000.0;
    return [NSString stringWithFormat:@"%.1f万", wan];
}

@end
